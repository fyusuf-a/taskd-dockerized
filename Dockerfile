ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

#RUN addgroup -S taskd \
	#&& adduser -S -G taskd taskd

RUN apk add --no-cache --no-progress taskd taskd-pki

COPY run.sh /run.sh
RUN chmod +x /run.sh

ARG TASKDDATA
ENV TASKDDATA ${TASKDDATA:-/var/taskd}

	#&& mkdir -p $TASKDDATA \
	#&& chown -R taskd:taskd /var/taskd

WORKDIR /var/taskd

VOLUME ["${TASKDDATA}"]
EXPOSE 53589

ENTRYPOINT ["/run.sh"]
