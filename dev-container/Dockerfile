# TODO: Use multi-stage for compiling softwares which may have specific
# versions specified in tool-versions.conf

FROM ubuntu:24.04

# Set build context path
COPY tool-versions.conf /build-context/tool-versions.conf

ARG TOOL_CONF=/build-context/tool-versions.conf
#ENV TOOL_CONF=$TOOL_CONF

RUN ls -la /build-context && cat $TOOL_CONF

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    build-essential \
    ca-certificates \
    pkg-config \
    unzip \
    ninja-build \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    cmake \
    xz-utils \
    gosu \
    && apt-get clean

# ----------- NEOVIM INSTALL --------------------
# Read pinned version from config file
RUN NEOVIM_VERSION=$(grep '^NEOVIM=' $TOOL_CONF | cut -d '=' -f2) \
    && echo "Neovim version is " $NEOVIM_VERSION \
    && if [ -n "$NEOVIM_VERSION" ]; then \
         git clone --branch $NEOVIM_VERSION https://github.com/neovim/neovim.git && \
         cd neovim && make CMAKE_BUILD_TYPE=Release && make install; \
         cd .. && rm -rf neovim; \
       else \
         apt-get install -y neovim; \
       fi

# ----------- TMUX INSTALL --------------------
RUN TMUX_VERSION=$(grep '^TMUX=' $TOOL_CONF | cut -d '=' -f2) \
    && if [ -n "$TMUX_VERSION" ]; then \
         curl -LO https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz && \
         tar -xzf tmux-${TMUX_VERSION}.tar.gz && cd tmux-${TMUX_VERSION} && \
         ./configure && make && make install; \
         cd .. && rm -rf tmux-${TMUX_VERSION}; \
       else \
         apt-get install -y tmux; \
       fi

# ----------- GDB INSTALL --------------------
RUN GDB_VERSION=$(grep '^GDB=' $TOOL_CONF | cut -d '=' -f2) \
    && if [ -n "$GDB_VERSION" ]; then \
         curl -LO https://ftp.gnu.org/gnu/gdb/gdb-${GDB_VERSION}.tar.gz && \
         tar -xzf gdb-${GDB_VERSION}.tar.gz && cd gdb-${GDB_VERSION} && \
         ./configure && make && make install; \
         cd .. && rm -rf gdb-${GDB_VERSION}; \
       else \
         apt-get install -y gdb; \
       fi

# Rename default ubuntu user to devuser
RUN usermod -l devuser ubuntu && \
    groupmod -n devgroup ubuntu && \
    usermod -d /home/devuser -m devuser

# RUN useradd -ms /bin/bash devuser
WORKDIR /home/devuser

# Copy configuration files
COPY configs/bashrc .bashrc
COPY configs/gdbinit .gdbinit
COPY configs/neovim .config/nvim
COPY configs/tmux.conf .tmux.conf
COPY configs/vimrc .vimrc

# Make sure permissions are correct
RUN chown -R devuser:devgroup /home/devuser

# Create the target directory inside container
RUN mkdir -p /home/devuser/.local/share/nvim \
    && chown -R devuser:devgroup /home/devuser/.local

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use entrypoint for UID/GID mapping
USER root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["tmux"]
