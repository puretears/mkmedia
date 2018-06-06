#!/bin/bash

usage()
{
cat << EOF
Usage: $0 options

This script generates HLS streaming files for boxue develop and product environment.

OPTIONS:
-t    The video type, (free or paid) is supported.
-m    The envrionment the video will be hosted, (develop or product) is supported.
-f    The origin file name without suffix.
EOF
}

TYPE="free"
MODE="test"
BASE_URL=""
VIDEO_FILENAME=""

while getopts "f:t:m:h" arg
do
	case $arg in
		t)
			TYPE=$OPTARG
			;;
		m)
			MODE=$OPTARG
			;;
		f)
			VIDEO_FILENAME=$OPTARG
			;;
		h)
			usage
			exit 0
			;;
	esac
done

if [ $TYPE = "free" ]; then
	if [ $MODE = "develop" ]; then
		BASE_URL="https://oks54ciql.qnssl.com"
	elif [ $MODE = "product" ]; then
		BASE_URL="https://free-hls.boxueio.com"
	else
		usage
		exit 1
	fi
elif [ $TYPE = "paid" ]; then
	if [ $MODE = "develop" ]; then
		BASE_URL="https://oks5mc2c8.qnssl.com"
	elif [ $MODE = "product" ]; then
		BASE_URL="https://paid-ts.boxueio.com"
	else
		usage
		exit 1
	fi
else
	usage
	exit 1
fi

mediafilesegmenter -b $BASE_URL -i $VIDEO_FILENAME.m3u8 -B $VIDEO_FILENAME -s -q "$VIDEO_FILENAME.mp4"
