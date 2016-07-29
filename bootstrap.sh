#!/bin/bash

while [ "$1" != "" ]; do
    case $1 in
        -p | --project )           shift
                                project=$1
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

cd /tmp

rm -rf /tmp/project-bootstrap && git clone git@bitbucket.org:depositphotos/project-bootstrap.git && rm -rf /tmp/project-bootstrap/.git

cd - && mv /tmp/project-bootstrap ${project}

cd ./${project} && git init && git add . && git remote add origin git@bitbucket.org:depositphotos/${project}.git

echo ${project}