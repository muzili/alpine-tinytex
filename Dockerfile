FROM alpine:3.11

ENV PLANTUML_VERSION 1.2019.8
ENV PLANTUML_DOWNLOAD_URL https://sourceforge.net/projects/plantuml/files/plantuml.$PLANTUML_VERSION.jar/download

RUN apk --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community add \
  openjdk11-jre \
  ca-certificates \
  graphviz \
  perl  \
  wget \
  xz \
  tar \
  fontconfig \
  freetype \
  lua \
  gcc

RUN wget -O /tmp/pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/2.9.1.1/pandoc-2.9.1.1-linux-amd64.tar.gz \
  && tar xvzf /tmp/pandoc.tar.gz --strip-components 1 -C /usr/local/ \
  && update-ca-certificates \
  && rm /tmp/pandoc.tar.gz

RUN wget "$PLANTUML_DOWNLOAD_URL" -O /usr/local/plantuml.jar && \
  chmod a+r /usr/local/plantuml.jar 

# copy test latex standalone equation
RUN wget -O /tmp/dotfonts.zip https://github.com/muzili/dotfonts/archive/master.zip && \
    unzip /tmp/dotfonts.zip -d /root && \
    rm -rf /root/.fonts && \
    mv /root/dotfonts-master /root/.fonts

COPY plantuml /usr/local/bin/
COPY pandoc-default /usr/local/bin/
COPY pandoc /root

# install as root
USER root

# setup workdir
WORKDIR /root

# setup path
ENV PATH=/root/.TinyTeX/bin/x86_64-linuxmusl/:$PATH

# download and install tinytex
RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh

# add tlmgr to path
RUN /root/.TinyTeX/bin/*/tlmgr path add

# verify latex version
RUN latex --version

# verify tlmgr version
RUN tlmgr --version

# install texlive packages
RUN tlmgr install \
    preview \
    standalone \
    dvisvgm \
    xetex \
    unicode-math \
    filehook \
    xecjk \
    arphic-ttf \
    arphic \
    lm-math \
    wrapfig \
    ulem \
    amsmath \
    capt-of \
    hyperref \
    ctex \
    zhnumber \
    minted \
    titlesec \
    fvextra \
    lineno \
    ifplatform \
    xstring \
    tcolorbox \
    environ \
    trimspaces \
    fandol \
    placeins \
    colortbl \
    tabu \
    multirow \
    adjustbox  \
    varwidth \
    collectbox \
    wasysym \
    xcolor \
    courier \
    sectsty \
    tocloft  \
    courier \
    helvetic \
    listings  

RUN tlmgr install \
    collection-latexrecommended \
    collection-latexextra \
    collection-bibtexextra \
    mdwtools \
    parskip \
    pgf \
    tikz-cd

# temp assign root to clean up tlmgr only dependencies
USER root

# reset workdir
WORKDIR /root
