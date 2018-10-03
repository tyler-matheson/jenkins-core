#!/bin/bash

CREDENTIAL=$(aws sts assume-role \
--role-arn arn:aws:iam::115266808660:role/BuildRole \
--role-session-name BuildRole \
--duration 900 \
--output text \
--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken,Expiration]")

export AWS_ACCESS_KEY_ID=$(echo $CREDENTIAL | cut -d ' ' -f 1)
export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIAL | cut -d ' ' -f 2)
export AWS_SESSION_TOKEN=$(echo $CREDENTIAL | cut -d ' ' -f 3)
export AWS_DEFAULT_REGION=us-east-1

#Run instance or Create Cloudformation stack

LAUNCH=$(aws ec2 run-instances --image-id ami-ede6318f \
--count 1 \
--instance-type m4.2xlarge \
--key-name fpga-dev-us-1 \
--instance-initiated-shutdown-behavior terminate \
--user-data file://scripts/setup.sh)

INSTANCE=$(echo "$LAUNCH" | awk '/^INSTANCE/ {print $2}')

aws ec2 wait instance-terminated --instance-ids $INSTANCE