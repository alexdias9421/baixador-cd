#!/data/data/com.termux/files/usr/bin/bash
# Instalador Do Baixador De CD - Projeto Termux (ATUALIZADO - com busca por ano e desinstalação)

# Cores
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[1;31m'
AZUL='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

# Configurações de versão e GitHub
VERSAO_ATUAL="V1.0.0"
GITHUB_REPO="https://github.com/alexdias9421/baixador-cd.git"
GITHUB_RAW="https://raw.githubusercontent.com/alexdias9421/baixador-cd/main"
VERSION_FILE="$HOME/.config/baixador_cd/version.txt"

# Verificar se é pedido de desinstalação
if [[ "$1" == "--desinstalar" ]] || [[ "$1" == "-u" ]] || [[ "$1" == "desinstalar" ]]; then
    echo -e "${VERMELHO}============================================${RESET}"
    echo -e "${VERMELHO}    DESINSTALADOR DO BAIXADOR DE CD         ${RESET}"
    echo -e "${VERMELHO}============================================${RESET}"
    echo ""
    echo -e "${AMARELO}ATENÇÃO: Isso vai remover o Baixador de CD e suas configurações.${RESET}"
    echo ""
    read -p "Tem certeza que deseja desinstalar? (s/n): " confirm
    if [[ ! "$confirm" =~ ^[sS]$ ]]; then
        echo -e "${CYAN}Desinstalação cancelada.${RESET}"
        exit 0
    fi

    echo ""
    echo -e "${AMARELO}[1/4] Removendo comando 'baixador-cd'...${RESET}"
    if [ -f "$HOME/.local/bin/baixador-cd" ]; then
        rm -f "$HOME/.local/bin/baixador-cd"
        echo -e "${VERDE}[✓] Comando removido${RESET}"
    else
        echo -e "${AMARELO}[!] Comando não encontrado${RESET}"
    fi

    echo ""
    echo -e "${AMARELO}[2/4] Removendo configurações e preferências...${RESET}"
    if [ -d "$HOME/.config/baixador_cd" ]; then
        rm -rf "$HOME/.config/baixador_cd"
        echo -e "${VERDE}[✓] Configurações removidas${RESET}"
    else
        echo -e "${AMARELO}[!] Pasta de configurações não encontrada${RESET}"
    fi

    echo ""
    echo -e "${AMARELO}[3/4] Removendo PATH do .bashrc...${RESET}"
    if grep -q ".local/bin" "$HOME/.bashrc" 2>/dev/null; then
        sed -i '/\.local\/bin/d' "$HOME/.bashrc"
        echo -e "${VERDE}[✓] PATH removido do .bashrc${RESET}"
    else
        echo -e "${AMARELO}[!] PATH não encontrado no .bashrc${RESET}"
    fi

    echo ""
    echo -e "${AMARELO}[4/4] Remover arquivos baixados?${RESET}"
    DOWNLOAD_BASE="$HOME/storage/music/CDs_BAIXADOS"
    [ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="/sdcard/Music/CDs_BAIXADOS"
    [ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="$HOME/storage/downloads/CDs_BAIXADOS"
    [ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="/sdcard/Download/CDs_BAIXADOS"
    [ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="$HOME/Download/CDs_BAIXADOS"

    if [ -d "$DOWNLOAD_BASE" ]; then
        echo -e "  Pasta encontrada: ${CYAN}$DOWNLOAD_BASE${RESET}"
        read -p "Deseja remover também os arquivos de música baixados? (s/n): " remover_downloads
        if [[ "$remover_downloads" =~ ^[sS]$ ]]; then
            rm -rf "$DOWNLOAD_BASE"
            echo -e "${VERDE}[✓] Arquivos baixados removidos${RESET}"
        else
            echo -e "${CYAN}[i] Arquivos baixados mantidos em: $DOWNLOAD_BASE${RESET}"
        fi
    else
        echo -e "${AMARELO}[!] Pasta de downloads não encontrada${RESET}"
    fi

    echo ""
    echo -e "${VERDE}============================================${RESET}"
    echo -e "${VERDE}    DESINSTALAÇÃO CONCLUÍDA COM SUCESSO!    ${RESET}"
    echo -e "${VERDE}============================================${RESET}"
    echo ""
    echo -e "${CYAN}O Baixador de CD foi removido do seu sistema.${RESET}"
    echo -e "${CYAN}Feche e abra o Termux novamente para atualizar o PATH.${RESET}"
    echo ""
    exit 0
fi

echo -e "${AZUL}============================================${RESET}"
echo -e "${AZUL}    INSTALADOR DO BAIXADOR DE CD            ${RESET}"
echo -e "${AZUL}============================================${RESET}"
echo ""

# Passo 1: Verificar instalar storage
echo -e "${AMARELO}[1/5] Configurando armazenamento...${RESET}"
if [ ! -d "$HOME/storage" ]; then
    termux-setup-storage
    echo -e "${VERDE}[✓] Armazenamento configurado${RESET}"
else
    echo -e "${VERDE}[✓] Armazenamento ja configurado${RESET}"
fi

# Passo 2: Instalar dependencias
echo ""
echo -e "${AMARELO}[2/5] Instalando dependencias (ffmpeg, figlet, python)...${RESET}"
pkg install -y ffmpeg figlet python curl > /dev/null 2>&1
echo -e "${VERDE}[✓] Dependencias instaladas${RESET}"

# Passo 3: Instalar bibliotecas Python
echo ""
echo -e "${AMARELO}[3/5] Instalando bibliotecas Python (yt-dlp, mutagen)...${RESET}"
pip install -U yt-dlp mutagen > /dev/null 2>&1
echo -e "${VERDE}[✓] Bibliotecas Python instaladas${RESET}"

# Passo 4: Criar diretorio bin
echo ""
echo -e "${AMARELO}[4/5] Criando diretorio de comandos...${RESET}"
mkdir -p "$HOME/.local/bin"

# Passo 5: Criar o script principal
echo -e "${AMARELO}[5/5] Criando comando 'baixador-cd'...${RESET}"

cat > "$HOME/.local/bin/baixador-cd" << 'ENDSCRIPT'
#!/data/data/com.termux/files/usr/bin/bash
clear

# Cores
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[1;31m'
AZUL='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

# Configuracoes de versao e GitHub
VERSAO_ATUAL="V1.0.0"
GITHUB_REPO="https://github.com/alexdias9421/baixador-cd.git"
GITHUB_RAW="https://raw.githubusercontent.com/alexdias9421/baixador-cd/main"

# Pasta de downloads - detecta automaticamente (prioridade: Music > Downloads)
DOWNLOAD_BASE="$HOME/storage/music/CDs_BAIXADOS"
[ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="/sdcard/Music/CDs_BAIXADOS"
[ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="$HOME/storage/downloads/CDs_BAIXADOS"
[ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="/sdcard/Download/CDs_BAIXADOS"
[ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="$HOME/Download/CDs_BAIXADOS"
mkdir -p "$DOWNLOAD_BASE"

# Arquivo de preferencias
PREFS="$HOME/.config/baixador_cd/prefs.conf"
mkdir -p "$HOME/.config/baixador_cd"

# Carregar preferencias (bittarate padrao)
BITRATE="320k"
[ -f "$PREFS" ] && source "$PREFS"

# Banner com figlet
echo ""
figlet -f slant "BAIXADOR CD" 2>/dev/null || echo "   _____ _____   ____  _   _ ______ _____   _____ _   _ ______ _____ "
echo -e "${MAGENTA}============================================${RESET}"
echo -e "${MAGENTA}    Download de CDs por Genero Musical      ${RESET}"
echo -e "${MAGENTA}            Versao: $VERSAO_ATUAL             ${RESET}"
echo -e "${MAGENTA}============================================${RESET}"
echo ""

# Funcao: Verificar atualizacao no GitHub
verificar_atualizacao() {
    # Baixar versao remota
    remote_version=$(curl -fsSL "$GITHUB_RAW/VERSION" 2>/dev/null | head -1 | tr -d '\r\n')

    if [ -n "$remote_version" ] && [ "$remote_version" != "$VERSAO_ATUAL" ]; then
        echo -e "${AMARELO}============================================${RESET}"
        echo -e "${AMARELO}  ATUALIZACAO DISPONIVEL: $remote_version${RESET}"
        echo -e "${AMARELO}  Versao atual: $VERSAO_ATUAL${RESET}"
        echo -e "${AMARELO}============================================${RESET}"
        echo ""
        return 0
    fi
    return 1
}

# Verificar atualizacoes na inicializacao (em background)
verificar_atualizacao &

# Funcao: Listar generos
listar_generos() {
    echo "  1) Sertanejo  | 2) Hip Hop  | 3) Pop  | 4) Rock"
    echo "  5) Funk       | 6) Pagode   | 7) Dance| 8) Jazz"
    echo "  9) Classico   | 10) MPB     | 11) Eletronica"
    echo "  12) Outro"
}

# Funcao: Configurar bitrate
configurar_bitrate() {
    echo -e "${CYAN}Bitrate MP3:${RESET}"
    echo "  1) 128k | 2) 192k | 3) 256k | 4) 320k"
    read -p "Escolha [1-4]: " b
    case $b in
        1) BITRATE="128k" ;;
        2) BITRATE="192k" ;;
        3) BITRATE="256k" ;;
        *) BITRATE="320k" ;;
    esac
    echo "BITRATE='$BITRATE'" > "$PREFS"
    echo -e "${VERDE}Bitrate alterado para: $BITRATE${RESET}"
}

# Funcao: Baixar musicas (com ano)
baixar_musicas() {
    local query="$1"
    local genero="$2"
    local output="$DOWNLOAD_BASE/$genero"
    mkdir -p "$output"

    echo ""
    read -p "Quantas músicas deseja baixar? (ex: 10): " limit
    if [ -z "$limit" ]; then limit=20; fi

    echo -e "${AZUL}Preparando download...${RESET}"
    echo -e "  Query:   $query"
    echo -e "  Genero:  $genero"
    echo -e "  Limite:  $limit músicas"
    echo -e "  Pasta:   $output"
    echo ""

    # Adiciona "music" ou "song" dependendo do query
    # Limite de 50MB (52428800 bytes)
    yt-dlp -f "bestaudio" --extract-audio --audio-format mp3 --audio-quality "$BITRATE" --embed-thumbnail --add-metadata --playlist-end "$limit" --max-filesize 52428800 --progress -o "$output/%(title)s.%(ext)s" "ytsearch50:$query music" 2>&1 | grep -E "(Downloading|Destination|aria2|Analyzing)" || true

    echo ""
    echo -e "${VERDE}Download concluido!${RESET}"
    echo -e "${CYAN}Caminho: $output${RESET}"
    echo ""
}

# Funcao: Mostrar status
mostrar_status() {
    echo ""
    echo -e "${CYAN}Status dos Downloads:${RESET}"
    echo -e "  Pasta principal: $DOWNLOAD_BASE"
    for d in "$DOWNLOAD_BASE"/*/; do
        [ -d "$d" ] && nome=$(basename "$d") && count=$(find "$d" -name "*.mp3" 2>/dev/null | wc -l) && echo -e "  ${MAGENTA}$nome:${RESET} $count musicas"
    done
    total=$(find "$DOWNLOAD_BASE" -name "*.mp3" 2>/dev/null | wc -l)
    echo -e "  ${VERDE}Total:${RESET} $total arquivos MP3"
    echo ""
}

# Funcao: Mostrar caminho
mostrar_caminho() {
    echo ""
    echo -e "${AZUL}Caminho dos Arquivos:${RESET}"
    echo -e "  ${CYAN}$DOWNLOAD_BASE${RESET}"
    echo ""
    ls -la "$DOWNLOAD_BASE" 2>/dev/null || echo -e "  ${AMARELO}Pasta vazia${RESET}"
    echo ""
}

# Funcao: Buscar por ano
buscar_por_ano() {
    echo ""
    read -p "Digite o ano (ex: 2023 ou 2024): " ano
    read -p "Digite artista (ou Enter para 'Top hits'): " artista

    # Se artista vazio, usar search genérico
    if [ -z "$artista" ]; then
        artista="Top hits"
    fi

    # Montar query com ano
    query="$artista $ano"

    # Perguntar gênero
    listar_generos
    read -p "Genero (1-12): " g
    case $g in
        1) genero="Sertanejo" ;;
        2) genero="Hip Hop" ;;
        3) genero="Pop" ;;
        4) genero="Rock" ;;
        5) genero="Funk" ;;
        6) genero="Pagode" ;;
        7) genero="Dance" ;;
        8) genero="Jazz" ;;
        9) genero="Classico" ;;
        10) genero="MPB" ;;
        11) genero="Eletronica" ;;
        *) genero="Outros" ;;
    esac

    baixar_musicas "$query" "$genero"
}

# Funcao: Verificar atualizacao no GitHub
verificar_atualizacao() {
    echo -e "${CYAN}Verificando atualizacoes...${RESET}"

    # Baixar versao remota
    remote_version=$(curl -fsSL "$GITHUB_RAW/VERSION" 2>/dev/null | head -1 | tr -d '\r\n')

    if [ -n "$remote_version" ] && [ "$remote_version" != "$VERSAO_ATUAL" ]; then
        echo -e "${AMARELO}============================================${RESET}"
        echo -e "${AMARELO}  ATUALIZACAO DISPONIVEL: $remote_version${RESET}"
        echo -e "${AMARELO}  Versao atual: $VERSAO_ATUAL${RESET}"
        echo -e "${AMARELO}============================================${RESET}"
        echo ""
        return 0
    elif [ -n "$remote_version" ]; then
        echo -e "${VERDE}Voce esta na versao mais recente ($VERSAO_ATUAL)${RESET}"
        return 1
    else
        echo -e "${AMARELO}Nao foi possivel verificar atualizacoes${RESET}"
        return 2
    fi
}

# Funcao: Atualizar via GitHub
atualizar_github() {
    echo ""
    echo -e "${CYAN}Atualizar via GitHub${RESET}"
    echo -e "  Repositorio: ${GITHUB_REPO}${RESET}"
    echo ""

    # Verificar se tem atualizacao primeiro
    remote_version=$(curl -fsSL "$GITHUB_RAW/VERSION" 2>/dev/null | head -1 | tr -d '\r\n')

    if [ -n "$remote_version" ] && [ "$remote_version" != "$VERSAO_ATUAL" ]; then
        echo -e "${AMARELO}Nova versao encontrada: $remote_version (atual: $VERSAO_ATUAL)${RESET}"
        read -p "Deseja atualizar agora? (s/n): " confirm
        if [[ ! "$confirm" =~ ^[sS]$ ]]; then
            echo -e "${CYAN}Atualizacao cancelada.${RESET}"
            return
        fi
    elif [ -n "$remote_version" ]; then
        echo -e "${VERDE}Ja esta na versao mais recente ($VERSAO_ATUAL)${RESET}"
        read -p "Forcar re-instalacao? (s/n): " confirm
        if [[ ! "$confirm" =~ ^[sS]$ ]]; then
            return
        fi
    else
        echo -e "${AMARELO}Nao foi possivel verificar versao remota. Continuar mesmo assim? (s/n): ${RESET}"
        read -p "" confirm
        if [[ ! "$confirm" =~ ^[sS]$ ]]; then
            return
        fi
    fi

    echo ""
    echo -e "${AZUL}Baixando atualizacao...${RESET}"

    # Baixar o script de instalacao do GitHub
    temp_script="/tmp/instalar_github.sh"
    if curl -fsSL "$GITHUB_RAW/instalar.sh" -o "$temp_script" 2>/dev/null; then
        chmod +x "$temp_script"
        echo -e "${VERDE}Script baixado com sucesso!${RESET}"
        echo -e "${AMARELO}Executando atualizacao...${RESET}"
        echo ""
        bash "$temp_script"
        echo ""
        echo -e "${VERDE}Atualizacao concluida! Reinicie o Termux.${RESET}"
        rm -f "$temp_script"
        exit 0
    else
        echo -e "${VERMELHO}Erro ao baixar do GitHub.${RESET}"
        echo -e "${CYAN}Verifique sua conexao ou tente novamente mais tarde.${RESET}"
        rm -f "$temp_script"
    fi
}

# Loop principal do menu
while true; do
    echo ""
    echo -e "${CYAN}Menu:${RESET}"
    echo -e "  ${AMARELO}1)${RESET} Pesquisar por artista"
    echo -e "  ${AMARELO}2)${RESET} Download rapido (URL)"
    echo -e "  ${AMARELO}3)${RESET} Baixar por genero"
    echo -e "  ${AMARELO}4)${RESET} Buscar por ano"
    echo -e "  ${AMARELO}5)${RESET} Mostrar status"
    echo -e "  ${AMARELO}6)${RESET} Mostrar caminho"
    echo -e "  ${AMARELO}7)${RESET} Configurar opcoes"
    echo -e "  ${AMARELO}8)${RESET} Atualizar via GitHub"
    echo -e "  ${AMARELO}0)${RESET} Sair"
    echo ""

    read -p "Escolha> " op

    case $op in
        1)
            echo ""
            read -p "Digite artista ou DJ: " artista
            listar_generos
            read -p "Genero (1-12): " g
            case $g in
                1) genero="Sertanejo" ;;
                2) genero="Hip Hop" ;;
                3) genero="Pop" ;;
                4) genero="Rock" ;;
                5) genero="Funk" ;;
                6) genero="Pagode" ;;
                7) genero="Dance" ;;
                8) genero="Jazz" ;;
                9) genero="Classico" ;;
                10) genero="MPB" ;;
                11) genero="Eletronica" ;;
                *) read -p "Genero personalizado: " genero ;;
            esac
            baixar_musicas "$artista" "$genero"
            ;;

        2)
            echo ""
            read -p "URL YouTube ou busca: " url
            listar_generos
            read -p "Genero (1-12): " g
            case $g in
                1) genero="Sertanejo" ;;
                2) genero="Hip Hop" ;;
                3) genero="Pop" ;;
                4) genero="Rock" ;;
                5) genero="Funk" ;;
                6) genero="Pagode" ;;
                7) genero="Dance" ;;
                8) genero="Jazz" ;;
                9) genero="Classico" ;;
                10) genero="MPB" ;;
                11) genero="Eletronica" ;;
                *) genero="Outros" ;;
            esac
            baixar_musicas "$url" "$genero"
            ;;

        3)
            echo ""
            listar_generos
            read -p "Escolha o genero (1-12): " g
            case $g in
                1) baixar_musicas "Top Sertanejo" "Sertanejo" ;;
                2) baixar_musicas "Top Hip Hop Hits" "Hip Hop" ;;
                3) baixar_musicas "Top Pop Hits" "Pop" ;;
                4) baixar_musicas "Top Rock Hits" "Rock" ;;
                5) baixar_musicas "Top Funk Hits" "Funk" ;;
                6) baixar_musicas "Top Pagode" "Pagode" ;;
                7) baixar_musicas "Top Dance Hits" "Dance" ;;
                8) baixar_musicas "Jazz Classics" "Jazz" ;;
                9) baixar_musicas "Classical Music" "Classico" ;;
                10) baixar_musicas "Top MPB" "MPB" ;;
                11) baixar_musicas "Top Electronic" "Eletronica" ;;
                *) read -p "Genero personalizado: " gen; baixar_musicas "$gen" "Outros" ;;
            esac
            ;;

        4)
            buscar_por_ano
            ;;

        5) mostrar_status ;;
        6) mostrar_caminho ;;
        7) configurar_bitrate ;;
        8) atualizar_github ;;

        0)
            echo ""
            echo -e "${VERDE}Obrigado por usar o BAIXADOR DE CD!${RESET}"
            echo -e "${CYAN}Arquivos salvos em: $DOWNLOAD_BASE${RESET}"
            echo ""
            exit 0
            ;;

        *)
            echo -e "${VERMELHO}Opcao invalida${RESET}"
            ;;
    esac
done
ENDSCRIPT

# Tornar executavel
chmod +x "$HOME/.local/bin/baixador-cd"

# Adicionar ao PATH do .bashrc
if ! grep -q ".local/bin" "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# Mensagem final
echo ""
echo -e "${VERDE}============================================${RESET}"
echo -e "${VERDE}    INSTALACAO CONCLUIDA COM SUCESSO!       ${RESET}"
echo -e "${VERDE}============================================${RESET}"
echo ""
echo -e "${CYAN}Para usar:${RESET}"
echo -e "  1. Feche este terminal"
echo -e "  2. Abra o Termux novamente"
echo -e "  3. Digite: ${AMARELO}baixador-cd${RESET}"
echo ""
echo -e "${CYAN}Caminho dos downloads:${RESET}"
echo -e "  ${AMARELO}$HOME/storage/music/CDs_BAIXADOS${RESET}  (pasta Music)"
echo -e "  Ou: ${AMARELO}/sdcard/Music/CDs_BAIXADOS${RESET}"
echo ""
echo -e "${CYAN}Para desinstalar:${RESET}"
echo -e "  Execute: ${AMARELO}bash instalar.sh --desinstalar${RESET}"
echo -e "  Ou: ${AMARELO}bash instalar.sh -u${RESET}"
echo -e "  Ou: ${AMARELO}bash instalar.sh desinstalar${RESET}"
echo ""