#!/bin/bash

# meta
# two = Task Wiki Open
# this script is project-centric, that is to say that
# without [attribute:] the attribute is presumed to be "project"
# This allows wiki files to be created for other attributes,
# like "tag:" or your favorite UDA

# reset values
HELP_FILE=two.txt
USAGE='two [-a|-c|-h|-i|-l] [[attribute:]value] [filter]'
TASKWIKI_ROOT=~/.task/wiki
TASKWIKI_DIR=project
TASKWIKI_INDEX_FILE=index.wiki
TW_CONFIG='rc.context=none rc.verbose=off'
TW_REPORT=list
TW_ARGS=''
ACTION=open
ATTRIB=project
FILE_EXT=$ATTRIB.wiki
FILE=*

# options
## -h
### ACTION=help
if [[ ${1} == '' ]]
then
ACTION=index

elif [[ ${1} == -h ]]
then
cat $TASKWIKI_ROOT/$HELP_FILE
  exit 0

## -l
### ACTION=list
elif [[ ${1} == -l ]]
then
ACTION=list
shift

## -c
### ACTION=info_context
elif [[ ${1} == -c ]]
then
ACTION=$ACTION-context
shift

## -a
### ACTION=info_all
elif [[ ${1} == -a ]]
then
ACTION=$ACTION-all
shift

## -i
### ACTION=info
elif [[ ${1} == -i ]]
then
ACTION=info
shift

fi

FIELD=$1
TW_ARGS=$2

# attribute
## if FIELD has *:*
### first part = ATTRIB, second part = FILE

# paths
### if ATTRIB != project, TASKWIKI_DIR=ATTRIB
## elif exist ENV TASKWIKI_ROOT
### TASKWIKI_ROOT = envar
## elif taskrc has "wiki.root="
### TASKWIKI_ROOT = wiki.root

# list
### list files
if [[ $ACTION == 'index' ]]
then 
vi $TASKWIKI_ROOT/$TASKWIKI_INDEX_FILE
exit 0

elif [[ $ACTION == 'list' ]]
then 
tree -P *.*.wiki -R $TASKWIKI_ROOT
exit 0
fi

# report
### -a = show information on all projects (attribs?)
### show information
### -c = show information using current context
if [[ $ACTION = '-context' ]]
then
$TW_CONFIG='rc.verbose=off'

elif [[ $ACTION = '-all' ]]
then
TW_ARGS=$FIELD
ATTRIB=$ATTRIB.any

elif [[ $ACTION = 'info' ]] 
then
task $TW_CONFIG $TW_ARGS $ATTRIB:$FIELD summary
task $TW_CONFIG $TW_ARGS $ATTRIB:$FIELD $TW_REPORT

exit 0
fi

# open file
## if no ARGS open index.wiki
ACTION=open

vi $TASKWIKI_ROOT/$TASKWIKI_DIR/$ATTRIB.$FILE$_EXT

# usage
