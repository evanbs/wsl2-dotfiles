# wsl2-dotfiles

Configs do host WSL2 — a camada que sustenta os devcontainers.

Parte do ecossistema de desenvolvimento:

```
wsl2-dotfiles  →  devbase (imagem)  →  dev-template (devcontainer)
     ↓                                        ↓
~/.gitconfig                         VSCode repassa gitconfig
                                     automaticamente ao container
```

## Nova máquina? Comece aqui

```bash
git clone https://github.com/evanbs/wsl2-dotfiles.git ~/wsl2-dotfiles
cd ~/wsl2-dotfiles
chmod +x install.sh
./install.sh
```

O script cria o symlink `~/.gitconfig → wsl2-dotfiles/git/.gitconfig` e faz backup do arquivo existente caso necessário.

## O que aplica

| Arquivo | Destino | Descrição |
|---|---|---|
| `git/.gitconfig` | `~/.gitconfig` | Identidade git + pager delta + configs universais |

## Estrutura

```
wsl2-dotfiles/
├── install.sh        # cria symlinks no host WSL2
└── git/
    └── .gitconfig    # gitconfig completo do host
```

## Como estender

### Adicionar uma nova config

1. Crie o arquivo na pasta correspondente (ex: `zsh/.zshrc`, `ssh/config`)
2. Adicione a linha de symlink no `install.sh`:

```bash
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
```

3. Rode `./install.sh` para aplicar

### Atualizar o gitconfig

Edite `git/.gitconfig` diretamente — o symlink reflete imediatamente, sem precisar rodar o script novamente.

### Itens comuns para versionar aqui

| Arquivo | Descrição |
|---|---|
| `zsh/.zshrc` ou `.zshrc.local` | Variáveis de ambiente do host, PATH, exports |
| `ssh/config` | Aliases de hosts SSH |
| `git/.gitconfig` | Já presente |

## Relação com os outros repos

| Repo | Responsabilidade |
|---|---|
| **wsl2-dotfiles** | Configs do host WSL2 (este repo) |
| **dev-dotfiles** | Configs pessoais dentro do devcontainer (starship, aliases, zshrc) |
| **devbase** | Imagem Docker base com ferramentas universais |
| **dev-template** | Template de devcontainer por stack (Node.js, Python, etc.) |

O gitconfig do host é repassado automaticamente pelo VSCode ao abrir qualquer devcontainer — nenhuma configuração adicional necessária no `devcontainer.json`.
