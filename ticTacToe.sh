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

function winBlockCondition(){
	local symbol=$1
	if [ $flag -eq 0 ]
	then 
		computerRowWin $symbol
	fi
	if [ $flag -eq 0 ]
	then
		computerColumnWin $symbol
	fi
	if [ $flag -eq 0 ]
	then
		computerDiagonalWin $symbol
	fi
}


function computerRowWin(){
	local symbol=$1
	for((row=0;row<9;row=row+3))
	do
   		if [[ ${board[$row]} == $symbol && ${board[$row+1]} == $symbol && ${board[$row+2]} == $((row+2)) ]]
   		then
				board[$row+2]=$computer
				noMove=1
				checkConditions
   		elif [[ ${board[$row]} == $symbol && ${board[$row+2]} == $symbol && ${board[$row+1]} == $((row+1)) ]]
			then
        		board[$row+1]=$computer
        		noMove=1
				checkConditions
   		elif [[ ${board[$row+1]} == $symbol && ${board[$row+2]} == $symbol && ${board[$row]} == $row ]]
   		then
        		board[$row]=$computer
        		noMove=1
        		checkConditions
   		fi
	done
}

function computerColumnWin(){
	local symbol=$1
	for((column=0;column<7;column=column+1))
	do
		if [[ ${board[$column]} == $symbol && ${board[$column+3]} == $symbol && ${board[$column+6]} == $((column+6)) ]]
		then
			board[$column+6]=$computer
			noMove=1
			checkConditions
		elif [[ ${board[$column]} == $symbol && ${board[$column+6]} == $symbol && ${board[$column+3]} == $((column+3)) ]]
		then
			board[$column+3]=$computer
			noMove=1
			checkConditions
		elif [[ ${board[$column+3]} == $symbol && ${board[$column+6]} == $symbol && ${board[$column]} == $column ]]
		then
			board[$column]=$computer
			noMove=1
			checkConditions
		fi
	done
}

function computerDiagonalWin(){
	local symbol=$1
	diagonal=0
	if [[ ${board[$diagonal+2]} == $symbol && ${board[$diagonal+4]} == $symbol && ${board[$diagonal+6]} == $((diagonal+6)) ]]
	then
     		board[$diagonal+6]=$computer
     		noMove=1
			checkConditions
   	elif [[ ${board[$diagonal+2]} == $symbol && ${board[$diagonal+6]} == $symbol && ${board[$diagonal+4]} == $((diagonal+4)) ]]
   	then
			board[$diagonal+4]=$computer
			noMove=1
			checkConditions
   	elif [[ ${board[$diagonal+4]} == $symbol && ${board[$diagonal+6]} == $symbol && ${board[$diagonal+2]} == $((diagonal+2)) ]]
   	then
			board[$diagonal+2]=$computer
			noMove=1
			checkConditions
   	elif [[ ${board[$diagonal]} == $symbol && ${board[$diagonal+4]} == $symbol && ${board[$diagonal+8]} == $((diagonal+8)) ]]
   	then
			board[$diagonal+8]=$computer
			noMove=1
			checkConditions
   	elif [[ ${board[$diagonal]} == $symbol && ${board[$diagonal+8]} == $symbol && ${board[$diagonal+4]} == $((diagonal+4)) ]]
   	then
			board[$diagonal+4]=$computer
			noMove=1
			checkConditions
   	elif [[ ${board[$diagonal+4]} == $symbol && ${board[$diagonal+8]} == $symbol && ${board[$diagonal]} == $diagonal ]]
   	then
			board[$diagonal]=$computer
			noMove=1
			checkConditions
   	fi
}

function checkCorner(){
	for((i=0;i<7;i=i+6))
	do
		if [[ ${board[$i]} == $i ]]
		then
			board[$i]=$computer
			noMove=1
			checkConditions
			break
		elif [[ ${board[$i+2]} == $((i+2)) ]]
		then
			board[$i+2]=$computer
			noMove=1
			checkConditions
			break
		fi
	done
}


function checkConditions(){
	displayBoard
	flag=1
	((turnCount++))
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
	flag=0
	noMove=0
	if [[ $turnCount -lt $MAX_TURNS ]]
	then
		winBlockCondition $computer
		winBlockCondition $user
		if [[ flag -eq 0 ]]
		then
			checkCorner
		fi

		if [[ $noMove -eq 0 ]]
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
	read -p "Do you want to start a game? enter 'y' for yes or anything else for no: " choice
	
	if [[ $choice = "y" || $choice = "Y" ]]
	then
		clear

		declare -a board
		
		turnCount=0
		MAX_TURNS=9
		flag=1
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