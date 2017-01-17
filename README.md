[![Stories in Ready](https://badge.waffle.io/redhat-dotnet-msa/dotnet-msa.png?label=ready&title=Ready)](http://waffle.io/redhat-dotnet-msa/dotnet-msa)
# dotnet-msa
Main repository with documentation and support files.

This content is brought to you by http://developers.redhat.com - Register today!


## Use with CDK 
http://developers.redhat.com/products/cdk/overview/

### Start your VM and SSH into it

`vagrant up`
`vagrant ssh`

### Install .NET on your RHEL VM

Follow the instructions at https://access.redhat.com/documentation/en/net-core/1.1/paged/getting-started-guide/chapter-1-install-net-core-11-on-red-hat-enterprise-linux

### Clone this repository into your VM

git clone https://donschenck/dotnet_docker_msa.git

### Move into the directory 

`cd /dotnet_docker_msa`

### Restore and run the application and make sure it runs in RHEL

`dotnet restore`

`dotnet run`

In your host (Windows), point your browser to http://10.1.2.2:5000

### docker
Now that we know it runs, we need to publish a Release version to be used in docker.

Note that we *do not* want to use the combination of `dotnet restore` and `dotnet run` in our Dockerfile. Rather, we want the bits in the docker image to match our compiled project *exactly*, with no chance of `dotnet restore` pulling down different bits. Hence, we publish the solution and then copy that into our docker image.

Now we can publish the solution:

`dotnet publish -c Release -r rhel.7.2-x64`

Then build the docker image

`docker build -t donschenck/dotnethello .`

`docker images | grep donschenck`

Test the docker image

`docker run -d -p 5000:5000 donschenck/dotnethello`

`docker ps | grep donschenck`

`docker stop <containerid>`

`docker rm <containerid>`

### openshift/kubernetes
oc login 10.1.2.2:8443

user: openshift-dev

devel

`oc new-project mydotnet`

`oc new-build --binary --name=dotnethello`

`oc start-build dotnethello --from-dir=. --follow`

`oc new-app dotnethello`

`oc expose service dotnethello`


### Blue/Green
`oc new-build --binary --name=dotnethello-blue`

`oc start-build dotnethello-blue --from-dir=. --follow`

`oc new-app dotnethello-blue`

`oc patch route/dotnethello -p '{"spec": {"to": {"name": "dotnethello-blue" }}}'`

### Canary

1) First create the non-canary service deployment

`oc new-build --name dotnethello-first --binary -l app=dotnethello-first`

`oc start-build dotnethello-first --from-dir=. --follow`

`oc new-app dotnethello-first -l app=dotnethello-first`

`oc set probe dc/dotnethello-first --readiness --get-url=http://:5000/`

`oc expose service dotnethello-first`

2) Then create the canary service deployment

`vi Startup.cs`

change the "Hello World" line

`oc new-build --name dotnethello-first-canary --binary -l app=dotnethello-first-canary`

`oc start-build dotnethello-first-canary --from-dir=. --follow`

`oc new-app dotnethello-first-canary -l app=dotnethello-first-canary`

`oc set probe dc/dotnethello-first-canary --readiness --get-url=http://:5000/`

`oc patch dc/dotnethello-first -p '{"spec":{"template":{"metadata":{"labels":{"svc":"canary-dotnethello-first"}}}}}'`

`oc patch dc/dotnethello-first-canary -p '{"spec":{"template":{"metadata":{"labels":{"svc":"canary-dotnethello-first"}}}}}'`

`oc patch svc/dotnethello-first -p '{"spec":{"selector":{"svc":"canary-dotnethello-first","app": null, "deploymentconfig": null}, "sessionAffinity":"ClientIP"}}'`

After that use the OpenShift console to "Up" and "Down" to get the mix right

`http://screencast.com/t/dWdMETCtnYz`

