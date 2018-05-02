#!/bin/bash

while true 
do
curl --connect-timeout 1 -s http://dotnethello-mydotnet.$(minishift ip).nip.io/;
echo ;
sleep 1;
done
