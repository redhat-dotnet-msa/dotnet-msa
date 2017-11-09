#!/bin/bash

while true 
do
curl --connect-timeout 1 -s http://localhost:8080;
echo ;
sleep 1;
done
