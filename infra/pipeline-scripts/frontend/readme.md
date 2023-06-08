# Deploy Frontend

Scripts criados para realizar  deploy do frontend no bucket s3

## Features

- deploy no s3
- limpeza de cache no cloudfront

## s3-deploy

|    Parametro     | Obrigatório |                                Descrição                                |
| ---------------- | ----------- | ----------------------------------------------------------------------- |
| bucket           | Sim         | Nome do bucket do S3                                                    |
| files            | Sim         | Arquivo(s) a ser(em) copiado(s) para o S3                               |
| cloudfront       | Não         | Id do cloudfront                                                        |
| invalidationpath | Não         | Caminho a ser invalidado no CloudFront (padrão: /*) colocar entre aspas |
| profile          | Não         | Perfil AWS a ser usado para a operação                                  |
| help             | Não         | Mostra a mensagem de ajuda com os parametros acima                      |

Exemplo: 

```
./s3-deploy --bucket meubucket --files /frontend/ --cloudfront meucloudfront --invalidationpath /clientes/* --profile administrador
```

## Como utilizar o script

1 - Transforme o arquivo em executavel

```
chmod +x s3-deploy
```

2 - Execute 

Na duvida, deixe sem o --invalidationpath, ele limpará todo cache.

```
./s3-deploy --bucket web-app-frontend --files /web-app/frontend --cloudfront E1IHPMMRX0BZOY --invalidationpath /*
```


3 - Os arquivos devem estar no bucket e o cloudfront deve estar fornecendo os mesmos, a invalidação roda ainda por um tempo, ela não é instantanea.