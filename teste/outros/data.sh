#!/usr/bin/env bash

version="1.0.9"
seconds=30

print_usage() {
   echo -e "Usege: $ ./$(basename $0) -t <segundos>"
}

while getopts 'vht:' opts 2> /dev/null; do
   case ${opts} in
      v)
         echo -e "cork version ${version}"
         exit
         ;;
      h)
         print_usage
         exit
         ;;
      t)
         seconds=${OPTARG}
         ;;
      ?)
         print_usage
         exit 1
         ;;
      esac
done

shift $((OPTIND - 1))

sif=$(( $(date +%s) + ${seconds} )) #seconds in the future

while [ "${sif}" -ge $(date +%s) ]; do 
	
	sifdiff=$(( ${sif} - $(date +%s) ))
	echo -ne "$(date -u --date @${sifdiff} +%H:%M:%S)\r"
	
   if [ ${sifdiff} -eq 0 ]; then
      copy=${sifdiff}  
   fi

done

echo ${copy}