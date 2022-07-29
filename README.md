# gps-tag photos

This script will set artist and gps coordinates to all images that do not have these yet.

It is created for https://github.com/andi34/photobooth/ but can be used for other purposes, of cause.

## Usage

```shell
gps-tag_photos.sh <artist> <GPSLatitude> <GPSLatitudeRef> <GPSLongitude> <GPSLongitudeRef>
```

Example:

```shell
gps-tag_photos.sh Photobooth 10.000000 North 1.000000 East
```

## crontab

If you got a folder where photos are constantly added (like a photobooth) you can use a cronjob to periodicaly add the gps and artist information for new images.

In case your photobooth is in different locations at different times (like a couple of events) you can create cronjobs with specific time slots. see `crontab.example`