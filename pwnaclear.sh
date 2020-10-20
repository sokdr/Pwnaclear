#!/bin/bash
echo ' ____                        ____ _ _____       ____'
echo '|  _ \__      ___ __   __ _ / ___| |___ /  __ _| ___|'
echo '| |_) \ \ /\ / /  _ \ / _` | |   | | |_ \ / _` |___ \'
echo '|  __/ \ V  V /| | | | (_| | |___| |___) | (_| |___) |'
echo '|_|     \_/\_/ |_| |_|\__,_|\____|_|____/ \__,_|____/'
echo
echo
#
trap ctrl_c INT

function ctrl_c() { 
        echo 'You pressed Ctrl+C...Exiting'
	exit 0;
}
#
echo "Welcome $HOSTNAME to Pwnaclear: a bash script to find the clear and right handshakes from your friend Pwnagotchi:"
echo
echo "Remember always to backup your original Pwnagotchi handshakes"
echo
read -p 'Please enter the Handshake Path: ' userpath
echo
echo You entered $userpath  #read user input
echo
if [ -d $userpath ];  then # check if user input exists.
	echo 'Directory exists ;) '
else
	echo 'Directory does not exist....exiting (; '
	exit 0;
fi
count=$(find $userpath -type f -name "*.pcap" | wc -l) # count pcap files 
echo
echo 'Found' $count 'PCAP files'
echo
echo 'Checking if aircrack-ng is installed on your system'
echo
if [ -f /usr/bin/aircrack-ng ]; then #check if aircrack-ng is installed on the system
	echo 'OK found moving ok '
else
	echo 'Not found please install it and run again the script'
	exit 0;
fi
echo
mkdir $userpath/CleanHandshakes
touch $userpath/log.txt
echo 'Check for the right pcap files::'
echo '##########'
echo 
{
for file in $userpath/*.pcap; do
	check_pcap=$(echo 1 | aircrack-ng $file) 
	if [[ "$check_pcap" =~ "No networks found, exiting." ]]; then 
	echo > /dev/null 2>&1 
	else mv $file $userpath/CleanHandshakes 
	fi
done } > /$userpath/log.txt 2>&1 # log output errors 
clean_pcap=$(ls -l $userpath/CleanHandshakes | wc -l)
echo '##########'
echo
echo 'it seems you have' $clean_pcap 'pcap files to crack ;)'
echo '##########'
echo 'Happy hunting ;)'

exit 0;
