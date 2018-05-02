#!/bin/bash

while true 
do
curl --connect-timeout 1 -s http://dotnethello-first-mydotnet.$(minishift ip).nip.io/;
echo ;
sleep 1;
done
