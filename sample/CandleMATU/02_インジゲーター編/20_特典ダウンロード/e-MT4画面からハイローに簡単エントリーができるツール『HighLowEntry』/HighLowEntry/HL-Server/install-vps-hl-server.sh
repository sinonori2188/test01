#!/bin/sh

if yum list installed | grep 'node' ; then
  echo "::: [1] node already installed :::"
else
  echo "*** [1] install node ***"
  curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -
  yum install -y nodejs
fi

echo "::: [2] open port :::"

firewall-cmd --add-port=5733/tcp --zone=public --permanent
firewall-cmd --reload
firewall-cmd --list-all

firewall-cmd --add-service=http --zone=public --permanent
firewall-cmd --add-service=https --zone=public --permanent
firewall-cmd --reload
firewall-cmd --list-all

echo "::: [3] module install :::"

npm install

echo "::: [4] start hl-server :::"

nohup node hl-server.js >/dev/null &
