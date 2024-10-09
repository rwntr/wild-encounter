#!/bin/bash

#can be named anything, just point to it here
WHITELIST="/YOUR/WHITELIST/FILE/HERE"

#can be named anything, just point to it here
#this file is temporary and is removed after script execution
SELECTED="/YOUR/TEMPFILE/HERE"

#controls how often you see shinies.  This is the DENOMINATOR,
#so bigger numbers = less likely.

SHINYODDS=4096

POKENAME="#"

while [[ $POKENAME == *"#"* ]]; do
	shuf -n 1 $WHITELIST > $SELECTED
	POKENAME=$(head -n 1 $SELECTED)
done

#the way this works is scuffed, I know - don't include doubles of 
#alolan or galarian forms in the whitelist please.

HASALOLA=$(cat $WHITELIST | grep -c ""$POKENAME" alola")
HASGALAR=$(cat $WHITELIST | grep -c ""$POKENAME" galar")
INCREMENTOR=$((1+$HASALOLA+$HASGALAR))
FORMSWITCH=$(($RANDOM % $INCREMENTOR))
FORM="break"

case "$FORMSWITCH" in 
"0") 	FORM="regular";;
"1")	
	if [[ $HASGALAR -gt $HASALOLA ]]; then
		FORM="galar"
	else
		FORM="alola"
	fi ;;
"2")	FORM="galar";;
*)	FORM="regular";;
esac

#this statement here ensures a broken version of this script
#doesn't run and look bad in your IDE's terminal.

#If you use something other than kitty, you should change
#the first conditional here accordingly.

if [[ "$TERMINFO" == /usr/lib/kitty/terminfo ]]; 	then
	if [[ "$((1 + $RANDOM % $SHINYODDS))" == "1" ]]; 	then
		if [[ "$FORM" != "regular" ]]; 		then	
		pokego -name "$POKENAME" -no-title -shiny -form "$FORM"
		else
		pokego -name "$POKENAME" -no-title -shiny
		fi
	else
		if [[ "$FORM" != "regular" ]]; then
                pokego -name "$POKENAME" -no-title -form "$FORM"
                else
                pokego -name "$POKENAME" -no-title              
		fi
	fi
fi

rm $SELECTED