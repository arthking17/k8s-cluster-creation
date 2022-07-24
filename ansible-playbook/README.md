# My-Playbook ✅

Automation with Ansible Playbook 🛠️⚙️💡

## Getting started

- [ ] install ansible

```shell
sudo apt-get install -y ansible
```

- [ ] Install collection kubernetes.core from Ansible Galaxy

```shell
ansible-galaxy collection install kubernetes.core
```

- [ ] share ssh-key to all hosts to configure

```shell
ssh-keygen #on all host where you want to connect via ssh
ssh-copy-id username@ip-addr #ip-addr of host where you generate ssh key
```

- [ ] add a host's SSH Fingerprint to your know_hosts

```shell
ssh-keyscan -H HOST_IP >> ~/.ssh/known_hosts
```

- [ ] And you are now able to connect to those hosts, try the command below to test the connection

```shell
ansible -m ping -i inventory all
```

- [ ] first method by creating encrypting variable and store the encrypt var in your project 🔐

```shell
ansible-vault encrypt_string 'sudo_password_val' --ask-vault-pass  --name 'sudo_password'
ansible-vault encrypt_string 'host_password_val' --ask-vault-pass  --name 'host_password'
```

- [ ] second method by creating a vault file to store all sensible information 🔒
- cmd to create a vault file

```shell
ansible-vault create group_vars/all/vault
```

- cmd to edit your vault file

```shell
ansible-vault edit group_vars/all/vault
```

- [ ] How to decrypt a String 🔓, press the command `ansible-vault decrypt`
    > enter the string to decrypt there!
    > then press *enter* and *ctrl+D*

- [ ] Run a playbook
- directly enter the vault pwd in terminal when using this cmd

```shell
ansible-playbook -i inventory site.yml --ask-vault-password
```

- with this cmd you have to create a file ( exple .passwd.py ) who will content your vault password

```shell
echo 'vault_password' > .passwd.py
chmod 600 .passwd.py
echo ".passwd.py" >> .gitignore
ansible-playbook -i inventory site.yml --vault-password-file .passwd.py
```

don't forget to add vault password file to .gitignore

- create a var ANSIBLE_VAULT_PASS of type file and masked in "gitlab-ci variable section" to store your ansible vault password

```shell
ansible-playbook -i inventory site.yml --vault-password-file $ANSIBLE_VAULT_PASS
```

## Install and configure an runner host

- [ ] Run the playbook📖

```shell
ansible-playbook -i inventory site_runner.yml --vault-password-file .passwd.py
```

## Install and configure an kubernetes Cluster

- [ ] copy your ssh-key to the host to configure 🔑

```shell
for i in $(seq 3); do sshpass -f .hostpasswd.py -d $i ssh-copy-id vagrant@192.168.130.17$i -f ; done
```

- [ ] Run the playbook

```shell
ansible-playbook -i inventory site_staging.yml --vault-password-file .passwd.py
```

- [ ] In Gitlab-ci script

```shell
echo "execution of the ansible playbook 🔥"
git clone -b dev https://${GITLAB_USERNAME}:${TOKEN_RUNNER_IRIS_T24}@gitlab.com/i3017/ansible-playbook.git
cd ansible-playbook/ && ansible-playbook -i inventory site_staging.yml --vault-id $ANSIBLE_VAULT_PASS
```

### Generate token to access Kubernetes Dashboard🗝️

```shell
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" 
```

### Allow Kubernetes services ports on master node (Azure)

*port_range*: 30000-32767
*rule_name*: kubernetes_services_port

### Setup a kubernetes cluster with custom *apiserver advertise address* (default = 10.0.0.5)

```shell
ansible-playbook -i inventory site_cluster.yml --vault-password-file .passwd.py --extra-vars "apiserver_advertise_address=192.168.56.171"
```

### Update CI/CD var *inventory* type file with correct ip_address of servers before running the pipeline

### solve issue with gpg key of package repo (*temporary solution*)

- [ ] delete files in /etc/apt/sources.list.d
- [ ] delete /etc/apt/trusted.gpg

### Debug ansible

- [ ] add this task to get the info about hosts in a file ansible_facts.yml
- name: debug gather_facts
  copy:
    content: "{{ansible_facts}}"
    dest: ansible_facts.yml

### Setup ssh key

- [ ]  add public key and set right right for id_rsa.pub file

```shell
chmod 644 /azure/.ssh/id_rsa.pub
```

- [ ]  add private key and set right right for id_rsa file

```shell
chmod 600 /azure/.ssh/id_rsa
```

- [ ] connect to server using his private ssh-key

```shell
ssh -i /azure/.ssh/id_rsa william@HOST_IP
```

> ansible module for kubernetes is *community.kubernetes* for later version of ansible and the new one is *kubernetes.core.k8s*

```shell
ansible-galaxy collection install community.kubernetes
```

> List the versions available in your repo 
```
apt-cache madison docker-ce
```
- [ ] Install a specific version using the version string from the second column, for example, 5:20.10.16~3-0~ubuntu-jammy
```
sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io docker-compose-plugin
```

- [ ] prometheus-grafana default login
- username: ***admin***
- password: ***prom-operator***
