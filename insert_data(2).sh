#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # INSERT TEAMS TABLE DATA

    # GET WINNER TEAM NAME

      #exclude column names row
      if [[ $WINNER != winner ]]
        then
          # get team name
          WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
            #if team name is not found we need to include the new team to the table
            if [[ -z $WINNER_NAME ]]
              then
              #insert new team
              INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
                #echo call to let us know team was inserted
                if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
                  then
                    echo "Inserted team: $WINNER"
                fi
            fi
      fi

    # GET OPPONENT TEAM NAME

      #exclude column names row
      if [[ $OPPONENT != "opponent" ]]
        then
          # get team name
          OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
            #if team name is not found we need to include the new team to the table
            if [[ -z $OPPONENT_NAME ]]
              then
              #insert new team
              INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
                #echo call to let us know team was inserted
                if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
                  then
                    echo "Inserted team: $OPPONENT"
                fi
            fi
      fi

  # INSERT GAMES TABLE DATA

    # we dont want the column names row so exclude it
    if [[ YEAR != "year" ]]
      then
        #GET WINNER_ID
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        #GET OPPONENT_ID
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        #INSERT NEW GAMES ROW
        INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
          # echo call to let us know what was added
          if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
            then
              echo "New game added: $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
          fi
    fi
done