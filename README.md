# Docker + AWS

Essa é uma documentação para quem está interessado em subir serviços com facilidade na núvem, sem precisar ficar se enrolando com diversas ferramentas de desenvolvimento ou construção de serviços na hora da disponibilização para produção ou teste para times de desenvolvimento ou de controle de qualidade.

`AWS` (Amazon Web Services) é uma plataforma de serviços na núvem que auxilia e automatiza a execução de vários serviços, seja ele um site, uma API, armazenamento de arquivos e mais um conjunto de ferramentas. Por sua vez, fornece uma estrutura virtual, ficando independente de lugares ou gastos físicos.

`Docker` é uma tecnologia que permite a virtualização de um ou mais ambientes baseados em imagens de sistemas limpos ou não (com a presença de tecnologias terceiras ou não) onde é possível manipular os seus recursos e fazer uma instalação limpa de um serviço como um site ou API para disponibilizar para outros usuários. Além disso, permite com que esses ambientes sejam iniciados por arquivos de configuração compartilháveis, tornando a execução desse(s) ambiente(s) simples e fácil a partir de um único comando.

## Configurando o Serviço

Para teste, foi criada uma aplicação utilizando ViteJS + React para termos uma resposta visual quando disponibilizarmos na AWS.

Com isso, para fins de curiosidade, para executar a aplicação basta seguir os passos abaixo. Essa parte é opcional, somente para pessoas que querem verificar a aplicação:

1. Executar `npm install` para instalar os pacotes da aplicação;
2. Executar `npm run dev` para executar a aplicação em modo de desenvolvimento.

Agora, basta abrir o endereço [http://127.0.0.1:5173](http://127.0.0.1:5173) no navegador e você deve ver a seguinte página:

![image](https://github.com/wallrony/docker-aws-example/assets/49597325/1b09e4d1-71a2-402f-8e83-66f8dbbc5fbd)

Pronto, essa é a aplicação que queremos disponibilizar na AWS.

### Configurações do Docker

Para podermos executar a mesma aplicação com o Docker, nós iremos utilizar os seguintes arquivos:

1. [Dockerfile](./Dockerfile) - Responsável por conter as instruções de instalação, configuração e construção prévia do serviço a ser executado. Geralmente existe um arquivo Dockerfile por serviço (ex.: caso tivéssemos uma API cujo é consumida por nosso site, teríamos um outro Dockerfile para configurar a instância da nossa API);
2. [docker-compose.yml](./docker-compose.yml) - Responsável por conter configurações de disponibilização dos serviços de um projeto e a hierarquia desses, sendo possível utilizá-lo pelo plugin `Docker Compose` (geralmente instalados pelo passo a passo da instalação da `Docker Engine`), facilitando a execução e manutenção dos serviços especificados.

## Configuração na AWS

De início, nós precisamos configurar um ambiente virtual na AWS para podermos disponibilizar o serviço criado. Para isso, utilizaremos o serviço EC2 (Elastic Compute Cloud) que permite com que criemos instâncias no ambiente de núvem da AWS com infraestrutura suficiente para executarmos o serviço do nosso interesse.

### Adicionando uma Instância EC2

Para começar, após entrar em uma conta da AWS, iremos dar de cara com o painel principal. Com isso, iremos pesquisar o serviço EC2 na barra de pesquisa principal da AWS:

![#1](https://github.com/wallrony/docker-aws-example/assets/49597325/127c3a16-a128-4102-82df-a99e4b2981f5)

Na barra de pesquisa, iremos digitar "EC2" e clicaremos na seguinte opção:

![#2](https://github.com/wallrony/docker-aws-example/assets/49597325/93322efd-0147-409d-b1d9-4d4dac69c793)

Após clicar na opção exibida, iremos entrar na seção de instâncias da EC2 clicando em "Instâncias" ou "Instâncias (em execução)":

![#3](https://github.com/wallrony/docker-aws-example/assets/49597325/26bb26c9-46d8-477d-a61a-9197fcc79e2b)

Após carregar a página de instâncias, clique em "Executar Instância":

![#4](https://github.com/wallrony/docker-aws-example/assets/49597325/3dbd7582-d6e6-46cb-97d4-0e0ca0978573)

Com isso você será redirecionado à página de criação de uma nova instância EC2. Temos algumas etapas específicas para seguir e configurar apropriadamente.

Primeiro iremos configurar as partes básicas da instância. De acordo com a imagem abaixo, siga o passo a passo:

![#5](https://github.com/wallrony/docker-aws-example/assets/49597325/1991562f-1fee-4763-b3df-0644c313bea6)

1. Digite o nome da sua instância (ex.: "Docker Test");
2. Selecione o tipo de imagem base da instância EC2 como "Ubuntu";
3. Escolha a versão da imagem selecionada (no caso da "Ubuntu", irá aparecer versões desde a atual LTS até algumas antigas ainda suportadas).

Pronto, agora vamos configurar o acesso à instância:

![#6](https://github.com/wallrony/docker-aws-example/assets/49597325/1f17c791-f773-4348-86a4-d95aafbd4a4f)

1. Caso já tenha uma chave de acesso, é possível selecionar uma já existente no campo de seleção;
2. Caso não tenha nenhuma chave de acesso, clique no botão "Criar novo par de chaves" e siga o passo a passo abaixo:

> ![#7](https://github.com/wallrony/docker-aws-example/assets/49597325/d9d62e01-497c-45b5-907d-84518b78a525)
> 1. Digite o nome da chave (ex.: "DockerTest" - esse vai ser o nome do arquivo da chave de acesso também);
> 2. Selecione o tipo da chave como RSA (recomendo a RSA por ser de fácil utilização e amplamente aceito pelo acesso SSH e ainda manter segurança);
> 3. Selecione o formato da chave privada como ".pem" (pode ser utilizado pelo software OpenSSH, que na maioria das vezes já é instalado em todos os sistemas, seja `Windows`, `Linux` ou `MAC`);
> 4. Clique no botão "Criar par de chaves" para registrar na AWS e baixar a chave de acesso privada.

Pronto, agora vamos configurar a parte de segurança no acesso externo à instância (regras de entrada à instância). Siga o passo a passo abaixo:

![#8](https://github.com/wallrony/docker-aws-example/assets/49597325/016597cf-da9d-4a35-956d-1d481dffb390)

1. Selecione criar grupo de segurança caso ainda não tenha nenhum previamente criado;
2. Selecione para utilizar um grupo de segurança já criado caso já exista um pré-configurado com atribuições que satisfazem o nosso objetivo;
3. Habilite a caixa "Permitir tráfego SSH de";
4. Selecione a origem do acesso SSH (por padrão é selecionado "0.0.0.0", que é o acesso de qualquer computador que tenha a chave de acesso), porém é possível delimitar e escolher, por exemplo, seu próprio IP;
5. Não iremos habilitar a caixa "Permitir tráfego HTTPS da internet" pois não iremos configurar acesso com Certificados SSL, que é o que permite o uso do protocolo HTTPS;
6. Habilite a caixa "Permitir tráfego HTTP da internet" para que seja possível o acesso à nossa máquina a partir do protocolo HTTP (porta 80).

Vale lembrar que essas configurações são regras de entrada à nossa instância. Todo grupo de segurança criado permite o tráfego à internet por padrão. Com isso, ficarão disponíveis os acessos via portas 22 (SSH) e 80 (HTTP) no nosso grupo de segurança da AWS.

Com isso, temos a nossa instância basicamente configurada. Como essa documentação não visa configurações complexas para serviços mais complexos, não é necessário configurações adicionais.

Para finalizar a criação da instância, precisamos verificar o resumo com a quantidade de instâncias que queremos criar (por padrão 1) e clicar no botão "Executar instância", assim como exibido na imagem abaixo:

![#10](https://github.com/wallrony/docker-aws-example/assets/49597325/4f59ceeb-4648-4868-9863-0e467faa3f85)

Após um tempo, a página exibirá o status de "Êxito" na criação da instância EC2 (com isso, clique no ID da instância para ser redirecionado à página de detalhes da instância):

![#12](https://github.com/wallrony/docker-aws-example/assets/49597325/757b5d9d-b4cb-4956-ae4e-cb7486f1d58b)

Após acessar a página de detalhes da instância, teremos várias informações dela, incluindo o IP público que será utilizado para acessar a instância via SSH. Logo, copie ela e salve para os próximos passos:

![#13](https://github.com/wallrony/docker-aws-example/assets/49597325/6b51e931-60ef-43ff-933a-5ccb13c912d4)

Pronto! Agora temos a nossa instância devidamente configurada e criada, precisamos configurar o ambiente na parte de dentro, conectando via SSH e instalando as ferramentas necessárias.

## Configurando Instância EC2

Para configurar a instância que criamos na etapa anterior, iremos conectar via SSH e realizar os procedimentos necessários para execução do serviço que criamos.

### Conectando via SSH

Para conectar via SSH ao nosso serviço, precisamos executar os comandos destacados na seguinte imagem:

![#14](https://github.com/wallrony/docker-aws-example/assets/49597325/0f81bfb9-b7b9-4d3f-bd22-fc41445408f5)

1. Executar `chmod 400 /caminho/para/chave_de_acesso.pem` - substitua "/caminho/para/chave_de_acesso.pem" pelo devido caminho para a chave de acesso - a chave de acesso foi baixada após criar ou cadastrada na instância AWS. Esse comando deve ser executado para que essa tenha permissão somente de leitura para que não seja alterada e que seja lida somente pelo usuário cujo baixou a chave;
2. Executar `ssh -i /caminho/para/chave_de_acesso.pem ubuntu@ip_publico` - substitua "/caminho/para/chave_de_acesso.pem" pelo devido caminho para a chave de acesso e "ip_publico" pelo ip copiado na página de detalhes da instância;
3. Caso tudo tenha ocorrido bem, um texto com `Ubuntu@ip_publico:` será exibido, assim como apresentado na imagem acima.

Com isso, conseguimos acessar com sucesso a instância EC2 que foi criada na AWS. Agora, precisamos mover o nosso projeto, que está na nossa máquina local, para a nossa instância EC2.

### Adquirindo Projeto

Para adquirir o projeto na instância EC2 é possível utilizar vários caminhos, porém existem dois simples e principais que facilitam bastante a nossa vida:

1. GIT - é possível termos o nosso projeto no GitHub e dentro da nossa instância EC2 somente realizarmos o `git clone` do nosso projeto, facilitando o download de todos os arquivos;
2. SCP (Secure Copy) - realizar a transferência de arquivos via SSH com o SCP, que permite a transferência de arquivos de forma fácil e segura entre a máquina local e um dispositivo remoto (nesse caso, a nossa instância EC2).

Evitando uma configuração extra, seguiremos utilizando o protocolo SCP.

Execuremos o comando `scp -i /caminho/para/chave_de_acesso.pem -r /caminho/para/projeto ubuntu@ip_publico`, assim como apresentado na imagem abaixo:

![#15](https://github.com/wallrony/docker-aws-example/assets/49597325/77394390-a866-420f-a843-b77ece325bf2)

1. Substitua "/caminho/para/chave_de_acesso.pem" pelo devido caminho para a chave de acesso;
2. Substitua "/caminho/para/projeto" pelo devido caminho do projeto - o parâmetro "-r" é adicionado anterior à esse caminho para indicar que é necessário transferir arquivos de forma recursiva no diretório especificado;
3. Substitua "ip_publico" pelo ip copiado na página de detalhes da instância;

Com isso, entre na instância EC2 com o comando citado anteriormente para acessar com a chave de acesso, e execute o comando `ls -l`. A saída deve ser a mesma que a apresentada na imagem abaixo:

![#16](https://github.com/wallrony/docker-aws-example/assets/49597325/ed809078-8ee7-46b1-92f9-89e847de74e6)

Pronto! Temos todos os arquivos necessários para executar o nosso projeto na nossa instância EC2.

### Instalando o Docker

Sobre a instalação do Docker, será um processo que seria executado em qualquer outro sistema considerando que estamos conectados somente à uma máquina virtual. Para isso, recomendo seguir a seguinte [documentação do site oficial do docker](https://docs.docker.com/engine/install/ubuntu/).

Ps.: para realizar executar as etapas de instalação do `Docker`, lembre-se de acessar a instância pelo comando citado anteriormente utilizando o `ssh` na linha de comando.

Ps. 2: seguindo as recomendações de segurança da documentação oficial do Docker, não seguimos o passo a passo de pós instalação para permitir a execução sem a concessão de super usuário. 

### Executando serviço

Ainda estando conectado à instância EC2, entraremos na pasta com o nome do projeto (existente na instância EC2) e executaremos o comando `sudo docker compose up`, assim como apresentado na imagem abaixo:

![#17](https://github.com/wallrony/docker-aws-example/assets/49597325/a9fbf623-d069-4b6e-a26f-039473957c88)

No final, temos uma mensagem de informação onde diz que nossa aplicação está sendo executada na porta 80 (HTTP).

Após isso, ao acessar o endereço `http://ip_publico` você deve ser capaz de visualizar a mesma página que conseguimos visualizar quando executando localmente:

![#18](https://github.com/wallrony/docker-aws-example/assets/49597325/a1194eda-6c82-44fe-a8e9-a55163fbd6ba)

Com isso, conseguimos configurar o Docker em uma instância EC2 da AWS! Isso faz com que toda vez que tivermos uma atualização ou algum problema de configuração, basta altermos as configurações dos arquivos do Docker e executar apenas um comando para reestruturar a nossa aplicação e torná-la disponível o mais rápido o possível.

Vale salientar que o Docker, nos dias atuais, não é tão utilizado para ambientes de produção quando se trata de aplicações complexas. Atualmente são utilizadas ferramentas como Kubernetes para orquestrar um conjunto de serviços e ter uma maior abrangência de disponibilidade e observabilidade do que ocorre durante sua execução ou até mesmo em eventuais finalizações ou interrupções da aplicação.

Outro ponto muito importante é que para aplicações com tráfego de dados (ex.: consumo de API externa) é necessário que seja feita uma configuração de certificados SSL para utilização do protocolo HTTPS ao invés do HTTP, cujo não realiza nenhum processo de segurança com os dados que são trafegados.
