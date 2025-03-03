#!/bin/bash

# Variables
WORKLOAD_FOLDER="./infrastructure/"
S3_BUCKET="rcw-code-bucket-dev/templates"
REGION="us-west-1"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it to continue."
    exit 1
fi

# Check if workload folder exists
if [ ! -d "$WORKLOAD_FOLDER" ]; then
    echo "Workload folder does not exist: $WORKLOAD_FOLDER"
    exit 1
fi

# Upload all YAML/JSON templates in the workload folder
for template in "$WORKLOAD_FOLDER"/*.{yaml,yml,json}; do
    # Check if the template exists (in case of no matching files)
    if [ ! -e "$template" ]; then
        echo "No templates found in $WORKLOAD_FOLDER."
        exit 1
    fi

    # Get the filename
    FILENAME=$(basename "$template")

    # Upload to S3
    echo "Uploading $FILENAME to s3://$S3_BUCKET/$FILENAME..."
    aws s3 cp "$template" "s3://$S3_BUCKET/$FILENAME" --region "$REGION"

    if [ $? -eq 0 ]; then
        echo "$FILENAME uploaded successfully."
    else
        echo "Failed to upload $FILENAME."
    fi

done

echo "All templates processed."
