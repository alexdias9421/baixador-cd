# Como Enviar para o GitHub

## Passo a Passo

1. **Criar o repositório no GitHub:**
   - Acesse: https://github.com/new
   - Nome: `baixador-cd`
   - Descrição: "🎵 Baixador de CD - Script para download de músicas por gênero no Termux"
   - Licença: MIT
   - Clique em "Create repository"

2. **Conectar e enviar:**
```bash
# No Termux
cd ~/baixador-cd

# Adicionar o remote (substitua SEU_USUARIO)
git remote add origin https://github.com/SEU_USUARIO/baixador-cd.git

# Enviar
git branch -M main
git push -u origin main
```

## 📦 Arquivos Incluídos

| Arquivo | Descrição |
|---------|-----------|
| `instalar.sh` | Instalador completo com todas as dependências |
| `baixador_cd.sh` | Script completo com todas as funcionalidades |
| `baixador_cd_simple.sh` | Versão simplificada do script |
| `README_BAIXADOR_CD.md` | Documentação completa |
| `CHANGELOG.md` | Histórico de versões |
| `LICENSE` | Licença MIT |
| `.gitignore` | Arquivos a ignorar |

## 🎯 Recursos Principais

- 🎨 **ASCII Art** com Figlet
- 📂 **12 Gêneros** (incluindo Dance)
- 🔍 **Busca por Ano** (ex: 2023, 2024)
- 🎵 **MP3 com Capa** integrada
- ⚙️ **Bitrate configurável** (128k-320k)
- 📍 **Mostra caminho** dos downloads
- 🚪 **Opção de sair** (0)
- 📊 **Status de downloads**

## 📖 Uso

```bash
# Instalar
bash instalar.sh

# Executar
baixador-cd
```

## 📸 Banner

```
    ____  ___    _____  __ ___    ____  ____  ____    
   / __ )/   |  /  _/ |/ //   |  / __ \/ __ \/ __ \   
  / __  / /| |  / / |   // /| | / / / / / / / /_/ /   
 / /_/ / ___ |_/ / /   |/ ___ |/ /_/ / /_/ / _, _/    
/_____/_/  |_/___//_/|_/_/  |_/_____/\____/_/ |_|    
```

---
GitHub: https://github.com/SEU_USUARIO/baixador-cd