#!/bin/sh

GREEN='\033[0;32m'
GREY='\033[0;90m'
RESET='\033[0m'

# check <cmd> <description> <check_command>
check() {
  cmd="$1"
  desc="$2"
  check_cmd="$3"

  if eval "$check_cmd" > /dev/null 2>&1; then
    printf "  [x] ${GREY}%-30s %s${RESET}\n" "$desc" "$cmd"
  else
    printf "  [ ] %-30s %s\n" "$desc" "$cmd"
  fi
}

printf "${GREEN}"
printf "=========================================\n"
printf " Post-install checklist\n"
printf "=========================================\n"
printf "${RESET}"
printf "\nManual steps remaining:\n\n"

check "ssh-keygen -t ed25519" "Generate SSH key"        "test -f ~/.ssh/id_ed25519"
printf "    - Then upload to github.com/settings/keys\n"
check "gh auth login"        "Authenticate GitHub CLI"  "gh auth status"


printf "\n${GREEN}"
printf "=========================================\n"
printf "${RESET}\n"
