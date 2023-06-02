#!/bin/bash
# usage: ./pen_cracked_accounts.sh secretdumps.out hashcat.potfile
secretsdump="$1"
potfile="$2"
#potfile="/home/$LOGNAME/.local/share/hashcat/hashcat.potfile"

if [[ ! -r $secretsdump ]]; then
	echo $secretsdump.": INVALID SECRETDUMPS FILE."
	exit;
fi

echo "NO CRACKED ACCOUNT." > cracked_accounts.txt

if [[ -e $potfile && -r $potfile ]]; then
	echo "" > cracked_accounts.txt
	cat $potfile | while read line; do
		cracked_hash=`echo $line | cut -f1 -d:`
		grep $cracked_hash $secretsdump | cut -f1 -d: >> cracked_accounts.txt
	done
fi

cat cracked_accounts.txt