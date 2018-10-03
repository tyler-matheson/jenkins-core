#!/bin/bash

yes | sudo yum update
yes | sudo yum install awslogs

sudo service awslogs start

project_name=cl_hello_world

git clone https://github.com/aws/aws-fpga.git $AWS_FPGA_REPO_DIR  
#git clone https://github.com/tyler-matheson/jenkins-core.git $CODE_CHANGES

cd $AWS_FPGA_REPO_DIR  

source hdk_setup.sh

cd $HDK_DIR/cl/examples/$project_name
export CL_DIR=$(pwd)

cd $CL_DIR/build/scripts

export EMAIL="t_matheson@hotmail.com"
$HDK_COMMON_DIR/scripts/notify_via_sns.py
./aws_build_dcp_from_cl.sh -notify -foreground

path="$(find ../checkpoints/to_aws/ -regex ".*\.Developer_CL.tar$")"
checkpoint=$(basename "$path")

aws s3 mb s3://tyler-projects/$project_name/
aws s3 rm s3://tyler-projects/$project_name/*.Developer_CL.tar
aws s3 cp $CL_DIR/build/checkpoints/to_aws/$checkpoint s3://tyler-aws-us/$project_name/

touch LOGS_FILES_GO_HERE.txt
aws s3 cp LOGS_FILES_GO_HERE.txt s3://tyler-projects/$project_name/logs/

#Collect AFI id and global AFI id
afi=$(aws ec2 create-fpga-image --name $project_name \
    --input-storage-location Bucket=tyler-projects,Key=$project_name/$checkpoint \
    --logs-storage-location Bucket=tyler-projects,Key=$project_name/logs/)

echo afi >> afi_ids.txt
aws s3 cp afi_ids.txt s3://tyler-aws-us/$project_name/

#$HDK_COMMON_DIR/scripts/wait_for_afi.py --afi #afi-id

#shutdown -h now

#aws ec2 describe-fpga-images --filters Name=name,Values=cl_ddr