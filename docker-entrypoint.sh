#!/bin/sh

set -e

if [ ! "$CERT_CN" ]; then
	echo 'You have to set a $CERT_CN environment variable'
	exit 1
fi

# Add script to add user to current directory
mv /add_user ${TASKDDATA}/

# If no config file found, create it
if ! test -e ${TASKDDATA}/config; then
	taskd init
 	taskd config server ${CERT_CN}:53589
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
		sed -id "s/\(CN=\).*/\1\"$CERT_CN\"/" vars
		if [ "$CERT_ORGANIZATION" ]; then
			sed -id "s/\(ORGANIZATION=\).*/\1'CERT_ORGANIZATION'/" vars
		fi
		if [ "$CERT_COUNTRY" ]; then
			sed -id "s/\(COUNTRY=\).*/\1'CERT_COUNTRY'/" vars
		fi
		if [ "$CERT_STATE" ]; then
			sed -id "s/\(STATE=\).*/\1'CERT_STATE'/" vars
		fi
		if [ "$CERT_LOCALITY" ]; then
			sed -id "s/\(LOCALITY=\).*/\1'CERT_LOCALITY'/" vars
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

export PATH=$PATH:${TASKDDATA}

taskd server $@
