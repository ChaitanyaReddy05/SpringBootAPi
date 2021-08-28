#!/bin/bash
pid=$(sudo lsof -t -i:8083)
sudo kill -9 $pid
