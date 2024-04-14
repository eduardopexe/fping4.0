#!/bin/bash

#echo "### PING MONITORING ENGINE ###";

reg=$(echo $1 | cut -d ":" -f 1 );

sl=$(echo $1 | cut -d ":" -f 2 );

echo $reg $sl;

sleep $sl;

cd /fping4.0/coleta

#for x in $arquivo;
#do

if [ $reg == "ebtv" ]; then
c=10;
t=8000;
b=20;
i=5;

else

c=3;
t=4000;
b=20;
i=5;

fi

if [ $reg == "cqmri" ]; then
c=10;
t=18000;
b=20;
i=5;
fi

if [ $reg == "kpmg" ]; then
c=10;
t=18000;
b=20;
i=5;
fi

/usr/local/sbin/fping -q -c $c -t $t -b $b -i $i -f /fping4.0/lista_ip/$reg.txt &> "/fping4.0/coleta/tcoleta_$reg.txt";

#echo "-c $c -t $t -b $b -i $i ";

mv /fping4.0/coleta/tcoleta_$reg.txt /fping4.0/coleta/coleta_$reg.txt

perl /fping4.0/leitor/fp_leitor.pl $reg ;

mv /fping4.0/web/resultado/$reg/tmp_res_$reg.txt /fping4.0/web/resultado/$reg/res_$reg.txt;

mv /fping4.0/web/resultado/$reg/tmp_fping_rtt_media_$reg.txt  /fping4.0/web/resultado/$reg/fping_rtt_media_$reg.txt ;

mv /fping4.0/web/resultado/$reg/tmp_loss_$reg.txt  /fping4.0/web/resultado/$reg/loss_$reg.txt; 

perl  /fping4.0/leitor/gera_topo.pl $reg "2-" log

perl  /fping4.0/leitor/gera_topo.pl $reg "1-|2-" fis_e_log

perl /fping4.0/leitor/leitor_log.pl $reg &

exit

