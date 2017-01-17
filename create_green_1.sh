oc new-build --binary --name=dotnethello
oc start-build dotnethello --from-dir=. --follow
oc new-app dotnethello
