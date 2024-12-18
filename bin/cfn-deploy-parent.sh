aws cloudformation deploy \
    --template-file ./infrastructure/arch-foundation.yaml \
    --stack-name RCW-Architecture-Foundation-Prod \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    --no-execute-changeset \
    --region us-west-1 \
    --parameter-overrides \
        Environment=Prod