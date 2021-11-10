#!/usr/bin/env bash
version=0.10

install_chrome(){
    echo "installs chrome"
}

install_vscode(){
    echo "install vscode"
}

install_discord(){
    echo "installs discord"
}

ask(){
    local message_prompt
    local -l answer

    message_prompt=$1

    while true; do
        read -p "${message_prompt}" answer
        case ${answer} in
            y|n)
                echo ${answer};
                return
                ;;
            "")
                echo "n"
                return
                ;;
            *)
                echo "Invalid answer, please answer 'y' or 'n'"
                ;;
        esac
    done
}

menu(){
    local answer
    local -a list_functions
    local -a toinstall

    echo -e "Which program you want to install ?\n"

    list_functions=( "$(declare -f | awk '$1 ~ "install_" { print $1 }')" )

    for ifunction in ${list_functions[@]}; do
        answer=$(ask "Would you like to install ${ifunction#*_} [y/N] ?")
        if [ ${answer} == "y" ]; then
            toinstall+=(${ifunction});
        fi
    done
    echo

    makeinstall ${toinstall[@]}

}

makeinstall(){
    local programs
    programs=$@
    for prg in ${programs[@]}; do
        echo "I am installing ${prg#*_}"
        ${prg}
    done
}

main(){
    getopts 'v' VERSION
    if [ ${VERSION} == "v" ]; then
        echo ${version};
        exit 0
    fi

    menu;
}

if [[ "$0" == "${BASH_SOURCE}" ]]; then
    main $@
fi