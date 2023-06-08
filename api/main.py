import log_config
import sys
import math

from fastapi import FastAPI, Response, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from logging.config import dictConfig
from prometheus_fastapi_instrumentator import Instrumentator


dictConfig(log_config.sample_logger)

app = FastAPI()

Instrumentator().instrument(app).expose(app)

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Aplicacao para teste de deployment e DevOps - Clientes - 2023"}
    
@app.get("/api")
async def api():
    response = {
        "app_name": "api-clientes",
        "endpoints": [
            {
            "metodo": "GET",
            "caminho": "/api/clientes",
            "desc": "Lista geral de clientes" 
            },
            {
            "metodo": "GET",
            "caminho": "/api/clientes/<id_cliente>",
            "desc": "Traz clientes especifico" 
            },
            {
            "metodo": "POST",
            "caminho": "/api/clientes/<id_cliente>",
            "desc": "Cria novo cliente",
            "campos_obrigatorios" : "id<int>,nome<str>,email<str>,endereco<str>" 
            }
        ]
        }
    return response

class Cliente(BaseModel):
    id: int
    nome: str
    email: str
    endereco: str

base_dados = [
    Cliente(id=1,nome="Jose Silva", email="jose.silva@email.com",endereco="Rua dos bobos, n 0"),
    Cliente(id=2,nome="Maria Joaquina", email="maria.joaquina@email.com",endereco="Alameda dos anjos, n 1970"),
    Cliente(id=3,nome="Juliana Cardoso", email="ju.cardoso@email.com",endereco="Rua Silva Pereira, n 19"),
    Cliente(id=4,nome="Cassio Ramos", email="cassiogoleiro@email.com",endereco="Rua Juvenal, n 400")
]

@app.get("/api/clientes")
def get_todos_clientes():
    return base_dados
    
@app.get("/api/clientes/{id_usuario}")
def get_cliente_id(id_usuario: int):
    for cliente in base_dados:
        if(cliente.id == id_usuario):
            return cliente
    return{"Mensagem": "Usuario não encontrado, por favor confira os id's existentes"}

@app.post("/api/clientes")
def post_client(cliente: Cliente):
    base_dados.append(cliente)
    return cliente

class Data(BaseModel):
    user: str