#!/usr/bin/env bash

# ===========================================================
#
# Sessão de declaração de funções
#
# ===========================================================

# Passa a senha para o comando sudo

auto_sudo() {

	echo -e "${password}\n" | sudo -S ${1}

}

# CHROME

fun0() {

	wget -P ${install_dir} "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
	auto_sudo "dpkg -i ${install_dir}/google*.deb"

}

# VS-CODE

fun1() {

	wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	auto_sudo "install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/"
	echo -e "${password}\n" | sudo -S sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	rm -f packages.microsoft.gpg
	auto_sudo "apt install apt-transport-https -y"
	auto_sudo "apt update -y"
	auto_sudo "apt install code -y"
	# auto_sudo "apt install code-insiders -y"

}

# DISCORD

fun2() {

	wget -O discord_tmp.deb "https://discord.com/api/download?platform=linux&format=deb" 
	mv ./discord*.deb ${install_dir}
	sleep 10
	auto_sudo "dpkg -i ${install_dir}/discord*.deb"
	auto_sudo "apt install -f -y"
	# Talvez haverá a necessidade de descomentar a linha a baixo
	# auto_sudo "dpkg -i ./discord*.deb"

}

# FILEZILLA

fun3() {

	auto_sudo "apt install filezilla -y"

}

# ANYDESK

fun4() {

	echo -e "${password}\n" | sudo -S su -c "wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add - 2>> /dev/null"
	echo -e "${password}\n" | sudo -S su -c "echo 'deb http://deb.anydesk.com/ all main' > /etc/apt/sources.list.d/anydesk-stable.list"
	auto_sudo "apt update -y"
	auto_sudo "apt install anydesk -y"

}

# POSTMAN

fun5() {

	wget -O postman_temp.tar.gz "https://dl.pstmn.io/download/latest/linux64" 
	mv ./postman*.tar.gz ${install_dir}
	auto_sudo "tar -zxvf ${install_dir}/postman*.tar.gz -C /opt/"
	auto_sudo "ln -s /opt/Postman/Postman /usr/bin/postman"
	echo -e "[Desktop Entry]\n\tEncoding=UTF-8\n\tName=Postman\n\tComment=Postman API Client\n\tIcon=/opt/Postman/app/resources/app/assets/icon.png\n\tExec=/usr/bin/postman\n\tTerminal=false\n\tType=Application\n\tCategories=Desenvolvimento" > ${HOME}/.local/share/applications/postman.desktop
	chmod +x ${HOME}/.local/share/applications/postman.desktop

}

# MY-SQL/WORKBENCH

fun6() {

	auto_sudo "apt install mysql-server -y"

	echo ""
	echo "--- workbench ---"
	echo ""

	auto_sudo "snap install mysql-workbench-community"

}

# SIMPLESCREENRECORDER

fun7() {

	auto_sudo "apt install simplescreenrecorder -y"

}

# FLAMESHOT

fun8() {

	auto_sudo "apt install flameshot -y"

}

# KOLOURPAINT

fun9() {

	auto_sudo "apt install kolourpaint -y"

}

# NPM

fun10() {

	auto_sudo "apt install npm -y"

}

# ===========================================================
#
# Sessão de declaração de variáveis
#
# ===========================================================

readonly version="3.0.1"

array_program=("CHROME" "VS-CODE" "DISCORD" "FILEZILLA" "ANYDESK" "POSTMAN" "MY-SQL/WORKBENCH" "SIMPLESCREENRECORDER" "FLAMESHOT" "KOLOURPAINT" "NPM")

install_dir="${HOME}/instalacao"

password=$(cat ${install_dir}/pass.txt)

for ((i=0;i<${#array_program[@]};++i)); do
	array_answer[${i}]=$(cut -d ':' -f $((${i}+1)) ${install_dir}/answer_file)
done

# ===========================================================
#
# Inicio do programa
#
# ===========================================================

# Dorme antes de efetivamente começar a instalação dos progrmas

sleep 30

# Sessão de instalação dos programas selecionados

echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>   INSTALAÇÃO   <<<<<<<<<<<<<<<<<<<<<<"
echo ""
echo ""

for ((i=0; i<${#array_program[@]}; ++i)); do

	if [ "${array_answer[${i}],,}" == "y" ]; then
		
		echo "======================   ${array_program[${i}]}   ======================"
		echo ""
		fun"${i}"
		echo ""
		echo ">>> Finalizado !"
		echo ""

	fi

done

sleep 30

# ===========================================================

# Sessão de limpeza de pacotes que possam estar sobrando
# e possivelmente quebrados também

echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>   LIMPAR   <<<<<<<<<<<<<<<<<<<<<<"
echo ""

auto_sudo "apt install -f"
auto_sudo "apt --fix-broken install"

echo ""
echo "--- switch ---"
echo ""

auto_sudo "apt clean -y"
auto_sudo "apt autoclean -y"
auto_sudo "apt autoremove -y"

echo ""
echo "======================   Version ${version}   ======================"
echo ""
echo ""
echo "A simple solution..."
echo ""
echo "Created by: Crazy Group Inc © (CG)"
echo ""
echo ""
echo "================================================================"

sed -i '/array_answer/d' ${HOME}/.bashrc

rm ${install_dir}/*.deb

rm ${install_dir}/*.tar.gz

rm ${install_dir}/cork.sh

auto_sudo "rm /usr/local/bin/script-cork.sh"

rm ${install_dir}/pass.txt

rm ${install_dir}/answer_file

rm ${HOME}/.config/autostart/cork.desktop

rmdir ${install_dir}

echo ""
echo "Reiniciando em 30s (cancelar o reboot: ctrl+c)"
echo ""

seconds=30

sif=$(( $(date +%s) + ${seconds} )) #seconds in the future

while [ ${sif} -ge $(date +%s) ]; do 
	
	sifdiff=$(( ${sif} - $(date +%s) ))
	echo -ne "$(date -u --date @${sifdiff} +%H:%M:%S)\r"
	
done

reboot

# ===========================================================
