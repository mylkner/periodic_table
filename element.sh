#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT=$($PSQL "SELECT name FROM elements WHERE atomic_number::text = '$1' OR symbol = '$1' OR name = '$1'")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  echo "$($PSQL "SELECT * FROM types JOIN properties USING(type_id) JOIN elements USING(atomic_number) WHERE name = '$ELEMENT'")" | while IFS="|" read ATOMIC_NUMBER TYPE_ID TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS SYMBOL NAME 
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done 
fi
