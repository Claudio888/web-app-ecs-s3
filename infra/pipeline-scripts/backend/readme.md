# Build e Deploy Backend

Scripts criados para realizar build e deploy

## Features

- script de build
- script de deploy

## build-image

Exemplo:

```
./build-image --imagename teste --version 1.0.0 --path /api/ --reponame meuecr
```

| Parametro | Obrigatório | Descrição                                       |
|-----------|-------------|-------------------------------------------------|
| imagename | Sim         | Nome da imagem Docker a ser construída          |
| version   | Sim         | Tag que será atribuída à imagem Docker          |
| path      | Sim         | Caminho onde o Dockerfile está localizado       |
| reponame  | Sim         | Nome do repositório no ECR para enviar a imagem |

## deploy-image

| Parametro | Obrigatório | Descrição                                   |
|-----------|-------------|---------------------------------------------|
| t         | Sim         | Timeout da execução, default é 90, dobramos |
| c         | Sim         | Nome do cluster a ser feito deployment      |
| n         | Sim         | Nome do serviço a ser feito o deployment    |
| i         | Sim         | Nome completo da imagem a ser utilizada     |

Exemplo do comando que usaremos 

```
ecs-deploy -t 180 -c production -n clientes-api-service -i 1234567891100.dkr.ecr.us-east-1.amazonaws.com/clientes-api:1.0.1
```
Para mais informações sobre o script acesse [ecs-deploy](https://github.com/silinternational/ecs-deploy)

## Como utilizar os scripts

Ambos scripts foram feitos visando o facil uso e também facil acoplamento. Como possível melhoria de projeto e afins, é possível implementar alguma ferramenta de CI/CD, como por exemplo o Jenkins, o TravisCI, o GithubActions, entre outros. 

Estes scripts de CI/CD aqui criados, são genéricos e são de facil utilização por qualquer outra ferramenta que venha a chama-los. 

O script de build, é criado em bash que visa realizar o build da imagem através do docker e fazer um push para o ecr criado pela infra. 

O script do deploy de ECS é do projeto [ecs-deploy](https://github.com/silinternational/ecs-deploy), por ser um script bem consolidado e que funciona bem, neste projeto optamos por utiliza-lo ao invés de criar um do zero. 

### Fazendo a build 

1 - Transforme o arquivo em executavel

```
chmod +x build-image
```

2 - Execute 

```
./buld-image --imagename clientes --version 1.0.0 --path /web-app/api
```

3 - Sua imagem já deve estar no ECR vamos ao deploy dela como uma task no ecs

### Fazendo a deploy

1 - Transforme o arquivo em executavel

```
chmod +x build-image
```

2 - Execute, considerando os valores que criamos com o terraform e também o nome da imagem gerada anteriormente

```
ecs-deploy -t 180 -c prod -n clientes-api-service -i <id conta aws>.dkr.ecr.<regiao>.amazonaws.com/clientes:1.0.0
```

3 - Verifique os logs, ao terminar a aplicação estará rodando no ecs. 

Caso deseje verificar se a aplicação esta rodando, é possível acessar o recurso de ALB no console, pegar seu valor e bater nele pela internet, deverá retornar o nosso backend. 

Em seguida, para tudo correr bem, vamos fazer o deployment do frontend, siga o link; 

- [Deployment Frontend](/infra/pipeline-scripts/frontend/readme.md)