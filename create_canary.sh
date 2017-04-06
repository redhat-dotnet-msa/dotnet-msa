oc new-build --name dotnethello-canary --binary -l app=dotnethello-canary

oc start-build dotnethello-canary --from-dir=. --follow

oc new-app dotnethello-canary -l app=dotnethello-canary

oc set probe dc/dotnethello-canary --readiness --get-url=http://:5000/

oc patch dc/dotnethello-blue -p '{"spec":{"template":{"metadata":{"labels":{"svc":"canary-dotnethello"}}}}}'

oc patch dc/dotnethello-canary -p '{"spec":{"template":{"metadata":{"labels":{"svc":"canary-dotnethello"}}}}}'

oc patch svc/dotnethello-blue -p '{"spec":{"selector":{"svc":"canary-dotnethello","app": null, "deploymentconfig": null}, "sessionAffinity":"ClientIP"}}'
