oc new-build --binary --name=dotnethello-blue
oc start-build dotnethello-blue --from-dir=. --follow
oc new-app dotnethello-blue
sleep 4s
oc patch route/dotnethello -p '{"spec": {"to": {"name": "dotnethello-blue" }}}'
