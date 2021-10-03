#!/usr/bin/env bash

ress="n"

while [ "${ress,,}" == "n" ]; do

	clear

	echo ""
	echo "======================   CONFIGURAÇÃO   ======================"
	echo ""

	read -s -p "Password [sudo]: " password

	echo ""
	echo ""

	read -p "As informações estão corretas (y/n)? " ress

	clear

done

auto_sudo() {

	echo -e "$password\n" | sudo -S $1

}

echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | auto_sudo "debconf-set-selections"
auto_sudo "apt install ttf-mscorefonts-installer"

