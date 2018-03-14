# Extended Robot Framework in Docker and Chrome Headless 

This repository holds a [docker](http://docker.com) image with [robotframework](http://robotframework.org/) and some useful libraries pre installed,
and a [headless chrome] that can be used in the robot testing environment using the [robotframework-seleniumlibrary]

... with many utility Libraries installed, spawned from:
https://github.com/ppodgorsek/docker-robot-framework 

# Robot Framework in Docker, with Chrome only... and RobotFramework Libraries

## What is it?

This project consists of a Docker image containing a Robot Framework installation. 

This installation also contains Firefox, Chrome and the Selenium library for Robot Framework. The test cases and reports should be mounted as volumes.

## Bundled Robot Libraries

The robot framework comes with a bunch of preinstalled python libraries which are:


[robotframework-requests==0.4.7](http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)

[robotframework-advancedlogging==1.0.1](https://github.com/peterservice-rnd/robotframework-advancedlogging)

[robotframework-imaplibrary==0.1.4](https://rickypc.github.io/robotframework-imaplibrary/doc/ImapLibrary.html)

[robotframework-difflibrary==0.1.0](https://bulkan.github.io/robotframework-difflibrary/) 

[robotframework-mongodblibrary==0.3.4](http://mahartma.github.io/robotframework-mongodblibrary/de.codecentric.robot.mongodblibrary.keywords.MongodbLibrary.html)

[robotframework-databaselibrary==1.0.1](https://franz-see.github.io/Robotframework-Database-Library/api/1.0.1/DatabaseLibrary.html)

[robotframework-kafkalibrary==0.0.1](https://rawgit.com/s4int/robotframework-KafkaLibrary/master/doc/KafkaLibrary.html)

[robotframework-jsonlibrary==0.2](https://nottyo.github.io/robotframework-jsonlibrary/JSONLibrary.html)
 
[robotframework-jsonschemalibrary==1.0](https://github.com/jstaffans/robotframework-jsonschemalibrary)

[robotframework-seleniumlibrary==3.1.1](http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
 
[robotframework-csvlibrary==3.1.1](https://rawgit.com/s4int/robotframework-CSVLibrary/master/doc/CSVLibrary.html)
 
[robotframework-yamlibrary==3.1.1](https://github.com/divfor/robotframework-yamllibrary)
 
 
## Building the container

	build.sh


## Executing the container

use a docker-compose.yml to define the tests - this example is included in this repo and can be started 
	
```dockerfile
version: '3'
    services:
      roboter_chrome:
        image: ufp-docker-robot-framework
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
 
### Changing the container screen's resolution

It is possible to define the settings of the virtual screen in which the browser is run by changing several environment variables:
 
* `SCREEN_HEIGHT` (default: 1080)
* `SCREEN_WIDTH` (default: 1920)
* `ENV ROBOT_INCLUDE_TAG` (default:'')
* `ENV ROBOT_EXCLUDE_TAG` (default:'')
* `ENV ROBOT_CRITICAL_TAG` (default:'critical')
* `ENV ROBOT_NONCRITICAL_TAG` (default:'noncritical')
* `ENV ROBOT_LOGLEVEL` (default:'INFO')
* `ENV ROBOT_OPTIONS` (default:'')
  
## Acknowledgments

 - this repo has been forked from [https://github.com/ppodgorsek/docker-robot-framework](https://github.com/ppodgorsek/docker-robot-framework)
 
 - Shared Memory Size 'shm_size' in cases of heavy memory use e.g. for browser testing a reasonable high memory has to be provided
