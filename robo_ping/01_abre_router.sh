#!/bin/bash

NEWLINE='
';
IFS=$NEWLINE;

lista=$(cat /fping4.0/routers_ebt/$1);


   for x in $lista;

   do

      cod=$(echo $x | cut -f2 -d"*");
      pe=$(echo $x | cut -f3 -d"*");
      ser_a=$(echo $x | cut -f11 -d"*");
      ip_remoto=$(echo $x | cut -f7 -d"*");
      vrf=$(echo $x | cut -f8 -d"*");
      ser2=$(echo $x | cut -f9 -d"*");

echo "###### $ser2 #####";

   /fping4.0/robo_ping/01_ping.tcl $x

   perl /fping4.0/robo_ping/leitor.pl $cod $pe $ser_a
   
   rm /fping4.0/robo_ping/log_telnet/$cod-$pe-$ser_a.txt

   done

IFS=" ";
exit
