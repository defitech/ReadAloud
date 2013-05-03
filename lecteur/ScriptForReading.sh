#!/bin/sh

#  ScriptForReading.sh
#  lecteur
#
#  Created by dev on 02.05.13.
#  Copyright (c) 2013 dev. All rights reserved.
PRESSEPAPIER=`pbpaste`
INTERRUPTEUR='ON'
while :
do
read -t 1 -n 1 key
if [[ $key = d ]]
then
INTERRUPTEUR='ON'
echo -e "\npressez la touche a pour mettre en pause le programme"
fi
while [ $INTERRUPTEUR == 'ON' ];
do
read -t 1 -n 1 key
if [[ $key = a ]]
then
INTERRUPTEUR='OFF'
kill $(ps aux | grep '[s]ay' | awk '{print $2}')
echo -e "\nle programme est maintenant en pause, pressez la touche d pour le redémarrer"
fi
if [ "$PRESSEPAPIER" != "`pbpaste`" ]
then
kill $(ps aux | grep '[s]ay' | awk '{print $2}')
say "`pbpaste`" &
PRESSEPAPIER=`pbpaste`
fi
done
done