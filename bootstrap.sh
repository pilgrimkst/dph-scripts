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

current_dir=$(pwd)
cd /tmp

echo "Fetching project template\n\n"

rm -rf /tmp/project-bootstrap && git clone git@bitbucket.org:depositphotos/project-bootstrap.git && rm -rf /tmp/project-bootstrap/.git

echo "Moving template to working folder ${current_dir}\n\n"
cd ${current_dir} && mv /tmp/project-bootstrap ${project}
cd ./${project} && git init && git add . && git remote add origin git@bitbucket.org:depositphotos/${project}.git

echo "Replacing template with ${project}\n\n"
echo "folders"
mv ./services/_bootstrap_ ./services/${project}-app
mv ./services/${project}-app/src/main/java/com/dph/_bootstrap_ ./services/${project}-app/src/main/java/com/dph/${project}

echo "settings.gradle"
sed s/_bootstrap_/${project}-app/g ./settings.gradle > ./settings.gradle.extr; mv ./settings.gradle.extr ./settings.gradle
cat ./settings.gradle

echo "Java classes"
find . -name "*.java" | while read fname; do cat $fname |  sed  s/_bootstrap_/${project}/g > ${fname}_tmp; mv ${fname}_tmp $fname; done

echo "Building project"
chmod +x ./gradlew

./gradlew build