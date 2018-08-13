#!/bin/bash

yes | sudo yum update
yes | sudo yum install awslogs

sudo service awslogs start

git clone https://github.com/aws/aws-fpga.git $AWS_FPGA_REPO_DIR  
git clone https://github.com/tyler-matheson/jenkins-core.git $CODE_CHANGES

cd $AWS_FPGA_REPO_DIR  

source hdk_setup.sh
source sdk_setup.sh

cd $HDK_DIR/cl/examples/cl_hello_world
export CL_DIR=$(pwd)

cd $CL_DIR/build/scripts

export EMAIL="t_matheson@hotmail.com"
$HDK_COMMON_DIR/scripts/notify_via_sns.py
./aws_build_dcp_from_cl.sh -notify -foreground

aws s3 mb s3://tyler-aws-us/example/
aws s3 rm s3://tyler-aws-us/example/*.Developer_CL.tar
aws s3 cp $CL_DIR/build/checkpoints/to_aws/*.Developer_CL.tar s3://tyler-aws-us/example/

aws s3 mb s3://tyler-aws-us/logs/
touch LOGS_FILES_GO_HERE.txt
aws s3 cp LOGS_FILES_GO_HERE.txt s3://tyler-aws-us/logs/

#Collect AFI id and global AFI id
aws ec2 create-fpga-image --name <afi-name> --description <afi-description> --input-storage-location Bucket=<dcp-bucket-name>,Key=<path-to-tarball> --logs-storage-location Bucket=<logs-bucket-name>,Key=<path-to-logs>      

$HDK_COMMON_DIR/scripts/wait_for_afi.py --afi #afi-id

shutdown -h now