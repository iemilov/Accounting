#!/bin/bash
#Get the latest package version ID
#Platform=$(sfdx force:package:version:list -p 'Vestas_Platform_Package' -o CreatedDate --concise | tail -1 | awk '{print $3}')
#sfdx force:auth:web:login -d -a DevHub
#sfdx force:org:list --all
args=("$@")

SCRATCH_ORG_ALIAS=""
DEVHUB_ALIAS=""

function goto
{
  label=$1
  cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
  eval "$cmd"
  exit
}

if [ $# -gt 1 ]
  then
    SCRATCH_ORG_ALIAS=$2
    DEVHUB_ALIAS=$1
  else 
  echo 'USAGE : setupScratchOrg <DEVHUB_ALIAS> <SCRATCH_ORG_ALIAS>'
  exit
fi

echo '##### DEFINE DEVHUB AS DEFAULT #####'
sfdx force:config:set defaultusername=${DEVHUB_ALIAS}

echo '##### CREATING SCRATCH ORG #####'
sfdx force:org:create -f config/project-scratch-def.json -a ${SCRATCH_ORG_ALIAS} -s -d 30

if [ "$?" = "1" ] 
then
	echo "Can't create your scratch org."
  echo "Please authorize your dev hub with this command : sfdx force:auth:web:login -d -a <DEVHUB_ALIAS>"
	exit
fi

echo "Scratch org created."

echo '##### GENERATE PASSWORD #####'
sfdx force:user:password:generate -u ${SCRATCH_ORG_ALIAS}

echo '##### DISPLAY PASSWORD #####'
sfdx force:org:display -u ${SCRATCH_ORG_ALIAS}

#echo '##### INSTALL myTrailhead AppExchnage Package #####'
#sfdx force:package:install --wait 10 --publishwait 10 --package 04t1Q000001QhC4QAK --noprompt -u ${SCRATCH_ORG_ALIAS}

#while read $Package
#do
#  package_ver=`sfdx force:package:version:list | grep $Package | tail -1 | awk '{ FS=OFS="\t" } {print $5}'`
#  sfdx force:package:install --wait 10 --publishwait 10 --package $package_ver --noprompt -u ${SCRATCH_ORG_ALIAS}
#done < Packages_list

#echo '##### PUSHING METADATA #####'
#sfdx force:source:push -u ${SCRATCH_ORG_ALIAS} -f

#sfdx force:user:permset:assign --permsetname <permset_name> --targetusername <username/alias>