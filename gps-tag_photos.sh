#!/bin/bash

# Constants
IMAGE_DIR="/var/www/html/data/images"
LAST_FILE_STORE_DIR="/opt/gps-tag_photos"
LAST_FILE_STORE_NAME="last_file_store.txt"
LAST_FILE_STORE_PATH="${LAST_FILE_STORE_DIR}/${LAST_FILE_STORE_NAME}"

image_name="$(ls -Art ${IMAGE_DIR} | tail -n 1)"
image_path="${IMAGE_DIR}/${image_name}"
last_file=""
image=""

# get last checked image
if [[ -s "${LAST_FILE_STORE_PATH}" ]]; then
    echo "${LAST_FILE_STORE_PATH} existiert"
    last_file="$(cat ${LAST_FILE_STORE_PATH})"
else
    # set oldest file as ${last_file}
    echo "${LAST_FILE_STORE_PATH} existiert nicht"
    last_file="${IMAGE_DIR}/$(ls -Art ${IMAGE_DIR} | head -n 1)"
fi

echo "last_file: ${last_file}"

echo ""

# Find all photos newer than ${last_file}
for image in $(find "${IMAGE_DIR}" -type f -newer ${last_file}); do
    echo "Current file: ${image}"

    # check if file already has gps coordinates
    if ! exiftool "${image}" | grep "GPS Position" -q; then
        exiftool \
          -P \
          -overwrite_original \
          -artist="Fotobox" \
          -EXIF:GPSLatitude="51.976503" \
          -GPSLatitudeRef="North" \
          -EXIF:GPSLongitude="9.548523" \
          -GPSLongitudeRef="East" \
          ${image}
    fi

done

if [[ ${image} == "" ]]; then
    echo "No files to check."
else
    # store path to last image
    echo "Store ${image} as last file..."
    echo "${image}" > "${LAST_FILE_STORE_PATH}"
fi
