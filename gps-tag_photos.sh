#!/bin/bash
# This script will set artist and gps coordinates to alle images that do not have these yet.
# Usage: gps-tag_photos.sh <artist> <GPSLatitude> <GPSLatitudeRef> <GPSLongitude> <GPSLongitudeRef>

# Constants
IMAGE_DIR="/var/www/html/data/images"
LAST_FILE_STORE_DIR="/opt/gps-tag_photos"
LAST_FILE_STORE_NAME="last_file_store.txt"
LAST_FILE_STORE_PATH="${LAST_FILE_STORE_DIR}/${LAST_FILE_STORE_NAME}"

last_file=""
image=""

# EXIF data
artist="$1"
GPSLatitude="$2"
GPSLatitudeRef="$3"
GPSLongitude="$4"
GPSLongitudeRef="$5"


echo "artist: ${artist}"
echo "GPSLatitude: ${GPSLatitude}"
echo "GPSLatitudeRef: ${GPSLatitudeRef}"
echo "GPSLongitude: ${GPSLongitude}"
echo "GPSLongitudeRef: ${GPSLongitudeRef}"
echo ""

# check if parameters are set
if [[ -z "${artist}" ]] || [[ -z "${GPSLatitude}" ]] || [[ -z "${GPSLatitudeRef}" ]] || [[ -z "${GPSLongitude}" ]] || [[ -z "${GPSLongitudeRef}" ]]; then
    echo "Some parameters are empty!"
    exit 1
fi


# get last checked image
if [[ -s "${LAST_FILE_STORE_PATH}" ]]; then
    last_file="$(cat ${LAST_FILE_STORE_PATH})"
else
    # set oldest file as ${last_file}
    echo "${LAST_FILE_STORE_PATH} existiert nicht"
    last_file="${IMAGE_DIR}/$(ls -Art ${IMAGE_DIR} | head -n 1)"
fi

echo "last_file: ${last_file}"

echo ""

# Find all photos newer than ${last_file}
for image in $(find "${IMAGE_DIR}" -type f -newer "${last_file}"); do
    echo "Current file: ${image}"

    # check if file already has gps coordinates
    if ! exiftool "${image}" | grep "GPS Position" -q; then
        exiftool \
          -P \
          -overwrite_original \
          -artist="Fotobox" \
          -EXIF:GPSLatitude="${GPSLatitude}" \
          -EXIF:GPSLatitudeRef="${GPSLatitudeRef}" \
          -EXIF:GPSLongitude="${GPSLongitude}" \
          -EXIF:GPSLongitudeRef="${GPSLongitudeRef}" \
          "${image}"
    fi

done

if [[ ${image} == "" ]]; then
    echo "No files to check."
else
    # store path to last image
    echo "Store ${image} as last file..."
    echo "${image}" > "${LAST_FILE_STORE_PATH}"
fi
