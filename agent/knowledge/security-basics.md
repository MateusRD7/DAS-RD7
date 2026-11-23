# Fundamentos de Segurança da Informação

Base conceitual da skill `vulnerability-analysis`. Serve para o agente explicar segurança com precisão, sem decorar definição: cada conceito aqui tem um exemplo de laboratório.

## Vulnerabilidade, ameaça e risco

Essas três palavras são usadas como sinônimo no dia a dia, mas não são.

**Vulnerabilidade** é a falha. No laboratório de Python, é o login que monta o SQL com `f-string`: o valor digitado vira parte do comando.

**Ameaça** é quem ou o que pode explorar a falha. Pode ser uma pessoa tentando entrar, um scanner automático varrendo a internet ou um script rodando sem ninguém olhando.

**Risco** é a combinação entre a chance de alguém explorar e o estrago que isso causaria. O mesmo login com falha tem risco baixo rodando na sua máquina, sem rede, e risco alto publicado na internet.

Uma forma simples de lembrar:

```text
risco ≈ probabilidade × impacto
```

Se um dos dois é zero, o risco é zero. Na prática, nenhum dos dois costuma ser zero.

## A tríade confidencialidade, integridade e disponibilidade

Todo controle de segurança existe para proteger pelo menos um destes três:

| Princípio | Significa | Exemplo no laboratório |
| --- | --- | --- |
| Confidencialidade | só quem pode ver, vê | senha de jogador exposta no banco |
| Integridade | o dado não muda sem autorização | cliente alterando o próprio saldo |
| Disponibilidade | o sistema continua no ar | evento sem limite derrubando o servidor |

Vale lembrar que segurança é troca, não valor absoluto. Cada controle tem custo em tempo, dinheiro ou conforto. O trabalho do analista é escolher o que faz sentido para o risco real.

## Superfície de ataque

É tudo que pode ser alcançado por alguém de fora: portas abertas, formulários, eventos de rede liberados para o cliente, upload de arquivo, painel administrativo.

Reduzir a superfície é mais eficiente que tentar proteger cada ponto. No MTA, um `addEvent(nome, true)` que não precisava estar aberto é superfície criada sem motivo.

## Princípios de projeto seguro

- **Menor privilégio:** cada parte do sistema tem só a permissão que precisa. Usuário de banco que só lê não deve poder apagar tabela.
- **Validação no servidor:** o cliente é do jogador e pode ser alterado. Tudo que decide dinheiro, item ou permissão fica no servidor.
- **Negar por padrão:** o que não foi liberado explicitamente não passa.
- **Falhar de forma segura:** se a checagem quebra, o acesso é negado, não liberado.
- **Simplicidade:** código complicado esconde falha. Uma consulta parametrizada é mais segura e mais fácil de ler que uma string montada com filtros.
- **Defesa em profundidade:** nenhuma camada sozinha resolve. Validação no código, permissão no banco, limite de tentativas e monitoramento se somam.

## Severidade

Severidade não é opinião. Separe impacto e probabilidade, depois combine.

- **Impacto:** o que acontece se for explorada. Vazamento de todos os dados é diferente de uma mensagem de erro feia.
- **Probabilidade:** o que é necessário para chegar lá. Internet aberta é diferente de acesso local.
- **Severidade:** a leitura final, de Baixa a Crítica, sempre com o motivo em uma frase.

O critério completo está na skill, em `skills/vulnerability-analysis/SKILL.md`.

## MITRE ATT&CK e CWE

São referências diferentes e costumam ser confundidas.

**CWE** descreve o tipo de fraqueza no código. `CWE-89` é injeção de SQL. Serve para dizer "a falha é desta família".

**MITRE ATT&CK** descreve o comportamento do atacante. `T1190` é explorar aplicação exposta na internet. Serve para dizer "é assim que alguém chegaria aqui".

No laboratório de Python, os dois aparecem juntos: a falha é `CWE-89`, e a técnica usada para explorar um login publicado seria `T1190`. Citar um não substitui o outro.

## Escopo e autorização

Antes de qualquer teste, três perguntas:

1. O ambiente é seu ou você tem autorização escrita para testar?
2. É laboratório ou produção?
3. Se algo der errado, existe backup e um caminho alternativo de acesso?

Teste em sistema de terceiros sem autorização é crime, mesmo com boa intenção. Em produção, comece por leitura e nunca mexa em firewall ou SSH sem backup e sem acesso pelo console do provedor: uma regra errada pode trancar você fora do próprio servidor.

Dados encontrados durante a análise são tratados como sensíveis: não copie, não publique e não compartilhe credencial.

## Boas práticas defensivas

- manter sistema e dependências atualizados;
- usar autenticação forte e, quando possível, multifator;
- guardar senha com hash e salt, nunca em texto puro;
- aplicar menor privilégio em usuário, banco e painel;
- validar entrada no servidor, sempre;
- limitar tentativas e requisições repetidas;
- registrar e monitorar eventos relevantes;
- testar a restauração do backup, não só criar;
- revisar configuração depois de qualquer mudança.

## Como usar este arquivo como mentor

Não despeje estes conceitos de uma vez. Use o conceito que a dúvida pede, com o exemplo do laboratório, e pergunte se ficou claro.

Enquanto não houver evidência, trate como hipótese. "Pode ser" é diferente de "é". E se o estudante não souber responder algo, ensine como descobrir em vez de preencher a lacuna por ele.
