#!/bin/bash
#
#  ╔═══════════════════════════════════════════════════════════╗
#  ║         🎵 BAIXADOR DE CD - PROJETO TERMUX 🎵           ║
#  ║     Download de músicas via YouTube separado por gênero    ║
#  ╚═══════════════════════════════════════════════════════════╝
#

# Cores para output
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[1;31m'
AZUL='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
BRANCO='\033[1;37m'
RESET='\033[0m'

# Pastas
DOWNLOAD_BASE="$HOME/Download/CDs_BAIXADOS"
GENRE_CACHE="$HOME/.config/baixador_cd/genres.json"
PREFS_FILE="$HOME/.config/baixador_cd/prefs.conf"

# Criar diretórios necessários
mkdir -p "$DOWNLOAD_BASE"
mkdir -p "$HOME/.config/baixador_cd"

# ============================================================================
# FUNÇÃO: Inicialização e verificação de dependências
# ============================================================================
inicializar() {
    echo -e "${AZUL}============================================${RESET}"
    echo -e "${AZUL}    BAIXADOR DE CD - INICIALIZANDO...      ${RESET}"
    echo -e "${AZUL}============================================${RESET}"
    echo ""

    # Verificar se figlet está instalado
    if ! command -v figlet &> /dev/null; then
        echo -e "${AMARELO}Instalando figlet...${RESET}"
        pkg install -y figlet
    fi

    # Verificar ffmpeg
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${AMARELO}Instalando ffmpeg...${RESET}"
        pkg install -y ffmpeg
    fi

    # Verificar Python e yt-dlp
    if ! python3 -c "import yt_dlp" 2>/dev/null; then
        echo -e "${AMARELO}Instalando yt-dlp e dependências Python...${RESET}"
        pip install -U yt-dlp mutagen
    fi

    echo -e "${VERDE}[✓] Todas as dependências estão instaladas${RESET}"
    echo ""
}

# ============================================================================
# FUNÇÃO: Mostrar banner com figlet
# ============================================================================
mostrar_banner() {
    clear
    echo ""
    figlet -f slant "BAIXADOR" | head -5
    echo ""
    echo -e "${MAGENTA}============================================${RESET}"
    echo -e "${MAGENTA}    🎧 Download de CDs por Gênero Musical 🎧   ${RESET}"
    echo -e "${MAGENTA}============================================${RESET}"
    echo ""
}

# ============================================================================
# FUNÇÃO: Carregar preferências salvas
# ============================================================================
carregar_prefs() {
    if [ -f "$PREFS_FILE" ]; then
        source "$PREFS_FILE"
    fi
    BITRATE_MUSICA="${BITRATE_MUSICA:-320k}"
    USE_CAPA="${USE_CAPA:-true}"
    MAX_MUSICAS="${MAX_MUSICAS:-20}"
}

# ============================================================================
# FUNÇÃO: Salvar preferências
# ============================================================================
salvar_prefs() {
    cat > "$PREFS_FILE" << EOF
BITRATE_MUSICA="$BITRATE_MUSICA"
USE_CAPA="$USE_CAPA"
MAX_MUSICAS="$MAX_MUSICAS"
EOF
}

# ============================================================================
# FUNÇÃO: Listar gêneros disponíveis
# ============================================================================
listar_generos() {
    echo -e "${CYAN}Gêneros disponíveis:${RESET}"
    echo -e "  ${AMARELO}1)${RESET} Sertanejo"
    echo -e "  ${AMARELO}2)${RESET} Hip Hop"
    echo -e "  ${AMARELO}3)${RESET} Pop"
    echo -e "  ${AMARELO}4)${RESET} Rock"
    echo -e "  ${AMARELO}5)${RESET} Funk"
    echo -e "  ${AMARELO}6)${RESET} Pagode"
    echo -e "  ${AMARELO}7)${RESET} Jazz"
    echo -e "  ${AMARELO}8)${RESET} Clássico"
    echo -e "  ${AMARELO}9)${RESET} MPB"
    echo -e "  ${AMARELO}10)${RESET} Eletrônica"
    echo -e "  ${AMARELO}11)${RESET} Outro (personalizado)"
    echo ""
}

# ============================================================================
# FUNÇÃO: Escolher bitrate do MP3
# ============================================================================
escolher_bitrate() {
    echo -e "${CYAN}Qual bitrate do MP3 deseja?${RESET}"
    echo -e "  ${AMARELO}1)${RESET} 128k (padrão)"
    echo -e "  ${AMARELO}2)${RESET} 192k"
    echo -e "  ${AMARELO}3)${RESET} 256k"
    echo -e "  ${AMARELO}4)${RESET} 320k (máximo)"
    read -p "Escolha [1-4]: " bit_choice

    case $bit_choice in
        1) BITRATE_MUSICA="128k" ;;
        2) BITRATE_MUSICA="192k" ;;
        3) BITRATE_MUSICA="256k" ;;
        *) BITRATE_MUSICA="320k" ;;
    esac

    salvar_prefs
}

# ============================================================================
# FUNÇÃO: Escolher número máximo de músicas
# ============================================================================
escolher_max_musicas() {
    echo -e "${CYAN}Quantas músicas deseja baixar no máximo?${RESET}"
    echo -e "  ${AMARELO}1)${RESET} 10 músicas"
    echo -e "  ${AMARELO}2)${RESET} 20 músicas (padrão)"
    echo -e "  ${AMARELO}3)${RESET} 30 músicas"
    echo -e "  ${AMARELO}4)${RESET} 50 músicas"
    echo -e "  ${AMARELO}5)${RESET} Personalizado"
    read -p "Escolha [1-5]: " max_choice

    case $max_choice in
        1) MAX_MUSICAS=10 ;;
        2) MAX_MUSICAS=20 ;;
        3) MAX_MUSICAS=30 ;;
        4) MAX_MUSICAS=50 ;;
        5)
            read -p "Digite o número máximo de músicas: " MAX_MUSICAS
            if ! [[ "$MAX_MUSICAS" =~ ^[0-9]+$ ]] || [ "$MAX_MUSICAS" -lt 1 ]; then
                echo -e "${VERMELHO}Número inválido. Usando padrão (20).${RESET}"
                MAX_MUSICAS=20
            fi
            ;;
        *) MAX_MUSICAS=20 ;;
    esac

    salvar_prefs
    echo -e "${VERDE}✓ Máximo de músicas definido para: $MAX_MUSICAS${RESET}"
}

# ============================================================================
# FUNÇÃO: Baixar músicas de um artista por gênero
# ============================================================================
baixar_por_genero() {
    local genero="$1"
    local artista="$2"
    local output_dir="$DOWNLOAD_BASE/$genero"

    mkdir -p "$output_dir"

    echo ""
    echo -e "${AZUL}Preparando download para: ${genero} - $artista${RESET}"
    echo ""

    # Montar a URL de busca
    local search_query="${artista} ${genero} music"

    echo -e "${CYAN}Buscando músicas...${RESET}"
    echo ""

    # Arquivo temporário para lista de músicas
    local temp_file="/tmp/baixar_mp3_list.txt"

    # Usar yt-dlp para buscar e baixar músicas
    python3 << PYEOF
import yt_dlp
import os
import json

search_query = "${search_query}"
output_dir = "${output_dir}"
bitrate = "${BITRATE_MUSICA}"
genre = "${genero}"
max_musicas = ${MAX_MUSICAS}

ydl_opts = {
    'format': 'bestaudio/best',
    'postprocessors': [{
        'key': 'FFmpegExtractAudio',
        'preferredcodec': 'mp3',
        'preferredquality': bitrate.replace('k', ''),
    }, {
        'key': 'FFmpegMetadata',
    }, {
        'key': 'EmbedThumbnail',
    }],
    'outtmpl': os.path.join(output_dir, '%(title)s.%(ext)s'),
    'progress_hooks': [],
    'quiet': False,
    'no_warnings': False,
    'embedthumbnail': True,
    'writethumbnail': True,
    'addmetadata': True,
    'noplaylist': False,
    'playlistend': max_musicas,  # Máximo de músicas por download
}

try:
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        # Primeiro, obter informações da playlist de busca
        ydl.download([f'ytsearch50:{search_query}'])
except Exception as e:
    print(f"Erro: {e}")
PYEOF

    echo ""
    echo -e "${VERDE}Músicas de '$artista' do gênero '$genero' foram baixadas!${RESET}"
    echo -e "${CYAN}Pasta de destino: ${output_dir}${RESET}"
    echo ""
}

# ============================================================================
# FUNÇÃO: Baixar álbum completo
# ============================================================================
baixar_album() {
    local genero="$1"
    local artista="$2"
    local album="$3"
    local output_dir="$DOWNLOAD_BASE/$genero/$album"

    mkdir -p "$output_dir"

    echo ""
    echo -e "${AZUL}Preparando download do álbum: ${artista} - $album${RESET}"
    echo ""

    # Buscar o álbum no YouTube
    python3 << PYEOF
import yt_dlp
import os

search_query = "ytsearch1:${artista} ${album} official album"
output_dir = "${output_dir}"
bitrate = "${BITRATE_MUSICA}"
max_musicas = ${MAX_MUSICAS}

ydl_opts = {
    'format': 'bestaudio/best',
    'postprocessors': [{
        'key': 'FFmpegExtractAudio',
        'preferredcodec': 'mp3',
        'preferredquality': bitrate.replace('k', ''),
    }, {
        'key': 'FFmpegMetadata',
    }, {
        'key': 'EmbedThumbnail',
    }],
    'outtmpl': os.path.join(output_dir, '%(title)s.%(ext)s'),
    'quiet': False,
    'no_warnings': False,
    'embedthumbnail': True,
    'writethumbnail': True,
    'addmetadata': True,
    'noplaylist': False,
    'extract_flat': False,
    'playlistend': max_musicas,
}

try:
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([f'ytsearch50:{search_query}'])
except Exception as e:
    print(f"Erro: {e}")
PYEOF

    echo ""
    echo -e "${VERDE}Álbum '$album' foi baixado com sucesso!${RESET}"
    echo -e "${CYAN}Pasta de destino: ${output_dir}${RESET}"
    echo ""
}

# ============================================================================
# FUNÇÃO: Buscar por artista
# ============================================================================
buscar_artista() {
    echo -e "${CYAN}Digite o nome do artista ou DJ:${RESET}"
    read -p "> " artista

    if [ -z "$artista" ]; then
        echo -e "${VERMELH}Nome do artista não informado.${RESET}"
        return
    fi

    echo ""
    listar_generos
    read -p "Escolha o gênero (1-11): " gen_choice

    case $gen_choice in
        1) genero="Sertanejo" ;;
        2) genero="Hip Hop" ;;
        3) genero="Pop" ;;
        4) genero="Rock" ;;
        5) genero="Funk" ;;
        6) genero="Pagode" ;;
        7) genero="Jazz" ;;
        8) genero="Clássico" ;;
        9) genero="MPB" ;;
        10) genero="Eletrônica" ;;
        *) genero="Outros"; read -p "Digite o gênero personalizado: " genero ;;
    esac

    echo ""
    read -p "Quer baixar álbum específico? (s/n/Enter=pular): " tem_album

    if [[ "$tem_album" =~ ^[sS]$ ]]; then
        read -p "Nome do álbum: " album
        baixar_album "$genero" "$artista" "$album"
    else
        baixar_por_genero "$genero" "$artista"
    fi
}

# ============================================================================
# FUNÇÃO: Opção de download rápido
# ============================================================================
download_rapido() {
    echo -e "${CYAN}Digite a URL do YouTube ou termo de busca:${RESET}"
    read -p "> " url_ou_busca

    if [ -z "$url_ou_busca" ]; then
        echo -e "${VERMELHO}URL ou termo de busca não informado.${RESET}"
        return
    fi

    # Determinar se é URL
    if [[ "$url_ou_busca" =~ ^https?:// ]]; then
        # É uma URL
        echo ""
        read -p "Qual gênero? (1=Sertanejo, 2= Hip Hop, etc): " gen_choice
        case $gen_choice in
            1) genero="Sertanejo" ;;
            2) genero="Hip Hop" ;;
            3) genero="Pop" ;;
            4) genero="Rock" ;;
            5) genero="Funk" ;;
            6) genero="Pagode" ;;
            7) genero="Jazz" ;;
            8) genero="Clássico" ;;
            9) genero="MPB" ;;
            10) genero="Eletrônica" ;;
            *) genero="Outros" ;;
        esac

        local output_dir="$DOWNLOAD_BASE/$genero"
        mkdir -p "$output_dir"

        python3 << PYEOF
import yt_dlp
import os

url = "${url_ou_busca}"
output_dir = "${output_dir}"
bitrate = "${BITRATE_MUSICA}"
max_musicas = ${MAX_MUSICAS}

ydl_opts = {
    'format': 'bestaudio/best',
    'postprocessors': [{
        'key': 'FFmpegExtractAudio',
        'preferredcodec': 'mp3',
        'preferredquality': bitrate.replace('k', ''),
    }, {
        'key': 'FFmpegMetadata',
    }, {
        'key': 'EmbedThumbnail',
    }],
    'outtmpl': os.path.join(output_dir, '%(title)s.%(ext)s'),
    'quiet': False,
    'no_warnings': False,
    'embedthumbnail': True,
    'writethumbnail': True,
    'addmetadata': True,
    'playlistend': max_musicas,
}

try:
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])
except Exception as e:
    print(f"Erro: {e}")
PYEOF

        echo ""
        echo -e "${VERDE}✓ Download concluído!${RESET}"
        echo -e "${CYAN}Salvo em: ${output_dir}${RESET}"
    else
        echo -e "${VERMELHO}Opção inválida.${RESET}"
    fi
}

# ============================================================================
# FUNÇÃO: Mostrar status de downloads
# ============================================================================
mostrar_status() {
    echo ""
    echo -e "${AZUL}============================================${RESET}"
    echo -e "${AZUL}        STATUS DOS DOWNLOADS                 ${RESET}"
    echo -e "${AZUL}============================================${RESET}"
    echo ""

    if [ ! -d "$DOWNLOAD_BASE" ]; then
        echo -e "${AMARELO}Nenhum download realizado ainda.${RESET}"
        return
    fi

    # Contar arquivos por gênero
    for dir in "$DOWNLOAD_BASE"/*/; do
        if [ -d "$dir" ]; then
            local nome=$(basename "$dir")
            local count=$(find "$dir" -name "*.mp3" 2>/dev/null | wc -l)
            echo -e "${CYAN}$nome:${RESET} $count músicas"
        fi
    done

    echo ""
}

# ============================================================================
# FUNÇÃO: Limpar downloads
# ============================================================================
limpar_downloads() {
    echo -e "${VERMELHO}ATENÇÃO: Isso vai excluir todos os arquivos baixados!${RESET}"
    read -p "Tem certeza? (s/n): " confirm

    if [[ "$confirm" =~ ^[sS]$ ]]; then
        rm -rf "$DOWNLOAD_BASE"/*
        echo -e "${VERDE}Downloads limpos com sucesso!${RESET}"
    fi
}

# ============================================================================
# FUNÇÃO: Mostrar caminho dos downloads
# ============================================================================
mostrar_caminho() {
    echo ""
    echo -e "${AZUL}============================================${RESET}"
    echo -e "${AZUL}        CAMINHO DOS ARQUIVOS                  ${RESET}"
    echo -e "${AZUL}============================================${RESET}"
    echo ""
    echo -e "${CYAN}Pasta principal:${RESET} $DOWNLOAD_BASE"
    echo ""
    echo -e "${CYAN}Estrutura:${RESET}"
    ls -la "$DOWNLOAD_BASE" 2>/dev/null || echo -e "${AMARELO} (Pasta vazia ou inexistente)${RESET}"
    echo ""
}

# ============================================================================
# FUNÇÃO: Menu de configurações
# ============================================================================
menu_configuracoes() {
    while true; do
        echo ""
        echo -e "${CYAN}============================================${RESET}"
        echo -e "${CYAN}           CONFIGURAÇÕES                    ${RESET}"
        echo -e "${CYAN}============================================${RESET}"
        echo ""
        echo -e "  ${AMARELO}1)${RESET} Escolher bitrate do MP3 (atual: ${BITRATE_MUSICA})"
        echo -e "  ${AMARELO}2)${RESET} Escolher máximo de músicas (atual: ${MAX_MUSICAS})"
        echo -e "  ${AMARELO}0)${RESET} Voltar"
        echo ""
        read -p "Escolha uma opção: " cfg_opcao

        case $cfg_opcao in
            1) escolher_bitrate ;;
            2) escolher_max_musicas ;;
            0) break ;;
            *) echo -e "${VERMELHO}Opção inválida!${RESET}" ;;
        esac
    done
}

# ============================================================================
# MENU PRINCIPAL
# ============================================================================
menu_principal() {
    while true; do
        mostrar_banner
        echo -e "${BRANCO}Menu Principal:${RESET}"
        echo -e "  ${AMARELO}1)${RESET} Pesquisar por artista"
        echo -e "  ${AMARELO}2)${RESET} Download rápido (URL)"
        echo -e "  ${AMARELO}3)${RESET} Baixar por gênero"
        echo -e "  ${AMARELO}4)${RESET} Mostrar status de downloads"
        echo -e "  ${AMARELO}5)${RESET} Mostrar caminho dos arquivos"
        echo -e "  ${AMARELO}6)${RESET} Configurar opções"
        echo -e "  ${AMARELO}7)${RESET} Limpar downloads"
        echo -e "  ${AMARELO}0)${RESET} Sair"
        echo ""

        read -p "Escolha uma opção: " opcao

        case $opcao in
            1) buscar_artista ;;
            2) download_rapido ;;
            3)
                listar_generos
                read -p "Escolha o gênero (1-11): " gen_choice
                case $gen_choice in
                    1) baixar_por_genero "Sertanejo" "Artista Sertanejo" ;;
                    2) baixar_por_genero "Hip Hop" "Artista Hip Hop" ;;
                    3) baixar_por_genero "Pop" "Artista Pop" ;;
                    4) baixar_por_genero "Rock" "Artista Rock" ;;
                    5) baixar_por_genero "Funk" "Artista Funk" ;;
                    6) baixar_por_genero "Pagode" "Artista Pagode" ;;
                    7) baixar_por_genero "Jazz" "Artista Jazz" ;;
                    8) baixar_por_genero "Clássico" "Artista Clássico" ;;
                    9) baixar_por_genero "MPB" "Artista MPB" ;;
                    10) baixar_por_genero "Eletrônica" "Artista Eletrônica" ;;
                    *)
                        read -p "Digite o gênero personalizado: " genero
                        read -p "Digite o nome do artista: " artista
                        baixar_por_genero "$genero" "$artista"
                        ;;
                esac
                ;;
            4) mostrar_status ;;
            5) mostrar_caminho ;;
            6) menu_configuracoes ;;
            7) limpar_downloads ;;
            0)
                echo ""
                echo -e "${VERDE}Obrigado por usar o BAIXADOR DE CD!${RESET}"
                echo -e "${CYAN}Arquivos salvos em: ${DOWNLOAD_BASE}${RESET}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${VERMELHO}Opção inválida!${RESET}"
                read -p "Pressione Enter para continuar..."
                ;;
        esac
    done
}

# ============================================================================
# INÍCIO DO SCRIPT
# ============================================================================
inicializar
carregar_prefs
mostrar_banner
menu_principal