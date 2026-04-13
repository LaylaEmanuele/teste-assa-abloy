# ASSA ABLOY Mobile Challenge

Aplicativo iOS desenvolvido em `SwiftUI` para o desafio mobile, consumindo a API fornecida no enunciado.

## Objetivo

O app foi estruturado para cobrir o fluxo principal do desafio:

- cadastro de usuario
- login
- persistencia de sessão com token
- listagem de portas
- busca de portas por nome
- navegação para detalhe da porta

## Stack

- `SwiftUI`
- `MVVM`
- `async/await`
- `URLSession`
- `Keychain`
- `NavigationStack`

## Arquitetura

O projeto foi dividido em camadas pequenas e previsiveis para manter o codigo simples de navegar e fácil de evoluir

### Estrutura

```text
test-assa-abloy/
  App/
  Core/
  Networking/
  Features/
    Auth/
    Doors/
    Events/
```

### Responsabilidades

- `App/`
  Centraliza estado global do app, fluxo raiz e sessão autenticada

- `Core/`
  Guarda tipos compartilhados, navegação, configuração de ambiente e segurança

- `Networking/`
  Contém a infraestrutura genérica de rede: request builder, client HTTP, encoder/decoder e tratamento de erro

- `Features/`
  Organiza o app por domínio funcional
  Cada feature separa `Models`, `Services`, `ViewModels` e `Views` quando necessário

## Decisoes Tecnicas

### 1. MVVM por feature

A escolha por `MVVM` foi feita para separar:

- `View`: renderização e interação do usuário
- `ViewModel`: estado da tela e regras de apresentação
- `Service`: comunicacao com API

Isso reduz acoplamento entre interface e rede, e facilita testes e manutenção

### 2. URLSession com async/await

Foi usada uma camada própria sobre `URLSession` em vez de bibliotecas externas para:

- manter o projeto mais leve
- seguir o que foi pedido no desafio
- centralizar construção de requests, headers, autenticação e tratamento de erros

O `APIClient` foi pensado para ser reaproveitado entre login, portas e próximos endpoints

### 3. Keychain para o token

O token de autenticação e persistido no `Keychain`, e não em `UserDefaults`, porque se trata de um dado sensível

Com isso o app consegue:

- restaurar a sessão ao abrir novamente
- manter o login entre execuções
- limpar a sessão corretamente no logout

### 4. NavigationStack na raiz

A navegação foi centralizada em `RootView` + `AppRouter` com `NavigationStack`.

Isso permite:

- fluxo de autenticação desacoplado da area autenticada
- navegação tipada com `AppRoute`
- crescimento mais previsível conforme novas telas entram

### 5. Organização por feature

Em vez de uma separação apenas por tipo de arquivo, o projeto foi organizado por domínio

Essa escolha ajuda porque:

- deixa cada fluxo mais fácil de localizar
- evita arquivos espalhados demais
- melhora a escalabilidade conforme entram eventos, permissões e demais endpoints

## O que Foi Implementado

### Etapa 1. Base do app

- estrutura inicial do projeto
- `RootView`
- `AppRouter`
- `NavigationStack`
- placeholders iniciais das features

### Etapa 2. Camada de networking

- `AppEnvironment`
- `HTTPMethod`
- `APIRequest`
- `APIClient`
- `NetworkError`
- suporte de encode/decode

### Etapa 3. Persistencia de sessão

- `KeychainService`
- `SessionStore`
- `AppSession` restaurando token salvo
- logout limpando a sessão

### Etapa 4. Autenticacao real

- `Sign Up` via `/users/signup`
- `Sign In` via `/users/signin`
- formulários reais de login e cadastro
- persistencia do token real retornado pela API

### Etapa 5. Lista de portas

- consumo de `/doors`
- listagem real de portas
- pull-to-refresh
- detalhe da porta com mais informações

### Etapa 6. Busca de portas

- campo de busca com `.searchable`
- debounce simples
- consumo de `/doors/find`
- alternancia entre lista geral e lista filtrada

## Fluxo Atual do App

1. Usuário abre o app
2. Se houver token salvo, o app entra direto na area autenticada
3. Se não houver token, o app mostra a tela de acesso
4. Após login, o token e salvo no Keychain
5. A tela de portas e carregada
6. O usuário pode buscar uma porta e abrir o detalhe

## Tratamento de Erros

Foi criada uma camada de erro própria para não espalhar lógica de rede pelas views

Hoje o projeto já trata:

- resposta inválida
- erro de encoding
- erro de decoding
- status HTTP inválido com payload de erro da API
- cancelamento de request

Isso ajuda a deixar as telas mais simples e melhora a legibilidade do fluxo assincrono

## Pontos de Atencao

- Durante o desenvolvimento, alguns endpoints retornaram shapes diferentes do esperado inicialmente
  Por isso os modelos foram ajustados com base no retorno real da API

- A primeira carga da tela de portas após o login exigiu um cuidado extra com timing de navegação e request assincrona

- O fluxo de eventos ainda esta apenas preparado na navegação, mas não implementado por completo

## Como Rodar

1. Abra o projeto em:

```text
test-assa-abloy/test-assa-abloy.xcodeproj
```

2. Rode no simulador

3. Crie uma conta ou faça login com um usuário valido da API

## Como Testar Manualmente

- cadastrar usuário
- fazer login
- fechar e abrir o app para validar persistencia de sessão
- listar portas
- buscar por nome
- abrir detalhe da porta
- fazer logout

## OBS:

O projeto foi implementado priorizando clareza, separacao de responsabilidades e facilidade de evoluçao, em vez de abstracoes excessivas logo no inicio. A ideia foi construir uma base solida para o fluxo principal do desafio e manter espaco para crescer as proximas features sem retrabalho grande
