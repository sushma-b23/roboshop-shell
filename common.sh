script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
    else
      echo -e "\e[1;31mFAILURE\e[0m"
      echo "Refer Log file for more information, LOG - ${LOG}"
  exit
      fi
}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

NODEJS() {
  print_head "Configuring NodeJS Repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check
  print_head "Install NodeJS"
  yum install nodejs -y &>>${LOG}
  status_check
  print_head "Add Application User"
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
  fi
  mkdir -p /app &>>${LOG}
  print_head "Downloading App content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}                                                                             .zip &>>${LOG}
  status_check

  print_head "Cleanup Old Content"
  cd /app &>>${LOG}
  status_check

  print_head "Extracting App Content"
  rm -rf /app/* &>>${LOG}
  status_check
  unzip /tmp/${component}.zip &>>${LOG}
  status_check
  print_head "Installing NodeJS Dependencies"
  cd /app &>>${LOG}
  npm install &>>${LOG}
  status_check
  print_head "Configuring ${component} Service File"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.serv                                                                             ice &>>${LOG}
  status_check

  print_head "Reload SystemD"
  systemctl daemon-reload &>>${LOG}
  status_check

  print_head "Enable ${component} Service"
  systemctl enable ${component} &>>${LOG}
  status_check

  print_head "Start ${component} Service"
  systemctl start ${component} &>>${LOG}
  status_check

  if [ ${schema_load} == "true" ]; then

  print_head "Configuring Mongo repo"
  cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
  status_check

  print_head "Install Mongo Client"
  yum install mongodb-org-shell -y &>>${LOG}
  status_check

  print_head "Load Schema"
  mongo --host localhost </app/schema/${component}.js &>>${LOG}
  status_check
fi
}

MAVEN() {
  print_head "Install NodeJS"
    yum install nodejs -y &>>${LOG}
    status_check
}

PYTHON() {
  print_head "Install Python"
  yum install python36 gcc python3-devel -y &>>${LOG}
  status_check
  APP_PREREQ
  print_head "Download Dependencies"
  cd /app
  pip3.6 install -r requirements.txt &>>${LOG}
  ststus_check

  print_head "Update passwords in Service File"
  sed -i -e "s/roboshop_rabbitmq_password/${roboshop_rabbitmq_password}/" ${script_location}/files/${component}.service &>>${LOG}
  status_check

  SYSTEMD_SETUP

}
