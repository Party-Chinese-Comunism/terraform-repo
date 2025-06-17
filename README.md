

# README: Projeto de Infraestrutura Multinuvem com CI/CD - Google Cloud

## Visão Geral

Este projeto tem como objetivo criar e automatizar o deploy de dois ambientes na **Google Cloud Platform (GCP)**: **Produção** e **Homologação (Stage)**. A infraestrutura será provisionada automaticamente usando **Terraform**, e o deploy da aplicação será realizado através de pipelines no **GitHub Actions**. Ambos os ambientes terão monitoramento com **Prometheus** e **Grafana**.

## Estrutura do Projeto

### Infraestrutura a ser Provisionada

1. **Cluster Kubernetes (K8s)** em ambas as contas do GCP:

   * Ambiente de **Produção**
   * Ambiente de **Stage**
2. **Monitoramento com Prometheus + Grafana**:

   * Coleta de métricas essenciais como **CPU**, **Memória** e **Status dos Pods**.
   * Criação de um dashboard básico no **Grafana** para visualizar essas métricas.

### Etapas do Pipeline CI/CD

1. **Provisionamento da infraestrutura** usando **Terraform**.
2. **Configuração do cluster Kubernetes** e instalação do monitoramento com **Prometheus + Grafana**.
3. **Build da aplicação**.
4. **Push da imagem Docker** para o **Google Container Registry (GCR)**.
5. **Deploy automatizado** no cluster Kubernetes.
6. **Aplicação de Manifests e Helm Charts**.
7. **Validação do deploy**.

## Como Usar

### Requisitos

1. **Conta no Google Cloud Platform (GCP)**.
2. **Ferramentas necessárias**:

   * Terraform
   * kubectl
   * Docker
   * Google Cloud SDK (gcloud)
   * GitHub

### Passos para Configuração

1. **Clone o Repositório**:

   Clone o repositório Git que contém os arquivos de configuração e o pipeline:

   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd <DIRETORIO_DO_REPOSITORIO>
   ```

2. **Configure o Google Cloud SDK**:

   Para interagir com a GCP via linha de comando, você deve configurar o **Google Cloud SDK**. Se ainda não o instalou, siga as instruções oficiais [aqui](https://cloud.google.com/sdk/docs/install).

   Após a instalação, execute:

   ```bash
   gcloud init
   ```

   Siga as instruções para configurar o projeto e a conta.

3. **Configure o Terraform para a GCP**:

   No repositório, altere o arquivo `variables.tf` para incluir as credenciais de sua conta do Google Cloud, como `project_id`, `region`, `zone` e `credentials_file`. Exemplo:

   ```hcl
   variable "project_id" {
     description = "ID do projeto GCP"
     default     = "<SEU_PROJECT_ID>"
   }

   variable "region" {
     description = "Região GCP"
     default     = "us-central1"
   }

   variable "zone" {
     description = "Zona GCP"
     default     = "us-central1-a"
   }

   provider "google" {
     project     = var.project_id
     region      = var.region
     zone        = var.zone
     credentials = file("<CAMINHO_PARA_O_ARQUIVO_DE_CREDENCIAIS>.json")
   }
   ```

4. **Inicialize o Terraform e Provisione a Infraestrutura**:

   Execute o Terraform para inicializar o ambiente e criar a infraestrutura (clusters Kubernetes no GKE):

   ```bash
   terraform init
   terraform apply
   ```

   Isso criará o cluster Kubernetes no GKE e configurará a rede, autenticação e os recursos necessários.

5. **Configure o kubectl para acessar o cluster**:

   Após o provisionamento do cluster no GKE, configure o **kubectl** para acessar o cluster:

   ```bash
   gcloud container clusters get-credentials <NOME_DO_CLUSTER> --zone <ZONE> --project <PROJECT_ID>
   ```

## Build e Push da Imagem Docker

A pipeline de **CI/CD** no **GitHub Actions** realiza o processo de build e push da imagem Docker para o repositório configurado (por exemplo, **Docker Hub** ou **Google Container Registry - GCR**).

Com a utilização de **Docker Buildx** e **Docker Login**, a imagem é construída a partir do código fonte e enviada para o repositório de imagens com duas tags: uma com o **commit SHA** e outra com a tag `latest`.

Fluxo da pipeline:

* **Checar** o código a partir do repositório Git.
* **Construir** a imagem Docker.
* **Enviar** a imagem para o repositório com as tags apropriadas.

```bash
docker build -t gcr.io/<PROJECT_ID>/<NOME_DA_IMAGEM>:<TAG> .
docker push gcr.io/<PROJECT_ID>/<NOME_DA_IMAGEM>:<TAG>
```

---

## Configuração do GitHub Actions

A configuração da pipeline **CI/CD** é realizada por meio do **GitHub Actions**, que executa dois jobs principais:

1. **Build e Push**: Constrói a imagem Docker e envia para o repositório de imagens.
2. **Deploy**: Após o build, a aplicação é automaticamente implantada no cluster Kubernetes.

Cada job é independente e configurado para ser executado em uma máquina **Ubuntu**, utilizando variáveis e segredos armazenados no **GitHub Secrets** para garantir a segurança das credenciais.

---

## Deploy Automatizado no Cluster Kubernetes

Após o envio da imagem Docker para o repositório, o pipeline executa automaticamente o **deploy** da aplicação no cluster Kubernetes (GKE). O **kubectl** é utilizado para:

* **Atualizar a imagem** do contêiner no **deployment** Kubernetes.
* **Reiniciar o pod** para garantir que a nova versão da aplicação esteja em execução.

Com isso, as mudanças feitas no código são refletidas automaticamente no ambiente de produção ou homologação.

```bash
kubectl set image deployment/blog-frontend blog-frontend=gcr.io/<PROJECT_ID>/<NOME_DA_IMAGEM>:<TAG>
kubectl rollout restart deployment/blog-frontend
```

---

## Monitoramento com Prometheus e Grafana

A infraestrutura de monitoramento é configurada diretamente no cluster Kubernetes usando **Prometheus** e **Grafana**. O Prometheus coleta métricas detalhadas de **CPU**, **Memória** e **Status dos Pods**, enquanto o Grafana exibe essas métricas em dashboards visualmente acessíveis.

Isso permite que a equipe de operações tenha uma visão clara da performance da aplicação e da infraestrutura, ajudando na tomada de decisões rápidas para eventuais ajustes ou otimizações.

---

## Validação do Deploy

Após o deploy ser concluído, o **GitHub Actions** fornece um status de sucesso ou falha diretamente na interface da plataforma. Além disso, o monitoramento no **Grafana** permite que você valide o estado da aplicação e garanta que tudo esteja funcionando corretamente no ambiente de produção ou homologação.

---

## Descrição dos Ambientes

### Ambiente de Produção

* O **Google Cloud Platform (GCP)** hospeda o ambiente de produção, com um **cluster Kubernetes (GKE)** configurado para alta disponibilidade.
* O monitoramento com **Prometheus** e **Grafana** garante a visibilidade contínua do estado da aplicação e da infraestrutura.

### Ambiente de Homologação (Stage)

* O ambiente de homologação é configurado em um **Google Cloud Project** distinto, com uma infraestrutura similar ao ambiente de produção.
* O monitoramento também está habilitado para permitir a validação do comportamento da aplicação antes de ser promovida à produção.

---

## Observações Adicionais

* A pipeline de **GitHub Actions** automatiza tanto a criação da infraestrutura quanto o deploy da aplicação em ambos os ambientes, garantindo consistência entre os ambientes de desenvolvimento, homologação e produção.
* O **monitoramento** via **Prometheus** e **Grafana** oferece um acompanhamento eficaz dos clusters Kubernetes, permitindo respostas rápidas a qualquer anomalia.

