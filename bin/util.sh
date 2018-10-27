#!/bin/sh

log(){
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $@"
}

logv(){
	if [ "${LOG_LEVEL}" = "v" ] ||[ "${LOG_LEVEL}" = "vv" ] ||[ "${LOG_LEVEL}" = "vvv" ]
	then
		log $@
	fi
}

logvv(){
	if [ "${LOG_LEVEL}" = "vv" ] ||[ "${LOG_LEVEL}" = "vvv" ]
	then
		log $@
	fi
}

logvvv(){
    if [ "${LOG_LEVEL}" = "vvv" ]
	then
		log $@
	fi
}
