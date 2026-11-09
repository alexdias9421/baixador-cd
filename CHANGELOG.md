# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-11-09

### ✅ Added
- **Dance Genre**: Added Dance as the 7th genre for electronic/dance music downloads
- **Year Search**: New functionality to search music by year (e.g., "2023", "2024")
- **12 Genres Total**: Full list now includes:
  - Sertanejo
  - Hip Hop
  - Pop
  - Rock
  - Funk
  - Pagode
  - **Dance** (new!)
  - Jazz
  - Clássico
  - MPB
  - Eletrônica
  - Outro (personalizado)

### 🎵 Audio Features
- MP3 download with **cover art embedding** (thumbnails)
- Configurable **bitrate**: 128k, 192k, 256k, 320k
- Automatic bitrate persistence between sessions

### 🎨 Visual Features
- **ASCII Art Banner** with figlet
- Clean, colorful terminal interface
- Progress indicators during downloads

### 📂 Organization
- Automatic genre-based folder structure
- Downloads saved to: `/sdcard/Download/CDs_BAIXADOS/`
- Shows download path after completion

### 🖥 Menu Options
1. Pesquisar por artista - Search by artist/DJ name
2. Download rápido - Quick download from URL
3. Baixar por gênero - Download top hits by genre
4. **Buscar por ano** - NEW! Find music from specific year
5. Mostrar status - View download statistics
6. Mostrar caminho - Show download location
7. Configurar opções - Adjust settings
0. Sair - Exit the script

### 🚀 Installation
- Single-command installer: `bash instalar.sh`
- Creates `baixador-cd` command in `~/.local/bin`
- Auto-adds to PATH in `.bashrc`
- Installs all dependencies: ffmpeg, figlet, python, yt-dlp, mutagen

### 📝 Documentation
- Complete README with usage examples
- Menu screenshots
- Genre listing
- Configuration guide

### 🔧 Technical Details
- Uses yt-dlp for YouTube searching and downloading
- FFmpeg for audio extraction and thumbnail embedding
- mutagen for metadata handling
- Python3 integration for advanced features