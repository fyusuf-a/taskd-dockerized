#!/bin/sh

if [ $# -eq 0 ];then
  echo "Usage: add_user.sh user [group]"
  exit 1
fi

if [ $# -gt 2 ];then
  echo "Usage: add_user.sh user [group]"
  exit 1
fi

ORG="Public"
if [ $# -eq 2 ];then
  ORG=$2 
fi

taskd add org --force $ORG
taskd add user $ORG "$1"

cd ${TASKDDATA}/pki
echo $1 | tr ' ' '_' | xargs ./generate.client
cd ..

mv pki/$1.cert.pem .
mv pki/$1.key.pem .

exit 0
