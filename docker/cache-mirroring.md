
# Docker Image Proxy Cache ve Registery Mirroring Kullanımı

Merhaba arkadaşlar

Bu yazımızda Docker image'larımızı local private registry'de nasıl cache'leyebileceğimizi öğrenmeye çalışacağız. 

Docker haricinde birde private registry'e ihtiyacımız olacak. Daha önce kurmadıysanız konu ile ilgili internette bol miktarda kaynak bulabilirsiniz.

Eğer Docker'ın resmi olarak sunduğu registry'yi kurmak isterseniz alttaki kaynaklardan faydalanabilirsiniz.

- [Docker registry deployment](https://docs.docker.com/registry/deploying/)
- [Insecure Registry ayarları](https://docs.docker.com/registry/insecure/)


Daha gelişmiş bir registry'ye ihtiyaç duyarsanız alttaki kaynakları inceleyebilirsiniz.

- [Sonatype Nexus 3 OSS](https://hub.docker.com/r/sonatype/nexus3/)
- [Harbor](https://goharbor.io/docs/2.5.0/install-config/)

Docker'ın sunmuş olduğu bazı özellikleri kullanarak mevzuyu anlamaya çalışalım.

- Registry Mirroring
- Pull-through Cache
- Allow Nondistributable Artifacts


# Registery Mirroring

Bu özellik Docker client'larımızda talep ettiğimiz (docker pull) image'ın ve bu image için kullanılan base image'ların öncelikle belirttiğimiz registry'de aramasını sağlamak için kullanılır. Private image'da bulunmayan image'lar Dockerhub'dan getirlir.

Bu özellik şuan için sadece Dockerhub için geçerli. Bilgi için [resmi sayfasını](https://docs.docker.com/registry/recipes/mirror/#gotcha) inceleyebilirsiniz.

__/etc/docker/daemon.json__  dosyasında alttaki ayar yapılmalıdır. Konu ilgili olarak [Docker resmi sayfalarını](https://docs.docker.com/registry/recipes/mirror/#configure-the-docker-daemon) inceleyebilirsiniz.

```json
{
  "registry-mirrors": ["https://my-docker-mirror-host:port-number"]
}
```

Bunu yapıyor olmamız offical base image'ların da öncelikle local registry'mizde aranacağı anlamına geliyor. Dış registry'deki image'ları local registry'ye push'lamazsak sistem local'de bulamayacaktır. Local registry'ye ilgili dış image'ı push'lamak için Docker iki yöntem sunuyor.

- allow-nondistributable-artifacts özelliği kullanılabilir
- proxy cache kullanılabilir


# Allow-nondistributable-artifacts Özelliği

Bu özelliğin asıl amacı  Dockerhub dışında başka bir public registry'e push'lanamayacak lisanslı  base image'ların (örneğin Windows image'larının)  private registry'ye push'lanabilmesini sağlamaktır.

Image push edilirken "foreign layer" ve image'ların push edilmesini sağlar.

__/etc/docker/daemon.json__ dosyasında alttaki ayar yapılmalıdır.

[Kaynak](https://docs.docker.com/engine/reference/commandline/dockerd/#allow-push-of-nondistributable-artifacts)

```json
{
  "allow-nondistributable-artifacts": [
    "private_registry_url:port_number"
  ]
}
```

# Pull-through cache (Proxy Cache)

[Proxy cache ](https://docs.docker.com/registry/recipes/mirror/#run-a-registry-as-a-pull-through-cache)ile bütün Dockerhub istekleri local registry'ye cache'lenir. Ancak yukarıda bahsettiğimiz gibi eğer Windows gibi lisanslı image'larınız varsa ve bunların public registry'lere push'lanması engellendiyse allow-nondistributable-artifact özelliği her durumda image push yaptığınız Docker client'ınızda yapmalısınız..

Aşağıdaki ayar yapıldıktan sonra Docker client tarafından talep edilen image private registry'de yoksa öncelikle Dockerhub'dan registry üzerine alınır ve oradan da  Docker client'a gönderilir.

Tabii ki bu özelliğin çalışabilmesi için yukarıda bahsettiğimiz registry mirroring ayarının da yapılmış olması gerekiyor. Öteki türlü Docker client'ımız image'ı Dockerhub'dan çekecektir.





__/etc/docker/registry/config.yml__ dosyasında aşağıdaki ayarı yapıyoruz.

Dosya yoksa oluşturmalısınız.

```yml
proxy:
  remoteurl: https://registry-1.docker.io
  username: [username]
  password: [password]

```


Eğer Docker'ın kendi resmi registry'isini değilde yukarıda bahsettiğimiz Nexus3, Harbor gibi veya servis sağlayıcılardan aldığınız registry'lerden birini kullanıyorsanız bu ayarı veya buna benzer bir ayarı onların dokümanlarından destek alarak yapmalısınız.

- Nexus3 için resmi dokümanına [şu linkten](https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/docker-registry/proxy-repository-for-docker) ulaşabilirsiniz.

- Harbor için resmi dokümana [şu linkten](https://goharbor.io/docs/2.5.0/administration/configure-proxy-cache/) ulaşabilirsiniz.


Yukarıda bahsettiğimiz kurguları sadece cache'lemek amacıyla değil aynı zamanda Docker client'larınızın internete kapalı bir ortamda olması durumunda  da kullanabilirsiniz. Proxy olarak kullanığınız makinanınızın internete açık olması yeterli olacaktır. 


Umarım faydalı olmuştur


