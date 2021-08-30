#!/bin/bash
cd ..
pwd
cd release/
cd $(ls -d */|head -n 1)
nohup java -jar release.jar --server.port=8083 &
