# Setup Cluster Kubernetes
Provisionamento de cluster Kubernetes vanilla em VMs Azure

## Setup para a VM e serviço do Jenkins
- Criar um "app regristration" (https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#app-registration-app-objects-and-service-principals) e obtenção de subscription_id, tenant_id, client_id and client_secret. 
- Criar um nsg com regras de entrada apropriadas para seu IP público ou acesso público.
- Criar uma vnet com endereçamento de rede 192.168.0.0/16.
- Criar uma subnet na vnet acima com endereçamento 192.168.1.0/24.
- Criar uma vm pro jenkins (1 vcpu, 3,5GB de RAM and a public IP is enough) na subnet acima.
- Instalar docker, git e jenkins na vm.
- Instalar os plugins no Jenkins: Credentials, Docker, Docker Pipeline, Git, Pipeline
- Criar as credenciais no Jenkins conforme esta [imagem](images/Credenciais_Jenkins.png). 
  > Cole a saída do comando **"cat id_rsa | base64 -w0"** na credencial "azure_nodes_admin_ssh_privkey".

## Criação do Pipeline
No dashboard do Jenkins crie um job do tipo Pipeline, nele informe um parâmetro para cada variável existente no Jenkinsfile, na aba <i>Pipeline</i> informe o repositório https://github.com/diegomacielp/k8s-azure.git na branch main e em <i>Script Path</i> o arquivo Jenkinsfile.

## Provisionamento das VMs
Para provisionamento das VMs, o jenkins utiliza um agente Docker para crair um container da imagem 'hashicorp/terraform:0.12.26'. Em execução, o container inicializa o terraform no diretório terraform/ e cria todas as variáveis de ambiente com base nos valores passados anteriormente, concluindo essa etapa, o container faz login na azure e cria 4 VMs.

<img src="https://github.com/diegomacielp/k8s-azure/blob/main/images/VMs.png">

