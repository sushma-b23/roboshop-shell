#!/bin/bash

##### Change these values ###
ZONE_ID="Z03482602CK395N17NV00"
DOMAIN="devops70.online"
SG_NAME="allow-all"
env=dev
##############################



 create_ec2() {
  PRIVATE_IP=$(aws ec2 run-instances \
            --instance-type t3.micro \
            --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}, {Key=Monitor,Value=yes}]" "ResourseType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]" \
            --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
            --security-group-ids ${SGID} \
         | jq -r '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

      echo "Private IP address: $PRIVATE_IP"


 sed -e "s/IpADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" -e "s/DOMAIN/${DOMAIN}/" route53.json >/tmp/record.json
 aws rout53 change-resourse-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json 2>/dev/null


}

##Main Program

   SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG_NAME} | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')
 if [ -z "${SGID}" ]; then
  echo "Given Security Group does not exit"
  exit 1
 fi

for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch; do
   COMPONENT="${component}-${env}"
   create_ec2
done

