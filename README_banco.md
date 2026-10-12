# Estrutura do banco

Os comandos de criação foram separados em arquivos individuais:

- `tabelas/`: um arquivo por tabela, numerados na ordem de dependência das chaves estrangeiras.
- `views/`: um arquivo por view, numerados para facilitar a execução.
- `_script_fisico.sql`: versão consolidada anterior do esquema.

Execute os arquivos da pasta `tabelas` em ordem numérica e, depois, os arquivos da pasta `views`, também em ordem numérica. Cada arquivo pode ser executado individualmente no PostgreSQL após suas dependências terem sido criadas.
