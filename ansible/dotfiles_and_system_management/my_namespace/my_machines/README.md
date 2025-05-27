
## How To



```shell
python3 -m venv $HOME/ansible_virtual_env

source $HOME/ansible_virtual_env/bin/activate

pip install ansible


git clone https://github.com/muratcabuk/murat-dotfiles.git $HOME

cd $HOME/murat-dotfiles

ansible-galaxy collection build --force

ansible-galaxy collection install my_namespace-my_machines-1.0.0.tar.gz --force

cd /home/vagrant/.ansible/collections/ansible_collections/my_namespace/my_machines/

ansible-playbook -i inventory.yml my_machine_playbook.yml  --limit ubuntu_hosts -e "target_distribution=Ubuntu"

```