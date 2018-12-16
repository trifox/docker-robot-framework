#!/bin/sh

log(){
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $@"
}

logv(){
	if [ "${LOG_LEVEL}" = "v" ] ||[ "${LOG_LEVEL}" = "vv" ] ||[ "${LOG_LEVEL}" = "vvv" ]
	then
		log [INFO] $@
	fi
}

logvv(){
	if [ "${LOG_LEVEL}" = "vv" ] ||[ "${LOG_LEVEL}" = "vvv" ]
	then
		log [DEBUG] $@
	fi
}

logvvv(){
    if [ "${LOG_LEVEL}" = "vvv" ]
	then
		log [TRACE] $@
	fi
}


logBegin(){

	log "///////////////////////////////////////////////////////////////////////"

}



logEnd(){


	log "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"

}
