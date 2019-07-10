#!/usr/bin/env bash

set -e -u

SCRIPT_DIR=$(dirname "$(realpath "$0")")
export PATH="${SCRIPT_DIR}/bin:${PATH}"

print_usage() {
	local script_name
	script_name=$(basename "$0")

	echo
	echo "Usage: ${script_name} [ramdisk directory] [output file]"
	echo
	echo "Helper script for re-packing ramdisk."
	echo
}

if [ $# -lt 2 ]; then
	echo
	echo "Missing some arguments."
	print_usage
	exit 1
fi

INPUT_RAMDISK_DIRECTORY="$1"
OUTPUT_FILE="$2"

if [ -z "$(command -v gzip)" ]; then
	echo "Utility 'gzip' is not found in PATH."
	exit 1
fi

if [ -z "$(command -v mkbootfs)" ]; then
	echo "Utility 'mkbootfs' is not found in PATH."
	exit 1
fi

if [ ! -e "$INPUT_RAMDISK_DIRECTORY" ]; then
	echo "Directory '${INPUT_RAMDISK_DIRECTORY}' is not found."
	exit 1
fi

if [ -e "$OUTPUT_FILE" ]; then
	echo "Refusing to overwrite existing file '${OUTPUT_FILE}'."
	exit 1
fi

mkbootfs "$INPUT_RAMDISK_DIRECTORY" | gzip -9 > "${OUTPUT_FILE}"
