#!/bin/bash


lista=$(cat /fping4.0/routers_ebt/routers.txt);


   for x in $lista;

   do


   /fping4.0/robo_ping/01_abre_router.sh $x
   

   done


perl /fping4.0/robo_ping/sumario.pl

exit
