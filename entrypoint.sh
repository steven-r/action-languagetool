#!/bin/sh
set -eo pipefail

API_ENDPOINT="${INPUT_CUSTOM_API_ENDPOINT}"
if [ -z "${INPUT_CUSTOM_API_ENDPOINT}" ]; then
  API_ENDPOINT=http://localhost:8010
  java -cp "/LanguageTool/languagetool-server.jar" org.languagetool.server.HTTPServer --port 8010 &
  sleep 3 # Wait the server statup.
fi

echo "API ENDPOINT: ${API_ENDPOINT}" >&2
default_api="${API_ENDPOINT}/v2/check"

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

git config --global --add safe.directory $GITHUB_WORKSPACE

# https://languagetool.org/http-api/swagger-ui/#!/default/post_check
if [ -n "${INPUT_LANGUAGE}" ]; then
  DATA="--language ${INPUT_LANGUAGE}"
fi
if [ -n "${INPUT_ENABLED_RULES}" ]; then
  DATA="$DATA --enabled-rules ${INPUT_ENABLED_RULES}"
fi
if [ -n "${INPUT_DISABLED_RULES}" ]; then
  DATA="$DATA --disabled-rules ${INPUT_DISABLED_RULES}"
fi
if [ -n "${INPUT_ENABLED_CATEGORIES}" ]; then
  DATA="$DATA --enabled-categories ${INPUT_ENABLED_CATEGORIES}"
fi
if [ -n "${INPUT_DISABLED_CATEGORIES}" ]; then
  DATA="$DATA --disabled-categories ${INPUT_DISABLED_CATEGORIES}"
fi
if [ -n "${INPUT_ENABLED_ONLY}" ]; then
  DATA="$DATA --only-enabled"
fi
if [ -n "${INPUT_MOTHER_TONGUE}" ]; then
  DATA="$DATA --mother-tongue ${INPUT_MOTHER_TONGUE}"
fi
if [ -n "${INPUT_RULE_FILES}" ]; then
  DATA="$DATA --rule-config ${INPUT_RULE_FILES}"
fi
if [ -n "${INPUT_CONCURRENT}" ]; then
  DATA="$DATA --concurrent ${INPUT_CONCURRENT}"
fi
if [ -n "${INPUT_VERBOSE}" ]; then
  DATA="$DATA --verbose ${INPUT_VERBOSE}"
fi

# Disable glob to handle glob patterns with ghglob command instead of with shell.
set -o noglob
FILES="$(git ls-files | ghglob ${INPUT_PATTERNS})"
set +o noglob

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

language-tool --output-format reviewdog --url ${default_api} $DATA -- $FILES \
 | reviewdog -efm="%f:%l:%c:%m" -name="LanguageTool" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}" -filter-mode="${INPUT_FILTER}"
