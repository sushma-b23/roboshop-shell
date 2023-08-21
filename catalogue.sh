script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m Configuring NodeJS repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[35m Install NodeJS\e[0m"
yum install nodejs -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi

echo -e "\e[35m Add Application User\e[0m"
useradd roboshop &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi

mkdir -p /app &>>${LOG}
echo -e "\e[35m Downloading App content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi

echo -e "\e[35m Cleanup Old Content\e[0m"
cd /app &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[35m Extracting App Content\e[0m"
rm -rf /app/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
unzip /tmp/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[35m Installing NodeJS Dependencies\e[0m"
cd /app &>>${LOG}
npm install &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi

echo -e "\e[35m Configuring Catalogue Service File\e[0m"

cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[35m Reload SystemD\e[0m"
systemctl daemon-reload &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[35m Enable Catalogue Service\e[0m"
systemctl enable catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[35m Start Catalogue Service\e[0m"
systemctl start catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi

echo -e "\e[35m Configuring Mongo repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
echo -e "\e[35m Install Mongo Client\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi

echo -e "\e[35m Load Schema\e[0m"
mongo --host localhost </app/schema/catalogue.js &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi