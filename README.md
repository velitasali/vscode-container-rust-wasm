# VS Code Container with Rustup & Node.Js

This image is mainly for VS Code and GitHub Codespaces.

## Usage

Basically, change your `.devcontainer/Dockerfile` file like this:

```Dockerfile
ARG VARIANT="ubuntu-22.04"
FROM ghcr.io/velitasali/vscode-container-rust-wasm:main
```
