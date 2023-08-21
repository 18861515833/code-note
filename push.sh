#!/bin/bash
cd `dirname $0`
pwd
git add .
git commit -m "auto commit `date`"
git push
