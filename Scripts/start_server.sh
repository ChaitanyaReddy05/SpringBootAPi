#!/bin/bash
cd /home/ec2-user/springbootapi/release
cd $(ls -d */|head -n 1)
nohup java -jar release.jar --server.port=8083 2> /dev/null &
