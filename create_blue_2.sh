oc new-build --binary --name=dotnethello-blue
oc start-build dotnethello-blue --from-dir=. --follow
oc new-app dotnethello-blue
oc patch route/dotnethello -p '{"spec": {"to": {"name": "dotnethello-blue" }}}'
