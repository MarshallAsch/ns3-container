[![Create Docker Container](https://github.com/MarshallAsch/ns3-container/actions/workflows/deploy.yaml/badge.svg)](https://github.com/MarshallAsch/ns3-container/actions/workflows/deploy.yaml)![GitHub](https://img.shields.io/github/license/marshallasch/ns3-container?style=plastic)
![Lines of code](https://img.shields.io/tokei/lines/github/marshallasch/ns3-container?style=plastic)
![NS3 version](https://img.shields.io/badge/NS--3-3.32-blueviolet?style=plastic)
![NS3 version](https://img.shields.io/badge/NS--3-3.33-blueviolet?style=plastic)
![NS3 version](https://img.shields.io/badge/NS--3-3.34-blueviolet?style=plastic)
![NS3 version](https://img.shields.io/badge/NS--3-3.35-blueviolet?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/marshallasch/ns3?style=plastic)

# NS-3 Container

This will create a docker container for the [ns-3](https://www.nsnam.org/) network simulator. 
This repository is designed to be used as a base container for simulation models, expriments and CI piplines for ns3. 

This action can be used to check your code for multiple versions of ns-3, currently this will support
`ns-3.32`, `ns-3.33`, `ns-3.34`, and `ns-3.35`. 
If you wish to see a different version of ns-3 supported by this action open an issue and Id be happy to add support for it. 


## Motivation

The ns-3 network simulation platform is an interesting codebase that is different from most other
library projects, where instead of including the simulator as a project dependency the simulation
code needs to be written _inside_ of the simulator code.

We developed Docker containers for our simulation studies so that a permanent stable artifact can be provided. 
This base container has been developed to help provide some standardization across each of the simulations. 

## Building

The only dependency needed to build this is docker, and more than 2 GB of ram, I think 4GB might be needed
or it will crash part way through. 

```bash
$ docker build \
      --build-arg VCS_REF=$(git rev-parse -q --verify HEAD) \
      --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
      --build-arg BUILD_PROFILE=debug \
      -t marshallasch/ns3 .
```

That is all that is needed to build the docker container, you do not need to have the ns-3 codebase installed
because it will download a fresh copy of the `ns3-allinone` version when building the container. 

By default it will build NS3 version 3.32, as that is the version of the simulator that I am using for my
research.
But a different version can be specified:

```bash
$ docker build --build-arg NS3_VERSION=3.33 marshallasch/ns3 .
```

The build variant can be configured using the `BUILD_PROFILE` build-arg, it can be set to either `debug`, `release`, or `optimized`.
It is set to `debug` by default.

The only potential shortcoming of that is if there are different system dependencies needed for different
versions of ns3, although it _should_ be fine.

One thing to note about this container is that it does not support any visualization.

## Usage

This Docker image can be used in one of three ways:

1. as a base image for other ns-3 projects
2. to run ns-3 simulations directly
3. to get a bash shell in a ns-3 installation


### As a base image

The main purpose of this image is to be used as a base image for other containers. 
This image will provide the base ns-3 installation and all of its dependancies. 
Below is an example docker file showing how this base could be used:

```dockerfile
FROM marshallasch/ns3:3.32-debug

COPY . contrib/
RUN ./waf configure --enable-examples --enable-tests --build-profile=${BUILD_PROFILE} && ./waf build
```



### Interactive bash terminal

The interactive shell will put you in the ns-3 root directory.
Depending on which docker image tag is used ns-3 can either be built in debug mode or optimized mode.

```bash
docker run --rm -it marshallasch/ns3:3.32-optimized bash
```


### To run ns-3 simulations

If anything other than `bash` is given as the command to the Docker container then the command will
be passed to `./waf --run "<command>"` to run a simulation.

```bash
docker run --rm marshallasch/ns3:3.32-optimized first
```

## Special Thanks

I would like to acknowledge Dr. Jason Ernst ([@compscidr](https://github.com/compscidr))
who gave me the idea to implement this pipeline stage to help validate that my simulation code
actually builds. 
