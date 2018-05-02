[![Stories in Ready](https://badge.waffle.io/redhat-dotnet-msa/dotnet-msa.png?label=ready&title=Ready)](http://waffle.io/redhat-dotnet-msa/dotnet-msa)
# dotnet-msa

## Main repository with documentation and support files.

#### This content is brought to you by http://developers.redhat.com - Register today!

#### Some useful acronyms:  
* Red Hat Enterprise Linux: RHEL  
* Virtual Machine: VM  

## Use with minishift on all three major operating systems
This demo was developed using minishift on MacOS.  

You can use Windows, MacOS or Linux to run this demo; Instructions are included for Linux-based operating systems.

### Install minishift
You can get minishift at the minishift releases page:  
https://github.com/minishift/minishift/releases

### Start minishift
After installing minishift, and after making sure it is in your PATH, start it by running:  
`minishift start`  

Point the docker environment to be *inside* your minishift instance:  
`eval $(minishift docker-env)`

### Install .NET on your machine
Follow instructions at http://dot.net

### Clone this repository to your machine

`git clone https://github.com/redhat-dotnet-msa/dotnet-msa.git`

### Move into the directory

`cd /dotnet_msa`

### Verify that the code runs on your machine

`dotnet run`

On your machine, point your browser to http://localhost:5000  

### Run in docker  
Now that we know it runs, we need to publish a Release version to be used in docker.

Publish the solution:

`dotnet publish -c Release -r rhel.7.4-x64`

Then build the docker image

`docker build -t dotnethello .`  

Test the docker image

`docker run -d -p 5000:5000 --name dotnethello dotnethello`

`open https://$(minishift ip):5000`

`docker stop dotnethello`

`docker rm dotnethello`

### Using OpenShift/kubernetes  
`oc login $(minishift ip):8443 -u openshift-dev -p devel`  

#### Create the new project  
`oc new-project mydotnet`

#### Run script to create new service  
`./create_green_1.sh1`

#### Expose the service (i.e. give it a URI)  
`oc expose service dotnethello`

On the host machine, log in to OpenShift at   
`open https://$(minishift ip):8443`  
user: `openshift-dev`  
password: `devel`

You can view the service running.

### Blue/Green Release
`./create_blue_2.sh`

### Canary

First create the non-canary service deployment

`canary_create_1.sh`

Then create the canary service deployment

`canary_create_2.sh`  

After that use the OpenShift console to "Up" and "Down" to get the mix right
