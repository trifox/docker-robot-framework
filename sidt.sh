#!/usr/bin/env bash
# SIDT https://github.com/FrontendSolutionsGmbH/ufp-sidt-template

loadEnv(){

filename=".env"
while IFS='=' read -r key value ; do
    export $key=$value
    echo "Name read from file - $key -- $value"
done < "$filename"

}
loadEnv
log(){
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $@"
}

log ""
log "SIDT - Service Infrastructure Debug Test"
log ""

ACTIVE_STACKS=(infra service debug test)

CACHE="--no-cache"
CACHE =""
DOCKERFILESUFFIX=""

SUITE_NAME=${SIDT_SUITE:-"componenttest"}

PROJECT_NAME=${SIDT_PROJECT_NAME:-"ckleinhuis/ufp-robotframework"}
VERSION=${SIDT_VERSION:-13}
SCRIPT_PATH=$(realpath "$0")
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_HOME=${SCRIPT_PATH%$SCRIPT_NAME}

START=1
STOP=0

LOG_STACK=0
STATE_STACK=0
PULL_STACK=0
DEBUG=${SIDT_DEBUG:-0}
MAKE=0
EXECUTE=1

BACKGROUND="-d"
CREATE=0

COMPOSE_PROJECT_NAME="${PROJECT_NAME}componenttest"

RESULT=0
###
# Functions
###

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
  echo "   -m <name>    Make"
  echo "   -l <stack>   Show the logs of stacks"
  echo "   -u <stack>   Starts the given stack. Possible stacks see below!"
  echo "   -d <stack>   Stops the given stack. Possible stacks see below!"
  echo "   -s <stack>   Stack state ps"
  echo "   -a <area>    Stack area, an area is a folder containing the -stack yamls"
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

makeIt(){

DOCKERFILENAME=${DOCKERFILESUFFIX}
DOCKERTAG=${DOCKERFILESUFFIX}

if [ "$DOCKERFILESUFFIX" = "service" ]; then
   DOCKERFILENAME=""
   DOCKERTAG=""
elif [ $DOCKERFILESUFFIX ]; then
   DOCKERFILENAME=".$DOCKERFILESUFFIX"
   DOCKERTAG="-$DOCKERFILESUFFIX"
fi
cd application
    	#    handle call to docker build of main service in root Dockerfile
	log "Building main docker image Dockerfile${DOCKERFILENAME} $PROJECT_NAME${DOCKERTAG}:$VERSION "
        docker build -f Dockerfile${DOCKERFILENAME} --rm -t ${PROJECT_NAME}${DOCKERTAG}:${VERSION}  -t ${PROJECT_NAME}${DOCKERTAG}:latest .  ${CACHE}
cd ..

}

pullStack() {
    COMPOSE_FILENAME=$1

	log "Pulling Stack ${COMPOSE_FILENAME}"
    docker-compose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} pull
}

logStack() {
    COMPOSE_FILENAME=$1
    log "Logging Stack ${COMPOSE_FILENAME}"
    docker-compose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME}logs
}

statsStack() {
    COMPOSE_FILENAME=$1
    log "Stats Stack ${COMPOSE_FILENAME}"
    docker-compose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} ps
}

startStack() {
    COMPOSE_FILENAME=$1

	log "(Re-)Starting Stack ${COMPOSE_FILENAME}"

	stopStack  $COMPOSE_FILENAME
    if [ "$CREATE" -eq "1" ]; then
	    log "(Re-)Creating Stack ${COMPOSE_FILENAME}"
		  docker-compose -f $COMPOSE_FILENAME -p ${COMPOSE_PROJECT_NAME} build  --no-cache --force-rm
	  fi

    if [ -f $1 ]; then
        log "Starting Stack with start-dependencies entrypoint"
        docker-compose -f $1 -p ${COMPOSE_PROJECT_NAME} run --rm start-dependencies
        if [ "$?" -ne "0" ]; then
        log "wait-for-dependencies not found starting normal"
            docker-compose -f $1 -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND}
        fi
    else
        log "File not found ${1}"
    fi


    docker-compose -f $1 -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND}
    RESULT=$?
}
stopStack() {
    COMPOSE_FILENAME=$1
	  log "Stopping Stack ${COMPOSE_FILENAME}"
    docker-compose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} down -v
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
            ACTIVE_STACKS+=("debug")
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

while getopts 'v:m:a:u:d:p:l:s:chb' OPTION; do
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


log ""
log "SIDT - Dockerfile '${DOCKERFILESUFFIX}'"
log "SIDT - Suite '${SUITE_NAME}'"
log "SIDT - Stacks [${ACTIVE_STACKS[*]}]"
log ""

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
    execute ${STACK_LOCATION}${stack_name}.yml
  done

#  for stack_name in "${ACTIVE_STACKS[@]}"
#  do
#    statsStack ${STACK_LOCATION}${stack_name}.yml
#  done

elif [ "$MAKE" -eq "1" ]; then
  makeIt
fi

log ""
log "SIDT - ${ACTIVE_STACKS}"
log "SIDT - Service Infrastructure Debug Test Exit"
log ""

echo "SIDT.sh exiting with result ${RESULT}"
exit ${RESULT}
