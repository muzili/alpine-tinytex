FROM alpine:3.14.2

ENV PLANTUML_VERSION 1.2021.12
ENV PLANTUML_DOWNLOAD_URL https://sourceforge.net/projects/plantuml/files/plantuml.$PLANTUML_VERSION.jar/download

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
  apk --no-cache --repository=http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/community add \
  openjdk11-jre \
  ca-certificates \
  graphviz \
  perl  \
  git  \
  wget \
  aria2 \
  xz \
  tar \
  fontconfig \
  freetype \
  lua \
  gcc

ENV PANDOC_VERSION 2.14.2
RUN aria2c -d /tmp https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux-amd64.tar.gz  && \
  tar xvzf /tmp/pandoc-$PANDOC_VERSION-linux-amd64.tar.gz --strip-components 1 -C /usr/local/  && \
  update-ca-certificates  && \
  rm -fr /tmp/pandoc-2.14.1-linux-amd64.tar.gz

RUN aria2c "$PLANTUML_DOWNLOAD_URL" -d /tmp && \
  mv -f /tmp/plantuml.$PLANTUML_VERSION.jar /usr/local/plantuml.jar && \
  chmod a+r /usr/local/plantuml.jar

# copy test latex standalone equation
RUN rm -rf /root/.fonts && \
    git clone --depth 1 --no-tags https://gitee.com/lzgcc/dotfonts.git  ~/.fonts  && \
    rm -rf /root/.fonts/.git

COPY plantuml /usr/local/bin/
COPY pandoc-default /usr/local/bin/
COPY pandoc /root

# install as root
USER root

# setup workdir
WORKDIR /root

# setup path
ENV PATH=/root/.TinyTeX/bin/x86_64-linuxmusl/:$HOME/bin:$PATH

# download and install tinytex
RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh

# add tlmgr to path
RUN tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet && \
    tlmgr update --self --all && \
    tlmgr path add && \
    fmtutil-sys --all

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

RUN cd $HOME/bin && ls $HOME/.TinyTeX/bin/x86_64-*/* | xargs -n 1 ln -s -f

# temp assign root to clean up tlmgr only dependencies
USER root

# reset workdir
WORKDIR /root
