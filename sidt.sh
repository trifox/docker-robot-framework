#!/usr/bin/env bash

loadEnv(){

filename=".env"
while IFS='=' read -r key value ; do
    export $key=$value
#    echo "Name read from file - $key -- $value"
done < "$filename"

}
loadEnv

COLOR1="\033[1;34m"
COLOR2="\033[0;33m"
NOCOLOR="\033[0m" # No Color
log(){
	echo -e "[${COLOR1}$(date '+%Y-%m-%d %H:%M:%S')${NOCOLOR}] [${COLOR2}${1}${NOCOLOR}]"
}

log ""
log "SIDT - Service Infrastructure Debug Test"
log ""

ACTIVE_STACKS=(infra service debug test)

CACHE=${SIDT_CACHE:-"--no-cache"}
#CACHE=""
DOCKERFILESUFFIX="service"

SUITE_NAME=${SIDT_SUITE:-"componenttest"}

PROJECT_NAME=${SIDT_PROJECT_NAME:-"frontendsolutions/ufp-backend"}
export VERSION=${SIDT_VERSION:-1}
export CWD=$(pwd)
SCRIPT_PATH=$(realpath "$0")
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_HOME=${SCRIPT_PATH%$SCRIPT_NAME}

START=1
STOP=0

LOG_STACK=0
STATE_STACK=${SIDT_INFO:-0}
PULL_STACK=0
DEBUG=${SIDT_DEBUG:-1}
MAKE=0
EXECUTE=1
PUSH=0

BACKGROUND="-d"
CREATE=0

COMPOSE_PROJECT_NAME="${PROJECT_NAME}componenttest"

RESULT=0
###
# Functions
###

dockerCompose () {

	log "------------------------------- docker-compose -------------------------------------"
	log "docker-compose ${1} ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9}"
	log "------------------------------- docker-compose  -------------------------------------"
	docker-compose ${1} ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9}

}

help() {
  echo " "
  echo " SIDT Cli"
  echo " "
  echo " ./sidt.sh -[action] stack "
  echo " "
  echo " Starts/Stops the local stack and their debug-tools."
  echo " Options:"
  echo "   -h           Show this help"
  echo "   -p <stack>   Pulls the latest docker images"
  echo "   -b           Starts stack in background with -d"
  echo "   -c           (re-)Create container stacks"
  echo "   -v <version> Version"
  echo "   -n <name>    Name"
  echo "   -q <name>    PUSH to name"
  echo "   -m <name>    Make"
  echo "   -l <stack>   Show the logs of stacks"
  echo "   -u <stack>   Starts the given stack. Possible stacks see below!"
  echo "   -d <stack>   Stops the given stack. Possible stacks see below!"
  echo "   -s <stack>   Stack state ps"
  echo "   -a <area>    Stack area, an area is a folder containing the -stack yamls"
  echo "   -x     Publishes the main docker service image to registry"
  echo ""
  echo "   Possible Stacks:"
  echo "     infra     The infrastructure needed by the services"
  echo "     service   The involved services"
  echo "     debug     The debug tools"
  echo "     dependencies Dependencies"
  echo "     all       All these stacks"
  echo "     *any      Any other componenttest/docker-compose-[*any].yml"
  echo ""
  echo "   Possible Make Areas:"
  echo "     Any folder in the /stacks directory"
  echo ""
  echo "   Possible Make Targets:"
  echo "     service   The Service points to Dockerfile in current dir"
  echo "     *any      Any other input is suffixed to dockerfile in same dir Dockerfile.{Name}"
  echo ""
  echo " Default behavior: Does Nothing"
  echo ""
  echo " (continued) author: ck@froso.de"
  echo " (initial) author: s.schumann@tarent.de"
}

pushMainServiceDockerImage() {

    VERSION=${VERSION} envsubst <docker-compose.yml>>docker-compose-fix.yml

	DOCKERFILENAME=${DOCKERFILESUFFIX}
	DOCKERTAG=${DOCKERFILESUFFIX}

	if [ "$DOCKERFILESUFFIX" = "service" ]; then
	   DOCKERFILENAME=""
	   DOCKERTAG=""

	elif [ $DOCKERFILESUFFIX ]; then
	   DOCKERFILENAME=".$DOCKERFILESUFFIX"
	   DOCKERTAG="-$DOCKERFILESUFFIX"
	fi
	log "PUSHING main docker image ${PROJECT_NAME}:${VERSION}${DOCKERTAG} "
    docker push ${PROJECT_NAME}:${VERSION}${DOCKERTAG}
#    docker push ${PROJECT_NAME}${DOCKERTAG}:latest

}

makeIt(){
DOIT=${1:-1}
DOCKERFILENAME=${DOCKERFILESUFFIX}
DOCKERTAG=${DOCKERFILESUFFIX}

if [ "$DOCKERFILESUFFIX" = "service" ]; then
   DOCKERFILENAME=""
   DOCKERTAG=""



# MANUAL EDIT EXECUTE LOCALIZED BUT DOCKERIZED MAVEN BUILD
#
#if [ "$DOIT" = "1" ]; then
#./maven.sh clean install
#	TEMP=$?
#	if [ $TEMP -eq 0 ];then
#		log "MAKE SUCCESS"
#	else
#		log "MAKE FAILED"
#		RESULT=$TEMP
#		exit ${RESULT}
#	fi
#
#else
#	log "MAKING SKIPPED"
#fi

elif [ $DOCKERFILESUFFIX ]; then
   DOCKERFILENAME=".${DOCKERFILESUFFIX}"
   DOCKERTAG="-${DOCKERFILESUFFIX}"
fi


    	#    handle call to docker build of main service in root Dockerfile
	log "Building main docker image Dockerfile${DOCKERFILENAME} ${PROJECT_NAME}:${VERSION}${DOCKERTAG} "
        docker build -f Dockerfile${DOCKERFILENAME} -t ${PROJECT_NAME}:${VERSION}${DOCKERTAG}  --build-arg VERSION=${VERSION}  -t ${PROJECT_NAME}:${VERSION}${DOCKERTAG}  -t ${PROJECT_NAME}:latest .  ${CACHE}

TEMP=$?
if [ $TEMP -eq 0 ];then
	echo "BUILD SUCCESS"
else
	echo "BUILD FAILED"
	RESULT=$TEMP
fi



}

pullStack() {
    COMPOSE_FILENAME="${STACK_LOCATION}${1}.yml"

	log "Pulling Stack ${1}"
    dockerCompose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} pull
}

logStack() {
    COMPOSE_FILENAME="${STACK_LOCATION}${1}.yml"
    log "Logging Stack ${1}"
    dockerCompose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} logs $2
}

statsStack() {
    COMPOSE_FILENAME="${STACK_LOCATION}${1}.yml"
    log "Stats Stack ${1}"
    dockerCompose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} ps
}

startStack() {
    COMPOSE_FILENAME="${STACK_LOCATION}${1}.yml"

	log "(Re-)Starting Stack ${1}"

	stopStack  ${1}

    if [ "$CREATE" -eq "1" ]; then
	    log "(Re-)Creating Stack ${1}"

    if [ "${1}" == "service" ]; then
      log "Recreating Dockerfile for main service"
      makeIt 0
    fi



	  log "(Re-)Creating Stack ${1}"
	dockerCompose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} build  --no-cache --force-rm
	else
	    log "Stopping Stack ${1}"
	stopStack  ${1}
	 fi

 	if [ "${1}" == "test" ]; then
      log "Deleting Test Report Folder"
      rm -rf stacks/componenttest/robot/report
    fi

    if [ -f ${COMPOSE_FILENAME} ]; then
        log "Starting Stack with start-dependencies entrypoint"
        dockerCompose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME}   run   start-dependencies
        TEMP=$?
#        if [ "$TEMP" -ne "0" ]; then
#        	log "$TEMP start-dependencies not found starting normal"
#            docker-compose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND} --build --force-recreate
#            TEMP=$?
#        fi
#		else
	#        check for log if run in run mode with start-dependencies

			if [ $TEMP -eq 0 ];then
				echo "COMMAND SUCCESS"
			else
				echo "COMMAND FAILED"
				RESULT=$TEMP
			fi

			if [ -z "${BACKGROUND}"  ]; then
	#        call log with tail -f
			logStack $1 -f
			fi

#			iterate over all stacks entries and ghet exit code
            RESULT=$(docker-compose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} ps -q   | xargs docker inspect -f '{{ .State.ExitCode }}' | grep -v '^0' | wc -l | tr -d ' ')
#         fi
    else
        log "File not found ${1}"
    fi
}
stopStack() {
    COMPOSE_FILENAME="${STACK_LOCATION}${1}.yml"
	  log "Stopping Stack ${1}  ${COMPOSE_PROJECT_NAME}"
    dockerCompose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME}   down -v
#     --rmi all
}

logAllImages() {
    logStack ${STACK_LOCATION_SERVICE}
    logStack ${STACK_LOCATION_INFRA}
    logStack ${STACK_LOCATION_DEBUG}
    logStack ${STACK_LOCATION_TEST}
}

pullAllImages() {
    pullStack ${STACK_LOCATION_SERVICE}
    pullStack ${STACK_LOCATION_INFRA}
    pullStack ${STACK_LOCATION_DEBUG}
    pullStack ${STACK_LOCATION_TEST}
}

chooseServices() {
    ACTIVE_STACKS=()
    case $1 in
       all)
            ACTIVE_STACKS+=("infra")
            ACTIVE_STACKS+=("service")
#            ACTIVE_STACKS+=("debug")
#            ACTIVE_STACKS+=("test")
            ;;
     *)
            log "Using input --- $1"
            STACK_NAME=$1
            ACTIVE_STACKS+=("$1")
    esac
}
chooseArea() {
    ACTIVE_STACKS=()
    case $1 in
     *)
            log "Using input area --- $1"
            SUITE_NAME=$1
    esac
}
chooseName() {
    case $1 in
     *)
            log "Using name --- $1"
            PROJECT_NAME=$1
    esac
}
chooseVersion() {
    case $1 in
     *)
            log "Using version --- $1"
            VERSION=$1
    esac
}

chooseDockerfile() {
    case $1 in
     *)
            log "Using input area --- $1"
            DOCKERFILESUFFIX="$1"
    esac
}

###
# Main
###

#if [ "$#" -ge 1 ]; then
#    STACK_SERVICE=0
#fi

while getopts 'v:m:a:u:d:p:l:s:chbx:' OPTION; do
  case $OPTION in
    b)
    	log "Background flag -b found, starting in background"
        BACKGROUND=""
    ;;
    p)
    	log "Pull All Images flag -p found, pulling all images"
        chooseServices $OPTARG
    ;;
    c)
    	log "Create flag -c found, (re-)creating stacks/images"
        CREATE=1
    ;;
 	s)
    	log "State flag -s found,  printing stats"
        STATE_STACK=1
        START=0
        STOP=0
        chooseServices $OPTARG
    ;;

    l)
    	log "Log flag -l found, logging  stacks"
#        logAllImages
		  LOG_STACK=1
        START=0
        STOP=0
        chooseServices $OPTARG
    ;;
    u)
    	log "Start flag -u found, starting"
        START=1
        STOP=0
        chooseServices $OPTARG
    ;;
    x)
    	log "Publish flag -x found, pushing to registry"
        PUSH=1
        STATE_STACK=0
        MAKE=0
        START=0
        STOP=0
        EXECUTE=0
        chooseDockerfile $OPTARG
    ;;
    d)
    	log "Stop flag -d found, stopping"
        START=0
        STOP=1
        chooseServices $OPTARG
    ;;
    a)
    	log "Area flag -a found, determining area"
        chooseArea $OPTARG
    ;;
      v)
    	log "Version flag -v found, determining version"
        chooseVersion $OPTARG
    ;;
      n)
    	log "Name flag -n found, determining name"
        chooseName $OPTARG
    ;;
    m)
    	log "Dockerfile Make flag -m found, determining Dockerfile, ommiting all other params"
        chooseDockerfile $OPTARG
        MAKE=1
        EXECUTE=0
    ;;
    h)
        help
        exit 0
    ;;

  esac
done

STACK_LOCATION="${SCRIPT_HOME}stacks/${SUITE_NAME}/docker-compose-"
STACK_LOCATION_SERVICE="${STACK_LOCATION}service.yml"
BUILD_DEPENDENCIES="${STACK_LOCATION}dependencies.yml"
STACK_LOCATION_INFRA="${STACK_LOCATION}infrastructure.yml"
STACK_LOCATION_DEBUG="${STACK_LOCATION}debug.yml"
STACK_LOCATION_TEST="${STACK_LOCATION}test.yml"

info(){




log ""
log "SIDT - Dockerfile '${DOCKERFILESUFFIX}'"
log "SIDT - Suite '${SUITE_NAME}'"
log "SIDT - Stacks [${ACTIVE_STACKS[*]}]"
log ""
log "${PROJECT_NAME}:${VERSION}"
}



 info
execute(){
    log "Executing ${1}"

    if [ "$STOP" -eq "1" ];then
     stopStack $1
    fi
    if [ "$START" -eq "1" ];then
    startStack $1
    fi

    if [ "$LOG_STACK" -eq "1" ];then
    logStack $1
    fi
    if [ "$PULL_STACK" -eq "1" ];then
    pullStack $1
    fi
    if [ "$STATE_STACK" -eq "1" ];then
    statsStack $1
    fi


}



if [ "$DEBUG" -eq "1" ]; then
set -x
fi

if [ "$EXECUTE" -eq "1" ]; then
  for stack_name in "${ACTIVE_STACKS[@]}"
  do
    execute ${stack_name}
  done

#  for stack_name in "${ACTIVE_STACKS[@]}"
#  do
#    statsStack ${STACK_LOCATION}${stack_name}.yml
#  done

elif [ "$MAKE" -eq "1" ]; then
  makeIt
elif [ "$PUSH" -eq "1" ];then
    pushMainServiceDockerImage
fi
log ""
log "SIDT - ${ACTIVE_STACKS}"
log "SIDT - Service Infrastructure Debug Test Exit"
log ""

echo "SIDT.sh exiting with result ${RESULT}"
exit ${RESULT}

