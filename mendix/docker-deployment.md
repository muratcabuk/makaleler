## Mendix Uygulamaları Deployment Teknikleri Nelerdir? Nasıl Dockerize Edilir ve Yayına Verilir?

Bu yazımmızda bir low-code yazılım geliştirme aracı olan Mendix uygulamalarının nasıl dockerize edilecğeiniz ve yayına verileceğini inceleyeceğiz.

![mendix.png](files/mendix.png)


Son zamanlarda low-code veya no-code geliştirme ortamlarını sıkça duyuyoruz. Farklı dillerde bir çok low-code ürün açok kaynak veya lisanslı olarak piyasaya çıkıyor. 

2024 Gartner raporuna bakacak olursak ilk  üçte Mendix, Microsoft ve OutSystem'i görebiliriz.

- Mendix: Java
- Microsoft Power App: C#
- OutSystem: C#

![gartner.png](files/gartner.png)

Bu ürünlerin üçü de cross platform ürünler çıkartmamızı sağlıyor. Yani üçünde de web sayfası ve mobil uygulama geliştirebiliyoruz. 

Mendix ve OutSystem daha çok low-code ürün iken Power App daha çok no-code ürün diyebiliriz.


| Özellik                | OutSystems                              | Mendix                                 | Microsoft Power Apps                    |
|------------------------|-----------------------------------------|----------------------------------------|-----------------------------------------|
| **Kapsam**             | Büyük kurumsal projeler                | Hızlı prototipleme ve dijital dönüşüm | Küçük ve orta ölçekli iş uygulamaları  |
| **Kod Yazma İhtiyacı** | Düşük kod, ancak daha fazla manuel kod yazma imkanı | Görsel modelleme, düşük kod            | Düşük kod, basit arayüzler              |
| **Entegrasyonlar**     | Yüksek, üçüncü parti sistemlerle entegrasyon | Esnek entegrasyonlar, geniş araçlar   | Microsoft ürünleriyle mükemmel entegrasyon |
| **Esneklik**           | Yüksek, özelleştirme ve manuel kod yazma imkanları | Orta derecede esneklik                 | Orta, ancak Microsoft ekosisteminde mükemmel |
| **Kullanıcı Kitlesi**  | Kurumsal kullanıcılar, yazılım geliştiriciler | İşbirliğine dayalı, iş analistleri ve geliştiriciler | Hem teknik hem de teknik olmayan kullanıcılar |
| **Platform Özellikleri** | Geniş çaplı web ve mobil uygulama desteği | Hızlı uygulama geliştirme ve prototipleme | Microsoft 365 ve Azure entegrasyonu |



Ufak bir bilgi verdikten sonra konumuza dönebiliriz.



## Mendix Uygulamaları Nasıl Deploy Edilir?

Mendix uygulamalarını deploy etmek için bir çok yol var. Aslında bu teknikler uygulamanızı nereye deploy etmek istediğinize göre değişiyor. [Resmi sayfasında](https://docs.mendix.com/deployment/)n da detaylarına bakabilirsiniz.

- Mendix Cloud: Bu en çok tercih edilen yöntem. Eğer sistem işleriyle ve CI/Cd süreçleriyle uğraşmak istemiyorsanız en iyi ve hızlı yöntem. Üstelik takımlarınız için proje yönetimi ve Scrum board'ları sunuyor. Tek tık ile uygulamasını farklı ortamlar (test, uat, prod) için yayına verebilirsiniz. [Resmi sayfasından](https://docs.mendix.com/developerportal/deploy/mendix-cloud-deploy/deploying-an-app/) detaylarını okuyabilirsiniz.
- Mendix Cloud Dedicated: Mendix Cloud ile tamamen aynı tek farkı tamamen firmanıza özel bir cluster üzerinde uygulamalarınız çalıştığı yöntem. Deetaylarını [resmi sayfasından](https://www.mendix.com/evaluation-guide/deployment/mendix-cloud/dedicated/) okuyabilirsiniz.
- Mendix Private Cloud: Bu yöntemde Mendix Cloud kendi veri merkezinize kurulur ve Mendix Cloud'daki yetenekleri kullanarak deployment çıkılır. Ancak tabi bu çok maliyetli bir yöntem. Yani iş hacminizin ciddi miktarada büyük olması lazım.
-  Cloud Foundary: Cloud Foundary (CF) destekli platformalara deploy edilebilir. CF nedir,ne yapar kopnumuz olamdığı için burada detaylarına girmiyoruz ama merak ederseniz [resmi sayfasını](https://www.cloudfoundry.org/get-started/) ziyaret edebilirsiniz.
-  Azure Maketplace: Azure Maketplace uygulaması üzerinden Azure'da sanal makine üzerinde yayına verebilirsinniz. Yapmanız gereken Azure üzerinde kaynak olarka Mendix Pro'yu oluşturmak. Zaten Mendix Pro size sorular sorarak nasıl bir mekinede, nasıl bir networkde yayına vermek isterseniz ona göre bir ortam kuruyor.
-  Industrial Edge: Siemens'in IOT platformların adeplşoy etmek için kullanılır. [Şu sayfadan](https://docs.mendix.com/developerportal/deploy/mendix-app-on-industrial-edge/) detaylarına bakabilirsiniz.
-  On-Premises: Bu yöntemde ise klasik yöntemlerle uygulama poaketi alınır ve manule olarka bir Linux veya Windows sunucuda yayına verilir. Uygulama bir servis olarak çalıştırılır ve Windows IIS, Linux'de ise Nginx veya HAProxy benzeri bir Proxy ile uygulama dışarı açılır. Windows için  süreç bir daha kolayken Linux tarafında (kişisel düşüncem) gereksiz bir karmaşıklık var. Linux için Python ile yazdıkları m2ee-tools adında bir Python paketini ve komutlarını kullnarak uygulamanızı puslish edebiliyorsunuz .Aslında Windows'da da bir GUI olması işleri kolaylaştırıyor. Aslında amacımız bir Java uygulmasını publish alıp yayına vermek ama zannediyorum low-code olma amacıyla birşeyleri hep soyutlama yoluna gitmişler ancak bu da daha fazla karmaşıklaştırmış. Üstelik doküman bulmanızı da zorlaştırıyor.  Windows için [şu sayfayı](https://docs.mendix.com/developerportal/deploy/deploy-mendix-on-microsoft-windows/) Linux için de [resmi Github sayfasına](https://github.com/mendix/m2ee-tools/blob/develop/doc/README.md) bakmanız gerekiyor. 
- Docker ve Kubernetes: Yukarıda bahsettiğimiz Mendix Cloud da aslında uygulamamızı bir Docker image haline getirip kendi Kubernmetes Cluster'larında yayına veiyor. Normal şartlarda On-Premise yönteminde Linux üzerinde yapılan deployment süreçlerini Dockerfile üzerinden yazıp çalıştırmamız yeterli olacaktır. Ancak Mendix bütün bu süreci Cloud Foundary kullanarak uygulamamızı paketleyip Dockerize edecek bir yöntem geliştirmiş. Açıkçası Cloud Foundry kullanmaya zorlamak da bana biraz gereksiz geldi. Yine low-code ürün olma ünvanından olmamak için her yeri soyutlamışlar ancak bu da hata ayıklama konusunda zorlayıcı oluyor. 

Bu konuyu da lattaki başlık da inceliyor olacağız.

## Mendix Uygulamalaır Nasıl Dockerize Edilir?

Mendix uygulamalarımızı Dockerize edebilmemiz için Github'da bir proje yayınlamış. Adı da [docker-mendix-buildpack](https://github.com/mendix/docker-mendix-buildpack)  ve bu da Mendix'in diğer bir Github projesini kullanıyor onun adı da [cf-mendix-buildpack](https://github.com/mendix/cf-mendix-buildpack). Biz bunların detaylarına girmeyeceğiz. Amacımız sadece elimizdeki mendiz uygulmasını dockerize etmek ve yayına vermek. 

Bu arada Prod ortamlarında da lisans işlemlerini nasıl çözeceğinizi de değineceğim.

Mendix uygulamamızı build alırken bizden 2 adet image istiyor.
- Mendix uygulamamızın çalışacağı image
- Mendix uygulamamızı build alacak image

Bu iki image'ı da kendimiz build almamız gerekiyor.

Şimdi adım adım uygulamamızı Dockerize edelim. Öncelikle bahsettiğimiz image'ları build almayı görelim. Bunları kendimiz build labildiğimiz için içide istediğimiz değişiklikleri de yapabiliriz. Ancak çok zorunda kalmadıkça yapmanızı tavsiye etmiyorum.

Öncelike docker-mendix-buildpack reposunu uygun versiyonunu lokal'imize klonluyoruz. Bu makaleyi yazdığımda enson altıncı versiyonu yayındaydı. Özellikle bu versiyonun dokümanını takip edeceğiz. Master branch'deki en son haline bakmıyoruz yani. Şu [linkten altıncı](https://github.com/mendix/docker-mendix-buildpack/tree/v6.0.0)  versiyona ulaşbilirsiniz.

```shell
git clone https://github.com/mendix/docker-mendix-buildpack.git
cd docker-mendix-buildpack
git checkout v6.0.0
```

Daha sonra Docker image'ımızı oluşturuyoruz. İndirdiğimiz Git reposunun dizinindeyken alttaki komutları çalıştırıyoruz.

```shell
cd docker-mendix-buildpack
docker build -t mendix-rootfs:app -f rootfs-app.dockerfile .
```

Şimdi de Mendix builder image'ını build alıyoruz.

```shell
docker build -t mendix-rootfs:builder -f rootfs-builder.dockerfile .
```


Böylece `mendix-rootfs:app` ve `mendix-rootfs:builder` adında iki image oluşturmuş olduk. İsterseniz bu image'ları bir repoya kaydedip oradan da kullanabilirsiniz böylece her defasında build lmak zorunda kalmazsınız.

Şimdi bunları kullanarak uygulamamızı build alalım. Örnek uygulama için alttaki komutları repo dizinindeyken çalıştırıyoruz.


```shell
mkdir -p downloads build
wget https://s3-eu-west-1.amazonaws.com/mx-buildpack-ci/BuildpackTestApp-mx-7-16.mda -O build/BuildpackTestApp-mx-7-16.mda

```

Genellikle uygulamamız bir kaynak MPK dosyası, bir MPR proje dizini veya sıkıştırılmış bir MDA dosyası olacaktır. Bu durumda CF Buildpack tarafından desteklenen bir formata dönüştürülmesi veya derlenmesi gerekir. Buda aslında çıkarılmış bir MDA dosyasıdır. Bu özellik, Docker Buildpack sürüm v6.0.0 ve sonrasında mevcuttur ve Mendix 8, 9 ve 10 uygulamalarının özel CI/CD pipeline'larında derlenmesine olanak tanımaktadır.


```shell
./build.py --source  downloads/  --destination build/ build-mda-dir
```
Bu script bizim için uyygulamamızı extract edip birde Dockerfile dosyası oluşturmuş oldu.

Artık uygulamamızı build alabiliriz. Komutta en sondaki build kelimesi projemizin extract edilmiş ve Dockerfile dosyasını içeren dizin.

```shell
docker build --build-arg ROOTFS_IMAGE=mendix-rootfs:app --build-arg BUILDER_ROOTFS_IMAGE=mendix-rootfs:builder --tag my-mendixapp:latest build

# yada
# docker build --tag my-mendixapp:latest build

```
Build argümanları sadece BUILD_PATH, ROOTFS_IMAGE ve BUILDER_ROOTFS_IMAGE parametlerinden ibaret değil. Altta diğer parametleri de listeliyorum.


* BUILD_PATH: Uygulama modelinin bulunduğu yeri belirtir. Bu, açılmış bir .MDA veya .MPK dosyasının kök dizinidir. İkinci durumda, bu, .MPR dosyanızın bulunduğu dizindir. Build bağlamı içinde olmalıdır. Varsayılan olarak ./project olarak ayarlanmıştır.
* ROOTFS_IMAGE: Bir tür rootfs (kök dosya sistemi) görüntüsüdür. Varsayılan olarak mendix/rootfs:ubi8 (Red Hat Universal Base Image 8) kullanılır. Ubuntu 18.04 kullanmak için bunu mendix/rootfs:bionic olarak değiştirebilirsiniz. Ayrıca, gelişmiş özelliklerde belirtildiği gibi özel bir rootfs görüntüsü kullanmak da mümkündür.
* BUILDER_ROOTFS_IMAGE: Mendix uygulama bağımlılıklarını indirip Mendix uygulamasını kaynaktan derlemek için kullanılan bir rootfs görüntüsüdür. Varsayılan olarak mendix/rootfs:bionic kullanılır. Ayrıca, gelişmiş özelliklerde belirtildiği gibi özel bir rootfs görüntüsü kullanmak da mümkündür.
* CF_BUILDPACK: CloudFoundry buildpack sürümüdür. Varsayılan olarak v4.30.14'tür. Kararlı hatlar için, v4.30.14 ve sonrasındaki sabit bir sürüm kullanılması önerilir. CloudFoundry buildpack sürümleri v4.30.14'ten önce desteklenmemektedir.
* EXCLUDE_LOGFILTER: Eğer true olarak ayarlanırsa, mendix-logfilter ikili dosyasını son Docker imajından hariç tutar. Varsayılan olarak true'dur. mendix-logfilter'ı hariç tutmak, imaj boyutunu küçültür ve genellikle kullanılmayan bir bileşeni kaldırır; LOG_RATELIMIT ortam değişkeni seçeneği devre dışı bırakılır.
* UNINSTALL_BUILD_DEPENDENCIES: Uygulama başlatmak için gerekli olmayan ve yalnızca build aşamasında kullanılan paketleri kaldırır. Varsayılan olarak true'dur. Bu seçenek, yamanmamış CVE güvenlik açıklarına sahip olduğu bilinen birkaç kütüphaneyi kaldırır.
* CF_BUILDPACK_URL: CF buildpack'in indirileceği URL'yi belirtir (örneğin, yerel bir yansıma). Varsayılan olarak https://github.com/mendix/cf-mendix-buildpack/releases/download/${CF_BUILDPACK}/cf-mendix-buildpack.zip kullanılır. 
* CF_BUILDPACK_URL belirtildiğinde, CF_BUILDPACK'ten gelen sürüm geçersiz kılınır.
* BLOBSTORE: Alternatif bir buildpack kaynak sunucusu belirtmek için kullanılabilir (varsayılan Mendix CDN yerine). Daha fazla bilgi için, CF Buildpack çevrimdışı ayarlarına bakın.
* BUILDPACK_XTRACE: CF Buildpack hata ayıklama günlüklemesini etkinleştirmek için kullanılabilir. Bu değişkeni true olarak ayarlayarak hata ayıklama günlüklemesini etkinleştirebilirsiniz.



## Mendix Uygulaması Docker Olarak Nasıl Yayına Verilir? 

Artık elimizde my-mendixapp adında bir image var. Uygulamayı açlıştıamk için bir veritabanına ihtiyacımız olacak. Alttaki komutla bir postgres ayağa kaldıralım.

```shell
docker run --name mendix-postgres -e POSTGRES_PASSWORD=abc123 -p 5436:5432 -d  postgres:12
```

Daha sonra uygulamamız için bir veritabanı oluşturalım

```bash
docker exec -it mendix-postgres psql -h localhost -U postgres -c 'create database mendixdb;'
```

Bağlanabilmek için host makinemmizin 5436 portun abağlanmaız gerekiyor. Benim ip adresim `192.168.0.25` olarak görünüyor. Siz kendihost ip  adresinizle bunu değiştirmelisiniz.

```bash
docker run -d --name mymendixapp  -e ADMIN_PASSWORD=Password1! -e DATABASE_ENDPOINT=postgres://postgres:abc123@192.168.0.25:5436/mendixdb -p 8585:8080  my-mendixapp:latest
```


Daha sonra tarayıcınızda `http://localhost:8585` adresine girdiğimizde kullanıcı adı olarak `MxAdmin` ve şifre `Password1!` olarak giriyoruz. Kullanıcı adı ve şifreyi de büyük/küçük harf duyarlı girmek girekiyor.


![home.png](files/home.png)


## Production Ortamları için Lisanslama

Lisans almak için  `https://newnode.mendix.com/index.html` adresine giriş yapmamız gerekiyor.

![login.png](files/login.png)

Company, Contact Name ve Email address kısımları zaten dolu gelecek. Hosting Type olarak On-Premise seçiyoruz ve Uygulama dını (App name) girip next butonuna tıklıyoruz. Uygulama adını Mendix üzerinde veya Mendix Studio üzerinde uygulama oluştururken verdiğimiz ismi olduğu gibi kullanarak yazıyoruz.

Bir sonraki ekranda `Add Environment` Butonuna tıklayıp bir de Test ortamı eklemiş oluyoruz. Docker kullandığımız için `Server Id` yazan kısımlara altta görüdüğünüz gibi metinler giriyoruz. Bunların bir önemi yok sadece boş geçemediğimiz için yazdık. 

![login2.png](files/login2.png)

Daha sonra save butonuna tıklayıp devam ediyoruz. Sonuç oalrak 1 gün içinde emailimize bir email gelcek burada ekrandi üç ortam için de birer `LICENSE_ID` ve `LICENSE_ID` gelecek.


Lisanslar geldiğinde her ortam için alttaki gibi `LICENSE_ID` ve `LICENSE_ID` değerlerini de ekleyerek konteynerlerimizi çalıştırmamız gerekiyor.

```bash
docker run -d --name mymendixapp  \ 
            -e ADMIN_PASSWORD=Password1! \ 
            -e DATABASE_ENDPOINT=postgres://postgres:abc123@192.168.0.25:5436/mendixdb \
            -e LICENSE_ID=Lisans_Id_gelecek \
            -e LICENSE_KEY=Lisans_Key_gelecek \
            -p 8585:8080 \  
            my-mendixapp:latest
```

### Environemet Variable (Constants) Kullanımı

Environment variables ve Constant kullanımı hakkında resmi sayfasındaki [şu dokümana](https://docs.mendix.com/refguide/constants/) bakabilirsiniz.

Mendix için constant uygulamanız ayakta olduğu sürece global olarak kullanılan değişkenlerdir diyebiliriz. Bu da bize  environment variable kavramını tanımlıyor. Aradaki fark Mendix kendi içinden sistemin environment variable'larını okumaktansa constant'ları okuyor ve bunları dışarıdan uygulamaya verebilmemiz için yöntemler sunuyor. Bunlar Docker üzerinden Environment Variable olarak uygulamaya geçirilebiliyor.

Örneğin `MyModule.MyConstant` şeklinde bir constant tanımladıysak bunu container'a geçirirken `-e MX_MyModule_MyConstant=abc` şeklinde tanımlıyoruz. Yani MX ile başlayacak ve her nokta `_` alt çizgi olarak yazılır.



### Runtime Customization Kullanımı

Runtime Customization hakkında detaylı bilgi almak için resmi sayfasındaki [şu dokümanı](https://docs.mendix.com/refguide/custom-settings/) okuyabilirsiniz.

Buna da kısaca değinecek olursak uygulamamızın framework'ünün kullantığı rruntime değişkenlerini ifade eder. Verdiğim linkte yüzlerce parametre var. Sertifika, veritabanı, veritabanı  migration, proxy, log, storage, metrik vb bir çok ayarı yapabiliyoruz.


Burada linkte verdiğimiz her bir runtime ayarı için alttaki örneklerideki gibi her birinin basşına `MXRUNTIME` kelimesini ekliyoruz.

```
-e MXRUNTIME_DatabaseUserName=db_username 
-e MXRUNTIME_DatabaseType=POSTGRESQL
-e MXRUNTIME_DatabasePassword=db_sifre 
-e MXRUNTIME_DatabaseName=db_name 
```


Altta örneğin alttaki gibi konfigürasyonla uygulama çalıştırılabilir.

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
  -e MXRUNTIME_DatabasePassword=db_sifre 
  -e MXRUNTIME_DatabaseName=db_name 
  mymandixapp 
```

## Kubernetes ile Uygulama Yayına Nasıl Verilebilir?

Yukarıda anlattıklarımı dikkate alarak normal bir uygulama nasıl yayına veriliyorsa aynı şekilde yayına verilir. Sadece Constant ve Runtime setting'lere dikkat etmek yeterli. Yani sonuçta elimizde halen bir Docker image var.

Bu yazımızda bu kadar. Umarım faydalı olmuştur.

Bir sonraki yazımızda görüşmek üzere.



