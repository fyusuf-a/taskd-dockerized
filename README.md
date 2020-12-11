# taskd-dockerized

taskd-dockerized is a containerized [Taskwarrior](https:/taskwarrior.org/) server based upon [ogarcia](https://github.com/ogarcia/docker-taskd)'s and [x4121]'s versions. It brings such niceness as the ability to log on stdoud.

## Building

```
docker build -t taskd . --build-arg ALPINE_VERSION=3.12.1
```

## Usage

If no config and public key infrastructure are present in the persistent directory of your choosing, the executable creates certificate and keys in the pki subdirectory. In this case, it is mandatory to provide the CERT\_CN environment variable.

```
docker run -d --name taskd \
	-p 53589 \
	-v path_to_persistent_host_dir:/var/taskd \
	[-e CERT_CN = "domain_name"] \
	[-e CERT_ORGANIZATION = "Evil Corp"] \
	[-e CERT_COUNTRY = "USA"] \
	[-e CERT_STATE = "NY"] \
	[-e CERT_LOCALITY = "New York"] \
	taskd
```
