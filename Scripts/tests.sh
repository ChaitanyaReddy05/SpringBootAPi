#!/bin/bash
curl -f -s -I "http://localhost:8080/hello" &>/dev/null && echo OK || echo FAIL
