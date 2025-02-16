#!/bin/bash

# Set the path to your SAM template file and output directory
TEMPLATE_FILE_FRONTEND="./infrastructure/workloads/rcw-client-public-app-layer.yaml"
BUILD_DIR=".aws-sam/build"


# Validate the SAM template
echo "Validating the SAM template..."
sam validate --template-file "$TEMPLATE_FILE_FRONTEND"

if [ $? -ne 0 ]; then
    echo "SAM template validation failed. Exiting..."
    exit 1
fi

# Run SAM build
echo $OAUTH_TOKEN
echo "Building the SAM application..."
sam build --template-file "$TEMPLATE_FILE_FRONTEND" --build-dir "$BUILD_DIR"

if [ $? -ne 0 ]; then
    echo "SAM build failed. Exiting..."
    exit 1
fi

source .env

# Deploy the stack using the built template
echo "Deploying the SAM application..."
aws cloudformation deploy \
    --template-file infrastructure/rcw-infra.yaml \
    --stack-name RCW-Infrastructure-Prod \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    --region us-west-1 \
    --parameter-overrides \
        Environment=Prod \
        FoundationTemplateS3Uri=https://rcw-code-bucket.s3.us-west-1.amazonaws.com/templates/arch-foundation.yaml \
        ClientPublicDBTemplateS3Uri=https://rcw-code-bucket.s3.us-west-1.amazonaws.com/templates/rcw-client-public-db.yaml \
        ClientPublicAppS3Uri=https://rcw-code-bucket.s3.us-west-1.amazonaws.com/templates/rcw-client-public-app.yaml \
        PaypalProcessorS3Uri=https://rcw-code-bucket.s3.us-west-1.amazonaws.com/templates/rcw-paypal-processor.yaml \
        EmailIdentityRecipientEmail=emmanuelurias60@icloud.com \
        EmailIdentitySenderEmail=emmanuelurias60@nebulaawsconsulting.com \
        PaypalSecret=${{ secrets.PAYPAL_SECRET }} \
        PayPalClientId=${{ secrets.PAYPAL_CLIENT_ID }} \
        SpreadSheetId=1Jpicnmuuuy7aS__mGb-3sLgED9vxvELrvffrDtOHWjo \
        Repository=https://github.com/Nebula-AWS-Consulting/RCW-Infrastructure-Campaign \
        Branch=main \
        OauthToken=${{ secrets.OAUTH_TOKEN }} \
        DomainName=restoredchurchlv.org

if [ $? -ne 0 ]; then
    echo "SAM deploy failed. Exiting..."
    exit 1
fi

echo "Back-end for front-end website deployed successfully!"