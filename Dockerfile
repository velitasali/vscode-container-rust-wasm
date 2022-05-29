# See here for image contents: https://github.com/microsoft/vscode-dev-containers/blob/v0.233.0/containers/ubuntu/.devcontainer/base.Dockerfile

ARG VARIANT="ubuntu-22.04"
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Set up environment variables
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.61.0

# Install Rust
# Based on: https://github.com/rust-lang/docker-rust/blob/d49d8fbd5ea2c34f6ae421abccce0a0fe8af1bc6/1.61.0/buster/Dockerfile
RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='3dc5ef50861ee18657f9db2eeb7392f9c2a6c95c90ab41e45ab4ca71476b4338' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='67777ac3bc17277102f2ed73fd5f14c51f4ca5963adadf7f174adf4ebc38747b' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='32a1532f7cef072a667bac53f1a5542c99666c4071af0c9549795bbdb2069ec1' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='e50d1deb99048bc5782a0200aa33e4eea70747d49dffdc9d06812fd22a372515' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.24.3/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile complete --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# Update database & upgrade packages
RUN apt-get update && apt-get -y upgrade

# Install base development packages
RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends build-essential

# Install helpful tools
RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends bash-completion

# Install Firefox
RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends firefox

# Add nodejs PPA
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# Install nodejs
RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get install -y nodejs
