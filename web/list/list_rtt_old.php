<?

####exibicao para falha

   if ($ver=="rtt"){



      $link_chk_all="<a href='http://$ips/fping4.0/bd/check_Update_all_n.php?dir=$dir&cor=$ver' target=_blank>check all</a>";
      echo "<table width=1200>";
      echo "<tr bgcolor='CCCCCC'>";
      echo "<td width='32' colspan='1'>proc</td>";
      echo "<td width='32' colspan='1'>cpu</td>";
      echo "<td width='32' colspan='1'>cfg</td>";
      echo "<td width='80'>data</td>";
      echo "<td width='220'>host_a int_a - host_b int_b</td>";
      echo "<td width='80'>ipa - ipb</td>";
      echo "<td width='250'>Descricao</td>";
      echo "<td width='24'>rtt</td>";
      echo "<td width='100'>loss</td>";
      echo "<td width='100' colspan='3'>info</td>";
      echo "</tr>";
      rsort($fp);
##################paginacao

      $i=1;

      $inicio=$num_pagina*$num_reg-($num_reg);

      $fim=$inicio+$num_reg;



         $total=$rtt;

      $total_paginas=(int) ($total/$num_reg);

##################fim paginacao

      foreach ( $fp as $linha )
      {

         $res=split(";",$linha);

         $res=split(";",$linha);

         $tstp=$res[0];
         $data_reg=$res[1];
         $ip_a=$res[2];
         $host_a=$res[10];
         $int_a=$res[11];
         $status=$res[7];
         $cod=$res[8];
         $ip_b=$res[9];
         $host_b=$res[12];
         $int_b=$res[13];
         $descr=$res[14];
         $vel=$res[18];
         $desig=$res[19];
         $tipo_link=$res[20];
         $mn_tipo=$res[21];
         $check_info=$res[22];
         $tstp_check=$res[23];
         $operadora=$res[38];

         $mfr_a=$res[15];
         $mfr_b=$res[16];
         $envia_email=$res[17];

         $tel_operadora=$res[38];

         $vcpu_a=$res[32];
         $vcpu_b=$res[33];

         $v_mem_io_a=$res[36];
         $v_mem_io_b=$res[37];

         $v_mem_proc_a=$res[34];

#echo "$ver -- $teste_ver $status<br>";


###############################

         if (preg_match('/rtt|lat/i', $status)) {

#echo "$status <br>";
            $res=split(";",$linha);
            if ($check_info=="check"){

               continue;
            }


###################paginacao


         $i++;

         if ($i>=$inicio and $i<$fim){


         }
         else {

            if ($i>$fim){
               Break;
            }
            else{
               continue;

            }

         }


########################
$link_cfg_a=link_cfg($host_a);

$link_cfg_b=link_cfg($host_b);

$link_gauge_a=link_cpu($vcpu_a,$host_a,"24");

$link_gauge_b=link_cpu($vcpu_b,$host_b,"24");

$link_mem_proc_a=link_mem_proc($v_mem_proc_a,$host_a);

$link_mem_proc_b=link_mem_proc($v_mem_proc_b,$host_b);

$link_gerar_evento=link_cadastro($cod,"falha",$operadora,$desig,$vel);


         $ipla=$res[56];
         $iplb=$res[57]; 
         
$teste_rtt=split(" ",$res[4]);

$tipo_rtt=$res[59];
#echo ",$teste_rtt[0] | ,$teste_rtt[1]<br>";
if ($res[58]=="sim"){
#$link_rtt_b=link_rtt($cod,"rtt",$host_a,$ipla,$int_a,$ip_b,$teste_rtt[0],$host_b,$int_b,$tipo_rtt);
#$link_rtt_a=link_rtt($cod,"rtt",$host_b,$iplb,$int_b,$ip_a,$teste_rtt[1],$host_a,$int_a,$tipo_rtt);

$lk_rtt=link_rttx($cod,"rtt",$host_b,$iplb,$int_b,$ip_a,$teste_rtt[1],$host_a,$int_a,$tipo_rtt,$ipla,$teste_rtt[0],$ip_b);
}
else{

#$link_rtt_a=link_rtt($cod,"rtt",$host_a,$ipla,$int_a,$ip_b,$teste_rtt[0],$host_b,$int_b,$tipo_rtt);
#$link_rtt_b=link_rtt($cod,"rtt",$host_b,$iplb,$int_b,$ip_a,$teste_rtt[1],$host_a,$int_a,$tipo_rtt);

$lk_rtt=link_rttx($cod,"rtt",$host_a,$ipla,$int_a,$ip_b,$teste_rtt[0],$host_b,$int_b,$tipo_rtt,$iplb,$teste_rtt[1],$ip_a);
}
         $corx="CC99FF";
         $vcolor="CC99FF";
         $vfont_color="black"; 
####check sys

###########novo sistema check

         $sqly="Select * from check_fp where cod_fping='$cod' and time_stamp='$tstp' and cli='$dir' order by cod desc limit 1";

#         echo "$sqly $con <br>";
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

         $link_chk="<a href='http://$ips/fping4.0/bd/check_Update_n.php?acao=check&codh=$cod&dt=$res[1]&tstp=$ty&cli=$dir&cnx=$host_a $int_a' target=_new>check</a>";

         if ($tstp==$tstp_checky) {

#echo "entrou <br>";
            $corx="#CCCCCC";

            $link_chk="<a href='http://$ips/fping4.0/bd/atualiza_check_Update_n.php?cod=$cod_chk&codh=$cod&tstp=$ty&v_acao=com&cli=$dir' target=_new>comentar</a>";
         }

###fim check

         $obsx=":";

         $obsx=str_replace(chr(13),"<br>",$obsy);

################
################
################
         $link_pesquisa="<a href='http://$ips/fping4.0/mon_pesquisa.php?txt_busca=$hostname' target=_blank>$hostname</a>";


         echo "<tr>";
      echo "<td bgcolor='$vcolory' width='1' style='border-bottom: 1 solid $vcolor'>".$link_mem_proc_a."<br><br>".$link_mem_proc_b."</td>";
      echo "<td bgcolor='$vcolory' width='1' style='border-bottom: 1 solid $vcolor'>".$link_gauge_a."<br>".$link_gauge_b."</td>";
      echo "<td bgcolor='$vcolory' width='32' style='border-bottom: 1 solid $vcolor'>".$link_cfg_a."<br>".$link_cfg_b."</td>";
         echo "<td bgcolor='$vcolor' width='80'>$data_reg</td>";
         echo "<td bgcolor='$vcolor' width='220'>$host_a ".$int_a."<br>".$host_b." ".$int_b."</td>";
         echo "<td bgcolor='$vcolor' width='80'>$ip_a<br>$ip_b</td>";
         echo "<td bgcolor='$vcolor' width='250'>$descr</td>";
#         echo "<td width='24' bgcolor='FFFFFF'>".$link_rtt_a."<br>".$link_rtt_b."<br>".$lk_rtt."</td>";
         echo "<td width='24' bgcolor='FFFFFF'>".$lk_rtt."</td>";
         echo "<td width='100' bgcolor='$corx'>$res[6]</td>";
      echo "<td width='48' bgcolor='$corx' align='center'>$link_chk</td>";
      echo "<td width='32' bgcolor='$corx' align='center'>$link_gerar_evento</td>";
         echo "<td bgcolor='$vcolor' width='100'>$mn_tipo</td>";
         echo "</tr>";

         $c++;

         }
      }
      echo "</table>";

include_once("/fping4.0/web/list/paginacao.php");

   }

?>
