#!/usr/local/bin/bash

declare -a board
board=(0 1 2 3 4 5 6 7 8)

function resetBoard() {
	echo "New game starts"

	board=(0 1 2 3 4 5 6 7 8)
	
}

function displayBoard(){
for (( row=0; row<7; row=row+3 ))
do
	echo " ${board[$row]} | ${board[$row+1]} | ${board[$row+2]}"
	if [ $row -lt 6 ]
	then
		echo "---*---*---"
	fi 
done
}

function main(){
	read -p "Do you want to start the game? enter 'y' for yes or anything else for no: " choice
	resetBoard
	if [[ $choice = "y" || $choice = "Y" ]]
	then
		displayBoard
	fi

}

main