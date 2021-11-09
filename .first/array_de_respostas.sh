#!/bin/bash

array_program=("CHROME" "VS-CODE" "DISCORD" "FILEZILLA" "ANYDESK" "POSTMAN" "MY-SQL/WORKBENCH" "SIMPLESCREENRECORDER" "FLAMESHOT" "KOLOURPAINT" "NPM")

arr_global='export array_answer=('

for ((i=0; i<${#array_program[@]}; ++i)); do

	read -p "Deseja instalar ${array_program[${i}]} (y/n)? " array_answer[${i}]
	arr_global+="\"${array_answer[${i}]}\""
	
	[ ${i} -lt $((${#array_program[@]}-1)) ] && arr_global+=' '

done

arr_global+=')'

echo "${arr_global}"
