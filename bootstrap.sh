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

mv ./services/_bootstrap_ ./services/${project}-app

mv ./services/${project}-app/src/main/java/com/dph/_bootstrap_ ./services/${project}-app/src/main/java/com/dph/${project}

sed s/_bootstrap_/${project}-app/g ./settings.gradle

find . -name "*.java" | while read fname; do cat $fname |  sed  s/_bootstrap_/${project}/g > ${fname}_tmp; mv ${fname}_tmp $fname; done

chmod +x ./gradlew

./gradlew build

echo ${project}

