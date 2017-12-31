#!/bin/sh

################################################
# Paths used to run docker commands - set them
# properly otherwise it won't work
################################################

DOCKER_DIR='/Users/marcin/Docker/';
DEFINITIONS_DIR='/Users/marcin/Docker/definitions/';
TEMPLATE_DIR=$DOCKER_DIR'templates/';
PROJECT_DIR=$DOCKER_DIR'projects/';
LOCAL_SHARE_DIRECTORY=$DOCKER_DIR'local_share/';
DEFAULT_TEMPLATE='php7.1-nginx-mysql5.7';

################################################
# Define colors for terminal
################################################

green=`tput setaf 2`
yellow=`tput setaf 3`
red=`tput setaf 1`
reset=`tput sgr0`

################################################
# Command to display available docker commands
################################################

function docc() {
   echo "Available aliases for Docker commands:"
   echo "${green}dcc ${yellow}(Docker compose create)${reset} - create new docker compose project from template";  
   echo "${green}dcu ${yellow}(Docker compose up)${reset} - run containers from given docker compose project";
   echo "${green}dcs ${yellow}(Docker compose stop)${reset} - stop containers for given docker compose project";
   echo "${green}dcb ${yellow}(Docker compose build)${reset} - build containers for given docker compose project";
   echo "${green}dps ${yellow}(Docker ps)${reset} - show all docker containers";
   echo "${green}dsa ${yellow}(Docker stop all)${reset} - stop all containers";
   echo "${green}drma ${yellow}(Docker remove all)${reset} - remove all containers";
   echo "${green}dfrma ${yellow}(Docker full remove all)${reset} - stop and remove all containers";
   echo "${green}de ${yellow}(Docker exec)${reset} - run command in given container";
   echo "${green}dssh ${yellow}(Docker SSH)${reset} - simple 'SSH' into container";
   echo "${green}dcp ${yellow}(Docker copy)${reset} - copy files from given localization in container into local filesystem";
   echo "${green}dlogs ${yellow}(Docker logs)${reset} - display logs from given container";
   echo "${green}di ${yellow}(Docker images)${reset} - list Docker images";
   echo "${green}drmi ${yellow}(Docker remove images)${reset} - remove unused Docker images";
   echo "${green}drmia ${yellow}(Docker remove all images)${reset} - remove all Docker images (they need to be redownloaded)";
   echo "${green}dfix ${yellow}(Docker fix)${reset} - fix docker problems in case of strange errors";   
}

export -f docc

################################################
# Extra docker commands aliases
################################################

function dcu { 
# If docker-sync.yml exists run docker-sync-stack start
if [ -f "${PROJECT_DIR}${1}/docker-sync.yml" ]; then
  docker-sync-stack start --config=${PROJECT_DIR}${1}/docker-sync.yml
  return;
fi

# Otherwise run just docker-compose up
docker-compose -f "${PROJECT_DIR}${1}/docker-compose.yml" up -d; 
}

export -f dcu

function dcs { docker-compose -f "${PROJECT_DIR}${1}/docker-compose.yml" stop; }

export -f dcs

function dcb { docker-compose -f "${PROJECT_DIR}${1}/docker-compose.yml" build --no-cache; }

export -f dcb

alias dps='docker ps -a'

alias dsa='docker stop $(docker ps -a -q)'

alias drma='docker rm $(docker ps -a -q)'

alias dfrma='dsa && drma'

alias de='docker exec'

alias di='docker images'

alias drmi='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'

alias drmia='docker rmi --force $(docker images -q)'

alias dfix='docker-machine restart default && eval $(docker-machine env default)'

alias dcp='docker cp $1 $2'

alias dlogs='docker logs $1'

function dssh { docker exec -i -t $1 /bin/bash; }

export -f dssh

################################################
# Creating docker compose project from template
################################################

function dcc {

# Verify number of arguments
if [ "$#" -lt 6 ]; then
   echo "${red}Invalid number of parameters. You should pass \$domain, \$prefix, \$webPort, \$secureWebPort, \$dbPort, \$sshPort and optionally \$templateName${reset}";
   return;
fi

if [ -z "$7" ]; then
  TEMPLATE=$DEFAULT_TEMPLATE;
else
  TEMPLATE=$7;  
fi

# Verify whether template directory exists
if [ ! -d "${TEMPLATE_DIR}${TEMPLATE}" ]; then
  echo "${red}Template directory ${TEMPLATE_DIR}${TEMPLATE} does NOT exist${reset}";
  return;
fi

# Set output directory
OUTPUT_DIR=$PROJECT_DIR"$1"'/';

# Verify whether output directory already exists
if [ -d "$OUTPUT_DIR" ]; then
  echo "${red}Directory ${OUTPUT_DIR} already exists. Cannot create new Docker project${reset}";
  return;
fi

# Create project directory
mkdir $OUTPUT_DIR;
echo "Created ${OUTPUT_DIR} directory"

# Copy docker-compose.yml and fill in variables
cp "${TEMPLATE_DIR}${TEMPLATE}/docker-compose.yml" $OUTPUT_DIR; 
sed -i '' -e "s#\${projectdir}#${PROJECT_DIR}#g" ${OUTPUT_DIR}docker-compose.yml;
sed -i '' -e "s#\${definitionsdir}#${DEFINITIONS_DIR}#g" ${OUTPUT_DIR}docker-compose.yml;
sed -i '' -e "s#\${localsharedir}#${LOCAL_SHARE_DIRECTORY}#g" ${OUTPUT_DIR}docker-compose.yml;
sed -i '' -e "s/\${domain}/$1/g" ${OUTPUT_DIR}docker-compose.yml;
sed -i '' -e "s/\${prefix}/$2/g" ${OUTPUT_DIR}docker-compose.yml;
sed -i '' -e "s/\${webPort}/$3/g" ${OUTPUT_DIR}docker-compose.yml;
sed -i '' -e "s/\${secureWebPort}/$4/g" ${OUTPUT_DIR}docker-compose.yml;
sed -i '' -e "s/\${dbPort}/$5/g" ${OUTPUT_DIR}docker-compose.yml;
sed -i '' -e "s/\${sshPort}/$6/g" ${OUTPUT_DIR}docker-compose.yml;
echo "Created ${OUTPUT_DIR}docker-compose.yml file";

# Copy docker-sync.yml and fill in variables
if [ -f "${TEMPLATE_DIR}${TEMPLATE}/docker-sync.yml" ]; then
  cp "${TEMPLATE_DIR}${TEMPLATE}/docker-sync.yml" $OUTPUT_DIR;
  sed -i '' -e "s/\${prefix}/$2/g" ${OUTPUT_DIR}docker-sync.yml;
fi

# Copy nginx directory structure
cp -R "${TEMPLATE_DIR}${TEMPLATE}/nginx" "${OUTPUT_DIR}nginx"
echo "Created ${OUTPUT_DIR}nginx directory structure";

# Copy MySQL structure
cp -R "${TEMPLATE_DIR}${TEMPLATE}/mysql" "${OUTPUT_DIR}mysql"
echo "Created ${OUTPUT_DIR}mysql directory structure";

# Copy html structure
cp -R "${TEMPLATE_DIR}${TEMPLATE}/html" "${OUTPUT_DIR}html"
sed -i '' -e "s/\${domain}/$1/g" ${OUTPUT_DIR}/html/public/index.php;
echo "Created ${OUTPUT_DIR}html directory structure";

# Copy supervisor structure
cp -R "${TEMPLATE_DIR}${TEMPLATE}/supervisor" "${OUTPUT_DIR}supervisor"
echo "Created ${OUTPUT_DIR}supervisor directory structure";

# Copy cron structure
cp -R "${TEMPLATE_DIR}${TEMPLATE}/cron" "${OUTPUT_DIR}cron"
echo "Created ${OUTPUT_DIR}cron directory structure";

echo "Finished with success";

echo "${green}Hint: ${red}You should add this project to XLS to not use same ports in future${reset}";
}

export -f dcc