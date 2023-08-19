#!/bin/bash

##### Change these values ###
ZONE_ID="Z03482602CK395N17NV00"
DOMAIN="devops70.online"
SG_NAME="allow-all"
env=dev
##############################




create_ec2() {
PRIVATE_IP=$(aws ec2 run-instances \
      --image-id ${AMI_ID} \
      --instance-type t3.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}, {Key=Monitor,Value=yes}]" "ResourseType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}] \
       --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehaviour=stop}"\
       --security-group-ids ${SGID} \
       iam-instance-profile Name=aws-ssm-dev-role \
       | jq '.instance[].privateIpAddress' | sed -e  's/"//g')

 sed -e "s/IpADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" -e "s/DOMAIN/${DOMAIN}/" route53.json >/tmp/record.json
 aws rout53 change-resourse-record-sets --hosted-zone-id ${ZONE-ID} --change-batch file:///tmp/record.json 2>/dev/null
 if [ $? -eq 0 ]; then
  echo "Server Created - SUCCESS - DNS RECORD - ${COMPONENT}.${DOMAIN}"
else
   echo "Server Created - FAILED - DNS RECORD - ${COMPONENT}.${DOMAIN}"
    exit 1
    fi
}

##Main Program
AMI_ID=$aws ec2 describe-images --filters "Name=name,values=Centos-8-Devops-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
if [ -z "${AMI_ID}' ];then
   echo "AMI_ID not found"
   exit 1
 fi


 for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch; do
   COMPONENT="{component}-${env}"
   create_ec2
  done