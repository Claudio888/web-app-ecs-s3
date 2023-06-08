function buscarCliente() {
    const clientId = document.getElementById('clientIdInput').value;

    if (!clientId) {
        alert('Por favor, insira o ID do cliente.');
        return;
    }

    fetch(`https://app.craudio.com.br/api/clientes/${clientId}`)
        .then(response => response.json())
        .then(data => {
            if (data.Mensagem) {
                const resultDiv = document.getElementById('result');
                resultDiv.innerHTML = data.Mensagem;
            } else {
                const resultDiv = document.getElementById('result');
                resultDiv.innerHTML = `ID: ${data.id}<br>
                                       Nome: ${data.nome}<br>
                                       Email: ${data.email}<br>
                                       Endereço: ${data.endereco}`;
            }
        })
        .catch(error => {
            const resultDiv = document.getElementById('result');
            resultDiv.innerHTML = 'Erro ao buscar o cliente.';
            console.error(error);
        });
}

function fetchData() {
    fetch('https://app.craudio.com.br/api/clientes')
      .then(response => response.json())
      .then(data => {
        const clientesList = document.getElementById('clientes-list');
        clientesList.innerHTML = '';
  
        data.forEach(cliente => {
          const listItem = document.createElement('li');
          listItem.innerHTML = `
            <strong>ID:</strong> ${cliente.id}<br>
            <strong>Nome:</strong> ${cliente.nome}<br>
            <strong>Email:</strong> ${cliente.email}<br>
            <strong>Endereço:</strong> ${cliente.endereco}<br>
          `;
  
          clientesList.appendChild(listItem);
        });
      })
      .catch(error => console.error('Erro ao buscar clientes:', error));
  }

function criarCliente() {
    const id = document.getElementById('idInput').value;
    const nome = document.getElementById('nomeInput').value;
    const email = document.getElementById('emailInput').value;
    const endereco = document.getElementById('enderecoInput').value;
  
    const cliente = {
      id: parseInt(id),
      nome: nome,
      email: email,
      endereco: endereco
    };
  
    fetch('https://app.craudio.com.br/api/clientes', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(cliente)
    })
    .then(response => response.json())
    .then(data => {
      console.log('Cliente criado:', data);
      alert('Cliente criado com sucesso!');
      // Limpar os campos do formulário, se necessário
    })
    .catch(error => {
      console.error('Erro ao criar o cliente:', error);
      alert('Ocorreu um erro ao criar o cliente.');
    });
  }