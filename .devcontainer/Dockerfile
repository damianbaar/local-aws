ARG VARIANT=3.12
FROM mcr.microsoft.com/vscode/devcontainers/base:alpine-${VARIANT} as FETCHER

ARG NIX_VERSION
ENV NIX_VERSION ${NIX_VERSION:-2.3.4}
ARG LANG
ENV LANG ${LANG:-"en_US.UTF-8"}

RUN addgroup -g 30000 -S nixbld \
    && for i in $(seq 1 30); do adduser -S -D -h /var/empty -g "Nix build user $i" -u $((30000 + i)) -G nixbld nixbld$i ; done \
    # && adduser -D vscode \
    && mkdir -m 0755 /nix && chown vscode /nix \
    && apk add --no-cache bash xz \
    && rm -rf /var/cache/apk/* \
    # sandboxing enabled by default since 2.2
    && mkdir -p /etc/nix && echo 'sandbox = false' > /etc/nix/nix.conf

USER vscode
ENV USER=vscode
ENV HOME="/home/vscode"

RUN cd && wget https://nixos.org/releases/nix/nix-$NIX_VERSION/nix-$NIX_VERSION-x86_64-linux.tar.xz \
    && tar xJf nix-*-x86_64-linux.tar.xz \
    && ~/nix-*-x86_64-linux/install \
    && rm -rf ~/nix-*-*

ENV ENV="/home/vscode/.nix-profile/etc/profile.d/nix.sh"
RUN echo ". ${ENV}" >> ${HOME}/.profile
# All subsequent "RUN" will use a login shell
SHELL ["/usr/bin/env", "bash", "-l", "-c"]

RUN nix-channel --add https://nixos.org/channels/nixpkgs-19.09-darwin nixpkgs \
    && nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable \
    && nix-channel --update

# Propagate UTF8
# https://github.com/NixOS/nix/issues/599#issuecomment-153885553
# The same is hapenning with stack2nix
RUN nix-env -iA nixpkgs.glibcLocales \
  unstable.bazel \
  unstable.bash

# RUN mkdir /workspace
WORKDIR /workspace

# < Nix context as a volume
# We want to be able to define /nix/store as a volume
VOLUME ["/nix"]
# Create bash profile
# COPY --chown=vscode:vscode .devcontainer/bash_profile /home/vscode/.profile
COPY --chown=vscode:vscode .devcontainer/bash_profile /home/vscode/bash_profile_external
RUN echo "source $HOME/bash_profile_external" >> /home/vscode/.bashrc
# />

# RUN nix-env -f nix/docker-deps.nix -i '.*' && nix-store --gc