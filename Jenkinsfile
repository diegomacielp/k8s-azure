pipeline {
    agent any
    environment {
        JENKINS_ID = sh(returnStdout: true, script: 'id jenkins -u').trim()
        JENKINS_GID = sh(returnStdout: true, script: 'id jenkins -g').trim()
        AZURE_SUBSCRIPTION_ID = credentials('azure_subscription_id')
        AZURE_TENANT_ID = credentials('azure_tenant_id')
        AZURE_CLIENT_ID = credentials('azure_client_id')
        AZURE_CLIENT_SECRET = credentials('azure_client_secret')
        AZURE_NODES_ADMIN_SSH_PUBKEY = credentials('azure_nodes_admin_ssh_pubkey')
        AZURE_NODES_ADMIN_SSH_PRIVKEY = credentials('azure_nodes_admin_ssh_privkey')
        TERRAFORM_STATE_DIR = '/var/lib/jenkins/terraform-state'
        TERRAFORM_VM_REGION = "East US 2"
        TERRAFORM_VM_RG_NAME = "workshop-trt"
        TERRAFORM_VM_VNET_NAME = "workshop-trt"
        TERRAFORM_VM_SUBNET_NAME = "workshop-trt"
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
        CSJT_CLUSTER_VER = '1.5.3'
        K8S_CNI = 'flannel'
        K8S_VERSION = 'v1.18.10'
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
    }   
