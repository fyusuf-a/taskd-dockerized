# taskd-dockerized

taskd-dockerized is a containerized [Taskwarrior](https:/taskwarrior.org/) server based upon [ogarcia](https://github.com/ogarcia/docker-taskd)'s and [x4121](https://hub.docker.com/x4121/taskd)'s versions. It brings such niceness as the ability to log on stdout.

## Building

```
docker build -t taskd . --build-arg ALPINE_VERSION=latest
```

## Usage

If no config and public key infrastructure are present in the persistent directory of your choosing, the executable creates certificates and keys in the pki subdirectory. In this case, it is mandatory to provide the CERT\_CN environment variable.

If you intend to use those, you should set up your client according to the section 'Client configuration'.

```
docker run -d --name taskd \
	-p 53589:53589 \
	-v path_to_persistent_host_dir:/var/taskd \
	[-e CERT_CN = "domain_name"] \
	[-e CERT_ORGANIZATION = "Evil Corp"] \
	[-e CERT_COUNTRY = "USA"] \
	[-e CERT_STATE = "NY"] \
	[-e CERT_LOCALITY = "New York City"] \
	taskd
```

## Client configuration
