FROM erikvl87/languagetool:5.9
# https://github.com/Erikvl87/docker-languagetool

ENV REVIEWDOG_VERSION=v0.14.1

USER root
SHELL [ "/bin/bash", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git curl nodejs
RUN curl -sfL https://raw.githubusercontent.com/haya14busa/ghglob/master/install.sh| sh -s

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

COPY entrypoint.sh /entrypoint.sh
COPY langtool.tmpl /langtool.tmpl

ENTRYPOINT ["/entrypoint.sh"]
