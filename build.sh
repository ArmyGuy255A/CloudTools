#!/bin/bash

# Read the current build version from buildver.txt
build_version=$(cat buildver.txt)

# Increment the build version
new_build_version=$((build_version + 1))

# Update the buildver.txt file with the new build version
echo $new_build_version > buildver.txt

# Build and tag the Docker image
docker build -t armyguy255a/cloudtools:latest . -t armyguy255a/cloudtools:v$new_build_version