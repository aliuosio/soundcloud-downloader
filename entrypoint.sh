#!/bin/sh
set -e

MUSIC_ROOT="/Music/SoundCloud/${SCDL_USERNAME:-krusty}"
PATH_DIR="${MUSIC_ROOT}/ONE"

invalid() { echo "$1" >&2; exit 1; }

# ponytail: one playlist only; a profile URL would pull every like/repost into ONE.
case "${SCDL_USERNAME:-krusty}" in
  *[!A-Za-z0-9._-]*) invalid "SCDL_USERNAME contains invalid characters" ;;
esac
SCDL_URL="${SCDL_URL:-https://soundcloud.com/krusty/sets/one}"
case "$SCDL_URL" in
  https://soundcloud.com/*/sets/*) ;;
  *) invalid "SCDL_URL must be a playlist URL like https://soundcloud.com/<user>/sets/<playlist> (got: $SCDL_URL)" ;;
esac
case "$SCDL_URL" in
  *[!A-Za-z0-9:/._-]*) invalid "SCDL_URL contains invalid characters" ;;
esac

mkdir -p "$PATH_DIR"

NAME_FORMAT='%(uploader)s - %(title)s'

echo "0 0 * * * scdl -c --original-art --original-name --original-metadata --no-original --no-playlist-folder --name-format \"${NAME_FORMAT}\" -l \"${SCDL_URL}\" --path \"${PATH_DIR}\" --debug" > /crontab.txt
crontab /crontab.txt
rm /crontab.txt

echo "Starting downloads..."
scdl -c --original-art --original-name --original-metadata --no-original --no-playlist-folder --name-format "${NAME_FORMAT}" -l "${SCDL_URL}" --path "${PATH_DIR}"
echo "Initial download done. Starting cron..."
cron -f
