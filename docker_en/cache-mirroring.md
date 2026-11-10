
# Using Docker Image Proxy Cache and Registry Mirroring

Hello friends,

In this article, we'll try to learn how we can cache our Docker images in a local private registry.

Apart from Docker, we'll also need a private registry. If you haven't set one up before, you can find plenty of resources on the internet about it.

If you'd like to install the official registry provided by Docker, you can make use of the resources below.

- [Docker registry deployment](https://docs.docker.com/registry/deploying/)
- [Insecure Registry settings](https://docs.docker.com/registry/insecure/)


If you need a more advanced registry, you can take a look at the resources below.

- [Sonatype Nexus 3 OSS](https://hub.docker.com/r/sonatype/nexus3/)
- [Harbor](https://goharbor.io/docs/2.5.0/install-config/)

Let's try to understand the topic by using some of the features Docker offers.

- Registry Mirroring
- Pull-through Cache
- Allow Nondistributable Artifacts


# Registry Mirroring

This feature is used to make our Docker clients look up the image we request (docker pull), and the base images used for that image, in the registry we specify first. Images that aren't found in the private registry are fetched from Docker Hub.

For now, this feature only works for Docker Hub. For more information, you can check the [official page](https://docs.docker.com/registry/recipes/mirror/#gotcha).

The setting below should be added to the __/etc/docker/daemon.json__ file. You can check the [official Docker pages](https://docs.docker.com/registry/recipes/mirror/#configure-the-docker-daemon) on the subject.

```json
{
  "registry-mirrors": ["https://my-docker-mirror-host:port-number"]
}
```

Doing this means that official base images will also be looked up in our local registry first. If we don't push the images from the external registry to the local registry, the system won't be able to find them locally. Docker offers two ways to push the related external image to the local registry.

- The allow-nondistributable-artifacts feature can be used
- A proxy cache can be used


# The Allow-nondistributable-artifacts Feature

The main purpose of this feature is to allow licensed base images (for example, Windows images), which can't be pushed to any public registry other than Docker Hub, to be pushed to a private registry.

It allows "foreign layers" and images to be pushed while an image is being pushed.

The setting below should be added to the __/etc/docker/daemon.json__ file.

[Source](https://docs.docker.com/engine/reference/commandline/dockerd/#allow-push-of-nondistributable-artifacts)

```json
{
  "allow-nondistributable-artifacts": [
    "private_registry_url:port_number"
  ]
}
```

# Pull-through Cache (Proxy Cache)

With a [proxy cache](https://docs.docker.com/registry/recipes/mirror/#run-a-registry-as-a-pull-through-cache), all Docker Hub requests are cached in the local registry. However, as we mentioned above, if you have licensed images such as Windows images and pushing them to public registries is blocked, you should enable the allow-nondistributable-artifact feature in every case on the Docker client you push images from.

After the setting below is applied, if the image requested by the Docker client isn't in the private registry, it is first pulled from Docker Hub onto the registry and then sent from there to the Docker client.

Of course, for this feature to work, the registry mirroring setting we mentioned above must also be in place. Otherwise, our Docker client will pull the image from Docker Hub.





We add the setting below to the __/etc/docker/registry/config.yml__ file.

If the file doesn't exist, you should create it.

```yml
proxy:
  remoteurl: https://registry-1.docker.io
  username: [username]
  password: [password]

```


If you're not using Docker's own official registry but one of the registries we mentioned above, such as Nexus3 or Harbor, or one you get from a service provider, you should apply this setting, or a similar one, with the help of their documentation.

- You can reach the official documentation for Nexus3 from [this link](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/docker-registry/proxy-repository-for-docker).

- You can reach the official documentation for Harbor from [this link](https://goharbor.io/docs/2.5.0/administration/configure-proxy-cache/).


You can use the setups we mentioned above not only for caching but also when your Docker clients are in an environment without internet access. It's enough for the machine you use as a proxy to have internet access.


Hope you found it useful.
