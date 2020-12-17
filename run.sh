#!/bin/sh

set -e

# Add script to add user to current directory
mv /add_user.sh ${TASKDDATA}/

# If no config file found, create it
if ! test -e ${TASKDDATA}/config; then
	taskd init
 	taskd config server localhost:53589
 	taskd config pid.file ${TASKDDATA}/taskd.pid

	# Get taskd's logs to be the container's log
	ln -sf /dev/stdout ${TASKDDATA}/taskd.log
 	taskd config log ${TASKDDATA}/taskd.log

	# If no public key infrastructure subdirectory found, create it and fill it with self-signed certificate and keys
	if [ ! -d "${TASKDDATA}/pki" ]; then
		mkdir -p ${TASKDDATA}/pki

		cp /usr/share/taskd/pki/generate* ${TASKDDATA}/pki
		cp /usr/share/taskd/pki/vars ${TASKDDATA}/pki

		cd ${TASKDDATA}/pki
		if [ "$CERT_CN" ]; then
			set -id "s/\(CN=\).*/\1'CERT_CN'/" vars
		fi
		if [ "$CERT_ORGANIZATION" ]; then
			set -id "s/\(ORGANIZATION=\).*/\1'CERT_ORGANIZATION'/" vars
		fi
		if [ "$CERT_COUNTRY" ]; then
			set -id "s/\(COUNTRY=\).*/\1'CERT_COUNTRY'/" vars
		fi
		if [ "$CERT_STATE" ]; then
			set -id "s/\(STATE=\).*/\1'CERT_STATE'/" vars
		fi
		if [ "$CERT_LOCALITY" ]; then
			set -id "s/\(LOCALITY=\).*/\1'CERT_LOCALITY'/" vars
		fi
		./generate
		cd -

		taskd config client.cert ${TASKDDATA}/pki/client.cert.pem
		taskd config client.key ${TASKDDATA}/pki/client.key.pem
		taskd config server.cert ${TASKDDATA}/pki/server.cert.pem
		taskd config server.key ${TASKDDATA}/pki/server.key.pem
		taskd config server.crl ${TASKDDATA}/pki/server.crl.pem
		taskd config ca.cert ${TASKDDATA}/pki/ca.cert.pem
	fi
fi

taskd server $@
