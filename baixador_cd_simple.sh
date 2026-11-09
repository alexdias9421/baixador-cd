#!/bin/bash
clear

# Cores
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[1;31m'
AZUL='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

# Pastas
DOWNLOAD_BASE="/sdcard/Download/CDs_BAIXADOS"
PREFS_FILE="$HOME/.config/baixador_cd/prefs.conf"
mkdir -p "$HOME/.config/baixador_cd"
mkdir -p "$DOWNLOAD_BASE"

# Carregar preferencias
BITRATE_MUSICA="320k"
[ -f "$PREFS_FILE" ] && source "$PREFS_FILE"

# Banner
echo ""
figlet -f slant "BAIXADOR CD" 2>/dev/null || echo "   _____ _____   ____  _   _ ______ _____   _____ _   _ ______ _____ "
echo -e "${MAGENTA}============================================${RESET}"
echo -e "${MAGENTA}    Download de CD por Genero Musical       ${RESET}"
echo -e "${MAGENTA}============================================${RESET}"
echo ""

mostrar_menu() {
    echo -e "${CYAN}Menu:${RESET}"
    echo -e "  ${AMARELO}1)${RESET} Pesquisar por artista"
    echo -e "  ${AMARELO}2)${RESET} Download rapido (URL)"
    echo -e "  ${AMARELO}3)${RESET} Baixar por genero"
    echo -e "  ${AMARELO}4)${RESET} Mostrar status"
    echo -e "  ${AMARELO}5)${RESET} Mostrar caminho"
    echo -e "  ${AMARELO}6)${RESET} Configurar bitrate"
    echo -e "  ${AMARELO}0)${RESET} Sair"
}

listar_generos() {
    echo ""
    echo -e "${CYAN}Generos:${RESET}"
    echo "  1) Sertanejo  | 2) Hip Hop | 3) Pop | 4) Rock"
    echo "  5) Funk       | 6) Pagode  | 7) Jazz| 8) Classico"
    echo "  9) MPB        | 10) Eletronica | 11) Outro"
}

escolher_bitrate() {
    echo ""
    echo -e "${CYAN}Bitrate MP3:${RESET}"
    echo "  1) 128k | 2) 192k | 3) 256k | 4) 320k"
    read -p "> " b
    case $b in
        1) BITRATE_MUSICA="128k" ;;
        2) BITRATE_MUSICA="192k" ;;
        3) BITRATE_MUSICA="256k" ;;
        *) BITRATE_MUSICA="320k" ;;
    esac
    echo "BITRATE_MUSICA=\"$BITRATE_MUSICA\"" > "$PREFS_FILE"
    echo -e "${VERDE}Bitrate alterado: $BITRATE_MUSICA${RESET}"
}

baixar_musicas() {
    local genero="$1"
    local artista="$2"
    local output_dir="$DOWNLOAD_BASE/$genero"
    mkdir -p "$output_dir"

    echo ""
    echo -e "${AZUL}Baixando: $artista ($genero)${RESET}"
    echo -e "${CYAN}Pasta: $output_dir${RESET}"
    echo ""

    yt-dlp -f "bestaudio/best" --extract-audio --audio-format mp3 \
        --audio-quality "$BITRATE_MUSICA" --embed-thumbnail --add-metadata \
        -o "$output_dir/%(title)s.%(ext)s" "ytsearch50:${artista} ${genero} music"

    echo ""
    echo -e "${VERDE}Pronto! Salvo em: $output_dir${RESET}"
}

# Loop principal
while true; do
    echo ""
    mostrar_menu
    read -p "Escolha> " op

    case $op in
        1)
            read -p "Artista/DJ: " artist
            listar_generos
            read -p "Genero (1-11): " g
            case $g in
                1) baixar_musicas "Sertanejo" "$artist" ;;
                2) baixar_musicas "Hip Hop" "$artist" ;;
                3) baixar_musicas "Pop" "$artist" ;;
                4) baixar_musicas "Rock" "$artist" ;;
                5) baixar_musicas "Funk" "$artist" ;;
                6) baixar_musicas "Pagode" "$artist" ;;
                7) baixar_musicas "Jazz" "$artist" ;;
                8) baixar_musicas "Classico" "$artist" ;;
                9) baixar_musicas "MPB" "$artist" ;;
                10) baixar_musicas "Eletronica" "$artist" ;;
                *) read -p "Genero: " gen; baixar_musicas "$gen" "$artist" ;;
            esac
            ;;
        2)
            read -p "URL YouTube ou busca: " url
            listar_generos
            read -p "Genero: " g
            case $g in
                1) baixar_musicas "Sertanejo" "$url" ;;
                2) baixar_musicas "Hip Hop" "$url" ;;
                3) baixar_musicas "Pop" "$url" ;;
                4) baixar_musicas "Rock" "$url" ;;
                5) baixar_musicas "Funk" "$url" ;;
                6) baixar_musicas "Pagode" "$url" ;;
                7) baixar_musicas "Jazz" "$url" ;;
                8) baixar_musicas "Classico" "$url" ;;
                9) baixar_musicas "MPB" "$url" ;;
                10) baixar_musicas "Eletronica" "$url" ;;
                *) baixar_musicas "Outros" "$url" ;;
            esac
            ;;
        3)
            listar_generos
            read -p "Genero: " g
            case $g in
                1) baixar_musicas "Sertanejo" "Top Sertanejo" ;;
                2) baixar_musicas "Hip Hop" "Top Hip Hop" ;;
                3) baixar_musicas "Pop" "Top Pop" ;;
                4) baixar_musicas "Rock" "Top Rock" ;;
                5) baixar_musicas "Funk" "Top Funk" ;;
                6) baixar_musicas "Pagode" "Top Pagode" ;;
                7) baixar_musicas "Jazz" "Top Jazz" ;;
                8) baixar_musicas "Classico" "Top Classico" ;;
                9) baixar_musicas "MPB" "Top MPB" ;;
                10) baixar_musicas "Eletronica" "Top Eletronica" ;;
                *) read -p "Nome do artista: " a; baixar_musicas "Outros" "$a" ;;
            esac
            ;;
        4)
            echo ""
            echo -e "${CYAN}Estatisticas:${RESET}"
            find "$DOWNLOAD_BASE" -name "*.mp3" 2>/dev/null | wc -l | xargs echo "Total de MP3s:"
            ;;
        5)
            echo ""
            echo -e "${VERDE}Caminho: $DOWNLOAD_BASE${RESET}"
            ls -la "$DOWNLOAD_BASE" 2>/dev/null
            ;;
        6) escolher_bitrate ;;
        0) echo -e "${VERDE}Saindo...${RESET}"; exit 0 ;;
        *) echo -e "${VERMELHO}Opcao invalida${RESET}" ;;
    esac
done