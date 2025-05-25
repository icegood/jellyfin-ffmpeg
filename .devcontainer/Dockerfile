ARG GCC_RELEASE_VERSION
ARG LLVM_RELEASE_VERSION
ARG LLVMSPIRVLIB_RELEASE_VERSION
ARG BUILD_ARCHITECTURE

FROM amd64/debian:bookworm-slim@sha256:28c1e76b454bb65a9138a2562708e7fa3a937ae88a36b30fe8a12e3e1d447ce3


# Docker build arguments
ARG ARG_SOURCE_DIR=/workspaces/jellyfin-ffmpeg
ARG ARG_ARTIFACT_DIR=/dist

# Docker run environment
ENV DEB_BUILD_OPTIONS=noddebs
ENV DEBIAN_FRONTEND=noninteractive
ENV ARCH=${BUILD_ARCHITECTURE}
ENV GCC_VER=${GCC_RELEASE_VERSION}
ENV LLVM_VER=${LLVM_RELEASE_VERSION}
ENV LLVMSPIRVLIB_VER=${LLVMSPIRVLIB_RELEASE_VERSION}
ENV SOURCE_DIR=${ARG_SOURCE_DIR}
ENV ARTIFACT_DIR=${ARG_ARTIFACT_DIR}
ENV DPKG_INSTALL_LIST=${SOURCE_DIR}/debian/jellyfin-ffmpeg7.install
ENV CMAKE_POLICY_VERSION_MINIMUM="3.5"

# Prepare Debian build environment
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y apt-transport-https \
    curl ninja-build debhelper gnupg wget devscripts \ 
    mmv equivs git nasm pkg-config subversion dh-autoreconf \
    libpciaccess-dev libwayland-dev libx11-dev libx11-xcb-dev \
    libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev \
    libxcb-shm0-dev libxcb-sync-dev libxshmfence-dev libxext-dev \ 
    libxfixes-dev libxcb1-dev libxrandr-dev libzstd-dev \ 
    libelf-dev zip unzip tar flex bison gperf ragel gdb \
    net-tools iproute2 \
 && apt-get clean autoclean -y \
 && apt-get autoremove -y

# Avoids timeouts when using git and disable the detachedHead advice
RUN git config --global http.postbuffer 524288000 \
 && git config --global advice.detachedHead false

ENV DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en"

RUN apt-get update && apt-get install -y locales sudo && apt-get clean autoclean -y
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

RUN apt-get update && apt-get install -y yasm pkg-config libx264-dev libx265-dev \
libmp3lame-dev libvpx-dev libxvidcore-dev && apt-get clean autoclean -y

VOLUME ${ARG_ARTIFACT_DIR}/

ARG myuser
ARG myuid
ARG mygid

RUN mkdir -p /opt/ffmpeg_ice
RUN mkdir /home/$myuser

RUN groupadd --gid $mygid $myuser \
    && sed -i '/test\s.*dircolors/s//#\0/' /etc/skel/.bashrc \
    && useradd --shell /bin/bash --groups users,sudo \
        --no-log-init --uid $myuid --gid $myuser --comment "dev" -- $myuser \
    && printf "%s\n" "$myuser:$myuser" | chpasswd \
    && printf "%s ALL=(ALL) NOPASSWD:SETENV: ALL\n" $myuser > "/etc/sudoers.d/$myuser"

RUN chown -R $myuser:$myuser /home/$myuser
RUN mkdir -p /workspaces && chown $myuser:$myuser /workspaces

USER $myuser

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
