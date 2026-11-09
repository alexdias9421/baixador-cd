# 🎵 BAIXADOR DE CD - Termux

**🎧 Script completo para download de músicas por gênero musical no Termux!**

---

## ✨ Funcionalidades

- 🎨 Interface bonita com **figlet** (ASCII art colorido)
- 📂 **Separa por gêneros** - Sertanejo, Hip Hop, Pop, Rock, Funk, Pagode, **Dance**, Jazz, Clássico, MPB, Eletrônica
- 🎤 **Pesquisar por artista** ou DJ
- 📆 **Buscar por ano** - encontre músicas de um ano específico
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

# 3. Clone ou baixe o projeto
git clone https://github.com/seu-usuario/baixador-cd.git
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

## 🎵 Gêneros Disponíveis

| Número | Gênero |
|--------|--------|
| 1 | Sertanejo |
| 2 | Hip Hop |
| 3 | Pop |
| 4 | Rock |
| 5 | Funk |
| 6 | Pagode |
| 7 | **Dance** |
| 8 | Jazz |
| 9 | Clássico |
| 10 | MPB |
| 11 | Eletrônica |
| 12 | Outro (personalizado) |

---

## 📆 Buscar por Ano (NOVO!)

```
Escolha> 4

Digite o ano (ex: 2023 ou 2024): 2023
Digite artista (ou Enter para 'Top hits'): 
Genero (1-11): 2

Preparando download...
  Query:   Top hits 2023
  Genero:  Hip Hop
  Pasta:   /sdcard/Download/CDs_BAIXADOS/Hip Hop
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

---

## 📁 Onde os Arquivos São Salvos

**Pasta padrão:** `/sdcard/Download/CDs_BAIXADOS`

### Estrutura:
```
CDs_BAIXADOS/
├── Sertanejo/
├── Hip Hop/
├── Pop/
├── Rock/
├── Funk/
├── Pagode/
├── Dance/
├── Jazz/
├── Classico/
├── MPB/
└── Eletronica/
```

---

## 🚪 Como Sair

Pressione **`0`** no menu principal.

---

## 📝 Exemplo de Uso Completo

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

### Opção 4 - Buscar por ano:
```
Escolha> 4

Digite o ano (ex: 2023 ou 2024): 2024
Digite artista (ou Enter para 'Top hits'): 
Genero (1-11): 3

Preparando download...
  Query:   Top hits 2024
  Genero:  Pop
```

### Opção 5 - Mostrar status:
```
Escolha> 5

Status dos Downloads:
  Pasta principal: /sdcard/Download/CDs_BAIXADOS
  Pop: 25 musicas
  Hip Hop: 18 musicas
  Total: 43 arquivos MP3
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

## 🗂️ Arquivos do Projeto

```
baixador-cd/
├── instalar.sh           # Instalador completo
├── baixador_cd.sh        # Script completo
├── baixador_cd_simple.sh # Versão simplificada
└── README_BAIXADOR_CD.md # Este arquivo
```

---

## 📜 Licença

MIT License - Livre para uso e modificação.

---

## 🚀 Dica Rápida

Para buscar as músicas mais populares de um determinado ano:

```
baixador-cd
→ Opção 4 (Buscar por ano)
→ Digite o ano desejado (ex: 2024)
→ Pressione Enter para artista
→ Escolha o gênero
```

---

*Desenvolvido com ❤️ no Termux usando o assistente Claude Code*