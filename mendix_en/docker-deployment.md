## What Are the Deployment Techniques for Mendix Applications? How Are They Dockerized and Published?

In this article, we'll examine how to dockerize and publish applications built with Mendix, a low-code software development tool.

![mendix.png](files/mendix.png)


Lately we've been hearing about low-code or no-code development environments a lot. Many low-code products in different languages are coming onto the market as open source or licensed. 

If we look at the 2024 Gartner report, we can see Mendix, Microsoft and OutSystem in the top three.

- Mendix: Java
- Microsoft Power App: C#
- OutSystem: C#

![gartner.png](files/gartner.png)

All three of these products let us release cross platform products. In other words, we can develop web pages and mobile applications in all three. 

We can say that Mendix and OutSystem are more low-code products, while Power App is more of a no-code product.


| Feature                | OutSystems                              | Mendix                                 | Microsoft Power Apps                    |
|------------------------|-----------------------------------------|----------------------------------------|-----------------------------------------|
| **Scope**             | Large enterprise projects                | Rapid prototyping and digital transformation | Small and medium-sized business applications  |
| **Need to Write Code** | Low code, but more room for writing manual code | Visual modeling, low code            | Low code, simple interfaces              |
| **Integrations**     | High, integration with third-party systems | Flexible integrations, wide range of tools   | Excellent integration with Microsoft products |
| **Flexibility**           | High, customization and manual coding options | Moderate flexibility                 | Moderate, but excellent within the Microsoft ecosystem |
| **User Base**  | Enterprise users, software developers | Collaboration-based, business analysts and developers | Both technical and non-technical users |
| **Platform Features** | Wide-scale web and mobile application support | Rapid application development and prototyping | Microsoft 365 and Azure integration |



After giving a bit of information, we can get back to our topic.



## How Are Mendix Applications Deployed?

There are many ways to deploy Mendix applications. Actually, these techniques vary depending on where you want to deploy your application. You can also look at the details on its [official page](https://docs.mendix.com/deployment/).

- Mendix Cloud: This is the most preferred method. If you don't want to deal with system work and CI/Cd processes, it's the best and fastest method. On top of that, it offers project management and Scrum boards for your teams. With a single click, you can publish your application for different environments (test, uat, prod). You can read the details on its [official page](https://docs.mendix.com/developerportal/deploy/mendix-cloud-deploy/deploying-an-app/).
- Mendix Cloud Dedicated: It's exactly the same as Mendix Cloud; the only difference is that it's the method where your applications run on a cluster completely dedicated to your company. You can read the details on its [official page](https://www.mendix.com/evaluation-guide/deployment/mendix-cloud/dedicated/).
- Mendix Private Cloud: In this method, Mendix Cloud is installed in your own data center, and deployment is done using the capabilities of Mendix Cloud. But of course this is a very costly method. In other words, your business volume needs to be seriously large.
-  Cloud Foundary: It can be deployed to platforms supported by Cloud Foundary (CF). Since what CF is and what it does isn't our topic, we won't go into the details here, but if you're curious you can visit its [official page](https://www.cloudfoundry.org/get-started/).
-  Azure Maketplace: You can publish it on a virtual machine in Azure through the Azure Maketplace application. What you need to do is create Mendix Pro as a resource on Azure. Mendix Pro already asks you questions and sets up an environment according to what kind of machine and what kind of network you want to publish on.
-  Industrial Edge: It's used to deploy to Siemens' IOT platforms. You can look at the details on [this page](https://docs.mendix.com/developerportal/deploy/mendix-app-on-industrial-edge/).
-  On-Premises: In this method, the application package is taken with classic methods and published manually on a Linux or Windows server. The application is run as a service, and it's exposed to the outside with Windows IIS, or on Linux with a Proxy like Nginx or HAProxy. While the process is a bit easier for Windows, on the Linux side there's (my personal opinion) unnecessary complexity. For Linux, you can publish your application using a Python package they wrote in Python called m2ee-tools and its commands. Actually, having a GUI on Windows makes things easier too. Actually, our goal is to publish a Java application and release it, but I suppose, with the aim of being low-code, they've always gone the way of abstracting things, but this has made it more complex. On top of that, it also makes it harder to find documentation.  For Windows you need to look at [this page](https://docs.mendix.com/developerportal/deploy/deploy-mendix-on-microsoft-windows/), and for Linux at the [official Github page](https://github.com/mendix/m2ee-tools/blob/develop/doc/README.md). 
- Docker and Kubernetes: The Mendix Cloud we mentioned above actually turns our application into a Docker image and publishes it on its own Kubernmetes Clusters. Under normal conditions, it would be enough for us to write the deployment processes done on Linux in the On-Premise method into a Dockerfile and run them. But Mendix has developed a method that packages our application and Dockerizes it using Cloud Foundary for this whole process. Frankly, forcing the use of Cloud Foundry also seemed a bit unnecessary to me. Again, so as not to lose the title of being a low-code product, they've abstracted everything, but this makes debugging challenging. 

We'll also be examining this topic in the section below.

## How Are Mendix Applications Dockerized?

To let us Dockerize our Mendix applications, it has published a project on Github. It's called [docker-mendix-buildpack](https://github.com/mendix/docker-mendix-buildpack)  and it uses another Github project of Mendix called [cf-mendix-buildpack](https://github.com/mendix/cf-mendix-buildpack). We won't go into their details. Our goal is just to dockerize the mendiz application we have and publish it. 

By the way, I'll also touch on how you'll solve licensing in Prod environments.

While building our Mendix application, it asks us for 2 images.
- The image our Mendix application will run on
- The image that will build our Mendix application

We need to build both of these images ourselves.

Now let's Dockerize our application step by step. First, let's see how to build the images we mentioned. Since we can build them ourselves, we can also make whatever changes we want inside them. But I don't recommend doing it unless you really have to.

First, we clone the appropriate version of the docker-mendix-buildpack repo to our local machine. When I wrote this article, the sixth version was the latest one available. We'll specifically follow the documentation of this version. In other words, we're not looking at the latest state on the Master branch. You can reach the [sixth version from this link](https://github.com/mendix/docker-mendix-buildpack/tree/v6.0.0) .

```shell
git clone https://github.com/mendix/docker-mendix-buildpack.git
cd docker-mendix-buildpack
git checkout v6.0.0
```

Then we create our Docker image. While in the directory of the Git repo we downloaded, we run the commands below.

```shell
cd docker-mendix-buildpack
docker build -t mendix-rootfs:app -f rootfs-app.dockerfile .
```

Now we build the Mendix builder image too.

```shell
docker build -t mendix-rootfs:builder -f rootfs-builder.dockerfile .
```


This way, we've created two images named `mendix-rootfs:app` and `mendix-rootfs:builder`. If you like, you can save these images to a repo and use them from there, so you won't have to build them every time.

Now let's build our application using them. For the example application, we run the commands below while in the repo directory.


```shell
mkdir -p downloads build
wget https://s3-eu-west-1.amazonaws.com/mx-buildpack-ci/BuildpackTestApp-mx-7-16.mda -O build/BuildpackTestApp-mx-7-16.mda

```

Usually our application will be a source MPK file, an MPR project directory or a compressed MDA file. In this case, it needs to be converted or compiled into a format supported by the CF Buildpack. And that's actually an extracted MDA file. This feature is available in Docker Buildpack version v6.0.0 and later and makes it possible to compile Mendix 8, 9 and 10 applications in custom CI/CD pipelines.


```shell
./build.py --source  downloads/  --destination build/ build-mda-dir
```
This script extracted our application for us and also created a Dockerfile.

Now we can build our application. The word build at the very end of the command is the directory that contains our project's extracted files and the Dockerfile.

```shell
docker build --build-arg ROOTFS_IMAGE=mendix-rootfs:app --build-arg BUILDER_ROOTFS_IMAGE=mendix-rootfs:builder --tag my-mendixapp:latest build

# or
# docker build --tag my-mendixapp:latest build

```
The build arguments aren't limited to the BUILD_PATH, ROOTFS_IMAGE and BUILDER_ROOTFS_IMAGE parameters. I'm listing the other parameters below.


* BUILD_PATH: Specifies where the application model is located. This is the root directory of an unzipped .MDA or .MPK file. In the latter case, this is the directory where your .MPR file is located. It must be inside the build context. It's set to ./project by default.
* ROOTFS_IMAGE: It's a type of rootfs (root file system) image. By default, mendix/rootfs:ubi8 (Red Hat Universal Base Image 8) is used. To use Ubuntu 18.04, you can change this to mendix/rootfs:bionic. It's also possible to use a custom rootfs image as described in the advanced features.
* BUILDER_ROOTFS_IMAGE: It's a rootfs image used to download the Mendix application dependencies and compile the Mendix application from source. By default, mendix/rootfs:bionic is used. It's also possible to use a custom rootfs image as described in the advanced features.
* CF_BUILDPACK: It's the CloudFoundry buildpack version. It's v4.30.14 by default. For stable pipelines, it's recommended to use a fixed version of v4.30.14 or later. CloudFoundry buildpack versions before v4.30.14 aren't supported.
* EXCLUDE_LOGFILTER: If set to true, it excludes the mendix-logfilter binary from the final Docker image. It's true by default. Excluding mendix-logfilter reduces the image size and removes a component that's usually not used; the LOG_RATELIMIT environment variable option is disabled.
* UNINSTALL_BUILD_DEPENDENCIES: Removes the packages that aren't needed to start the application and are only used in the build stage. It's true by default. This option removes several libraries known to have unpatched CVE security vulnerabilities.
* CF_BUILDPACK_URL: Specifies the URL from which the CF buildpack will be downloaded (for example, a local mirror). By default, https://github.com/mendix/cf-mendix-buildpack/releases/download/${CF_BUILDPACK}/cf-mendix-buildpack.zip is used. 
* When CF_BUILDPACK_URL is specified, the version from CF_BUILDPACK is overridden.
* BLOBSTORE: Can be used to specify an alternative buildpack resource server (instead of the default Mendix CDN). For more information, see the CF Buildpack offline settings.
* BUILDPACK_XTRACE: Can be used to enable CF Buildpack debug logging. You can enable debug logging by setting this variable to true.



## How Is a Mendix Application Published as Docker? 

Now we have an image named my-mendixapp. To run the application, we'll need a database. Let's bring up a postgres with the command below.

```shell
docker run --name mendix-postgres -e POSTGRES_PASSWORD=abc123 -p 5436:5432 -d  postgres:12
```

Then let's create a database for our application

```bash
docker exec -it mendix-postgres psql -h localhost -U postgres -c 'create database mendixdb;'
```

To be able to connect, we need to connect to port 5436 of our host machine. My ip address appears as `192.168.0.25`. You should replace it with your own host ip  address.

```bash
docker run -d --name mymendixapp  -e ADMIN_PASSWORD=Password1! -e DATABASE_ENDPOINT=postgres://postgres:abc123@192.168.0.25:5436/mendixdb -p 8585:8080  my-mendixapp:latest
```


Then, when we go to the `http://localhost:8585` address in your browser, we enter `MxAdmin` as the username and `Password1!` as the password. The username and password need to be entered case-sensitively.


![home.png](files/home.png)


## Licensing for Production Environments

To get a license, we need to log in at the `https://newnode.mendix.com/index.html` address.

![login.png](files/login.png)

The Company, Contact Name and Email address parts will already come filled in. We select On-Premise as the Hosting Type, enter the application name (App name) and click the next button. We write the application name using exactly the name we gave while creating the application on Mendix or Mendix Studio.

On the next screen, by clicking the `Add Environment` Button, we also add a Test environment. Since we're using Docker, we enter texts in the parts that say `Server Id`, as you can see below. They don't matter; we just wrote them because we can't leave them empty. 

![login2.png](files/login2.png)

Then we click the save button and continue. As a result, within 1 day an email will come to our email address, and here a `LICENSE_ID` and `LICENSE_ID` will come for each of the three environments.


When the licenses come, we need to run our containers for each environment by also adding the `LICENSE_ID` and `LICENSE_ID` values as below.

```bash
docker run -d --name mymendixapp  \ 
            -e ADMIN_PASSWORD=Password1! \ 
            -e DATABASE_ENDPOINT=postgres://postgres:abc123@192.168.0.25:5436/mendixdb \
            -e LICENSE_ID=your_license_id \
            -e LICENSE_KEY=your_license_key \
            -p 8585:8080 \  
            my-mendixapp:latest
```

### Using Environemet Variables (Constants)

You can look at [this document](https://docs.mendix.com/refguide/constants/) on its official page about using Environment variables and Constants.

We can say that for Mendix, constants are variables used globally as long as your application is up. And this defines the environment variable concept for us. The difference is that, rather than reading the system's environment variables from within, Mendix reads constants and offers methods so that we can give them to the application from outside. These can be passed to the application as Environment Variables through Docker.

For example, if we defined a constant in the form `MyModule.MyConstant`, when passing it to the container we define it in the form `-e MX_MyModule_MyConstant=abc`. In other words, it'll start with MX, and each dot is written as an `_` underscore.



### Using Runtime Customization

To get detailed information about Runtime Customization, you can read [this document](https://docs.mendix.com/refguide/custom-settings/) on its official page.

To touch on this briefly too, it refers to the rruntime variables used by our application's framework. There are hundreds of parameters in the link I gave. We can make many settings such as certificates, database, database  migration, proxy, log, storage, metrics, etc.


Here, for each runtime setting we gave in the link, we add the word `MXRUNTIME` to the beginning of each one, as in the examples below.

```
-e MXRUNTIME_DatabaseUserName=db_username 
-e MXRUNTIME_DatabaseType=POSTGRESQL
-e MXRUNTIME_DatabasePassword=db_password 
-e MXRUNTIME_DatabaseName=db_name 
```


For example, the application can be run with a configuration like the one below.

```bash
docker run -d \
  -p 8080:80 \
  -e ADMIN_PASSWORD=Password1! \
  -e DATABASE_ENDPOINT=postgres://mendix:mendix@172.17.0.2:5432/mendix \
  -e MX_Module_Constant=ABC123 \
  -e LICENSE_ID=<UUID> \
  -e LICENSE_KEY=<LICENSE_KEY> \
  -e MXRUNTIME_DatabaseUserName=db_username 
  -e MXRUNTIME_DatabaseType=POSTGRESQL
  -e MXRUNTIME_DatabasePassword=db_password 
  -e MXRUNTIME_DatabaseName=db_name 
  mymandixapp 
```

## How Can the Application Be Published with Kubernetes?

Taking into account what I explained above, it's published the same way a normal application is published. It's enough to just pay attention to the Constant and Runtime settings. In other words, in the end we still have a Docker image.

That's it for this article. Hope you found it useful.

See you in the next article.


