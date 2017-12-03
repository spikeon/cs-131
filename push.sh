#!/bin/bash
#run as push.sh "message"

git add .
git commit -m "$1"
git push