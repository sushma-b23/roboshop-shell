script_location=$(pwd)

echo -e "/e[35m install Nginx\e[0m"
yum install nginx -y
systemctl enable nginx
echo -e "/e[35m Remove Nginx Old Content\e[0m"
systemctl start nginx
rm -rf /usr/share/nginx/html/*
echo -e "/e[35m Download Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "/e[35m Extract Frontend Content\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
systemctl enable nginx
echo -e "/e[35m Copy Roboshop Nginx Config File\e[0m"
systemctl restart nginx

echo -e "/e[35m Enable Nginx\e[0m"
echo -e "/e[35m Start Nginx\e[0m"