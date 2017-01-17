#!/bin/bash

while true 
do
curl --connect-timeout 1 -s http://dotnethello-mydotnet.rhel-cdk.10.1.2.2.xip.io/;
echo ;
sleep 1;
done
