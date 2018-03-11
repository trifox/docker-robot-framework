# Extended Robot Framework in Docker 

... with many utility Libraries installed, spawned from:
https://github.com/ppodgorsek/docker-robot-framework

# acknowlegdments

* WIndows user: dont forget to 

      git config --global core.autocrlf false

# Robot Framework in Docker, with Firefox and Chrome ... and RobotFramework Libraries

## What is it?

This project consists of a Docker image containing a Robot Framework installation. 

This installation also contains Firefox, Chrome and the Selenium library for Robot Framework. The test cases and reports should be mounted as volumes.

The robot framework comes with a bunch of preinstalled python libraries which are:


[robotframework-requests==0.4.7](http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)

[robotframework-advancedlogging==1.0.1](https://github.com/peterservice-rnd/robotframework-advancedlogging)

[robotframework-imaplibrary==0.1.4](https://rickypc.github.io/robotframework-imaplibrary/doc/ImapLibrary.html)

[robotframework-difflibrary==0.1.0](https://bulkan.github.io/robotframework-difflibrary/)

[robotframework-async==1.0.3](https://pypi.python.org/pypi/robotframework-async) 

[robotframework-mongodblibrary==0.3.4](http://mahartma.github.io/robotframework-mongodblibrary/de.codecentric.robot.mongodblibrary.keywords.MongodbLibrary.html)

[robotframework-databaselibrary==1.0.1](https://franz-see.github.io/Robotframework-Database-Library/api/1.0.1/DatabaseLibrary.html)

[robotframework-kafkalibrary==0.0.1](https://rawgit.com/s4int/robotframework-KafkaLibrary/master/doc/KafkaLibrary.html)

[robotframework-jsonlibrary==0.2](https://nottyo.github.io/robotframework-jsonlibrary/JSONLibrary.html)

[robotframework-wiremock==0.0.8](https://tyrjola.github.io/docs/robotframework-wiremock.html)

[robotframework-jsonschemalibrary==1.0](https://github.com/jstaffans/robotframework-jsonschemalibrary)

[robotframework-seleniumlibrary==3.1.1](http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
 
 
## Running the container

This container can be run using the following command:

    docker run -v <local path to the reports' folder>:/opt/robotframework/reports:Z\
        -v <local path to the test suites' folder>:/opt/robotframework/tests:Z\
        ppodgorsek/robot-framework:<version>

### Switching browsers

Browsers can be easily switched. It is recommended to define `${BROWSER} %{BROWSER}` in your Robot variables and to use `${BROWSER}` in your test cases. This allows to set the browser in a single place if needed.

When running your tests, simply add `-e BROWSER=chrome` or `-e BROWSER=firefox` to the run command.

### Changing the container screen's resolution

It is possible to define the settings of the virtual screen in which the browser is run by changing several environment variables:

* `SCREEN_COLOUR_DEPTH` (default: 24)
* `SCREEN_HEIGHT` (default: 1080)
* `SCREEN_WIDTH` (default: 1920)

## Testing this project

Not convinced yet? Simple tests have been prepared in the `test/` folder, you can run them using the following commands:

    # Using Chromium
    docker run -v `pwd`/reports:/opt/robotframework/reports:Z\
        -v `pwd`/test:/opt/robotframework/tests:Z\
        -e BROWSER=chrome\
        ppodgorsek/robot-framework:latest
    
    # Using Firefox
    docker run -v `pwd`/reports:/opt/robotframework/reports:Z\
        -v `pwd`/test:/opt/robotframework/tests:Z\
        -e BROWSER=firefox\
        ppodgorsek/robot-framework:latest

Screenshots of the results will be available in the `reports/` folder.

## Please contribute!


 * created from [https://github.com/ppodgorsek/docker-robot-framework](https://github.com/ppodgorsek/docker-robot-framework) mainly because it heeded a patch for the apk installation, fixing versions and extending the robot library was the main cause
