FROM erikvl87/languagetool:latest
# https://github.com/Erikvl87/docker-languagetool

ENV REVIEWDOG_VERSION=v0.14.1
ENV GHGLOB_VERSION=v2.0.2
ENV LANGTOOL_VERSION=latest

USER root
SHELL [ "/bin/bash", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git curl nodejs npm
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN wget -O - -q https://raw.githubusercontent.com/haya14busa/ghglob/master/install.sh| sh -s -- -b /usr/local/bin/ ${GHGLOB_VERSION}

RUN npm install -g languagetool-cli@${LANGTOOL_VERSION}

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
