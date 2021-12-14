pipeline {
    agent any
    environment {
        JENKINS_ID = sh(returnStdout: true, script: 'id jenkins -u').trim()
        JENKINS_GID = sh(returnStdout: true, script: 'id jenkins -g').trim()
        AZURE_SUBSCRIPTION_ID = "${param_azure_subscription_id}"
        AZURE_TENANT_ID = "${param_azure_tenant_id}"
        AZURE_CLIENT_ID = "${param_azure_client_id}"
        AZURE_CLIENT_SECRET = credentials('azure_client_secret')
        AZURE_NODES_ADMIN_SSH_PUBKEY = credentials('azure_nodes_admin_ssh_pubkey')
        AZURE_NODES_ADMIN_SSH_PRIVKEY = credentials('azure_nodes_admin_ssh_privkey')
        TERRAFORM_STATE_DIR = "${param_terraform_state_dir}"
        TERRAFORM_VM_REGION = "${param_terraform_vm_region}"
        TERRAFORM_VM_RG_NAME = "${param_terraform_vm_rg_name}"
        TERRAFORM_VM_VNET_NAME = "${param_terraform_vm_vnet_name}"
        TERRAFORM_VM_SUBNET_NAME = "${param_terraform_vm_subnet_name}"
        TERRAFORM_VM_ENVIRONMENT = "K8S Setup"
        TERRAFORM_VM_COUNT = 3
        TERRAFORM_BASE_NAME = "k8s-setup"
        TERRAFORM_VM_PROFILE_USER = "k8s"
        TERRAFORM_VM_IP_BASE = "192.168.1.4"
        TERRAFORM_VM_SIZE = "Standard_B4ms"
        TERRAFORM_VM_ENVIRONMENT_TAG = "K8S Setup"
        TERRAFORM_VM_IMAGE_PUBLISHER = "OpenLogic"
        TERRAFORM_VM_IMAGE_OFFER = "CentOS"
        TERRAFORM_VM_IMAGE_SKU = "7_9"
        TERRAFORM_VM_IMAGE_VERSION = "latest"
        TERRAFORM_VM_DISK_CACHING = "ReadWrite"
        TERRAFORM_VM_DISK_CREATE_OPTION = "FromImage"
        TERRAFORM_VM_DISK_MANAGED_DISK_TYPE = "Standard_LRS"
        TERRAFORM_VM_MANAGED_DISK_STORAGE_ACCOUNT_TYPE = "Standard_LRS"
        TERRAFORM_VM_MANAGED_DISK_CREATE_OPTION = "Empty"
        TERRAFORM_VM_MANAGED_DISK_SIZE = 50
        TERRAFORM_VM_MANAGED_DISK_LUN_BASE = 1
        KUBESPRAY_VERSION = 'v2.15.0'
        K8S_CNI = 'flannel'
        K8S_VERSION = "${param_k8s_version}"
        K8S_METRICS_SERVER_ENABLED = 'true'
	K8S_DASHBOARD_VERSION = 'v2.3.1'   

    }
    stages {
        stage('Provisionando_VMs') {
            agent {
                docker { 
                    image 'hashicorp/terraform:0.12.26'
                    args '-i --network host -v "$TERRAFORM_STATE_DIR":/backend --entrypoint='
                }
            }
            steps {
                dir(path: 'terraform/') { 
                    sh 'terraform init' 
                    sh 'terraform plan -var-file terraform.tfvars \
                        -var "azure_subscription_id=$AZURE_SUBSCRIPTION_ID" \
                        -var "azure_tenant_id=$AZURE_TENANT_ID" \
                        -var "azure_client_id=$AZURE_CLIENT_ID" \
                        -var "azure_client_secret=$AZURE_CLIENT_SECRET" \
                        -var "azure_nodes_admin_ssh_pubkey=$AZURE_NODES_ADMIN_SSH_PUBKEY" \
                        -var "vm_region=$TERRAFORM_VM_REGION" \
                        -var "vm_rg_name=$TERRAFORM_VM_RG_NAME" \
                        -var "vm_vnet_name=$TERRAFORM_VM_VNET_NAME" \
                        -var "vm_subnet_name=$TERRAFORM_VM_SUBNET_NAME" \
                        -var "vm_environment=$TERRAFORM_VM_ENVIRONMENT" \
                        -var "vm_count=$TERRAFORM_VM_COUNT" \
                        -var "base_name=$TERRAFORM_BASE_NAME" \
                        -var "vm_profile_user=$TERRAFORM_VM_PROFILE_USER" \
                        -var "vm_ip_base=$TERRAFORM_VM_IP_BASE" \
                        -var "vm_size=$TERRAFORM_VM_SIZE" \
                        -var "vm_environment_tag=$TERRAFORM_VM_ENVIRONMENT_TAG" \
                        -var "vm_image_publisher=$TERRAFORM_VM_IMAGE_PUBLISHER" \
                        -var "vm_image_offer=$TERRAFORM_VM_IMAGE_OFFER" \
                        -var "vm_image_sku=$TERRAFORM_VM_IMAGE_SKU" \
                        -var "vm_image_version=$TERRAFORM_VM_IMAGE_VERSION" \
                        -var "vm_disk_caching=$TERRAFORM_VM_DISK_CACHING" \
                        -var "vm_disk_create_option=$TERRAFORM_VM_DISK_CREATE_OPTION" \
                        -var "vm_disk_managed_disk_type=$TERRAFORM_VM_DISK_MANAGED_DISK_TYPE" \
                        -var "vm_managed_disk_storage_account_type=$TERRAFORM_VM_MANAGED_DISK_STORAGE_ACCOUNT_TYPE" \
                        -var "vm_managed_disk_create_option=$TERRAFORM_VM_MANAGED_DISK_CREATE_OPTION" \
                        -var "vm_managed_disk_size=$TERRAFORM_VM_MANAGED_DISK_SIZE" \
                        -var "vm_managed_disk_lun_base=$TERRAFORM_VM_MANAGED_DISK_LUN_BASE"'
                    
                    sh 'terraform apply -auto-approve -var-file terraform.tfvars \
                        -var "azure_subscription_id=$AZURE_SUBSCRIPTION_ID" \
                        -var "azure_tenant_id=$AZURE_TENANT_ID" \
                        -var "azure_client_id=$AZURE_CLIENT_ID" \
                        -var "azure_client_secret=$AZURE_CLIENT_SECRET" \
                        -var "azure_nodes_admin_ssh_pubkey=$AZURE_NODES_ADMIN_SSH_PUBKEY" \
                        -var "vm_region=$TERRAFORM_VM_REGION" \
                        -var "vm_rg_name=$TERRAFORM_VM_RG_NAME" \
                        -var "vm_vnet_name=$TERRAFORM_VM_VNET_NAME" \
                        -var "vm_subnet_name=$TERRAFORM_VM_SUBNET_NAME" \
                        -var "vm_environment=$TERRAFORM_VM_ENVIRONMENT" \
                        -var "vm_count=$TERRAFORM_VM_COUNT" \
                        -var "base_name=$TERRAFORM_BASE_NAME" \
                        -var "vm_profile_user=$TERRAFORM_VM_PROFILE_USER" \
                        -var "vm_ip_base=$TERRAFORM_VM_IP_BASE" \
                        -var "vm_size=$TERRAFORM_VM_SIZE" \
                        -var "vm_environment_tag=$TERRAFORM_VM_ENVIRONMENT_TAG" \
                        -var "vm_image_publisher=$TERRAFORM_VM_IMAGE_PUBLISHER" \
                        -var "vm_image_offer=$TERRAFORM_VM_IMAGE_OFFER" \
                        -var "vm_image_sku=$TERRAFORM_VM_IMAGE_SKU" \
                        -var "vm_image_version=$TERRAFORM_VM_IMAGE_VERSION" \
                        -var "vm_disk_caching=$TERRAFORM_VM_DISK_CACHING" \
                        -var "vm_disk_create_option=$TERRAFORM_VM_DISK_CREATE_OPTION" \
                        -var "vm_disk_managed_disk_type=$TERRAFORM_VM_DISK_MANAGED_DISK_TYPE" \
                        -var "vm_managed_disk_storage_account_type=$TERRAFORM_VM_MANAGED_DISK_STORAGE_ACCOUNT_TYPE" \
                        -var "vm_managed_disk_create_option=$TERRAFORM_VM_MANAGED_DISK_CREATE_OPTION" \
                        -var "vm_managed_disk_size=$TERRAFORM_VM_MANAGED_DISK_SIZE" \
                        -var "vm_managed_disk_lun_base=$TERRAFORM_VM_MANAGED_DISK_LUN_BASE"'
                }
            }
        }
        stage('Gerando_Imagem_Kubespray') {
            steps {
                dir("${env.WORKSPACE}/kubespray") {
                    sh '[ -d .git ] || git init'
                    sh 'git config http.sslVerify false'
                    checkout([  $class: "GitSCM",
                            branches: [[name: "refs/tags/${KUBESPRAY_VERSION}"]],
                            extensions: [[$class: "CloneOption", shallow: false, depth: 0, reference: ""]],
                            userRemoteConfigs: [[url: "https://github.com/kubespray/kubespray.git"]]
                            ])
                    sh 'sed -e "/ENV LANG=C.UTF-8/d" -e "/^FROM/a ENV LANG=C.UTF-8" -i Dockerfile'
                    sh 'docker build -t ks .'
                }
            }
        }
        stage('Preparando_VMs') {
            agent {
                docker { 
                    image 'ks:latest'
                    args '-i --privileged -u 0:0 --network host --entrypoint='
                }
            } 
            steps {
                dir("${env.WORKSPACE}/kubernetes") {
                    sh 'echo ${AZURE_NODES_ADMIN_SSH_PRIVKEY} | base64 -d > id_rsa'
                    sh 'echo ${AZURE_NODES_ADMIN_SSH_PUBKEY} > id_rsa.pub'
                    sh 'chmod 600 id_rsa* && chown ${JENKINS_ID}:${JENKINS_GID} id_rsa*'
                    sh 'export ANSIBLE_HOST_KEY_CHECKING=False ; ansible-playbook -i inventory.ini --user=${TERRAFORM_VM_PROFILE_USER} \
			--become --become-user=root --private-key=id_rsa nodes_bootstrap.yml'
                }
            }
        }
        stage('Configurando_Cluster_Kubernetes') {
            agent {
                docker { 
                    image 'ks:latest'
                    args '-i --privileged -u 0:0 --network host --entrypoint='
                }
            }	    
            steps {
                dir("${env.WORKSPACE}/kubernetes") {
		    sh 'for (( i=${TERRAFORM_VM_COUNT}-1; i>0; i-- )) do sed -e "1s/^/k8s-worker${i} ansible_ssh_host=${TERRAFORM_VM_IP_BASE}${i} ip=${TERRAFORM_VM_IP_BASE}${i}\n/" -e "/^.kube-node.$/a k8s-worker${i}" -i inventory.ini ; done'
                    sh 'sed -e "1s/^/k8s-master1 ansible_ssh_host=${TERRAFORM_VM_IP_BASE}0 ip=${TERRAFORM_VM_IP_BASE}0\n/" -i inventory.ini'
                    sh 'export ANSIBLE_HOST_KEY_CHECKING=False ; ansible-playbook -i inventory.ini --user=${TERRAFORM_VM_PROFILE_USER} --become --become-user=root \
                        --private-key=id_rsa --extra-var kube_network_plugin=$K8S_CNI --extra-var kube_version=$K8S_VERSION \
                        --extra-var metrics_server_enabled=$K8S_METRICS_SERVER_ENABLED /kubespray/cluster.yml' 
                    sh 'rm -f admin.conf || true'
                    sh 'export ANSIBLE_HOST_KEY_CHECKING=False ; ansible -i inventory.ini --user=${TERRAFORM_VM_PROFILE_USER} --become --become-user=root \
			--private-key=id_rsa -m fetch -a "src=/etc/kubernetes/admin.conf dest=./ flat=yes" \
                        $(cat inventory.ini |grep -v "^$" | fgrep "[kube-master]" -A1 | tail -1)'
                    sh 'chown ${JENKINS_ID}:${JENKINS_GID} admin.conf'
                    sh 'chmod 600 admin.conf'		
                }
            }
        }
	stage('Configurando_ingress_controller') {
	    agent {
                docker { 
                    image 'dtzar/helm-kubectl'
                    args '-i --privileged -u 0:0 --network host --entrypoint='
                }
            }
	    environment { 
                KUBECONFIG = "${env.WORKSPACE}/kubernetes/admin.conf"
	    }
	    steps {
	        dir("${env.WORKSPACE}/kubernetes") {
		    sh 'helm repo add haproxy-ingress https://haproxy-ingress.github.io/charts'
		    sh 'helm repo update'
		    sh 'helm install --create-namespace --namespace=haproxy-ingress haproxy-ingress haproxy-ingress/haproxy-ingress \
                       --set controller.kind=DaemonSet \
                       --set controller.hostNetwork=True \
                       --version "0.12"'
		}
	    }	
	}
	stage('Configurando_dashboard') {
	    agent {
                docker { 
                    image "dtzar/helm-kubectl"
                    args "-i --privileged -u 0:0 --network host --entrypoint="
                }
            }
	    environment { 
                KUBECONFIG = "${env.WORKSPACE}/kubernetes/admin.conf"
            }
	    steps {
                dir("${env.WORKSPACE}/kubernetes") {
                    sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${K8S_DASHBOARD_VERSION}/aio/deploy/recommended.yaml'
                }
            }
	}
    }
}
