oc new-build --name dotnethello-first --binary -l app=dotnethello-first

oc start-build dotnethello-first --from-dir=. --follow

oc new-app dotnethello-first -l app=dotnethello-first

oc set probe dc/dotnethello-first --readiness --get-url=http://:5000/

oc expose service dotnethello-first
