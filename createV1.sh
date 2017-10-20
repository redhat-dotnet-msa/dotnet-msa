oc new-build --binary --name=dotnethello
oc start-build dotnethello --from-dir=. --follow
oc set probe dc/dotnethello --readiness --get-url=http://5000
oc new-app dotnethello
oc expose service dotnethello