#!/bin/bash
sleep 30
echo "============================================================================================"
echo "|                                  API Validation is being started                         |"
echo "============================================================================================"
URL1_STATUS_CODE=$(curl -LI http://localhost:8083/hello -o /dev/null -w '%{http_code}\n' -s)
if [ $URL1_STATUS_CODE -ne 200 ];then
	echo "|                                  API Validation : Failed                                 |"
	echo "============================================================================================"
    exit 1
fi
URL2_STATUS_CODE=$(curl -LI http://localhost:8083/allpolicies -o /dev/null -w '%{http_code}\n' -s)
if [ $URL2_STATUS_CODE -ne 200 ];then
	echo "|                                  API Validation : Failed                                 |"
	echo "============================================================================================"
    exit 1
fi
URL3_STATUS_CODE=$(curl -LI http://localhost:8083/policy/PolicyA -o /dev/null -w '%{http_code}\n' -s)
if [ $URL3_STATUS_CODE -ne 200 ];then
	echo "|                                  API Validation : Failed                                 |"
	echo "============================================================================================"
    exit 1
fi
echo "|                                  API Validation : Passed                                 |"
echo "============================================================================================"
