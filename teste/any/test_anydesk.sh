#!/usr/bin/env bash

auto_sudo() {

	echo -e "$password\n" | sudo -S $1

}

auto_sudo "$(su -c "wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -")"
auto_sudo "$(su -c "$(echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list)")"
auto_sudo "apt update -y"
auto_sudo "apt install anydesk -y"