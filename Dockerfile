ARG VARIANT="1.14"
FROM elixir:${VARIANT}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# This Dockerfile adds a non-root user with sudo access. Update the "remoteUser" property in
# devcontainer.json to use it. More info: https://aka.ms/vscode-remote/containers/non-root-user.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Options for common package install script
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh"
ARG COMMON_SCRIPT_SHA="dev-mode"

# Optional Settings for Phoenix
ARG PHOENIX_VERSION="1.6.15"

# [Optional] Setup nodejs
ARG NODE_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/node-debian.sh"
ARG NODE_SCRIPT_SHA="dev-mode"
# [Optional, Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true
ENV PATH=${NVM_DIR}/current/bin:${PATH}

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
RUN apt-get update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
  && curl -sSL ${COMMON_SCRIPT_SOURCE} -o /tmp/common-setup.sh \
  && ([ "${COMMON_SCRIPT_SHA}" = "dev-mode" ] || (echo "${COMMON_SCRIPT_SHA} */tmp/common-setup.sh" | sha256sum -c -)) \
  && /bin/bash /tmp/common-setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
  #
  # [Optional] Install Node.js for use with web applications
  && if [ "$NODE_VERSION" != "none" ]; then \
  curl -sSL ${NODE_SCRIPT_SOURCE} -o /tmp/node-setup.sh \
  && ([ "${NODE_SCRIPT_SHA}" = "dev-mode" ] || (echo "${NODE_SCRIPT_SHA} */tmp/node-setup.sh" | sha256sum -c -)) \
  && /bin/bash /tmp/node-setup.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}"; \
  fi \
  #
  # Install dependencies
  && apt-get install -y build-essential inotify-tools \
  #
  # Clean up
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/common-setup.sh /tmp/node-setup.sh
ENV FLYCTL_INSTALL=/opt/flyctl
RUN su ${USERNAME} -c "mix local.hex --force \
  && mix local.rebar --force \
  && mix archive.install --force hex phx_new ${PHOENIX_VERSION}" \
  && mix local.hex --force \
  && mix local.rebar --force \
  && curl -L https://fly.io/install.sh | sh

# Docker in docker
RUN curl -s https://raw.githubusercontent.com/devcontainers/features/de1e634a6755e10b27e52ad4e0aa44f025540074/src/docker-in-docker/install.sh | bash

# Powershell
RUN curl -s https://raw.githubusercontent.com/devcontainers/features/7763e0b7db6a16f2efececb6ffa9bd917a9eb5de/src/powershell/install.sh | bash

# # git
# RUN curl -s https://raw.githubusercontent.com/devcontainers/features/7763e0b7db6a16f2efececb6ffa9bd917a9eb5de/src/git/install.sh | bash

# # git-lfs
# RUN curl -s https://raw.githubusercontent.com/devcontainers/features/7763e0b7db6a16f2efececb6ffa9bd917a9eb5de/src/git-lfs | bash

# act
RUN curl -s https://raw.githubusercontent.com/dhoeric/features/8ea9790d10c6d318bda8b542a438a4fe97228e17/src/act/install.sh | bash

# flyctl
RUN curl -s https://raw.githubusercontent.com/dhoeric/features/8bdd7c3b719e1f4e9d6ef6e6d1ef9a30fdd8f3a4/src/flyctl/install.sh | bash

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update \
#     && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install additional package.
# RUN  mix ...

