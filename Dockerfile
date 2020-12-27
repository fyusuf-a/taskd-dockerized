ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache --no-progress taskd taskd-pki

COPY add_user.sh /
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ARG TASKDDATA
ENV TASKDDATA /var/taskd

RUN mkdir -p ${TASKDDATA}

WORKDIR ${TASKDDATA}

VOLUME ["${TASKDDATA}"]

EXPOSE 53589

ENTRYPOINT ["/docker-entrypoint.sh"]
