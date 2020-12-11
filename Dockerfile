ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache --no-progress taskd taskd-pki

COPY add_user.sh /
COPY run.sh /
RUN chmod +x /run.sh

ARG TASKDDATA
ENV TASKDDATA ${TASKDDATA:-/var/taskd}

RUN mkdir -p ${TASKDDATA}

WORKDIR ${TASKDDATA}

VOLUME ["${TASKDDATA}"]
EXPOSE 53589

#ENV DEBUG ${DEBUG:-no}

ENTRYPOINT ["/run.sh"]
#CMD taskd server
