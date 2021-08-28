#!/bin/bash
cd SpringBootAPIProject/release/
cd $(ls -d */|head -n 1)
nohup java -jar release.jar & echo $! > ./pid.file &
