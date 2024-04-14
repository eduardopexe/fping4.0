#!/bin/bash

#auteor:Pexe - eduardopexe@yahoo.com.br - 14/05/2009
#script de coleta de dados bdc:
#parametros
#$1 - arquivo com a lista de ambientes e tempo de espera


ip=`cat /fping4.0/ambientes/lista_ambientes.txt`;

cd /fping4.0/

for x in $ip;

do

/fping4.0/fp_mon.sh $x &

done

exit
