source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is missing"
  exit
  fi
print_head "Disable MySQL Default Module"
yum module disable mysql -y  &>>${LOG}
status_check
print_head "Copy MySQL Repo file"
yum install mysql-community-server -y  &>>${LOG}
status_check


print_head "Enable MySQL"
systemctl enable mysql  &>>${LOG}
status_check

print_head "Enable MySQL"
systemctl restart mysql  &>>${LOG}
status_check

print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass RoboShop@1
status_check