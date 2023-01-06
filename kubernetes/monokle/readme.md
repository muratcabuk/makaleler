### Lab Ortamı Kurulumu  

Lab ortamımızı [Kind](https://kind.sigs.k8s.io/) ile kuracağız. Kind Kubernetes'in testlerinde kullanılmaz için geliştirilmiş bir Kubernetes cluster deployment aracı.

Docker container'ları üzerinden Kubernetes deployment yapmamızı sağlıyor. Sanal makine oluşturmadığımız için hem çok hızlı bir şekilde cluster'ımızı ayağa kaldırabiliyoruz hem de kaynak tüketimimiz de azalmış oluyor. Ayrıca native Kubernetes kullandığı için Kubernetes için geliştirilen bir çok native aracı (Nginx ingress, Calico, Istio, MetalLB..vb) kullanabilirsiniz.

Kind dışında başka Lightweight Kubernetes deployment araçları da var.

- [Minikube](https://minikube.sigs.k8s.io/docs/start/): Cross Multinode desteklenmez. Yani sadece aynı makine üzerinde multinode desteklenir. Tam native çözün sunmaz bu nedenle bazı araçların yerine kendi çözümü vardır. Mesela service mesh, load balancing, storage vb. 
- [Microk8s](https://microk8s.io/): Canonical firmasının geliştirdiği bir araçtır. IoT cihazları, test ortamları ve development için kullanılmak üzere geliştirilmiştir. Ayrıca büyük olmayan production ortamlarında da kullanılabilir. Tam native bir çözüm sunmaz. Bu nedenle bazı ihtiyaçlar için plugin sistemi vardır. Cross Multinode desteklenir. High Availability için  ETCD yerine [Dqlite](https://dqlite.io/docs/explanation/architecture) adında Sqlite üzerine kurulu bir distributed veri tabanı kullanır. 
- [K3s](https://docs.k3s.io/): IoT cihazları, test ve development için geliştirilmiştir. 100 MB'lık binary tekbir dosyadır. Bu haliyle Mikrok8s kadar gelişmiş değildir. Sanal makineler üzerinden cluster kurmayı destekler. Ancak native bir kurulum sunmadığı için Kubernetes için geliştirilmiş  her aracı kullanmak mümkün olmayabilir.
- [K3d](https://k3d.io/): Kendi başına bir Kubernetes deployment aracı değildir. K3s'i bir nevi sarmayalarak cli üzerinden docker container'ları üzerinde çalışacak cluster oluşturmamızı sağlar. Bu haliyle aslında K3s ile K3d'nin birleşimi bir Minikube veya Microk8s gibi bir araca denk geliyor diyebilir.


Bu durumda IoT , dev, test ve küçük production ortamları için en uygunu Microk8s gibi görünüyor. Ancak tam native test ortamı arıyorsanız o zaman da Kind uygun gibi görünüyor. Amacınız doğrudan native Kubernetes araçlarını kurmak ve test etmekse KinD native bir ortam sunduğu mantıklı görünüyor.

Öncelikle Kind'ı local makinemize kurmamız gerekiyor. Bunun için resmi sayfasından işletim sisteminize uygun kurulumu yapabilirsiniz. MacOs için brew, Windows için Chocolatey paket yöneticileri mevcut. Ayrıca isterseniz doğrudan binary üzerinden de çalıştırabilirsiniz.

Linux için alttaki komutları kullanabilirsiniz.


```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

Kind cli kullanarak cluster'ımızı oluşturuyoruz. Bunun için cluster.yaml adında bir dosyaya alttaki kodları kopyalıyoruz.

```bash

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
```


Daha sonra dosyanın bulunduğu dizinde iken terminalde alttaki komutla cluster'ımızı oluşturuyoruz.

```bash
kind create cluster --name mycluster --config cluster.yaml
```
Kubectl kurmak için 

- [Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [Mac Os](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
- [Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)


Linux için kurulum

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
mv ./kubectl /usr/local/bin/kubectl
```

Test etmek için alttaki komut kullanıyoruz. Home klasörümüzde .kube klasörü altında config adında bir doya oluşturulduğunu görebiliriz. Bu dosya içinde kind-mycluster adında bir context oluşturuldu bunu kullanarak cluster'ımız üzerinde komut çalıştırabiliriz.


```bash
kubectl cluster-info --context kind-mycluster

# Kubernetes control plane is running at https://127.0.0.1:41415
# CoreDNS is running at https://127.0.0.1:41415/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

# To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

```

Artık lab ortamımız hazır olduğuna göre Monocle'yi incelyebiliriz.


### Monocle de neymiş?

[Resmi sayfasındaki](https://monokle.io/) tanıma göre "Monokle, tüm uygulama yaşam döngüsü boyunca yüksek kaliteli Kubernetes yapılandırmaları oluşturmaya ve sürdürmeye yönelik bir araç setidir".

Araç setinde bulunan araçlar.
- Desktop: 
- CLI: 
- Cloud: 



Yani ne gibi faydaları var?















