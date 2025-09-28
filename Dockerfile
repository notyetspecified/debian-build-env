FROM debian:sid

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl wget git \
        build-essential cmake pkg-config \
        sudo \
        # Python tooling
        python3 python3-pip python3-venv python3-full \
        # Common build deps
        autoconf automake libtool \
        ninja-build \
        binutils-x86-64-linux-gnu \
        zlib1g-dev \
        # Frequently-needed libs
        libssl-dev \
        libunwind-dev \
        liblz4-dev \
        liblzma-dev \
        libzstd-dev \
        libxxhash-dev \
        libsodium-dev \
        libsnappy-dev \
        libpcre2-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libgtest-dev \
        libgmock-dev \
        libevent-dev \
        libdwarf-dev \
        libdouble-conversion-dev \
        python3-setuptools \
        # helpful utils
        unzip xz-utils gnupg \
    && apt-get clean

# install cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Workaround for Python's externally-managed-environment (PEP 668) in Debian 13+
# This disables the check to allow pip installs into system Python, which is common in build containers.
# Note: In a real app, prefer virtualenvs (python3 -m venv /path/to/venv).
# To re-enable: touch /usr/lib/python3.*/EXTERNALLY-MANAGED
RUN rm -f /usr/lib/python3.*/EXTERNALLY-MANAGED

# Force C++20 for CMake-based builds (fbcode_builder uses CMake for Thrift/Folly targets)
# This sets the default standard for CMake projects like fbthrift/eden_config_thrift.
# Also set flags for non-CMake tools, but note: build scripts may override—see usage notes.
ENV CMAKE_CXX_STANDARD=20
ENV CXX_STANDARD=20
ENV CXXFLAGS="-std=c++20 -O2"
ENV CFLAGS="-O2"
ENV CXX="g++"
ENV CC="gcc"

WORKDIR /workspace

CMD ["/bin/bash"]
