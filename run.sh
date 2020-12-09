#!/bin/sh

# If no config file found, create config and generate keys
if ! test -e ${TASKDDATA}/config; then

	taskd init

	cp /usr/share/taskd/pki.generate* /usr/share/taskd/pki ${TASKDDATA}/pki
	./pki/generate

	taskd config client.cert ${TASKDDATA}/client.cert.pem \
	taskd config client.key ${TASKDDATA}/client.key.pem \
	taskd config server.cert ${TASKDDATA}/server.cert.pem \
 	taskd config server.key ${TASKDDATA}/server.key.pem \
 	taskd config server.crl ${TASKDDATA}/server.crl.pem \
 	taskd config ca.cert ${TASKDDATA}/ca.cert.pem \
 	taskd config log ${TASKDDATA} taskd.log \
 	taskd config pid.file ${TASKDDATA} taskd.pid \
 	taskd config server localhost:53589 \
	taskd config debug.tls 3 
fi

if [ $# -gt 0 ];then
	exec "$@"
else
	exec taskd server
fi
