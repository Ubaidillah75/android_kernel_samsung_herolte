##
## Build with:
##   docker build -t xeffyr/android-kernel-builder .
##
## Push to docker hub with:
##   docker push xeffyr/android-kernel-builder
##

FROM ubuntu:19.04

# Fix locale to avoid warnings:
ENV LANG en_US.UTF-8

# Make sure that everything is up-to-date.
RUN apt update && env DEBIAN_FRONTEND=noninteractive apt upgrade -yq

# Install essential packages.
RUN env DEBIAN_FRONTEND=noninteractive apt install -yq --no-install-recommends \
    bc \
    bison \
    ca-certificates \
    curl \
    flex \
    git \
    gcc-multilib \
    g++-multilib \
    locales \
    make \
    sudo

# Install AArch64 cross-compiler toolchain.
RUN curl -L --output toolchain.tar.gz https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9/archive/cm-14.1.tar.gz && \
    mkdir -p /opt/aarch64-linux-android-4.9 && \
    tar xf toolchain.tar.gz -C /opt/aarch64-linux-android-4.9 --strip-components=1 && \
    rm -f toolchain.tar.gz

# Add toolchain to PATH.
RUN echo 'export PATH=/opt/aarch64-linux-android-4.9/bin:$PATH' > /etc/profile.d/toolchain-aarch64.sh && \
    chmod 644 /etc/profile.d/toolchain-aarch64.sh

# Configure locales.
RUN locale-gen --purge en_US.UTF-8 && \
    echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

# Configure user account.
RUN adduser --disabled-password --shell /bin/bash --gecos "" builder
RUN echo "builder ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/builder
RUN chmod 440 /etc/sudoers.d/builder

# Cleanup.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set user.
USER builder:builder

# Set working directory.
WORKDIR /home/builder
