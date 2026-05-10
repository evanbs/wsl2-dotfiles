# SSH Setup — Chaves por plataforma com Bitwarden

Uma chave por plataforma, armazenada no Bitwarden, reutilizada em qualquer máquina nova.

## Conceito

```
Bitwarden (cofre)
    └── GitHub SSH Key  →  ~/.ssh/github  →  ~/.ssh/config  →  git@github.com
    └── Servidor SSH Key →  ~/.ssh/servidor →  ~/.ssh/config  →  ssh user@host
```

`~/.ssh/config` é versionado no wsl2-dotfiles (sem segredos).
As chaves privadas ficam só no Bitwarden — nunca no repo.

---

## 1. Criar o par de chaves

Um par por plataforma. Use `ed25519` (mais seguro e compacto que RSA).

```bash
# GitHub
ssh-keygen -t ed25519 -C "evandro.barbosa@yahoo.com.br" -f ~/.ssh/github

# Outros servidores (repita o padrão)
ssh-keygen -t ed25519 -C "evandro.barbosa@yahoo.com.br" -f ~/.ssh/servidor
```

Não use senha (passphrase) se quiser que o bootstrap seja não-interativo.
Use se preferir segurança extra — o Bitwarden SSH agent pode gerenciar a desbloqueio.

Isso gera:
- `~/.ssh/github` — chave privada (vai para o Bitwarden)
- `~/.ssh/github.pub` — chave pública (vai para a plataforma)

---

## 2. Adicionar a chave pública à plataforma

### GitHub

```bash
cat ~/.ssh/github.pub
```

Cole o conteúdo em: **GitHub → Settings → SSH and GPG keys → New SSH key**

Teste:
```bash
ssh -T git@github.com
# Hi evanbs! You've successfully authenticated...
```

---

## 3. Salvar a chave privada no Bitwarden

### Via Bitwarden Web (recomendado para criação inicial)

1. Acesse [bitwarden.com](https://bitwarden.com) e faça login
2. **New Item → SSH Key**
3. Preencha:
   - **Name**: `SSH — GitHub` (ou o nome da plataforma)
   - **Private Key**: cole o conteúdo de `~/.ssh/github`

```bash
cat ~/.ssh/github
```

4. Salve o item

Repita para cada plataforma.

### Via `bw` CLI

```bash
# Login (uma vez)
bw login

# Criar item SSH Key
bw get template item | jq '
  .type = 5 |
  .name = "SSH — GitHub" |
  .sshKey.privateKey = (input)
' - < ~/.ssh/github | bw encode | bw create item
```

---

## 4. Verificar e limpar

Confirme que o item está salvo no Bitwarden antes de apagar as chaves locais.
Em uma máquina nova, elas virão do Bitwarden via bootstrap (a implementar).

```bash
# Verificar que a chave pública ainda funciona
ssh -T git@github.com

# Após confirmar, as chaves locais podem ser apagadas —
# o bootstrap do wsl2-dotfiles vai restaurá-las
```

---

## 5. `~/.ssh/config` — versionado no repo

Após criar as chaves, crie o arquivo de config que mapeia host → chave.
Este arquivo não contém segredos e será versionado no wsl2-dotfiles.

```
# ~/.ssh/config
Host github.com
  IdentityFile ~/.ssh/github
  AddKeysToAgent yes

# Host servidor.exemplo.com
#   IdentityFile ~/.ssh/servidor
#   User ubuntu
#   AddKeysToAgent yes
```

---

## Próximo passo

Com as chaves no Bitwarden, o `install.sh` do wsl2-dotfiles poderá
injetá-las automaticamente em `~/.ssh/` durante o bootstrap de uma nova máquina.
Essa implementação está planejada — ver ROADMAP.md.
