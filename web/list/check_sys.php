<?
#####################################


###########novo sistema check

         $sqly="Select * from check_fp where cod_fping='$cods' and time_stamp='$ts' and cli='$clis' order by cod desc limit 1";

         echo "$sqly $con <br>";
         $resultadoy = mysql_query($sqly,$con);

         #echo "$resultado <br>";
         $retornoy=mysql_fetch_assoc($resultadoy);

         $tstp_checky=$retornoy['time_stamp'];
         $inty=$retornoy['interface'];
         $cod_chky=$retornoy['cod'];
         $obsy=$retornoy['obs'];
         $codf=$retorno['cod_fping'];
         #$tstp=$res[0];
         #echo "$res[0] ||| $tstp_check -- $ip <br>";


         $link_chk="<a href='http://$ips/fping4.0/bd/check_Update_n.php?acao=check&codh=$cod&dt=$res[1]&tstp=$ty&cli=$dir";
         $link_chk=$link_chk."&cnx=$host_a $int_a' target='_blank'>";
         $link_chk=$link_chk."<img border='0' src='http://$ips/fping4.0/icones/check.png' width='39' height='48' title='marcar alarme'>";
         $link_chk=$link_chk."</a>";

         $corinfo="#FFFFFF";

         if ($tstp==$tstp_checky) {

#echo "entrou <br>";
            $corx="#CCCCCC";
            $corinfo="#FFFFFF";

         $link_chk="<a href='http://$ips/fping4.0/bd/atualiza_check_Update_n.php?cod=$cod_chk&codh=$cod&tstp=$ty";
         $link_chk=$link_chk."&v_acao=com&cli=$dir' target='_blank'>";
         $link_chk=$link_chk."<img border='0' src='http://$ips/fping4.0/icones/comentar.png' width='54' height='48' title='comentar'>";
         $link_chk=$link_chk."</a>";

         }
###fim check

         $obsx=":";

         $obsx=str_replace(chr(13),"<br>",$obsy);
?>
