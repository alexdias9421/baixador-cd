# 🎵 BAIXADOR DE CD - Termux

**🎧 Script completo para download de músicas por gênero musical no Termux!**

---

## ✨ Funcionalidades

- 🎨 Interface bonita com **figlet** (ASCII art colorido)
- 📂 **Separa por gêneros** - Sertanejo, Hip Hop, Pop, Rock, Funk, Pagode, **Dance**, Jazz, Clássico, MPB, Eletrônica
- 🎤 **Pesquisar por artista** ou DJ
- 📆 **Buscar por ano** - encontre músicas de um ano específico (ex: 2023, 2024)
- 📀 **Baixar álbuns completos**
- 🎵 **MP3 com capa integrada** (artwork)
- ⚙️ **Configuração de bitrate** (128k, 192k, 256k, 320k)
- 📍 **Mostra caminho dos arquivos** ao finalizar download
- 🚪 **Opção de sair** do menu

---

## 📱 Pre-requisitos (Instale no Termux)

```bash
# 1. Atualize o Termux
pkg update && pkg upgrade -y

# 2. Configure o armazenamento do Android
termux-setup-storage

# 3. Clone o projeto
git clone https://github.com/alexdias9421/baixador-cd.git
cd baixador-cd
```

---

## 🔧 Instalação Automática (Recomendado)

Execute o instalador completo:

```bash
bash instalar.sh
```

> **O que o instalador faz?**
> - Instala `ffmpeg` (codificação de áudio)
> - Instala `figlet` (ASCII art)
> - Instala `yt-dlp` (baixador de vídeos)
> - Instala `mutagen` (metadados das músicas)
> - Cria o comando `baixador-cd` em `~/.local/bin`

---

## 🏃 Como Usar

### Iniciar o baixador:
```bash
baixador-cd
```

### Menu Principal:

```
╔═══════════════════════════════════════════════════════════╗
║         🎵 BAIXADOR DE CD - PROJETO TERMUX 🎵           ║
║     Download de músicas via YouTube separado por gênero   ║
╚═══════════════════════════════════════════════════════════╝

Menu:
  1) Pesquisar por artista
  2) Download rapido (URL)
  3) Baixar por genero
  4) Buscar por ano         ← NOVO!
  5) Mostrar status
  6) Mostrar caminho
  7) Configurar opcoes
  0) Sair
```

---

## 🎵 Gêneros Disponíveis (12 total)

| Número | Gênero |
|--------|--------|
| 1 | Sertanejo |
| 2 | Hip Hop |
| 3 | Pop |
| 4 | Rock |
| 5 | Funk |
| 6 | Pagode |
| 7 | **Dance** ✨ |
| 8 | Jazz |
| 9 | Clássico |
| 10 | MPB |
| 11 | Eletrônica |
| 12 | Outro (personalizado) |

---

## 📆 Buscar por Ano (NOVO!)

Encontre as músicas mais populares de um ano específico:

```
Escolha> 4

Digite o ano (ex: 2023 ou 2024): 2024
Digite artista (ou Enter para 'Top hits'): [ENTER]
Genero (1-12): 7

Preparando download...
  Query:   Top hits 2024
  Genero:  Dance
  Pasta:   /sdcard/Download/CDs_BAIXADOS/Dance
```

---

## ⚙️ Configurações

### Bitrate do MP3:

| Opção | Qualidade |
|-------|-----------|
| 1 | 128k (padrão) |
| 2 | 192k |
| 3 | 256k |
| 4 | 320k (máximo) |

> O bitrate é salvo automaticamente e usado nas próximas sessões.

---

## 📁 Estrutura de Downloads

**Pasta padrão:** `/sdcard/Download/CDs_BAIXADOS`

### Pastas criadas automaticamente:
```
CDs_BAIXADOS/
├── Sertanejo/
├── Hip Hop/
├── Pop/
├── Rock/
├── Funk/
├── Pagode/
├── Dance/      ← NOVO!
├── Jazz/
├── Classico/
├── MPB/
├── Eletronica/
└── Outros/
```

---

## 📝 Comandos Úteis

```bash
# Verificar instalação
baixador-cd --help

# Mostrar status
baixador-cd → Opção 5

# Ver caminho
baixador-cd → Opção 6

# Limpar preferencias
rm -rf ~/.config/baixador_cd/

# Atualizar script
git pull origin main
```

---

## 🚪 Como Sair

Pressione **`0`** no menu principal ou use **`Ctrl + C`**.

---

## 📋 Exemplos de Uso

### Opção 1 - Pesquisar por artista:
```
Escolha> 1

Digite artista ou DJ: MC Marcinho
Genero (1-12): 2

Preparando download...
  Artista: MC Marcinho
  Genero:  Hip Hop
  Pasta:   /sdcard/Download/CDs_BAIXADOS/Hip Hop
```

### Opção 3 - Baixar por gênero:
```
Escolha> 3

1) Sertanejo  | 2) Hip Hop  | 3) Pop  | 4) Rock
5) Funk       | 6) Pagode   | 7) Dance| 8) Jazz
9) Classico   | 10) MPB    | 11) Eletronica | 12) Outro

Escolha o genero (1-12): 7

Preparando download...
  Query:   Top Dance Hits
  Genero:  Dance
```

### Opção 5 - Mostrar status:
```
Escolha> 5

Status dos Downloads:
  Pasta principal: /sdcard/Download/CDs_BAIXADOS
  Pop: 25 musicas
  Hip Hop: 18 musicas
  Dance: 12 musicas
  Total: 55 arquivos MP3
```

---

## 🛡️ Permissões Concedidas

| Permissão | Para quê |
|-----------|----------|
| Armazenamento (`termux-setup-storage`) | Salvar arquivos |
| Python | Executar `yt-dlp` e `mutagen` |
| `ffmpeg` | Transcodificar áudio com capa |
| Rede | Acesso à internet para download |

---

## 📜 Licença

MIT License - Livre para uso e modificação.

**Copyright (c) 2026 Claude Code**

---

## 🤝 Contribuições

Aberto para issues e pull requests!  

---

## 📸 Banner ASCII

```
    ____  ___    _____  __ ___    ____  ____  ____    
   / __ )/   |  /  _/ |/ //   |  / __ \/ __ \/ __ \   
  / __  / /| |  / / |   // /| | / / / / / / / /_/ /   
 / /_/ / ___ |_/ / /   |/ ___ |/ /_/ / /_/ / _, _/    
/_____/_/  |_/___//_/|_/_/  |_/_____/\____/_/ |_|   
                                                     
```

---

## 🚀 Dica Rápida

Para buscar as músicas mais populares de um determinado ano:

```bash
baixador-cd
→ Opção 4 (Buscar por ano)
→ Digite o ano desejado (ex: 2024)
→ Pressione Enter para artista
→ Escolha o gênero (ou 7 para Dance!)
```

---

## 📊 Estatísticas do Projeto

- **Gêneros suportados:** 12
- **Dependências:** 5 (ffmpeg, figlet, python, yt-dlp, mutagen)
- **Formato de saída:** MP3 com capa integrada
- **Código:** ~350 linhas
- **Licença:** MIT

---

*Desenvolvido com ❤️ no Termux usando o assistente Claude Code*