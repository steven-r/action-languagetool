FROM erikvl87/languagetool:5.9
# https://github.com/Erikvl87/docker-languagetool

ENV REVIEWDOG_VERSION=v0.14.1
ENV TMPL_VERSION=v1.2.0
ENV OFFSET_VERSION=v1.0.6
ENV LANGUAGETOOL_VERSION=5.2

ENV NODE_VERSION=18.12.1
ENV LT_NODE_VERSION=latest

USER root
SHELL [ "/bin/bash", "-c"]

RUN uname -a
# hadolint ignore=DL3006
RUN apk --no-cache add git curl nodejs

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

COPY entrypoint.sh /entrypoint.sh
COPY langtool.tmpl /langtool.tmpl

ENTRYPOINT ["/entrypoint.sh"]
