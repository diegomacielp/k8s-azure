# k8s-azure
Provisionamento de cluster Kubernetes vanilla em VMs Azure

Setup para a VM Jenkins
- Criar um "app regristration" (https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#app-registration-app-objects-and-service-principals) e and get subscription_id, tenant_id, client_id and client_secret. 
- Criar um nsg com regras de entrada apropriadas para seu IP público ou acesso público.
- Criar uma vnet com endereçamento de rede 192.168.0.0/16.
- Criar uma subnet na vnet acima com endereçamento 192.168.1.0/24.
- Criar uma vm pro jenkins (1 vcpu, 3,5GB de RAM and a public IP is enough) na subnet acima.
- Instalar docker, git e jenkins na vm.
- Instalar os plugins no Jenkins: Credentials
- Criar as credenciais no Jenkins conforme nesta [imagem]
  > Cloe a saída ddo comando **"cat id_rsa | base64 -w0"** na credencial "azure_nodes_admin_ssh_privkey".
