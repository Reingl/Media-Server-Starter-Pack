#!/bin/bash
RED=$'\e[31m'
GREEN=$'\e[32m'
BLUE=$'\e[34m'
RESET=$'\e[0m'

read -p "Start Server? (${GREEN}y${RESET}/${RED}n${RESET}): " choice
[[ "$choice" == [Yy] ]] || exit 1
sleep 1
echo "Enter ${RED}Password${RESET} on if prompted"
sleep 2
sudo pkill navidrome 2>/dev/null

if [ $? -ne 0 ]; then 
  echo "${BLUE}Process${RESET} hasn't even ${RED}LOADED${RESET}"
else
  echo "${BLUE}Process${RESET} has been ${RED}KILLED${RESET}"
  sleep 1
  clear
  sleep 1
  echo "${GREEN}SUCCESSFULLY${RESET} :D"
fi

sleep 2

echo "${GREEN}Starting${RESET} Server"

navidrome --configfile ~/.config/navidrome/navidrome.toml >$HOME/navidrome.log 2>&1 &

sleep 1

if pgrep -f "navidrome --configfile $HOME/.config/navidrome/navidrome.toml" >/dev/null; then
echo "${BLUE}Process${RESET} has ${GREEN}Started${RESET}"
else
echo "${BLUE}Process${RESET} has ${GREEN}started${RESET} but ${RED}FAILED${RESET}"
fi

sleep 2 

echo "Starting ${BLUE}Process Tailscale${RESET}"

sleep 1


ERROR_MSG=$(sudo tailscale funnel --bg 4533 2>&1)
sleep 1

if [[ "$ERROR_MSG" == *"tailscaled"* ]]; then
  echo "${RED}FAILED${RESET}, will reattempt with ${BLUE}elevated permission${RESET}"
  sudo systemctl start tailscaled.service

  sudo tailscale funnel --bg 4533 >/dev/null 2>&1 && clear
fi

sleep 1
 echo "${GREEN}GENERATING URL...${RESET}"

sleep 2

FUNNEL_URL=$(tailscale status --active | awk '/https:\/\// {print $3}')

sleep 1

echo "$FUNNEL_URL"

sleep 1

echo "${BLUE}--- Navidrome logs for debugging and experimenting ---${RESET}"

sleep 2

on_interrupt() {
  echo -e "\n[!] ${RED}STOPPED NAVIDROME...${RESET}"
  pkill -f "navidrome"
  rm -f $HOME/navidrome.log
  exit 0 
}
trap on_interrupt INT

tail -f $HOME/navidrome.log

sleep 0.5

