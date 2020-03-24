#!/usr/local/bin/bash

clear 

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

function letterAssign(){

	if [[ $((RANDOM%2)) -eq 0 ]]
	then	
		currentPlayer="user"
		user="X"
		computer="O"
	else
		currentPlayer="computer"
		computer="X"
		user="O"
	fi

	echo "user will play with $user and computer will play with $computer"

}

function main(){

	read -p "Do you want to start the game? enter 'y' for yes or anything else for no: " choice
	
	if [[ $choice = "y" || $choice = "Y" ]]
	then
		resetBoard
		displayBoard
	fi

	letterAssign
}

main