 

Kubespray ile kurumda çıkabilcek hatalar için çok iyi bir kaynak : https://dev.to/admantium/kubernetes-installation-tutorial-kubespray-46ek



![topology.jpg](files/topology.jpg)


[Kubespray Vagrant](https://github.com/kubernetes-sigs/kubespray/blob/v2.21.0/docs/vagrant.md)ile kurulumu destekliyor.  Ancak biz Vagrant tarafını manuel yapacağız.



alttaki kodları bir klasöre Vagrantf,le adında bir doya açıp içine kopyalıyoruz. Aynı dizinde bir terminal açıp _vagrant up_ komutu ile VM leri ayağa kaldırıyoruz.

```vagrantfile

# -*- mode: ruby -*-
# vi: set ft=ruby :


# 1-9 arası rakam giriniz
MASTER_COUNT = 3
WORKER_COUNT  = 3


MASTER_IP_PREFIX  = "192.168.56.4"
WORKER_IP_PREFIX  = "192.168.56.5"

PROVIDER = "virtualbox"

BASTION_IP = "192.168.56.31"

ROOT_PASS = "kubeadmin"


ENV['VAGRANT_DEFAULT_PROVIDER'] = PROVIDER

$allscript = <<-ALLSCRIPT

MASTER_COUNT=$1
WORKER_COUNT=$2
MASTER_IP_PREFIX=$3
WORKER_IP_PREFIX=$4
BASTION_IP=$5
ROOT_PASS=$6


echo master count : $MASTER_COUNT
echo worker count : $WORKER_COUNT
echo master ip prefix : $MASTER_IP_PREFIX
echo master worker prefix : $WORKER_IP_PREFIX
echo bastion ip : $BASTION_IP
echo root pass : $ROOT_PASS

sudo apt update && sudo apt upgrade -y
sudo apt install ntpstat -y
sudo apt install ntp -y



echo "===================== root user aktif ediliyor ====================="

sudo su

echo -e "$ROOT_PASS\n$ROOT_PASS" | passwd root
echo "export TERM=xterm" | tee -a /etc/bash.bashrc

echo "===================== ntp aktif ediliyor ====================="

timedatectl set-ntp true
timedatectl status

echo "===================== swap iptal ediliyor =========================="

sed -i "/swap/d" /etc/fstab
swapoff -a
systemctl disable --now ufw

echo "=================== kubernetes network için sysctl update ediliyor =============="

modprobe overlay
modprobe br_netfilter

cat <<EOF | sudo tee -a /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system

echo "============= ssh ayarları yapılıyor ============="

sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/" /etc/ssh/sshd_config
echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config

systemctl reload sshd

echo "===================== host dosyaları düzenleniyor ==================="
for i in $(seq 1 $MASTER_COUNT); do
   echo "$MASTER_IP_PREFIX$i master$i" >>/etc/hosts
done

for i in $(seq 1 $WORKER_COUNT); do
   echo "$WORKER_IP_PREFIX$i worker$i" >>/etc/hosts
done

echo "$BASTION_IP bastion" >>/etc/hosts
echo "$BASTION_IP mycluster.kubernetes.local" >>/etc/hosts


ALLSCRIPT


$bastionscript = <<-BASTION

MASTER_COUNT=$1
WORKER_COUNT=$2
MASTER_IP_PREFIX=$3
WORKER_IP_PREFIX=$4
BASTION_IP=$5
ROOT_PASS=$6


echo master count : $MASTER_COUNT
echo worker count : $WORKER_COUNT
echo master ip prefix : $MASTER_IP_PREFIX
echo master worker prefix : $WORKER_IP_PREFIX
echo bastion ip : $BASTION_IP
echo root pass : $ROOT_PASS




sudo apt install sshpass -y
sudo apt install python3 -y
apt install python3-pip -y
apt install python3-virtualenv -y


sudo su

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

for i in $(seq 1 $MASTER_COUNT); do
    sshpass -p $ROOT_PASS ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@$MASTER_IP_PREFIX$i
    echo "yes \n" | scp ~/.ssh/id_rsa root@$MASTER_IP_PREFIX$i:.ssh/
    echo key kopyalandı: $MASTER_IP_PREFIX$i
done


for i in $(seq 1 $WORKER_COUNT); do
    sshpass -p $ROOT_PASS ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@$WORKER_IP_PREFIX$i
    echo "yes \n" | scp ~/.ssh/id_rsa root@$WORKER_IP_PREFIX$i:.ssh/
    echo key kopyalandı: $WORKER_IP_PREFIX$i
done

BASTION




Vagrant.configure("2") do |config|

# master
(1..MASTER_COUNT).each do |i|

config.vm.define "master#{i}" do |master|
   master.vm.box = "generic/ubuntu2004"
   master.vm.network "private_network", ip: MASTER_IP_PREFIX+"#{i}"
   master.vm.hostname = "master#{i}"

   master.vm.provider :PROVIDER do |lv|
       lv.memory=2048
       lv.cpus=2
    end
 end
end


# worker
(1..WORKER_COUNT).each do |i|

config.vm.define "worker#{i}" do |worker|
   worker.vm.box = "generic/ubuntu2004"
   worker.vm.network "private_network", ip: WORKER_IP_PREFIX+"#{i}"
   worker.vm.hostname = "worker#{i}"


   worker.vm.provider :PROVIDER do |lv|
       lv.memory=2048
       lv.cpus=2
       lv.storage :file, :size => '10G'

   end
 end
end


# bastion
config.vm.define "bastion" do |bastion|
   bastion.vm.box = "generic/ubuntu2004"
   bastion.vm.network "private_network", ip: BASTION_IP
   bastion.vm.hostname = "bastion"

   bastion.vm.provider :PROVIDER do |lv|
       lv.memory=2048
       lv.cpus=2
    end

   bastion.vm.provision "shell", run: "once", inline: $bastionscript, args: [MASTER_COUNT,WORKER_COUNT, MASTER_IP_PREFIX,WORKER_IP_PREFIX, BASTION_IP, ROOT_PASS]
 end




# global olarak tanımlanmış shell provision. Bütün vm lerde çalışacak
config.vm.provision :shell, run: "once" do |s|
   s.args = [MASTER_COUNT,WORKER_COUNT, MASTER_IP_PREFIX,WORKER_IP_PREFIX, BASTION_IP, ROOT_PASS]
   s.inline = $allscript
end

end
```

### Python ve Kubespray kurulumları

Kurulumları Bastian üzerinden yapacağız.


Vagrant klasöründe iken terminalden _vagrant ssh bastion_ komutu ile bastion makinemize giriyoruz. Root kullanıcısına geçiş yapıp kurulumları yapıyoruz.


Kubespray 2.21 release şuna latest version. Biz de bunu kullanacağız. [Dokümana göre](https://github.com/kubernetes-sigs/kubespray/blob/release-2.21/docs/ansible.md) öncelikle Ansible'ı kurmamız gerekiyor. 


Python'da virtual environment oluşturup kurulumları yapıyoruz. 




```shell
sudo su


VENVDIR=/kubespray-venv
KUBESPRAYDIR=/kubespray


mkdir $VENVDIR

git clone -b release-2.21 https://github.com/kubernetes-sigs/kubespray.git $KUBESPRAYDIR




ANSIBLE_VERSION=2.12
virtualenv  --python=$(which python3) $VENVDIR
source $VENVDIR/bin/activate

cd $KUBESPRAYDIR

pip install -U -r requirements-$ANSIBLE_VERSION.txt

test -f requirements-$ANSIBLE_VERSION.yml && \
  ansible-galaxy role install -r requirements-$ANSIBLE_VERSION.yml && \
  ansible-galaxy collection -r requirements-$ANSIBLE_VERSION.yml

```


### Kubernetes Kurulumu

Sunucularımızı Kubespray'e tanıtmak için örnek inventory klasörünün kopyasını alıyoruz.

```shell

cd $KUBESPRAYDIR

cp -rfp inventory/sample inventory/mycluster

```

Mycluster altında inventory.ini adında bir dosya var. Bunun üzerinden cluster'daki makinelerimizi tanımlayabiliriz. Ancak Ansible bize bir builder sunuyor. Bunu kullanarak inventory'mizi oluşuracağız.



```shell
cd $KUBESPRAYDIR

declare -a IPS=(192.168.56.41 192.168.56.42 192.168.56.43 192.168.56.51 192.168.56.52 192.168.56.53)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

```

Oluşan inventory dosyamızın içeriğini bakalım.


```yaml
# cat  inventory/mycluster/hosts.yaml 

all:
  hosts:
    node1:
      ansible_host: 192.168.56.41
      ip: 192.168.56.41
      access_ip: 192.168.56.41
    node2:
      ansible_host: 192.168.56.42
      ip: 192.168.56.42
      access_ip: 192.168.56.42
    node3:
      ansible_host: 192.168.56.43
      ip: 192.168.56.43
      access_ip: 192.168.56.43
    node4:
      ansible_host: 192.168.56.51
      ip: 192.168.56.51
      access_ip: 192.168.56.51
    node5:
      ansible_host: 192.168.56.52
      ip: 192.168.56.52
      access_ip: 192.168.56.52
    node6:
      ansible_host: 192.168.56.53
      ip: 192.168.56.53
      access_ip: 192.168.56.53
  children:
    kube_control_plane:
      hosts:
        node1:
        node2:
    kube_node:
      hosts:
        node1:
        node2:
        node3:
        node4:
        node5:
        node6:
    etcd:
      hosts:
        node1:
        node2:
        node3:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```

Dosyamızı alttaki gibi değiştiriyoruz.

```yaml

all:
  hosts:
    node1:
      ansible_host: 192.168.56.41
      ip: 192.168.56.41
      access_ip: 192.168.56.41
    node2:
      ansible_host: 192.168.56.42
      ip: 192.168.56.42
      access_ip: 192.168.56.42
    node3:
      ansible_host: 192.168.56.43
      ip: 192.168.56.43
      access_ip: 192.168.56.43
    node4:
      ansible_host: 192.168.56.51
      ip: 192.168.56.51
      access_ip: 192.168.56.51
    node5:
      ansible_host: 192.168.56.52
      ip: 192.168.56.52
      access_ip: 192.168.56.52
    node6:
      ansible_host: 192.168.56.53
      ip: 192.168.56.53
      access_ip: 192.168.56.53
  children:
    kube_control_plane:
      hosts:
        node1:
        node2:
        node3:
    kube_node:
      hosts:
        node4:
        node5:
        node6:
    etcd:
      hosts:
        node1:
        node2:
        node3:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}


```

Cluster'ımız ile ilgili tüm değişkenleri _inventory/mycluster/group_vars_ dizinide bulabiliriz.

Öncelikle clusterım'ızın doman name'ini değiştirelim.


_inventory/mycluster/group_vars/all/all.yml_ dosyasında alttaki satırları buluyoruz.


```yaml
## External LB example config
## apiserver_loadbalancer_domain_name: "elb.some.domain"
# loadbalancer_apiserver:
#   address: 1.2.3.4
#   port: 1234


# upstream_dns_servers:
#   - 8.8.8.8
#   - 8.8.4.4




```

alttaki şekle getiriyoruz.


```yaml

## External LB example config
apiserver_loadbalancer_domain_name: "mykubecluster.com"
loadbalancer_apiserver:
   address: 192.168.56.31
   port: 6443


# altttki ip adreslerini gerçek ortamda yer alan DNS sunucu ip adreslerinizle değiştirebilirsiniz.clear
upstream_dns_servers:
   - 8.8.8.8
   - 8.8.4.4


```


Daha sonra _inventory/mycluster/group_vars/k8s_cluster/addons.yml_ dosyasında alttaki ayarları yapıyoruz.




```yaml
# dashboard_enabled: false
dashboard_enabled: true

# helm_enabled: false
helm_enabled: true

# metrics_server_enabled: false
metrics_server_enabled: true

# ingress_nginx_enabled: false
ingress_nginx_enabled: true

# cert_manager_enabled: false
cert_manager_enabled: true

# argocd_enabled: false
argocd_enabled: true


```

Cluster adını ve proxy modunu  değişirelim. Bunun için _inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml_ dosyasında alttaki değişikliği yapıyoruz. Burad şuna dikkat etmemiz gerekiyor. Geröek oramda hakikaten _kubernetes.mykubecluster.com_ adında bir dns kaydı olmalı. Genellikle com yerine gerçek ortamlarda _cluster.local_ şeklinde olur. eğer mümkünse gerçek ortamlarda buraya özel forward lookup zoe kurulmalı. Hatta PTR kayıtları bile girilmeli. Bu Bölümün altında ayrı bir başlık oalrka bu detaylar incelecenecek.

Eğer pod ve service ip'lerini değişrimöek istiyorsak onları da bu dosyadan değiştirmek mümkün. Ayrıca default CNI da bu dosyadan değiştirilebilir. 


Dosya içinde default container manager'ın containerd olduğuna dikkat edin (docker değil yani).


Aslında proxy modu değiştirelim demiştik ancak olduğu gibi bırakacağız. IPVS'de iptables gibi bir kernel feature ve iptables'a göre daha kolay ve anlaşılır Ayrıca daha hızlı. Bunu da hemen altta işliyor olacağız.


```yaml

## Container runtime
## docker for docker, crio for cri-o and containerd for containerd.
## Default: containerd
container_manager: containerd


# cluster_name: cluster.local

cluster_name: kubernetes.mykubecluster.com
 | 

# Kube-proxy proxyMode configuration.
# Can be ipvs, iptables
kube_proxy_mode: ipvs

```

Eğer farklı roller eklemyidüşünürsek Kubespray ana dizinindeki _cluster.yml_ dosyasında deişiklikleir yapılabilir. Sistemdeki roller için roles klasörüne bakabilirsiniz.


[Şu sayfada ](https://github.com/kubernetes-sigs/kubespray/blob/v2.21.0/docs/ansible.md)da bütün keyword'leri ve ne işe yaradıklarını liste olarak görebilirsiniz.

Evet artık her şey hazır görünüyor. cluster'ımızı ayağa kaldırabiliriz.


Alttaki komutla cluster'ımızı ayağa kaldırıyoruz.

```shell
cd $KUBESPRAYDIR

# Without --become the playbook will fail to run!
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml

```


### Kubespray ile Kubernetes Cluster upgrade


[Şu dokünman](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/upgrades.md) ile upagrade işlemleri yapılabilir.


#### Güvenli Olmayan Upgrade

#### Güvenli Upgrade


### IPVS ve DNS detayları 

local notlarını da eklemeyi unutma



### Nginx External Load Balancer Kurulumu

Bütün kurulum işlemlerimizi bastion sunucumuzda yapacağız.Bu sunucu aynı zamanda load balancer görevi de görecek. Bunun için Nginx kuracağız. Bastion sunucuna giriş yaptıktan sonra root kullanıcısına geçiş yapıyoruz ve kuruluma başlıyoruz.


```shell
sudo su
# apt update && apt upgrade -y
apt install nginx

mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

cat << EOF > /etc/nginx/nginx.conf

worker_processes 4;
worker_rlimit_nofile 40000;


#stream kullanabilmek için dinamik mobullerde strem modülünü yüklüyoruz
include /usr/share/nginx/modules/*.conf;
load_module /usr/lib/nginx/modules/ngx_stream_module.so;


events {
   worker_connections 8192;
}


# stream modülünü yüklediğimiz için kullanabiliyoruz.
stream {

   upstream master_backend {
         least_conn;
         server master1:9345 max_fails=3 fail_timeout=5s;
         server master1:9345 max_fails=3 fail_timeout=5s;
         server master1:9345 max_fails=3 fail_timeout=5s;
      }

   server {
         listen 9345;
         proxy_pass master_backend;
      }


   upstream kube_api {
         least_conn;
         server master1:6443 max_fails=3 fail_timeout=5s;
         server master2:6443 max_fails=3 fail_timeout=5s;
         server master3:6443 max_fails=3 fail_timeout=5s;
      }
   server {
         listen     6443;
         proxy_pass kube_api;
      }


   upstream rancher_web {
         least_conn;
         server master1:80 max_fails=3 fail_timeout=5s;
         server master1:80 max_fails=3 fail_timeout=5s;
         server master1:80 max_fails=3 fail_timeout=5s;
      }
   server {
         listen     80;
         proxy_pass rancher_web;
      }


   upstream rancher_web_https {
         least_conn;
         server master1:443 max_fails=3 fail_timeout=5s;
         server master1:443 max_fails=3 fail_timeout=5s;
         server master1:443 max_fails=3 fail_timeout=5s;
      }
   server {
         listen     443;
         proxy_pass rancher_web_https;
      }

}

EOF


systemctl status nginx


```
