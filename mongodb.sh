source common.sh
print_head "Copy MongoDB Repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo
status_check

print_head "Install MongoDB"
yum install mongodb-org -y
status_check

print_head "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check

print_head "Install MongoDB"
systemctl enable mongod
status_check

print_head "Install MongoDB"
systemctl restart mongod
status_check