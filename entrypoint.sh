#!/bin/sh
set -e

MUSIC_ROOT="/Music/SoundCloud/${SCDL_USERNAME:-krusty}"
PATH_DIR="${MUSIC_ROOT}/ONE"
mkdir -p "$PATH_DIR"

SCDL_URL="${SCDL_URL:-https://soundcloud.com/krusty}"
NAME_FORMAT='{artist} - {title}'

echo "0 0 * * * scdl -f -c --original-art --original-name --original-metadata --name-format \"${NAME_FORMAT}\" -l ${SCDL_URL} --path ${PATH_DIR} --debug" > /crontab.txt
crontab /crontab.txt
rm /crontab.txt

echo "Starting downloads..."
scdl -f -c --original-art --original-name --original-metadata --name-format "${NAME_FORMAT}" -l "${SCDL_URL}" --path "${PATH_DIR}"
echo "Initial download done. Starting cron..."
cron -f
