oc new-build --name dotnethello-first-canary --binary -l app=dotnethello-first-canary
oc start-build dotnethello-first-canary --from-dir=../bonjour/. --follow
oc new-app dotnethello-first-canary -l app=dotnethello-first-canary
oc set probe dc/dotnethello-first-canary --readiness --get-url=http://:5000/
oc patch dc/dotnethello-first -p '{"spec":{"template":{"metadata":{"labels":{"svc":"canary-dotnethello-first"}}}}}'
oc patch dc/dotnethello-first-canary -p '{"spec":{"template":{"metadata":{"labels":{"svc":"canary-dotnethello-first"}}}}}'
oc patch svc/dotnethello-first -p '{"spec":{"selector":{"svc":"canary-dotnethello-first","app": null, "deploymentconfig": null}, "sessionAffinity":"ClientIP"}}'

