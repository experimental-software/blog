#!/usr/bin/env bash

DATE=$(date '+%Y-%m-%d')
read -p "Enter the subject in lower-kebab-case: " SUBJECT

CREATED_MESSAGE=$(hugo new --kind post ${DATE}_${SUBJECT})
CREATED_DIR=$(echo ${CREATED_MESSAGE} | cut -d ' ' -f1)

echo ${CREATED_MESSAGE}
