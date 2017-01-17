[![Stories in Ready](https://badge.waffle.io/redhat-dotnet-msa/dotnet-msa.png?label=ready&title=Ready)](http://waffle.io/redhat-dotnet-msa/dotnet-msa)
# dotnet-msa

## Main repository with documentation and support files.

#### This content is brought to you by http://developers.redhat.com - Register today!

#### Some useful acronyms:  
* Red Hat Enterprise Linux: RHEL  
* Container Development Kit: CDK  
* Virtual Machine: VM  

## Use with CDK
This demo was developed using the Red Hat Container Development Kit (CDK) on a Window 10 PC.  
To get a no-cost copy of the CDK, go to http://developers.redhat.com/products/cdk/overview/

### Start your VM and SSH into it

1. Navigate to the path containing your Vagrantfile, e.g. `C:\DevelopmentSuite\cdk\components\rhel\rhel-ose`  
2. `vagrant up`  
3. `vagrant ssh`

### Install .NET on your RHEL VM

Follow the instructions at https://access.redhat.com/documentation/en/net-core/1.1/paged/getting-started-guide/chapter-1-install-net-core-11-on-red-hat-enterprise-linux

### Clone this repository into your VM

git clone https://github.com/redhat-dotnet-msa/dotnet-msa.git

### Move into the directory

`cd /dotnet_msa`

### Restore and run the application and make sure it runs in RHEL

`dotnet restore`

`dotnet run`

On your host (Windows) machine, point your browser to http://10.1.2.2:5000  
(Note: 10.1.2.2 is the IP address assigned to the RHEL VM by Vagrant. This can be changed by altering the contents of the file "Vagrantfile").

### Running in docker  
Now that we know it runs, we need to publish a Release version to be used in docker.

Note that we *do not* want to use the combination of `dotnet restore` and `dotnet run` in our Dockerfile. Rather, we want the bits in the docker image to match our compiled project *exactly*, with no chance of `dotnet restore` pulling down different bits. Hence, we publish the solution and then copy that into our docker image.

Publish the solution:

`dotnet publish -c Release -r rhel.7.2-x64`

Then build the docker image

`docker build -t dotnethello .`  

`docker images`  

Test the docker image

`docker run -d -p 5000:5000 dotnethello --name dotnethello`

`docker stop dotnethello`

`docker rm dotnethello`

### Using OpenShift/kubernetes  
`oc login`  
user: `openshift-dev`  
password: `devel`

#### Create the new project  
`oc new-project mydotnet`

#### Run script to create new service  
`./create_green_1.sh1`

#### Expose the service (i.e. give it a URI)  
`oc expose service dotnethello`

On the host machine, log in to OpenShift at https://10.1.2.2:8443  
user: `openshift-dev`  
password: `devel`

You can view the service running.


### Blue/Green Release
`./create_blue_2.sh`

### Canary

First create the non-canary service deployment

`canary_create_1.sh`

Then create the canary service deployment

`vi Startup.cs`

change the "Hello World" line

`create_canary_2.sh`  

After that use the OpenShift console to "Up" and "Down" to get the mix right
