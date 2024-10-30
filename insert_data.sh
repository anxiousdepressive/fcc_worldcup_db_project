#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$($PSQL "TRUNCATE TABLE games, teams;")
echo Tables cleared for data

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #go past the first line of the csv file
  if [[ $YEAR != year ]]
  then
    #check if line is not null
    if [[ $YEAR != NULL ]]
    then
      #get WINNER_ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      #if not found
      if [[ -z $WINNER_ID ]]
      then
        #insert WINNER into teams table
        INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams (name) VALUES('$WINNER')")
        #check if insert worked and echo message
        if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
        then
          echo Team $WINNER inserted into teams table
        fi
        #get new WINNER_ID
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi
      #get OPPONENT_ID
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #if not found
      if [[ -z $OPPONENT_ID ]]
      then
        #insert OPPONENT into teams table
        INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES('$OPPONENT')")
        #check if it worked and echo result
        if [[ $INSERT_OPPONENT_RESULT=='INSERT 0 1' ]]
        then
          echo Team $OPPONENT inserted into teams table
        fi
        #get new OPPONENT_ID
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi
      #fill out games table
      INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
      #check if it worked and echo result
      if [[ $INSERT_GAMES_RESULT=='INSERT 0 1' ]]
      then
        echo $WINNER vs $OPPONENT from $YEAR inserted into games table
      fi
    fi
  fi
  
  
done
