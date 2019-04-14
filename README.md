# Extended Robot Framework in Docker and Chrome Headless 

This repository holds a [docker](http://docker.com) image with [robotframework](http://robotframework.org/) and some useful libraries pre installed,
and a [headless chrome] that can be used in the robot testing environment using the [robotframework-seleniumlibrary]

... with many utility Libraries installed, spawned from:
https://github.com/ppodgorsek/docker-robot-framework 

## Prerequisites

* [Docker](http://www.docker.com) 

## Quickstart

Make the docker image

	sidt.sh -m service

Test The image, first start the infra stack 

	sidt.sh -u infra

then run the robot test against it (kinda inception testing itself by using itself)

the sidt.sh is a service paradigm read more about it [here](https://github.com/FrontendSolutionsGmbH/ufp-sidt-template) a short primer:

	-u debug - starts the debug stack usually with some utility containers
	-b runs stack in foreground

## What is it?

This project consists of a Docker image containing a Robot Framework installation. 

This installation also contains Chrome and the Selenium, and some more for libraries bundled with Robot Framework. 

The test cases and reports should be mounted as volumes.

## Bundled Robot Libraries

The robot framework comes with a bunch of preinstalled python libraries which are:

                            
[robotframework-advancedlogging==1.0.1](https://github.com/peterservice-rnd/robotframework-advancedlogging)

[robotframework-csvlibrary==3.1.1](https://rawgit.com/s4int/robotframework-CSVLibrary/master/doc/CSVLibrary.html)

[robotframework-databaselibrary==1.0.1](https://franz-see.github.io/Robotframework-Database-Library/api/1.0.1/DatabaseLibrary.html)

[robotframework-difflibrary==0.1.0](https://bulkan.github.io/robotframework-difflibrary/) 

[robotframework-fakerlibrary==4.2.0](https://guykisel.github.io/robotframework-faker/)

[robotframework-imaplibrary==0.1.4](https://rickypc.github.io/robotframework-imaplibrary/doc/ImapLibrary.html)

[robotframework-jsonlibrary==0.2](https://nottyo.github.io/robotframework-jsonlibrary/JSONLibrary.html)

[robotframework-jsonschemalibrary==1.0](https://github.com/jstaffans/robotframework-jsonschemalibrary)

[robotframework-kafkalibrary==0.0.1](https://rawgit.com/s4int/robotframework-KafkaLibrary/master/doc/KafkaLibrary.html)

[robotframework-mongodblibrary==0.3.4](http://mahartma.github.io/robotframework-mongodblibrary/de.codecentric.robot.mongodblibrary.keywords.MongodbLibrary.html)

[robotframework-requests==0.4.7](https://github.com/bulkan/robotframework-requests)

[robotframework-seleniumlibrary==3.1.1](http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
 
[robotframework-yamlibrary==3.1.1](https://github.com/divfor/robotframework-yamllibrary)
 
[RESTinstance==1.0.0rc5](https://github.com/asyrjasalo/RESTinstance)
 
## Building the container

The docker image needs to be created using

	./sidt.sh -m python2
	
and

    ./sidt.sh -m python3
    
 
 # Running self-tests
 
 use the stack.sh to bring up the testing infrastructur - after the build step before - using:
 
    ./sidt.sh -u infra
    
 and then run the tests 
 
    ./sidth.sh -u test -b
    
and the extensive tests testing both python2 and python3 images for their log levels v,vv and vv

    ./sidt.sh -u test-extensive -b


# Build / Deploy

The ./deploy.sh script is used to deploy the image to the docker.hub it is build, and after succesful tests it is deployed to docker hub

## Executing the container

A [docker-compose.yml](https://docs.docker.com/compose/) file defines all that is needed to run the tests
 in robotframework. It is started using in same folder

	docker-compose up

this is an example docker-compose file that is included in this repo 

	
```dockerfile
version: '3'
services:
  roboter_chrome:
	image: ckleinhuis/ufp-robotframework:latest
	 #
	 # shared memory size configuration
	 # even headless chrome needs some swapping memory, this is configured here
	 # and set to a reasonable amount if browser crashes without other reasons
	 # checking the free memory is quite an issue
	 #
	shm_size: '4gb'
	volumes:
	  - ./reports:/opt/robotframework/reports
	  - ./test:/opt/robotframework/tests
```

place this folder where a sub-folder 'tests' exists - containing the robot test
 
### Environment Configuration

It is possible to define the settings of the virtual screen in which the browser is run by changing 
several environment variables:
 
* `SCREEN_HEIGHT` (default: 1080)
* `SCREEN_WIDTH` (default: 1920)
* `ENV ROBOT_INCLUDE_TAG` (default:'')
* `ENV ROBOT_EXCLUDE_TAG` (default:'')
* `ENV ROBOT_CRITICAL_TAG` (default:'critical')
* `ENV ROBOT_NONCRITICAL_TAG` (default:'noncritical')
* `ENV ROBOT_LOGLEVEL` (default:'INFO')
* `ENV ROBOT_OPTIONS` (default:'')
### Log Level Documentation
 
 the log level is using v,vv,vvv for log level depth here the various depths are explained and what they do in the current configuration
 
#### Loglevel v
	* lints source test files    
	* prints information on console

#### Loglevel vv
	* creates keyword resource documentation 
	* creates test documentation
	* tidies up source test files
	* creates library documentaiton from bundled libraries in /reports/doc
#### Loglevel vvv
	* system level python packages version info
	* beautify robot source code
	* system level package version info

## Acknowledgments

 - this repo has been forked from [https://github.com/ppodgorsek/docker-robot-framework](https://github.com/ppodgorsek/docker-robot-framework)
 
 - Shared Memory Size 'shm_size' in cases of heavy memory use e.g. for browser testing a 
 reasonable high memory has to be provided
