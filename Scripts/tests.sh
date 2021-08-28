#!/bin/bash
curl -f -s -I "http://localhost:8083/hello" &>/dev/null && echo OK || echo FAIL
