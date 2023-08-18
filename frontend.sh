script_location=$(pwd)

yum install nginx -y
systemctl enable nginx
systemctl start nginx
rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://github.com/sushma-b23/roboshop-shell.git/
cd /usr/share/nginx/html
unzip /tmp/frontend.zip


cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

