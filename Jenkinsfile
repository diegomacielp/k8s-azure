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
        TERRAFORM_VM_ENVIRONMENT = "PJe Lab"
        TERRAFORM_VM_COUNT = 4
        TERRAFORM_BASE_NAME = "pjelab"
        TERRAFORM_VM_PROFILE_USER = "pje"
        TERRAFORM_VM_IP_BASE = "192.168.1.4"
        TERRAFORM_VM_SIZE = "Standard_B4ms"
        TERRAFORM_VM_ENVIRONMENT_TAG = "PJe Lab"
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
        TERRAFORM_VM_MANAGED_DISK_LUN_BASE = 10
        CSJT_CLUSTER_VER = "${param_csjt_cluster_ver}"
        K8S_CNI = 'flannel'
        K8S_VERSION = "${param_k8s_version}"
        K8S_METRICS_SERVER_ENABLED = 'true'

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
                dir(path: 'infra/terraform/') { 
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
                dir("${env.WORKSPACE}/infra") {
                    sh 'mkdir cluster || true'
                    dir("${env.WORKSPACE}/infra/cluster") {
                        sh '[ -d .git ] || git init'
                        sh 'git config http.sslVerify false'
                        checkout([  $class: "GitSCM",
                                    branches: [[name: "refs/tags/${CSJT_CLUSTER_VER}"]],
                                    extensions: [[$class: "CloneOption", shallow: false, depth: 0, reference: ""]],
                                    userRemoteConfigs: [[credentialsId: "gitcsjt", url: "https://git.pje.csjt.jus.br/infra/cluster.git"]]
                                ])
			sh 'sed -e "/ENV LANG=C.UTF-8/d" -e "/^FROM/a ENV LANG=C.UTF-8" -i kubespray/Dockerfile'
                        sh 'docker build -t ks kubespray'
                    }
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
                dir("${env.WORKSPACE}/infra/kubernetes") {
                    sh 'echo ${AZURE_NODES_ADMIN_SSH_PRIVKEY} | base64 -d > id_rsa'
                    sh 'echo ${AZURE_NODES_ADMIN_SSH_PUBKEY} > id_rsa.pub'
                    sh 'chmod 600 id_rsa* && chown ${JENKINS_ID}:${JENKINS_GID} id_rsa*'
                    sh 'export ANSIBLE_HOST_KEY_CHECKING=False ; ansible-playbook -i inventory.ini --user=${TERRAFORM_VM_PROFILE_USER} --become --become-user=root --private-key=id_rsa nodes_bootstrap.yml'
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
                dir("${env.WORKSPACE}/infra/kubernetes") {
                    //sh 'export ANSIBLE_HOST_KEY_CHECKING=False ; ansible-playbook -i inventory.ini --user=${TERRAFORM_VM_PROFILE_USER} --become --become-user=root \
                    //    --private-key=id_rsa --extra-var reset_confirmation=yes /kubespray/reset.yml'
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
        
        stage('Configurando_Node_Labels') {
            agent {
                docker { 
                    image 'dtzar/helm-kubectl'
                    args '-e KUBECONFIG=admin.conf -i --network host --entrypoint='
                }
            }
            steps {
                dir("${env.WORKSPACE}/infra/kubernetes") { 
                    sh 'kubectl get no -oname | grep infra | while read node ; do kubectl label $node infra=true --overwrite ; done'
                    sh 'kubectl get no -oname | grep worker | while read node ; do kubectl label $node pje=true --overwrite ; done'
                }
            }
        }

        stage('Configurando_acesso_registry.pje.redejt') {
            agent {
                docker { 
                    image 'ks:latest'
                    args '-i --privileged -u 0:0 --network host --entrypoint='
                }
            }	    
            steps {
                dir("${env.WORKSPACE}/infra/kubernetes") {
                    sh 'export ANSIBLE_HOST_KEY_CHECKING=False ; ansible-playbook -i inventory.ini --user=${TERRAFORM_VM_PROFILE_USER} --become --become-user=root \
                        --private-key=id_rsa registry_pje.yml'
                }
            }
        }
        stage('Clonando_repositorio_csjt_infra_cluster') {
            agent {
                docker { 
                    image "dtzar/helm-kubectl"
                    args "-i --network host --entrypoint="
                }
            }
            steps {
                dir("${env.WORKSPACE}/infra") {
                    sh 'mkdir cluster || true'
                    dir("${env.WORKSPACE}/infra/cluster") {
                        sh '[ -d .git ] || git init'
                        sh 'git config http.sslVerify false'
                        checkout([  $class: "GitSCM",
                                    branches: [[name: "refs/tags/${CSJT_CLUSTER_VER}"]],
                                    extensions: [[$class: "CloneOption", shallow: false, depth: 0, reference: ""]],
                                    userRemoteConfigs: [[credentialsId: "gitcsjt", url: "https://git.pje.csjt.jus.br/infra/cluster.git"]]
                                ])
                    }
                }
            }
        }
/*
        stage('Configurando_MetallLB') {
            agent {
                docker { 
                    image 'dtzar/helm-kubectl'
                    args '--privileged -u 0:0 -e KUBECONFIG=admin.conf -i --network host --entrypoint='
                }
            }
            environment { 
                KUBECONFIG = "${env.WORKSPACE}/infra/kubernetes/admin.conf"
            }
            steps {
                sh 'kubectl create namespace metallb-system --dry-run -o yaml | kubectl apply -f -'
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/metallb") {
                    sh 'sed -e "s/trtXX/pjelab/" -e "s|10.XX.1.210-10.XX.1.218|192.168.254.121-192.168.254.123|' -i metallb-config.yaml'
                    sh 'apk add openssl'
                    sh 'kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"'
                    sh 'kubectl apply -f .'
                    sh 'while [ `kubectl -n metallb-system get po | grep -E "controller|speaker" | grep -v Running | wc -l` -gt 0 ] ; do echo "Esperando Pods metallb estarem Ok" ; sleep 5 ; done'
                }
            }
        }
 */       
        stage('Configurando_ingress_controller') {
            agent {
                docker { 
                    image "dtzar/helm-kubectl"
                    args "-i --network host --entrypoint="
                }
            }
            environment { 
                KUBECONFIG = "${env.WORKSPACE}/infra/kubernetes/admin.conf"
            }
            steps {
                sh 'kubectl create namespace ingress-controller --dry-run -o yaml | kubectl apply -f -'
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/haproxy-ingress") {
                    sh 'sed -e "/^#/d" -e "/loadBalancerIP/d" -i haproxy-services-interno.yaml'
                    sh 'sed -e "s/type: LoadBalancer/type: NodePort/" -i haproxy-services-interno.yaml'
                    sh 'sed -e "/targetPort: 80/a __nodePort: 30080" -i haproxy-services-interno.yaml'
                    sh 'sed -e "/targetPort: 443/a __nodePort: 30443" -i haproxy-services-interno.yaml'
                    sh 'sed -e "/targetPort: 9101/a __nodePort: 30101" -i haproxy-services-interno.yaml'
                    sh 'sed -e "s/__node/    node/" -i haproxy-services-interno.yaml'
                    //
                    sh 'sed -e "/^#/d" -e "/loadBalancerIP/d" -i haproxy-services-externo.yaml'
                    sh 'sed -e "s/type: LoadBalancer/type: NodePort/" -i haproxy-services-externo.yaml'
                    sh 'sed -e "/targetPort: 80/a __nodePort: 31080" -i haproxy-services-externo.yaml'
                    sh 'sed -e "/targetPort: 443/a __nodePort: 31443" -i haproxy-services-externo.yaml'
                    sh 'sed -e "/targetPort: 9101/a __nodePort: 31101" -i haproxy-services-externo.yaml'
                    sh 'sed -e "s/__node/    node/" -i haproxy-services-externo.yaml'
                    //
                    sh 'sed -e "/^#/d" -e "/loadBalancerIP/d" -i haproxy-services-redejt.yaml'
                    sh 'sed -e "s/type: LoadBalancer/type: NodePort/" -i haproxy-services-redejt.yaml'
                    sh 'sed -e "/targetPort: 80/a __nodePort: 32080" -i haproxy-services-redejt.yaml'
                    sh 'sed -e "/targetPort: 443/a __nodePort: 32443" -i haproxy-services-redejt.yaml'
                    sh 'sed -e "/targetPort: 9101/a __nodePort: 32101" -i haproxy-services-redejt.yaml'
                    sh 'sed -e "s/__node/    node/" -i haproxy-services-redejt.yaml'                            
                    sh 'cat haproxy-services-*.yaml'
                    // 
                    sh 'sed "s|10.[Xx].0.0/16|192.168.1.0/24|g" -i haproxy-config.yaml'
                    sh 'kubectl apply -f .'
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
                KUBECONFIG = "${env.WORKSPACE}/infra/kubernetes/admin.conf"
            }
            steps {
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/dashboard") {
                    sh 'sed -e "s/::.*$/::pjelabdash/" -i auth'
                    sh 'cp ../../../kubernetes/kubedash-install.exp install.exp'
                    sh 'sed -e "s/dashboard.pjelab.jus.br/dash.pjelab.jus.br/" -i install.exp'
                    sh 'apk add expect'
                    sh 'expect -f ./install.exp'
                    sh 'rm -f install.exp'
                }
            }
        }
        stage('Configurando_logging') {
            agent {
                docker { 
                    image "dtzar/helm-kubectl"
                    args "-i --privileged -u 0:0 --network host --entrypoint="
                }
            }
            environment { 
                KUBECONFIG = "${env.WORKSPACE}/infra/kubernetes/admin.conf"
                INVENTORY = "${env.WORKSPACE}/infra/kubernetes/inventory.ini"
            }
            steps {
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/elasticsearch/scripts") {
                    sh 'apk add openssl'
                    sh 'kubectl delete namespace logging || true ; kubectl create namespace logging'
                    sh 'kubectl delete pv/pv-es-data-0 pv/pv-es-data-1 pv/pv-es-data-2 || true'
                    sh './01-criar-ca-e-instance-certs.sh "C=BR/ST=SC/L=Florianopolis/O=PJELAB/OU=SD"'
                    sh './02-criar-secret-com-certificados.sh'
                    sh 'chown -R ${JENKINS_ID}:${JENKINS_GID} .'
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/elasticsearch/storage") {
                    sh 'cp -fp pv-es-data.yaml.nfs pv-es-data.yaml'
                    sh 'IP_NFS=$(egrep "^[^#].*master.?1.*ip=" $INVENTORY | cut -d= -f3) ; \
                        sed -e "s/server:.*$/server: ${IP_NFS}/" -e "s|/volume/elasticsearch/data|/var/lib/docker/nfsdata/esdata|" -i pv-es-data.yaml'
                    sh 'kubectl apply -f pv-es-data.yaml'
                    sh 'kubectl apply -f pvc-es-data.yaml'
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/elasticsearch") {
                    sh 'IP_NFS=$(egrep "^[^#].*master.?1.*ip=" $INVENTORY | cut -d= -f3) ; \
                        sed -e "s/server:.*$/server: ${IP_NFS}/" \
                            -e "s|/volume/elasticsearch/data|/var/lib/docker/nfsdata/esdata|" \
                            -e "s|/volume/elasticsearch/backup|/var/lib/docker/nfsdata/esbackup|" \
                            -e "s|memory: 800Mi|memory: 300Mi|" \
                            -e "s|memory: 1200Mi|memory: 800Mi|" \
                            -i es-master-statefulset.yaml ; \
                        sed -e "s/server:.*$/server: ${IP_NFS}/" \
                            -e "s|/volume/elasticsearch/backup|/var/lib/docker/nfsdata/esbackup|" \
                            -e "s|memory: 12Gi|memory: 1Gi|" \
                            -e "s|memory: 14Gi|memory: 2Gi|" \
                            -e "s|10g|1g|g" \
                            -i es-data-statefulset.yaml ; \
                        sed -e "s|maxReplicas: 8|maxReplicas: 2|" -i es-client-hpa.yaml'
                    sh 'kubectl apply -f .'               
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/elasticsearch/scripts") {
                    sh 'while [ `kubectl -n logging get po | grep es-client | grep Running | wc -l` -lt 2 ] ; do echo "Esperando Pods es-client estarem Ok" ; sleep 5 ; done'
                    sh 'apk add openssl'
                    sh 'echo > output-passwords-default-es-users.txt'
                    sh 'while [ `cat output-passwords-default-es-users.txt | wc -l` -lt 2 ] ; do kubectl -n logging get po ; ./03-gerar-senhas.sh ; done'
                    sh './04-gerar-secrets.sh'
                    sh 'chown -R ${JENKINS_ID}:${JENKINS_GID} .'
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/elasticsearch") {
                    sh '''
                        cat es_exporter.template >> es-client-deployment.yaml ;
                        cat es_exporter.template >> es-master-statefulset.yaml ;
                        cat es_exporter.template >> es-data-statefulset.yaml
                       '''
                    sh 'kubectl apply -f .'                  
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/elasticsearch/scripts") {
                    sh 'apk add openssl'
                    sh 'while [ `kubectl -n logging get po --no-headers | grep -v Running | wc -l` -gt 0 ] ; do echo "Esperando Pods estarem Ok" ; sleep 5 ; done'
                    sh 'while [ `./05-gerar-repo-snapshot.sh 2>&1 | grep acknowledged | grep -i true | wc -l` -lt 1 ] ; do sleep 30 ; kubectl -n logging get po ; echo "Falha! Reexecutando script!" ; done'
                    sh 'while [ `./06-gerar-policy-snapshot.sh 2>&1 | grep acknowledged | grep -i true | wc -l` -lt 1 ] ; do sleep 30 ; kubectl -n logging get po ; echo "Falha! Reexecutando script!" ; done'
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/kibana") {
                    sh 'sed -e "s|trtXX.redejt|pjelab.jus.br|" -i kibana-ingress.yaml'
                    sh 'kubectl apply -f .'                  
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/kibana/templates") {
                    sh './01-criar-template-web.sh'                  
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/kibana/dashboards") {
                    sh 'while [ `./import-dashboard.sh 01-PJeJBoss.ndjson 2>&1 | grep -E  "(success.{3}true|PJeJBoss)" | wc -l` -lt 1 ] ; do sleep 30 ; kubectl -n logging get po ; echo "$(date -R) - Falha! Reexecutando script!" ; done'
                    sh 'while [ `./import-dashboard.sh 02-K8sLogs.ndjson 2>&1 | grep -E  "(success.{3}true|K8sLogs)" | wc -l` -lt 1 ] ; do sleep 30 ; kubectl -n logging get po ; echo "$(date -R) - Falha! Reexecutando script!" ; done'
                    sh 'while [ `./import-dashboard.sh 03-JBossAccess.ndjson 2>&1 | grep -E  "(success.{3}true|JBossAccess)" | wc -l` -lt 1 ] ; do sleep 30 ; kubectl -n logging get po ; echo "$(date -R) - Falha! Reexecutando script!" ; done'
                    sh 'while [ `./import-dashboard.sh 04-HAProxyAccess.ndjson 2>&1 | grep -E  "(success.{3}true|HAProxyAccess)" | wc -l` -lt 1 ] ; do sleep 30 ; kubectl -n logging get po ; echo "$(date -R) - Falha! Reexecutando script!" ; done'
                    sh 'while [ `./import-dashboard.sh 05-HAProxyAccess-ComparacaoHistorica.ndjson 2>&1 | grep -E  "(success.{3}true|HAProxyAccess)" | wc -l` -lt 1 ] ; do sleep 30 ; kubectl -n logging get po ; echo "$(date -R) - Falha! Reexecutando script!" ; done'
                    sh 'while [ `./import-dashboard.sh Opcional-01-Postgres.ndjson 2>&1 | grep -E  "(success.{3}true|Postgres)" | wc -l` -lt 1 ] ; do sleep 30 ; kubectl -n logging get po ; echo "$(date -R) - Falha! Reexecutando script!" ; done'
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/fluentd/user") {
                    sh './01-criar-fluentd-user.sh'                  
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/fluentd") {
                    sh 'sed -e "s|replicas: 3|replicas: 1|" \
                            -e "s|memory: 2Gi|memory: 500Mi|" \
                            -e "s|memory: 3Gi|memory: 1Gi|" \
                            -i fluentd-es-deployment.yaml'
                    sh 'kubectl apply -f .'                
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/curator") {
                    sh 'kubectl apply -f .'                
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/logstash/user") {
                    sh './01-criar-user.sh'                
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/logstash") {
                    sh 'kubectl apply -f .'                
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/apm/user") {
                    sh './01-criar-user.sh'                
                }
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/logging/apm") {
                    sh 'kubectl apply -f .'                
                }
            }
        }
        stage('Configurando_monitoring') {
            agent {
                docker { 
                    image "dtzar/helm-kubectl"
                    args "-i --privileged -u 0:0 --network host --entrypoint="
                }
            }
            environment { 
                KUBECONFIG = "${env.WORKSPACE}/infra/kubernetes/admin.conf"
                INVENTORY = "${env.WORKSPACE}/infra/kubernetes/inventory.ini"
            }
            steps {
                dir("${env.WORKSPACE}/infra/cluster/kubernetes/monitoring") {
                    sh 'kubectl delete namespace monitoring || true'
                    // O namespace monitoring e criado por yaml na pasta 0-setup 
                    sh 'IP_NFS=$(egrep "^[^#].*master.?1.*ip=" $INVENTORY | cut -d= -f3) ; \
                        sed -e "s/server:.*$/server: ${IP_NFS}/" -e "s|/monitoring/prometheus|/var/lib/docker/nfsdata/prometheus|" -i 1-prometheus-operator/pv-prometheus.yaml ; \
                        sed -e "s/server:.*$/server: ${IP_NFS}/" -e "s|/monitoring/grafana|/var/lib/docker/nfsdata/grafana|" -i 5-deploy/grafana-deployment.yaml ; \
                        sed -e "s/memory: 9Gi/memory: 1Gi/" -e "s/memory: 12Gi/memory: 2Gi/" -e "s/cpu: 2000m/cpu: 500m/" -i 5-deploy/prometheus-prometheus.yaml ; \
                        sed -e "s|trtXX.redejt|pjelab.jus.br|" -i 5-deploy/ingress.yaml'
                    sh 'kubectl apply -f 0-setup'
                    sh 'kubectl apply -f 1-prometheus-operator'
                    sh 'until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done'
                    sh 'kubectl apply -f 2-roles-cm'
                    sh 'kubectl apply -f 3-serviceMonitorCluster'
                    sh 'kubectl apply -f 5-deploy'
                }
            }
        }
    } 
}
