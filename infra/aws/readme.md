# Terraform


Projeto que provisiona uma infraesturua na AWS e serve uma aplicação frontend pelo S3 e um backend pelo ECS

## Features

- ecs cluster
- alb para o ecs
- bucket s3
- ecr
- cloudfront
- route53

## Como provisionar a infra

### Pré requisitos

Primeiramente certifique-se que possuí o terraform instalado em sua maquina, a versão que foi utilizada pelo construtor do script foi a v1.4.6, caso não tenha instale no [endereço oficial](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli), ou se preferir execute através de Docker.

Em seguida, tenha configurado o aws cli, e junto a isto um profile gerado com uma chave e segredo da AWS, desta forma será possível provisionar toda a infra. 

Neste projeto foi utilizada uma chave com acesso administrativo, recomenda-se criar um usuário com uma role com as atribuições especificas para cada serviço, porém se não tiver tempo, pode seguir como administrador, mas saiba que não é uma boa pratica. Jamais compartilhe ou faça commits da sua chave e segredo gerados na AWS. 

Infelizmente não foi possível implementar ainda a opção de não se criar os recursos do Route53 e do ACM, pois se você ja tiver este recurso criado será necessário somente criar um CNAME posteriormente apontando para o endereço do cloudfront, e incluir o alias corretamente no arquivo cf.tf. 

Para isto é necessário remover os arquivos dns.tf e route53.tf, alterar o cf.tf para remover a propriedade alias, e adicionar na propriedade viewer_certificate o valor default cloudfront_default_certificate = true (Desculpe por isso, estou sem tempo pra implementar agora)

Acesse o arquivo variables.tf e caso queira criar deixe a variavel "create_dns" em true, caso não, deixe em false. 

Após estas checagens, vamos lá.

1 - Com seu terraform instalado, acesse o diretório /infra/aws execute um terraform init, para baixar todos os providers necessários e inicar o terraform.

```
terraform init
```
Deverá ver uma mensagem similar a abaixo: 

![tf init](/docs/terraform/init.png "init")

2 - Com o terraform inicializado, podemos partir para o planejamento da nossa execução, com isto usamos o comando plan. 

Neste cenário, gosto de usar a opção --output <arquivo a ser salvo o plano> para que salve o plano em um local, e voce garanta no passo posterior que é o apply que realmente esta executando o plano correto, sem modificações intermediarias. 

```
terraform plan --out plano 
```

Neste caso utilizei o nome "plano" que ja inclusive esta no .gitignore. Não precisa ser commitado apenas leva o plano que efetuamos agora.

Se tudo ocorreu com sucesso, você deve receber uma mensagem exibindo quantos recursos serão criados e afins. Serão 25 recursos.

![tf plan](/docs/terraform/plan.png "plan")

3 - Com nosso plano criado, podemos partir para o apply, onde efetivamente vamos criar a infraestrutura na AWS. 

Lembrando que neste passo, caso alguma configuração esteja errada, ainda podem ocorrer erros, já que o plano não elimina 100% esta chance, ele nos da uma boa visão do que será feito, porém não utiliza a api da AWS em si, e não sabe se ela aceitará tudo. 

Passamos então o comando apply, e indicamos o arquivo "plano" que recem criamos.

```
terraform apply plano
```
Esta operação pode levar alguns minutos por conta de alguns recursos demorados como ecs, cloudfront, validação de certificado e afins, ao terminar você deve ver a seguinte mensagem. 

Caso tenha um dominio, você provavelmente terá de alterar os nameservers em seu controlador(GoDaddy, domain.com, registrobr, hostgator), pois toda vez que a zona é recriada, os nameservers se modificam. Então copie as entradas do tipo NS, e configure-as em seu dominio. 

Após criamos a infraestrutura, você pode acessar o console da AWS e verifiar se estão todos lá, e vai poder observar que o bucket s3 e o ecr estarão vazios, e o ecs sem nenhuma task rodando, isto acontece pois não fizemos nenhum deployment ainda. Bora então para a documentação a respeito, siga o link abaixo. 

- [Deployment Backend](/infra/pipeline-scripts/backend/readme.md)
