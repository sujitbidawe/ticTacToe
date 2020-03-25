#!/usr/local/bin/bash

clear

function resetBoard() {
	echo "********** New game starts **********"
	board=(0 1 2 3 4 5 6 7 8)
}

function displayBoard(){
for (( row=0; row<=6; row=row+3 ))
do
	echo " ${board[$row]} | ${board[$row+1]} | ${board[$row+2]}"
	if [ $row -lt 6 ]
	then
		echo "---*---*---"
	fi 
done
echo ""
}

function letterAssign(){
	if [[ $((RANDOM%2)) -eq 0 ]]
	then	
		user="X"
		computer="O"
	else
		computer="X"
		user="O"
	fi
	echo "user will play with $user and computer will play with $computer"
}

function toss(){
	if [[ $((RANDOM%2)) -eq 0 ]]
	then
		currentPlayer="user"
	else
		currentPlayer="computer"
	fi
	echo "$currentPlayer will start the game!"
}

function winChecker() {
   diagonal=0
   column=0
   for((row=0;row<9;row=row+3))
   do
      if [[ ${board[$row]} == ${board[$row+1]} && ${board[$row+1]} == ${board[$row+2]} ]] ||
         [[ ${board[$column]} == ${board[$column+3]} && ${board[$column+3]} ==  ${board[$column+6]} ]] || 
         [[ ${board[$diagonal]} == ${board[$diagonal+4]} && ${board[$diagonal+4]} == ${board[$diagonal+8]} ]] ||
         [[ ${board[$diagonal+2]} == ${board[$diagonal+4]} && ${board[$diagonal+4]} == ${board[$diagonal+6]} ]]
      then  
         echo "$currentPlayer Wins!!"
         echo ""
         main
      fi
      column=$((column+1))
   done
}


function play(){
	if [[ "$currentPlayer" = "user" ]]
	then
		userPlay
	else
		computerPlay
	fi
}

function userPlay(){
	currentPlayer="user"
	if [[ $turnCount -lt $MAX_TURNS ]]
	then
		read -p "Choose your position between 0 to 8: " position
		if [[ "${board[$position]}" = "$position" ]]
		then
			board[$position]=$user	
			((turnCount++))
			displayBoard
		else
			echo "Invalid position, please enter valid position between 0 to 8"
			userPlay
		fi
		winChecker
		computerPlay
	else
		echo "Game tie !!"
		echo ""
		main
	fi
}

function computerPlay(){
	currentPlayer="computer"
	if [[ $turnCount -lt $MAX_TURNS ]]
	then
		position=$((RANDOM%9))
		if [[ "${board[$position]}" = "$position" ]]
		then
			echo "computer's play:"
			board[$position]=$computer
			((turnCount++))
			displayBoard
		else
			computerPlay
		fi
		winChecker
		userPlay
	else
		echo "Game tie !!"
		echo ""
		main
	fi
}


function main(){
	echo "lets play with a smart computer"
	read -p "Do you want to start a game? enter 'y' for yes or anything else for no: " choice
	
	if [[ $choice = "y" || $choice = "Y" ]]
	then
		clear

		declare -a board
		
		turnCount=0
		MAX_TURNS=9
		user=""
		computer=""
		currentPlayer=""
		
		resetBoard
		letterAssign
		toss
		displayBoard
		play

	else
		echo "Bye!"
		exit
	fi

}

main