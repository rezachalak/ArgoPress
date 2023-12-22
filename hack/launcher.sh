#!/bin/bash
set -e

machine_address="192.168.1.1"
ssh_username="user"
ssh_password="Secret"
ssh_port=2233
kubespray_repo="https://github.com/kubernetes-sigs/kubespray.git"
if [ ! -d kubespray ]
then
    git clone $kubespray_repo
    cd kubespray
else
    cd kubespray
    git pull
fi
# sudo pip install -r requirements.txt
cp -rfp inventory/sample inventory/mycluster
cat <<EOF > inventory/mycluster/inventory.ini
[all]
node1 ansible_host=$machine_address ansible_port=$ssh_port ansible_user=$ssh_username ansible_ssh_pass=$ssh_password ansible_sudo_pass=$ssh_password

[kube-master]
node1

[etcd]
node1

[kube-node]
node1

[calico-rr]

[k8s-cluster:children]
kube-master
kube-node
calico-rr
EOF

# Install Kubernetes cluster using Kubespray
ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml -b --become-user=root
ansible node1 -i inventory/mycluster/inventory.ini -m fetch -a "src=/root/.kube/config dest=" -b --become-user=root
mv ./node1/root/.kube/config ../kubeconfig
# Get out of kubespray dir
cd ../terraform/
# Apply the Terraform resources 
terraform init
terraform apply -var 'create_k8s_manifests=false' --auto-approve # The prerequisit of k8s manifesets should be installed first
terraform apply -var 'create_k8s_manifests=true' --auto-approve
