#!/bin/bash
# usage: ./pen_cracked_accounts.sh secretdumps.out
args="$@"
secretsdump="${args[0]}"
#potfile="${args[1]}"
potfile="/home/$LOGNAME/.local/share/hashcat/hashcat.potfile"

if [[ ! -r $secretsdump ]]; then
	echo $secretsdump.": INVALID SECRETDUMPS FILE."
	echo $potfile
	exit;
fi

echo "NO CRACKED ACCOUNT." > cracked_accounts.txt

if [[ -e $potfile && -r $potfile ]]; then
	echo "" > cracked_account.txt

	cat $potfile | while read line; do
		cracked_hash=`echo $line | cut -f1 -d:`
		grep $cracked_hash $secretsdump >> cracked_accounts.txt
	done
fi

cat cracked_accounts.txt