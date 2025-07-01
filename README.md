# BugLang ++

## Descrição
BugLang é um compilador simples desenvolvido com Flex e Bison para uma linguagem de programação minimalista. Ele suporta declarações de variáveis, atribuições, entrada/saída, estruturas de controle (condicionais e laços), e expressões aritméticas, comparativas e lógicas. O compilador utiliza uma Árvore de Sintaxe Abstrata (AST) para processar o código, garantindo modularidade e facilitando extensões futuras.

Este compilador é uma versão aprimorada de um compilador inicial sem AST, incorporando a robustez de uma AST enquanto mantém todas as funcionalidades originais, como suporte a strings, entrada dinâmica de dados, e tipagem dinâmica.

## Requisitos
- **Flex**: Para gerar o lexer (`BugLang.l`).
- **Bison**: Para gerar o parser (`BugLang.y`).
- **GCC**: Para compilar o código C gerado.
- **Sistema Operacional**: Linux, macOS, ou Windows com ambiente compatível (ex.: WSL).
- **Biblioteca Matemática**: `-lm` para funções como `floor`.

## Instalação
1. **Clone o Repositório** (se aplicável):
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd BugLang