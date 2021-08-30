#!/bin/bash
sleep 30
curl -f -s -I "http://localhost:8083/hello" &>/dev/null && echo OK || echo FAIL
