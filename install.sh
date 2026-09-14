#!/bin/bash
set -e
# ============================================================
# ZELIX OFFC - Installer Panel Pterodactyl
# Usage: bash <(curl -s https://raw.githubusercontent.com/USER/REPO/main/install.sh)
# ============================================================

# Reset
NC='\033[0m'

# Style
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
HIDDEN='\033[8m'

# Foreground
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

BRIGHT_BLACK='\033[90m'
BRIGHT_RED='\033[91m'
BRIGHT_GREEN='\033[92m'
BRIGHT_YELLOW='\033[93m'
BRIGHT_BLUE='\033[94m'
BRIGHT_MAGENTA='\033[95m'
BRIGHT_CYAN='\033[96m'
BRIGHT_WHITE='\033[97m'

# Background
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

BG_BRIGHT_BLACK='\033[100m'
BG_BRIGHT_RED='\033[101m'
BG_BRIGHT_GREEN='\033[102m'
BG_BRIGHT_YELLOW='\033[103m'
BG_BRIGHT_BLUE='\033[104m'
BG_BRIGHT_MAGENTA='\033[105m'
BG_BRIGHT_CYAN='\033[106m'
BG_BRIGHT_WHITE='\033[107m'

if [ "$EUID" -ne 0 ]; then
  echo -e "\n  ${BG_RED}${BRIGHT_WHITE}${BOLD} ERROR ${NC} ${BOLD}Akses Ditolak! Skrip ini wajib dijalankan sebagai root.${NC}\n"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=1

log_info() {
  echo -e "${BOLD}${CYAN}$1${NC}"
}

log_success() {
  echo -e "${BOLD}${GREEN}$1${NC}"
}

log_error() {
  echo -e "${BOLD}${RED}$1${NC}"
}

print_info() {
  echo -e "\n  ${BG_BLUE}${BRIGHT_WHITE}${BOLD} INFO ${NC} ${BOLD}$1${NC}\n"
}

print_success() {
  echo -e "\n  ${BG_GREEN}${BRIGHT_WHITE}${BOLD} SUCCESS ${NC} ${BOLD}$1${NC}\n"
}

print_warning() {
  echo -e "\n  ${BG_YELLOW}${BRIGHT_WHITE}${BOLD} WARNING ${NC} ${BOLD}$1${NC}\n"
}

print_error() {
  echo -e "\n  ${BG_RED}${BRIGHT_WHITE}${BOLD} ERROR ${NC} ${BOLD}$1${NC}\n"
}

print_banner() {
  local title="$1"
  local border_color="${2:-$BLUE}"
  local text_style="${3:-$border_color}"
  local width=50
  local char="="

  local border=$(printf '%*s' "$width" "")
  border=${border// /$char}
  local title_len=${#title}
  local pad_len=$(( (width - title_len) / 2 ))
  local pad_left=$(printf '%*s' "$pad_len" "")
  local pad_right=$(printf '%*s' $((width - title_len - pad_len)) "")

  echo -e "\n${BOLD}${border_color}[+] ${border} [+]${NC}"
  echo -e "${BOLD}${border_color}[+]${NC} ${text_style}${pad_left}${title}${pad_right}${NC} ${BOLD}${border_color}[+]${NC}"
  echo -e "${BOLD}${border_color}[+] ${border} [+]\n${NC}"
}

print_logo() {
  echo -e "\n  "
  echo -e "${BOLD}${CYAN}        _,gggggggggg.${NC}"
  echo -e "${BOLD}${CYAN}    ,ggggggggggggggggg.${NC}"
  echo -e "${BOLD}${CYAN}  ,ggggg        gggggggg.${NC}"
  echo -e "${BOLD}${CYAN} ,ggg'               'ggg.${NC}"
  echo -e "${BOLD}${CYAN}',gg       ,ggg.      'ggg:${NC}"
  echo -e "${BOLD}${CYAN}'ggg      ,gg'''  .    ggg${NC}     ${BOLD}${BLUE}ZELIX OFFC${NC}"
  echo -e "${BOLD}${CYAN}gggg      gg     ,    ggg${NC}      ${BOLD}${BLUE}Installer Panel Pterodactyl${NC}"
  echo -e "${BOLD}${CYAN}ggg:     gg.     -   ,ggg${NC}     ${BOLD}${GREEN}----------------------------------${NC}"
  echo -e "${BOLD}${CYAN} ggg:     ggg._    _,ggg${NC}"
  echo -e "${BOLD}${CYAN} ggg.    '.'''ggggggp${NC}"
  echo -e "${BOLD}${CYAN}  'ggg    '-.__${NC}"
  echo -e "${BOLD}${CYAN}    ggg${NC}"
  echo -e "${BOLD}${CYAN}      ggg${NC}"
  echo -e "${BOLD}${CYAN}        ggg.${NC}"
  echo -e "${BOLD}${CYAN}          ggg.${NC}"
  echo -e "${BOLD}${CYAN}             b.${NC}"
  echo -e "  "
}

start_script() {
  clear
  echo -e ""
  echo -e "${BOLD}${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BOLD}${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BOLD}${BLUE}[+]                 ZELIX OFFC                      [+]${NC}"
  echo -e "${BOLD}${BLUE}[+]          Installer Panel Pterodactyl            [+]${NC}"
  echo -e "${BOLD}${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BOLD}${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "Script untuk import eggs (Python/NodeJS) dan create node auto hijau."
  echo -e ""
  sleep 1
}

# ============================================================
# 1. IMPORT EGGS (Python + NodeJS)
# ============================================================
import_eggs() {
  print_banner "IMPORT EGGS" "$CYAN" "${BG_CYAN}${BRIGHT_WHITE}${BOLD}"

  if [ ! -d "/var/www/pterodactyl" ]; then
    print_error "Panel Pterodactyl tidak ditemukan di /var/www/pterodactyl"
    sleep 2
    return 1
  fi

  print_info "Menyiapkan file eggs..."
  mkdir -p /tmp/ptero-eggs
  rm -f /tmp/ptero-eggs/*.json

  echo 'ewogICAgIl9jb21tZW50IjogIkRPIE5PVCBFRElUOiBGSUxFIEdFTkVSQVRFRCBBVVRPTUFUSUNBTExZIEJZIFBURVJPREFDVFlMIFBBTkVMIC0gUFRFUk9EQUNUWUwuSU8iLAogICAgIm1ldGEiOiB7CiAgICAgICAgInZlcnNpb24iOiAiUFRETF92MiIsCiAgICAgICAgInVwZGF0ZV91cmwiOiBudWxsCiAgICB9LAogICAgImV4cG9ydGVkX2F0IjogIjIwMjUtMTItMDJUMDc6MDQ6NDIrMDc6MDAiLAogICAgIm5hbWUiOiAicHl0aG9uIGdlbmVyaWMiLAogICAgImF1dGhvciI6ICJndWRlbDAyM0BtYWlsLmNvIiwKICAgICJkZXNjcmlwdGlvbiI6ICJBIEdlbmVyaWMgUHl0aG9uIEVnZyBmb3IgUHRlcm9kYWN0eWxcclxuXHJcblRlc3RlZCB3aXRoOiBodHRwczpcL1wvZ2l0aHViLmNvbVwvSXNwaXJhXC9waXhlbC1ib3QiLAogICAgImZlYXR1cmVzIjogbnVsbCwKICAgICJkb2NrZXJfaW1hZ2VzIjogewogICAgICAgICJQeXRob24gMy4xMyI6ICJnaGNyLmlvXC9wdGVyby1lZ2dzXC95b2xrczpweXRob25fMy4xMyIsCiAgICAgICAgIlB5dGhvbiAzLjEyIjogImdoY3IuaW9cL3B0ZXJvLWVnZ3NcL3lvbGtzOnB5dGhvbl8zLjEyIiwKICAgICAgICAiUHl0aG9uIDMuMTEiOiAiZ2hjci5pb1wvcHRlcm8tZWdnc1wveW9sa3M6cHl0aG9uXzMuMTEiLAogICAgICAgICJQeXRob24gMy4xMCI6ICJnaGNyLmlvXC9wdGVyby1lZ2dzXC95b2xrczpweXRob25fMy4xMCIsCiAgICAgICAgIlB5dGhvbiAzLjkiOiAiZ2hjci5pb1wvcHRlcm8tZWdnc1wveW9sa3M6cHl0aG9uXzMuOSIsCiAgICAgICAgIlB5dGhvbiAzLjgiOiAiZ2hjci5pb1wvcHRlcm8tZWdnc1wveW9sa3M6cHl0aG9uXzMuOCIsCiAgICAgICAgIlB5dGhvbiAzLjciOiAiZ2hjci5pb1wvcHRlcm8tZWdnc1wveW9sa3M6cHl0aG9uXzMuNyIsCiAgICAgICAgIlB5dGhvbiAyLjciOiAiZ2hjci5pb1wvcHRlcm8tZWdnc1wveW9sa3M6cHl0aG9uXzIuNyIKICAgIH0sCiAgICAiZmlsZV9kZW55bGlzdCI6IFtdLAogICAgInN0YXJ0dXAiOiAiaWYgW1sgLWQgLmdpdCBdXSAmJiBbWyBcInt7QVVUT19VUERBVEV9fVwiID09IFwiMVwiIF1dOyB0aGVuIGdpdCBwdWxsOyBmaTsgaWYgW1sgISAteiBcInt7UFlfUEFDS0FHRVN9fVwiIF1dOyB0aGVuIHBpcCBpbnN0YWxsIC1VIC0tcHJlZml4IC5sb2NhbCB7e1BZX1BBQ0tBR0VTfX07IGZpOyBpZiBbWyAtZiBcL2hvbWVcL2NvbnRhaW5lclwvJHtSRVFVSVJFTUVOVFNfRklMRX0gXV07IHRoZW4gcGlwIGluc3RhbGwgLVUgLS1wcmVmaXggLmxvY2FsIC1yICR7UkVRVUlSRU1FTlRTX0ZJTEV9OyBmaTsgXC91c3JcL2xvY2FsXC9iaW5cL3B5dGhvbiBcL2hvbWVcL2NvbnRhaW5lclwve3tQWV9GSUxFfX0iLAogICAgImNvbmZpZyI6IHsKICAgICAgICAiZmlsZXMiOiAie30iLAogICAgICAgICJzdGFydHVwIjogIntcclxuICAgIFwiZG9uZVwiOiBcImd1ZGVsMDIzXCJcclxufSIsCiAgICAgICAgImxvZ3MiOiAie30iLAogICAgICAgICJzdG9wIjogIl5DIgogICAgfSwKICAgICJzY3JpcHRzIjogewogICAgICAgICJpbnN0YWxsYXRpb24iOiB7CiAgICAgICAgICAgICJzY3JpcHQiOiAiIyFcL2JpblwvYmFzaFxyXG4jIFB5dGhvbiBBcHAgSW5zdGFsbGF0aW9uIFNjcmlwdFxyXG4jXHJcbiMgU2VydmVyIEZpbGVzOiBcL21udFwvc2VydmVyXHJcbmFwdCB1cGRhdGVcclxuYXB0IGluc3RhbGwgLXkgZ2l0IGN1cmwganEgZmlsZSB1bnppcCBtYWtlIGdjYyBnKysgbGlidG9vbFxyXG5cclxubWtkaXIgLXAgXC9tbnRcL3NlcnZlclxyXG5jZCBcL21udFwvc2VydmVyXHJcblxyXG5pZiBbIFwiJHtVU0VSX1VQTE9BRH1cIiA9PSBcInRydWVcIiBdIHx8IFsgXCIke1VTRVJfVVBMT0FEfVwiID09IFwiMVwiIF07IHRoZW5cclxuICAgIGVjaG8gLWUgXCJhc3N1bWluZyB1c2VyIGtub3dzIHdoYXQgdGhleSBhcmUgZG9pbmcgaGF2ZSBhIGdvb2QgZGF5LlwiXHJcbiAgICBleGl0IDBcclxuZmlcclxuXHJcbiMjIGFkZCBnaXQgZW5kaW5nIGlmIGl0J3Mgbm90IG9uIHRoZSBhZGRyZXNzXHJcbmlmIFtbICR7R0lUX0FERFJFU1N9ICE9ICouZ2l0IF1dOyB0aGVuXHJcbiAgICBHSVRfQUREUkVTUz0ke0dJVF9BRERSRVNTfS5naXRcclxuZmlcclxuXHJcbmlmIFsgLXogXCIke1VTRVJOQU1FfVwiIF0gJiYgWyAteiBcIiR7QUNDRVNTX1RPS0VOfVwiIF07IHRoZW5cclxuICAgIGVjaG8gLWUgXCJ1c2luZyBhbm9uIGFwaSBjYWxsXCJcclxuZWxzZVxyXG4gICAgR0lUX0FERFJFU1M9XCJodHRwczpcL1wvJHtVU0VSTkFNRX06JHtBQ0NFU1NfVE9LRU59QCQoZWNobyAtZSAke0dJVF9BRERSRVNTfSB8IGN1dCAtZFwvIC1mMy0pXCJcclxuZmlcclxuXHJcbiMjIHB1bGwgZ2l0IHB5dGhvbiByZXBvXHJcbmlmIFsgXCIkKGxzIC1BIFwvbW50XC9zZXJ2ZXIpXCIgXTsgdGhlblxyXG4gICAgZWNobyAtZSBcIlwvbW50XC9zZXJ2ZXIgZGlyZWN0b3J5IGlzIG5vdCBlbXB0eS5cIlxyXG4gICAgaWYgWyAtZCAuZ2l0IF07IHRoZW5cclxuICAgICAgICBlY2hvIC1lIFwiLmdpdCBkaXJlY3RvcnkgZXhpc3RzXCJcclxuICAgICAgICBpZiBbIC1mIC5naXRcL2NvbmZpZyBdOyB0aGVuXHJcbiAgICAgICAgICAgIGVjaG8gLWUgXCJsb2FkaW5nIGluZm8gZnJvbSBnaXQgY29uZmlnXCJcclxuICAgICAgICAgICAgT1JJR0lOPSQoZ2l0IGNvbmZpZyAtLWdldCByZW1vdGUub3JpZ2luLnVybClcclxuICAgICAgICBlbHNlXHJcbiAgICAgICAgICAgIGVjaG8gLWUgXCJmaWxlcyBmb3VuZCB3aXRoIG5vIGdpdCBjb25maWdcIlxyXG4gICAgICAgICAgICBlY2hvIC1lIFwiY2xvc2luZyBvdXQgd2l0aG91dCB0b3VjaGluZyB0aGluZ3MgdG8gbm90IGJyZWFrIGFueXRoaW5nXCJcclxuICAgICAgICAgICAgZXhpdCAxMFxyXG4gICAgICAgIGZpXHJcbiAgICBmaVxyXG5cclxuICAgIGlmIFsgXCIke09SSUdJTn1cIiA9PSBcIiR7R0lUX0FERFJFU1N9XCIgXTsgdGhlblxyXG4gICAgICAgIGVjaG8gXCJwdWxsaW5nIGxhdGVzdCBmcm9tIGdpdGh1YlwiXHJcbiAgICAgICAgZ2l0IHB1bGxcclxuICAgIGZpXHJcbmVsc2VcclxuICAgIGVjaG8gLWUgXCJcL21udFwvc2VydmVyIGlzIGVtcHR5LlxcbmNsb25pbmcgZmlsZXMgaW50byByZXBvXCJcclxuICAgIGlmIFsgLXogJHtCUkFOQ0h9IF07IHRoZW5cclxuICAgICAgICBlY2hvIC1lIFwiY2xvbmluZyBkZWZhdWx0IGJyYW5jaFwiXHJcbiAgICAgICAgZ2l0IGNsb25lICR7R0lUX0FERFJFU1N9IC5cclxuICAgIGVsc2VcclxuICAgICAgICBlY2hvIC1lIFwiY2xvbmluZyAke0JSQU5DSH0nXCJcclxuICAgICAgICBnaXQgY2xvbmUgLS1zaW5nbGUtYnJhbmNoIC0tYnJhbmNoICR7QlJBTkNIfSAke0dJVF9BRERSRVNTfSAuXHJcbiAgICBmaVxyXG5cclxuZmlcclxuXHJcbmV4cG9ydCBIT01FPVwvbW50XC9zZXJ2ZXJcclxuXHJcbmVjaG8gXCJJbnN0YWxsaW5nIHB5dGhvbiByZXF1aXJlbWVudHMgaW50byBmb2xkZXJcIlxyXG5pZiBbWyAhIC16ICR7UFlfUEFDS0FHRVN9IF1dOyB0aGVuXHJcbiAgICBwaXAgaW5zdGFsbCAtVSAtLXByZWZpeCAubG9jYWwgJHtQWV9QQUNLQUdFU31cclxuZmlcclxuXHJcbmlmIFsgLWYgXC9tbnRcL3NlcnZlclwvcmVxdWlyZW1lbnRzLnR4dCBdOyB0aGVuXHJcbiAgICBwaXAgaW5zdGFsbCAtVSAtLXByZWZpeCAubG9jYWwgLXIgJHtSRVFVSVJFTUVOVFNfRklMRX1cclxuZmlcclxuXHJcbmVjaG8gLWUgXCJpbnN0YWxsIGNvbXBsZXRlXCJcclxuZXhpdCAwIiwKICAgICAgICAgICAgImNvbnRhaW5lciI6ICJweXRob246My44LXNsaW0tYm9va3dvcm0iLAogICAgICAgICAgICAiZW50cnlwb2ludCI6ICJiYXNoIgogICAgICAgIH0KICAgIH0sCiAgICAidmFyaWFibGVzIjogWwogICAgICAgIHsKICAgICAgICAgICAgIm5hbWUiOiAiR2l0IFJlcG8gQWRkcmVzcyIsCiAgICAgICAgICAgICJkZXNjcmlwdGlvbiI6ICJHaXQgcmVwbyB0byBjbG9uZVxyXG5cclxuSS5FLiBodHRwczpcL1wvZ2l0aHViLmNvbVwvcGFya2VydmNwXC9yZXBvX25hbWUiLAogICAgICAgICAgICAiZW52X3ZhcmlhYmxlIjogIkdJVF9BRERSRVNTIiwKICAgICAgICAgICAgImRlZmF1bHRfdmFsdWUiOiAiIiwKICAgICAgICAgICAgInVzZXJfdmlld2FibGUiOiB0cnVlLAogICAgICAgICAgICAidXNlcl9lZGl0YWJsZSI6IHRydWUsCiAgICAgICAgICAgICJydWxlcyI6ICJudWxsYWJsZXxzdHJpbmciLAogICAgICAgICAgICAiZmllbGRfdHlwZSI6ICJ0ZXh0IgogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgICAibmFtZSI6ICJHaXQgQnJhbmNoIiwKICAgICAgICAgICAgImRlc2NyaXB0aW9uIjogIldoYXQgYnJhbmNoIHRvIHB1bGwgZnJvbSBnaXRodWIuXHJcblxyXG5EZWZhdWx0IGlzIGJsYW5rIHRvIHB1bGwgdGhlIHJlcG8gZGVmYXVsdCBicmFuY2giLAogICAgICAgICAgICAiZW52X3ZhcmlhYmxlIjogIkJSQU5DSCIsCiAgICAgICAgICAgICJkZWZhdWx0X3ZhbHVlIjogIiIsCiAgICAgICAgICAgICJ1c2VyX3ZpZXdhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInVzZXJfZWRpdGFibGUiOiB0cnVlLAogICAgICAgICAgICAicnVsZXMiOiAibnVsbGFibGV8c3RyaW5nIiwKICAgICAgICAgICAgImZpZWxkX3R5cGUiOiAidGV4dCIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgIm5hbWUiOiAiVXNlciBVcGxvYWRlZCBGaWxlcyIsCiAgICAgICAgICAgICJkZXNjcmlwdGlvbiI6ICJTa2lwIGFsbCB0aGUgaW5zdGFsbCBzdHVmZiBpZiB5b3UgYXJlIGxldHRpbmcgYSB1c2VyIHVwbG9hZCBmaWxlcy5cclxuXHJcbjAgPSBmYWxzZSAoZGVmYXVsdClcclxuMSA9IHRydWUiLAogICAgICAgICAgICAiZW52X3ZhcmlhYmxlIjogIlVTRVJfVVBMT0FEIiwKICAgICAgICAgICAgImRlZmF1bHRfdmFsdWUiOiAiMCIsCiAgICAgICAgICAgICJ1c2VyX3ZpZXdhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInVzZXJfZWRpdGFibGUiOiB0cnVlLAogICAgICAgICAgICAicnVsZXMiOiAicmVxdWlyZWR8Ym9vbGVhbiIsCiAgICAgICAgICAgICJmaWVsZF90eXBlIjogInRleHQiCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJuYW1lIjogIkF1dG8gVXBkYXRlIiwKICAgICAgICAgICAgImRlc2NyaXB0aW9uIjogIlB1bGwgdGhlIGxhdGVzdCBmaWxlcyBvbiBzdGFydHVwIHdoZW4gdXNpbmcgYSBHaXRIdWIgcmVwby4iLAogICAgICAgICAgICAiZW52X3ZhcmlhYmxlIjogIkFVVE9fVVBEQVRFIiwKICAgICAgICAgICAgImRlZmF1bHRfdmFsdWUiOiAiMCIsCiAgICAgICAgICAgICJ1c2VyX3ZpZXdhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInVzZXJfZWRpdGFibGUiOiB0cnVlLAogICAgICAgICAgICAicnVsZXMiOiAicmVxdWlyZWR8Ym9vbGVhbiIsCiAgICAgICAgICAgICJmaWVsZF90eXBlIjogInRleHQiCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJuYW1lIjogIkFwcCBweSBmaWxlIiwKICAgICAgICAgICAgImRlc2NyaXB0aW9uIjogIlRoZSBmaWxlIHRoYXQgc3RhcnRzIHRoZSBBcHAuIiwKICAgICAgICAgICAgImVudl92YXJpYWJsZSI6ICJQWV9GSUxFIiwKICAgICAgICAgICAgImRlZmF1bHRfdmFsdWUiOiAiYXBwLnB5IiwKICAgICAgICAgICAgInVzZXJfdmlld2FibGUiOiB0cnVlLAogICAgICAgICAgICAidXNlcl9lZGl0YWJsZSI6IHRydWUsCiAgICAgICAgICAgICJydWxlcyI6ICJyZXF1aXJlZHxzdHJpbmciLAogICAgICAgICAgICAiZmllbGRfdHlwZSI6ICJ0ZXh0IgogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgICAibmFtZSI6ICJBZGRpdGlvbmFsIFB5dGhvbiBwYWNrYWdlcyIsCiAgICAgICAgICAgICJkZXNjcmlwdGlvbiI6ICJJbnN0YWxsIGFkZGl0aW9uYWwgcHl0aG9uIHBhY2thZ2VzLlxyXG5cclxuVXNlIHNwYWNlcyB0byBzZXBhcmF0ZSIsCiAgICAgICAgICAgICJlbnZfdmFyaWFibGUiOiAiUFlfUEFDS0FHRVMiLAogICAgICAgICAgICAiZGVmYXVsdF92YWx1ZSI6ICIiLAogICAgICAgICAgICAidXNlcl92aWV3YWJsZSI6IHRydWUsCiAgICAgICAgICAgICJ1c2VyX2VkaXRhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInJ1bGVzIjogIm51bGxhYmxlfHN0cmluZyIsCiAgICAgICAgICAgICJmaWVsZF90eXBlIjogInRleHQiCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJuYW1lIjogIkdpdCBVc2VybmFtZSIsCiAgICAgICAgICAgICJkZXNjcmlwdGlvbiI6ICJVc2VybmFtZSB0byBhdXRoIHdpdGggZ2l0LiIsCiAgICAgICAgICAgICJlbnZfdmFyaWFibGUiOiAiVVNFUk5BTUUiLAogICAgICAgICAgICAiZGVmYXVsdF92YWx1ZSI6ICIiLAogICAgICAgICAgICAidXNlcl92aWV3YWJsZSI6IHRydWUsCiAgICAgICAgICAgICJ1c2VyX2VkaXRhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInJ1bGVzIjogIm51bGxhYmxlfHN0cmluZyIsCiAgICAgICAgICAgICJmaWVsZF90eXBlIjogInRleHQiCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJuYW1lIjogIkdpdCBBY2Nlc3MgVG9rZW4iLAogICAgICAgICAgICAiZGVzY3JpcHRpb24iOiAiUGFzc3dvcmQgdG8gdXNlIHdpdGggZ2l0LlxyXG5cclxuSXQncyBiZXN0IHByYWN0aWNlIHRvIHVzZSBhIFBlcnNvbmFsIEFjY2VzcyBUb2tlbi5cclxuaHR0cHM6XC9cL2dpdGh1Yi5jb21cL3NldHRpbmdzXC90b2tlbnNcclxuaHR0cHM6XC9cL2dpdGxhYi5jb21cLy1cL3Byb2ZpbGVcL3BlcnNvbmFsX2FjY2Vzc190b2tlbnMiLAogICAgICAgICAgICAiZW52X3ZhcmlhYmxlIjogIkFDQ0VTU19UT0tFTiIsCiAgICAgICAgICAgICJkZWZhdWx0X3ZhbHVlIjogIiIsCiAgICAgICAgICAgICJ1c2VyX3ZpZXdhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInVzZXJfZWRpdGFibGUiOiB0cnVlLAogICAgICAgICAgICAicnVsZXMiOiAibnVsbGFibGV8c3RyaW5nIiwKICAgICAgICAgICAgImZpZWxkX3R5cGUiOiAidGV4dCIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgIm5hbWUiOiAiUmVxdWlyZW1lbnRzIGZpbGUiLAogICAgICAgICAgICAiZGVzY3JpcHRpb24iOiAiaWYgdGhlcmUgYXJlIG90aGVyIHJlcXVpcmVtZW50cyBmaWxlcyB0byBjaG9vc2UgZnJvbS4iLAogICAgICAgICAgICAiZW52X3ZhcmlhYmxlIjogIlJFUVVJUkVNRU5UU19GSUxFIiwKICAgICAgICAgICAgImRlZmF1bHRfdmFsdWUiOiAicmVxdWlyZW1lbnRzLnR4dCIsCiAgICAgICAgICAgICJ1c2VyX3ZpZXdhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInVzZXJfZWRpdGFibGUiOiB0cnVlLAogICAgICAgICAgICAicnVsZXMiOiAicmVxdWlyZWR8c3RyaW5nIiwKICAgICAgICAgICAgImZpZWxkX3R5cGUiOiAidGV4dCIKICAgICAgICB9CiAgICBdCn0=' | base64 -d > /tmp/ptero-eggs/egg-python-generic.json
  echo 'ewogICAgIl9jb21tZW50IjogIkRPIE5PVCBFRElUOiBGSUxFIEdFTkVSQVRFRCBBVVRPTUFUSUNBTExZIEJZIFBURVJPREFDVFlMIFBBTkVMIC0gUFRFUk9EQUNUWUwuSU8iLAogICAgIm1ldGEiOiB7CiAgICAgICAgInZlcnNpb24iOiAiUFRETF92MiIsCiAgICAgICAgInVwZGF0ZV91cmwiOiBudWxsCiAgICB9LAogICAgImV4cG9ydGVkX2F0IjogIjIwMjUtMTAtMTFUMTE6MzQ6NTArMDc6MDAiLAogICAgIm5hbWUiOiAiTm9kZUpTIEdlbmVyaWMiLAogICAgImF1dGhvciI6ICJheGF0YWNyYXNodjEwQGdtYWlsLmNvbSIsCiAgICAiZGVzY3JpcHRpb24iOiAiZWdncyBub2RlanMgZ2VuZXJpYyIsCiAgICAiZmVhdHVyZXMiOiBudWxsLAogICAgImRvY2tlcl9pbWFnZXMiOiB7CiAgICAgICAgImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18yNSI6ICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMjUiLAogICAgICAgICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMjQiOiAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzI0IiwKICAgICAgICAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzIzIjogImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18yMyIsCiAgICAgICAgImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18yMiI6ICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMjIiLAogICAgICAgICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMjEiOiAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzIxIiwKICAgICAgICAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzIwIjogImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18yMCIsCiAgICAgICAgImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18xOSI6ICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMTkiLAogICAgICAgICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMTgiOiAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzE4IiwKICAgICAgICAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzE3IjogImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18xNyIsCiAgICAgICAgImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18xNiI6ICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMTYiLAogICAgICAgICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMTUiOiAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzE1IiwKICAgICAgICAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzE0IjogImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18xNCIsCiAgICAgICAgImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18xMyI6ICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMTMiLAogICAgICAgICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMTIiOiAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzEyIiwKICAgICAgICAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzExIjogImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18xMSIsCiAgICAgICAgImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18xMCI6ICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMTAiLAogICAgICAgICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfOSI6ICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfOSIsCiAgICAgICAgImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc184IjogImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc184IiwKICAgICAgICAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzciOiAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzciLAogICAgICAgICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfNiI6ICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfNiIsCiAgICAgICAgImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc181IjogImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc181IiwKICAgICAgICAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzQiOiAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzQiLAogICAgICAgICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMyI6ICJnaGNyLmlvL3BhcmtlcnZjcC95b2xrczpub2RlanNfMyIsCiAgICAgICAgImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18yIjogImdoY3IuaW8vcGFya2VydmNwL3lvbGtzOm5vZGVqc18yIiwKICAgICAgICAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzEiOiAiZ2hjci5pby9wYXJrZXJ2Y3AveW9sa3M6bm9kZWpzXzEiCiAgICB9LAogICAgImZpbGVfZGVueWxpc3QiOiBbXSwKICAgICJzdGFydHVwIjogImlmIFtbIC1kIC5naXQgXV0gJiYgW1sge3tBVVRPX1VQREFURX19ID09IFwiMVwiIF1dOyB0aGVuIGdpdCBwdWxsOyBmaTsgaWYgW1sgISAteiAke05PREVfUEFDS0FHRVN9IF1dOyB0aGVuIC91c3IvbG9jYWwvYmluL25wbSBpbnN0YWxsICR7Tk9ERV9QQUNLQUdFU307IGZpOyBpZiBbWyAhIC16ICR7VU5OT0RFX1BBQ0tBR0VTfSBdXTsgdGhlbiAvdXNyL2xvY2FsL2Jpbi9ucG0gdW5pbnN0YWxsICR7VU5OT0RFX1BBQ0tBR0VTfTsgZmk7IGlmIFsgLWYgL2hvbWUvY29udGFpbmVyL3BhY2thZ2UuanNvbiBdOyB0aGVuIC91c3IvbG9jYWwvYmluL25wbSBpbnN0YWxsOyBmaTsgIGlmIFtbICEgLXogJHtDVVNUT01fRU5WSVJPTk1FTlRfVkFSSUFCTEVTfSBdXTsgdGhlbiAgICAgIHZhcnM9JChlY2hvICR7Q1VTVE9NX0VOVklST05NRU5UX1ZBUklBQkxFU30gfCB0ciBcIjtcIiBcIlxcblwiKTsgICAgICBmb3IgbGluZSBpbiAkdmFyczsgICAgIGRvIGV4cG9ydCAkbGluZTsgICAgIGRvbmUgZmk7ICAvdXNyL2xvY2FsL2Jpbi8ke0NNRF9SVU59OyIsCiAgICAiY29uZmlnIjogewogICAgICAgICJmaWxlcyI6ICJ7fSIsCiAgICAgICAgInN0YXJ0dXAiOiAie1xyXG4gICAgXCJkb25lXCI6IFwicnVubmluZ1wiXHJcbn0iLAogICAgICAgICJsb2dzIjogInt9IiwKICAgICAgICAic3RvcCI6ICJeXkMiCiAgICB9LAogICAgInNjcmlwdHMiOiB7CiAgICAgICAgImluc3RhbGxhdGlvbiI6IHsKICAgICAgICAgICAgInNjcmlwdCI6ICIjIS9iaW4vYmFzaFxyXG4jIE5vZGVKUyBBcHAgSW5zdGFsbGF0aW9uIFNjcmlwdFxyXG4jXHJcbiMgU2VydmVyIEZpbGVzOiAvbW50L3NlcnZlclxyXG5hcHQgdXBkYXRlXHJcbmFwdCBpbnN0YWxsIC15IGdpdCBjdXJsIGpxIGZpbGUgdW56aXAgbWFrZSBnY2MgZysrIHB5dGhvbiBweXRob24tZGV2IGxpYnRvb2xcclxuXHJcbm1rZGlyIC1wIC9tbnQvc2VydmVyXHJcbmNkIC9tbnQvc2VydmVyXHJcblxyXG5pZiBbIFwiJHtVU0VSX1VQTE9BRH1cIiA9PSBcInRydWVcIiBdIHx8IFsgXCIke1VTRVJfVVBMT0FEfVwiID09IFwiMVwiIF07IHRoZW5cclxuICAgIGVjaG8gLWUgXCJhc3N1bWluZyB1c2VyIGtub3dzIHdoYXQgdGhleSBhcmUgZG9pbmcgaGF2ZSBhIGdvb2QgZGF5LlwiXHJcbiAgICBleGl0IDBcclxuZmlcclxuXHJcbiMjIGFkZCBnaXQgZW5kaW5nIGlmIGl0J3Mgbm90IG9uIHRoZSBhZGRyZXNzXHJcbmlmIFtbICR7R0lUX0FERFJFU1N9ICE9ICouZ2l0IF1dOyB0aGVuXHJcbiAgICBHSVRfQUREUkVTUz0ke0dJVF9BRERSRVNTfS5naXRcclxuZmlcclxuXHJcbmlmIFsgLXogXCIke1VTRVJOQU1FfVwiIF0gJiYgWyAteiBcIiR7QUNDRVNTX1RPS0VOfVwiIF07IHRoZW5cclxuICAgIGVjaG8gLWUgXCJ1c2luZyBhbm9uIGFwaSBjYWxsXCJcclxuZWxzZVxyXG4gICAgR0lUX0FERFJFU1M9XCJodHRwczovLyR7VVNFUk5BTUV9OiR7QUNDRVNTX1RPS0VOfUAkKGVjaG8gLWUgJHtHSVRfQUREUkVTU30gfCBjdXQgLWQvIC1mMy0pXCJcclxuZmlcclxuXHJcbiMjIHB1bGwgZ2l0IGpzIHJlcG9cclxuaWYgWyBcIiQobHMgLUEgL21udC9zZXJ2ZXIpXCIgXTsgdGhlblxyXG4gICAgZWNobyAtZSBcIi9tbnQvc2VydmVyIGRpcmVjdG9yeSBpcyBub3QgZW1wdHkuXCJcclxuICAgIGlmIFsgLWQgLmdpdCBdOyB0aGVuXHJcbiAgICAgICAgZWNobyAtZSBcIi5naXQgZGlyZWN0b3J5IGV4aXN0c1wiXHJcbiAgICAgICAgaWYgWyAtZiAuZ2l0L2NvbmZpZyBdOyB0aGVuXHJcbiAgICAgICAgICAgIGVjaG8gLWUgXCJsb2FkaW5nIGluZm8gZnJvbSBnaXQgY29uZmlnXCJcclxuICAgICAgICAgICAgT1JJR0lOPSQoZ2l0IGNvbmZpZyAtLWdldCByZW1vdGUub3JpZ2luLnVybClcclxuICAgICAgICBlbHNlXHJcbiAgICAgICAgICAgIGVjaG8gLWUgXCJmaWxlcyBmb3VuZCB3aXRoIG5vIGdpdCBjb25maWdcIlxyXG4gICAgICAgICAgICBlY2hvIC1lIFwiY2xvc2luZyBvdXQgd2l0aG91dCB0b3VjaGluZyB0aGluZ3MgdG8gbm90IGJyZWFrIGFueXRoaW5nXCJcclxuICAgICAgICAgICAgZXhpdCAxMFxyXG4gICAgICAgIGZpXHJcbiAgICBmaVxyXG5cclxuICAgIGlmIFsgXCIke09SSUdJTn1cIiA9PSBcIiR7R0lUX0FERFJFU1N9XCIgXTsgdGhlblxyXG4gICAgICAgIGVjaG8gXCJwdWxsaW5nIGxhdGVzdCBmcm9tIGdpdGh1YlwiXHJcbiAgICAgICAgZ2l0IHB1bGxcclxuICAgIGZpXHJcbmVsc2VcclxuICAgIGVjaG8gLWUgXCIvbW50L3NlcnZlciBpcyBlbXB0eS5cXG5jbG9uaW5nIGZpbGVzIGludG8gcmVwb1wiXHJcbiAgICBpZiBbIC16ICR7QlJBTkNIfSBdOyB0aGVuXHJcbiAgICAgICAgZWNobyAtZSBcImNsb25pbmcgZGVmYXVsdCBicmFuY2hcIlxyXG4gICAgICAgIGdpdCBjbG9uZSAke0dJVF9BRERSRVNTfSAuXHJcbiAgICBlbHNlXHJcbiAgICAgICAgZWNobyAtZSBcImNsb25pbmcgJHtCUkFOQ0h9J1wiXHJcbiAgICAgICAgZ2l0IGNsb25lIC0tc2luZ2xlLWJyYW5jaCAtLWJyYW5jaCAke0JSQU5DSH0gJHtHSVRfQUREUkVTU30gLlxyXG4gICAgZmlcclxuXHJcbmZpXHJcblxyXG5lY2hvIFwiSW5zdGFsbGluZyBub2RlanMgcGFja2FnZXNcIlxyXG5pZiBbWyAhIC16ICR7Tk9ERV9QQUNLQUdFU30gXV07IHRoZW5cclxuICAgIC91c3IvbG9jYWwvYmluL25wbSBpbnN0YWxsICR7Tk9ERV9QQUNLQUdFU31cclxuZmlcclxuXHJcbmlmIFsgLWYgL21udC9zZXJ2ZXIvcGFja2FnZS5qc29uIF07IHRoZW5cclxuICAgIC91c3IvbG9jYWwvYmluL25wbSBpbnN0YWxsIC0tcHJvZHVjdGlvblxyXG5maVxyXG5cclxuZWNobyAtZSBcImluc3RhbGwgY29tcGxldGVcIlxyXG5leGl0IDAiLAogICAgICAgICAgICAiY29udGFpbmVyIjogIm5vZGU6MTQtYnVzdGVyLXNsaW0iLAogICAgICAgICAgICAiZW50cnlwb2ludCI6ICJiYXNoIgogICAgICAgIH0KICAgIH0sCiAgICAidmFyaWFibGVzIjogWwogICAgICAgIHsKICAgICAgICAgICAgIm5hbWUiOiAiR2l0IFJlcG8gQWRkcmVzcyIsCiAgICAgICAgICAgICJkZXNjcmlwdGlvbiI6ICJHaXRIdWIgUmVwbyB0byBjbG9uZVxyXG5cclxuSS5FLiBodHRwczovL2dpdGh1Yi5jb20vdXNlcl9uYW1lL3JlcG9fbmFtZSIsCiAgICAgICAgICAgICJlbnZfdmFyaWFibGUiOiAiR0lUX0FERFJFU1MiLAogICAgICAgICAgICAiZGVmYXVsdF92YWx1ZSI6ICIiLAogICAgICAgICAgICAidXNlcl92aWV3YWJsZSI6IHRydWUsCiAgICAgICAgICAgICJ1c2VyX2VkaXRhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInJ1bGVzIjogIm51bGxhYmxlfHN0cmluZyIsCiAgICAgICAgICAgICJmaWVsZF90eXBlIjogInRleHQiCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJuYW1lIjogIkluc3RhbGwgQnJhbmNoIiwKICAgICAgICAgICAgImRlc2NyaXB0aW9uIjogIlRoZSBicmFuY2ggdG8gaW5zdGFsbC4iLAogICAgICAgICAgICAiZW52X3ZhcmlhYmxlIjogIkJSQU5DSCIsCiAgICAgICAgICAgICJkZWZhdWx0X3ZhbHVlIjogIiIsCiAgICAgICAgICAgICJ1c2VyX3ZpZXdhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInVzZXJfZWRpdGFibGUiOiB0cnVlLAogICAgICAgICAgICAicnVsZXMiOiAibnVsbGFibGV8c3RyaW5nIiwKICAgICAgICAgICAgImZpZWxkX3R5cGUiOiAidGV4dCIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgIm5hbWUiOiAiR2l0IFVzZXJuYW1lIiwKICAgICAgICAgICAgImRlc2NyaXB0aW9uIjogIlVzZXJuYW1lIHRvIGF1dGggd2l0aCBnaXQuIiwKICAgICAgICAgICAgImVudl92YXJpYWJsZSI6ICJVU0VSTkFNRSIsCiAgICAgICAgICAgICJkZWZhdWx0X3ZhbHVlIjogIiIsCiAgICAgICAgICAgICJ1c2VyX3ZpZXdhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInVzZXJfZWRpdGFibGUiOiB0cnVlLAogICAgICAgICAgICAicnVsZXMiOiAibnVsbGFibGV8c3RyaW5nIiwKICAgICAgICAgICAgImZpZWxkX3R5cGUiOiAidGV4dCIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgIm5hbWUiOiAiR2l0IEFjY2VzcyBUb2tlbiIsCiAgICAgICAgICAgICJkZXNjcmlwdGlvbiI6ICJQYXNzd29yZCB0byB1c2Ugd2l0aCBnaXQuXHJcblxyXG5JdCdzIGJlc3QgcHJhY3RpY2UgdG8gdXNlIGEgUGVyc29uYWwgQWNjZXNzIFRva2VuLlxyXG5odHRwczovL2dpdGh1Yi5jb20vc2V0dGluZ3MvdG9rZW5zXHJcbmh0dHBzOi8vZ2l0bGFiLmNvbS8tL3Byb2ZpbGUvcGVyc29uYWxfYWNjZXNzX3Rva2VucyIsCiAgICAgICAgICAgICJlbnZfdmFyaWFibGUiOiAiQUNDRVNTX1RPS0VOIiwKICAgICAgICAgICAgImRlZmF1bHRfdmFsdWUiOiAiIiwKICAgICAgICAgICAgInVzZXJfdmlld2FibGUiOiB0cnVlLAogICAgICAgICAgICAidXNlcl9lZGl0YWJsZSI6IHRydWUsCiAgICAgICAgICAgICJydWxlcyI6ICJudWxsYWJsZXxzdHJpbmciLAogICAgICAgICAgICAiZmllbGRfdHlwZSI6ICJ0ZXh0IgogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgICAibmFtZSI6ICJDb21tYW5kIFJ1biIsCiAgICAgICAgICAgICJkZXNjcmlwdGlvbiI6ICJUaGUgY29tbWFuZCB0byBzdGFydCB0aGUgYm90IiwKICAgICAgICAgICAgImVudl92YXJpYWJsZSI6ICJDTURfUlVOIiwKICAgICAgICAgICAgImRlZmF1bHRfdmFsdWUiOiAibnBtIHN0YXJ0IiwKICAgICAgICAgICAgInVzZXJfdmlld2FibGUiOiB0cnVlLAogICAgICAgICAgICAidXNlcl9lZGl0YWJsZSI6IHRydWUsCiAgICAgICAgICAgICJydWxlcyI6ICJyZXF1aXJlZHxzdHJpbmciLAogICAgICAgICAgICAiZmllbGRfdHlwZSI6ICJ0ZXh0IgogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgICAibmFtZSI6ICJOb2RlIFBhY2thZ2VzIiwKICAgICAgICAgICAgImRlc2NyaXB0aW9uIjogIkFkZGl0aW9uYWwgbnBtIHBhY2thZ2VzIHRvIGluc3RhbGwiLAogICAgICAgICAgICAiZW52X3ZhcmlhYmxlIjogIk5PREVfUEFDS0FHRVMiLAogICAgICAgICAgICAiZGVmYXVsdF92YWx1ZSI6ICIiLAogICAgICAgICAgICAidXNlcl92aWV3YWJsZSI6IHRydWUsCiAgICAgICAgICAgICJ1c2VyX2VkaXRhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInJ1bGVzIjogIm51bGxhYmxlfHN0cmluZyIsCiAgICAgICAgICAgICJmaWVsZF90eXBlIjogInRleHQiCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJuYW1lIjogIkF1dG8gVXBkYXRlIiwKICAgICAgICAgICAgImRlc2NyaXB0aW9uIjogIlB1bGwgbGF0ZXN0IGZyb20gZ2l0IG9uIHN0YXJ0dXAiLAogICAgICAgICAgICAiZW52X3ZhcmlhYmxlIjogIkFVVE9fVVBEQVRFIiwKICAgICAgICAgICAgImRlZmF1bHRfdmFsdWUiOiAiMCIsCiAgICAgICAgICAgICJ1c2VyX3ZpZXdhYmxlIjogdHJ1ZSwKICAgICAgICAgICAgInVzZXJfZWRpdGFibGUiOiB0cnVlLAogICAgICAgICAgICAicnVsZXMiOiAicmVxdWlyZWR8Ym9vbGVhbiIsCiAgICAgICAgICAgICJmaWVsZF90eXBlIjogInRleHQiCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJuYW1lIjogIlVzZXIgVXBsb2FkZWQgRmlsZXMiLAogICAgICAgICAgICAiZGVzY3JpcHRpb24iOiAiU2tpcCBpbnN0YWxsIGlmIHVzZXIgdXBsb2FkcyBmaWxlcyAoMD1mYWxzZSwgMT10cnVlKSIsCiAgICAgICAgICAgICJlbnZfdmFyaWFibGUiOiAiVVNFUl9VUExPQUQiLAogICAgICAgICAgICAiZGVmYXVsdF92YWx1ZSI6ICIwIiwKICAgICAgICAgICAgInVzZXJfdmlld2FibGUiOiB0cnVlLAogICAgICAgICAgICAidXNlcl9lZGl0YWJsZSI6IHRydWUsCiAgICAgICAgICAgICJydWxlcyI6ICJyZXF1aXJlZHxib29sZWFuIiwKICAgICAgICAgICAgImZpZWxkX3R5cGUiOiAidGV4dCIKICAgICAgICB9CiAgICBdCn0K' | base64 -d > /tmp/ptero-eggs/egg-nodejs.json

  log_success "[✓] Egg files written to /tmp/ptero-eggs/"
  ls -la /tmp/ptero-eggs/

  print_info "Membuat Nest 'Generic' & mengimpor eggs..."

  cat > /tmp/ptero-import-eggs.php << 'PHPEOF'
<?php
require "/var/www/pterodactyl/vendor/autoload.php";
$app = require_once "/var/www/pterodactyl/bootstrap/app.php";
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use Pterodactyl\Models\Nest;
use Pterodactyl\Services\Eggs\Sharing\EggImporterService;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Str;

try {
    $nest = Nest::where("name", "Generic")->first();
    if (!$nest) {
        $nest = new Nest();
        $nest->uuid = (string) Str::uuid();
        $nest->author = "panel@localhost";
        $nest->name = "Generic";
        $nest->description = "Generic eggs for bots & applications (Python, NodeJS, etc)";
        $nest->save();
        echo "NEST_CREATED:" . $nest->id . "\n";
    } else {
        echo "NEST_EXISTS:" . $nest->id . "\n";
    }

    $importer = app(EggImporterService::class);
    $files = glob("/tmp/ptero-eggs/*.json");
    $ok = 0;
    $fail = 0;

    foreach ($files as $f) {
        try {
            $uploaded = new UploadedFile($f, basename($f), "application/json", null, true);
            $egg = $importer->handle($uploaded, $nest->id);
            $ok++;
            echo "OK:" . basename($f) . ":id=" . $egg->id . "\n";
        } catch (Throwable $e) {
            $fail++;
            echo "FAIL:" . basename($f) . ":" . $e->getMessage() . "\n";
        }
    }

    echo "DONE ok=$ok fail=$fail nest=" . $nest->id . "\n";
} catch (Throwable $e) {
    echo "FATAL:" . $e->getMessage() . "\n";
    exit(1);
}
PHPEOF

  RESULT=$(cd /var/www/pterodactyl && php /tmp/ptero-import-eggs.php 2>&1) || true
  echo "$RESULT"
  rm -f /tmp/ptero-import-eggs.php

  echo ""
  if echo "$RESULT" | grep -q "DONE ok="; then
    OK=$(echo "$RESULT" | grep -oP 'DONE ok=\K[0-9]+' || echo "?")
    FAIL=$(echo "$RESULT" | grep -oP 'fail=\K[0-9]+' || echo "?")
    NEST=$(echo "$RESULT" | grep -oP 'nest=\K[0-9]+' || echo "?")
    print_banner "IMPORT EGGS BERHASIL" "$GREEN"
    echo -e "  ${BOLD}Nest${NC}   : ${CYAN}Generic${NC} (ID: $NEST)"
    echo -e "  ${BOLD}Sukses${NC} : ${GREEN}$OK${NC}"
    echo -e "  ${BOLD}Gagal${NC}  : ${RED}$FAIL${NC}"
    echo -e "\n  Cek di panel: ${BOLD}Admin → Nests → Generic${NC}"
  else
    print_warning "Auto-import gagal. File eggs ada di /tmp/ptero-eggs/"
    echo -e "  Import manual: Admin → Nests → Create 'Generic' → Import Egg"
  fi

  echo ""
  echo -n -e "${BOLD}Tekan Enter untuk kembali ke menu utama...${NC}"
  read
}

create_node() {
  print_banner "CREATE NODE + LOCATION + ALLOCATION (AUTO HIJAU)"

  if [ ! -d "/var/www/pterodactyl" ]; then
    print_error "Panel Pterodactyl tidak ditemukan di /var/www/pterodactyl"
    sleep 2
    return 1
  fi

  cd /var/www/pterodactyl || return 1

  # ---- Input semua data ----
  echo -e "${BOLD}${CYAN}Isi data berikut:${NC}"
  echo ""
  read -p "📍 Nama Location             : " location_name
  read -p "📝 Deskripsi Location        : " location_description
  read -p "🌐 Domain Node (FQDN)        : " domain
  read -p "🖥  Nama Node                 : " node_name
  read -p "💾 RAM (MB)                  : " ram
  read -p "💿 Disk (MB)                 : " disk_space
  read -p "🌍 IP VPS (allocation)       : " ip_alloc
  read -p "🔢 Port (spasi: 25565 8080)  : " -a PORTS
  read -p "🔗 URL Panel (https://...)   : " PANEL_URL

  PANEL_URL=$(echo "$PANEL_URL" | sed 's|/$||')
  domain=$(echo "$domain" | sed 's|^https\?://||' | sed 's|/$||')

  if [[ -z "$location_name" || -z "$domain" || -z "$node_name" || -z "$ram" || -z "$disk_space" || -z "$ip_alloc" || -z "$PANEL_URL" ]]; then
    print_error "Semua field wajib diisi!"
    sleep 2
    return 1
  fi

  if [ ${#PORTS[@]} -eq 0 ]; then
    PORTS=(25565 8080 3000)
    print_warning "Port kosong, pakai default: 25565 8080 3000"
  fi

  # ---- 1. Create Location ----
  print_info "[1/5] Membuat Location..."
  php artisan p:location:make <<EOF
$location_name
$location_description
EOF

  LOCID=$(php -r '
    require "vendor/autoload.php";
    $app = require "bootstrap/app.php";
    $app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
    $loc = \Pterodactyl\Models\Location::orderBy("id","desc")->first();
    echo $loc ? $loc->id : "";
  ' 2>/dev/null)

  if [[ -z "$LOCID" ]]; then
    print_error "Gagal mendapatkan Location ID"
    sleep 2
    return 1
  fi
  echo -e "  ${GREEN}Location ID: $LOCID${NC}"

  # ---- 2. Create Node ----
  print_info "[2/5] Membuat Node..."
  php artisan p:node:make <<EOF
$node_name
$location_description
$LOCID
https
$domain
yes
no
no
$ram
$ram
$disk_space
$disk_space
100
8080
2022
/var/lib/pterodactyl/volumes
EOF

  NODE_ID=$(php -r '
    require "vendor/autoload.php";
    $app = require "bootstrap/app.php";
    $app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
    $n = \Pterodactyl\Models\Node::orderBy("id","desc")->first();
    echo $n ? $n->id : "";
  ' 2>/dev/null)

  if [[ -z "$NODE_ID" ]]; then
    print_error "Gagal mendapatkan Node ID"
    sleep 2
    return 1
  fi
  echo -e "  ${GREEN}Node ID: $NODE_ID${NC}"

  # ---- 3. Application API Key ----
  print_info "[3/5] Membuat Application API Key..."
  API_KEY=$(php -r '
    require "vendor/autoload.php";
    $app = require "bootstrap/app.php";
    $app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
    try {
      $service = app(\Pterodactyl\Services\Api\KeyCreationService::class);
      $key = $service->handle(["memo" => "auto-node-".time()], ["*"]);
      echo $key->identifier . decrypt($key->token);
    } catch (Throwable $e) {
      echo "";
    }
  ' 2>/dev/null)

  if [[ -z "$API_KEY" ]]; then
    print_warning "Gagal auto API Key. Node sudah dibuat (ID: $NODE_ID)."
    echo -e "  Buat API key manual di Admin → Application API, lalu tambah allocation."
    echo ""
    read -p "Tekan Enter untuk kembali..."
    return 0
  fi
  echo -e "  ${GREEN}API Key OK${NC}"

  # ---- 4. Allocations ----
  print_info "[4/5] Menambahkan IP Allocation & Port..."
  apt-get install -y jq curl >/dev/null 2>&1 || true

  for PORT in "${PORTS[@]}"; do
    RESPONSE=$(curl -s -X POST "$PANEL_URL/api/application/nodes/$NODE_ID/allocations" \
      -H "Authorization: Bearer $API_KEY" \
      -H "Content-Type: application/json" \
      -H "Accept: Application/vnd.pterodactyl.v1+json" \
      -d "{\"ip\": \"$ip_alloc\", \"ports\": [\"$PORT\"]}")

    if echo "$RESPONSE" | grep -qE "attributes|object"; then
      echo -e "  ${GREEN}✓${NC} $ip_alloc:$PORT"
    else
      # retry single port format
      RESPONSE=$(curl -s -X POST "$PANEL_URL/api/application/nodes/$NODE_ID/allocations" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -H "Accept: Application/vnd.pterodactyl.v1+json" \
        -d "{\"ip\": \"$ip_alloc\", \"port\": $PORT}")
      if echo "$RESPONSE" | grep -qE "attributes|object"; then
        echo -e "  ${GREEN}✓${NC} $ip_alloc:$PORT"
      else
        echo -e "  ${YELLOW}!~${NC} $ip_alloc:$PORT (cek manual)"
      fi
    fi
  done

  # ---- 5. Wings config (node hijau) ----
  print_info "[5/5] Generate config Wings (biar node hijau)..."
  mkdir -p /etc/pterodactyl

  WINGS_CFG=$(curl -s -X GET "$PANEL_URL/api/application/nodes/$NODE_ID/configuration" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Accept: Application/vnd.pterodactyl.v1+json")

  if echo "$WINGS_CFG" | grep -q "uuid:"; then
    echo "$WINGS_CFG" > /etc/pterodactyl/config.yml
    echo -e "  ${GREEN}✓ /etc/pterodactyl/config.yml tersimpan${NC}"
  else
    # API kadang return JSON — simpan raw, user bisa pakai auto-deploy dari panel
    echo "$WINGS_CFG" > /tmp/wings-node-config.json
    print_warning "Ambil config Wings manual dari panel:"
    echo -e "  Admin → Nodes → ${node_name} → Configuration → Copy command auto-deploy"
  fi

  if systemctl list-unit-files 2>/dev/null | grep -q wings.service; then
    systemctl enable wings >/dev/null 2>&1 || true
    systemctl restart wings 2>/dev/null || true
    sleep 3
    if systemctl is-active --quiet wings 2>/dev/null; then
      echo -e "  ${GREEN}✓ Wings aktif — node seharusnya HIJAU${NC}"
    else
      echo -e "  ${YELLOW}!~ Wings belum aktif: systemctl start wings${NC}"
    fi
  else
    print_warning "Wings belum terinstall. Install dulu, lalu paste config dari panel."
  fi

  echo ""
  print_success "CREATE NODE SELESAI!"
  echo -e "  Location : $location_name (ID: $LOCID)"
  echo -e "  Node     : $node_name (ID: $NODE_ID)"
  echo -e "  Domain   : $domain"
  echo -e "  IP       : $ip_alloc"
  echo -e "  Ports    : ${PORTS[*]}"
  echo -e "  RAM/Disk : ${ram}MB / ${disk_space}MB"
  echo ""
  echo -e "  ${CYAN}Cek: Admin → Nodes → status harus hijau jika Wings jalan.${NC}"
  echo ""
  read -p "Tekan Enter untuk kembali ke menu..."
}


# ============================================================
# MAIN MENU
# ============================================================

MAIN_MENU=(
  "Import Eggs (Python + NodeJS);import_eggs"
  "Create Node + Location + Allocation (auto hijau);create_node"
)

start_script

while true; do
  clear
  print_logo
  echo -e "${BOLD} BERIKUT ADALAH LIST FITUR:${NC}"
  echo -e ""
  for i in "${!MAIN_MENU[@]}"; do
    IFS=';' read -r title func <<< "${MAIN_MENU[$i]}"
    echo -e "${BOLD}  $((i+1)). $title${NC}"
  done
  echo -e "${BOLD}  x. Exit${NC}"
  echo -e ""
  print_info "Pastikan panel Pterodactyl sudah terinstall sebelum menjalankan fitur."
  echo -n -e "${BOLD}Masukkan pilihan (1-${#MAIN_MENU[@]} atau x): ${NC}"
  read -r MENU_CHOICE

  if [[ "$MENU_CHOICE" =~ ^[0-9]+$ ]] && [ "$MENU_CHOICE" -ge 1 ] && [ "$MENU_CHOICE" -le "${#MAIN_MENU[@]}" ]; then
    IFS=';' read -r title func <<< "${MAIN_MENU[$((MENU_CHOICE-1))]}"
    $func
  elif [[ "${MENU_CHOICE,,}" == "x" ]]; then
    echo -e ""
    echo -e "${BOLD}${YELLOW}Keluar dari skrip. Terima kasih!${NC}"
    echo -e ""
    exit 0
  else
    print_error "Pilihan tidak valid. Silakan coba lagi."
    sleep 2
  fi
done
