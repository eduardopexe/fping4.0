<?

####exibicao para falha

   if ($ver=="crit"){



      $link_chk_all="<a href='http://$ips/fping4.0/bd/check_Update_all_n.php?dir=$dir&cor=$ver' target=_blank>check all</a>";

      echo "<table width=100%>";
      echo "<tr bgcolor='CCCCCC'>";
      echo "<td>";
      echo "atualizar";
      echo "</td>";
      echo "<td>";
      echo "data";
      echo "</td>";
      echo "<td>";
      echo "mem";
      echo "</td>";
      echo "<td>";
      echo "cpu";
      echo"</td>";
      echo"<td>";
      echo"cfg";
      echo"</td>";
      echo"<td>";
      echo"rtt";
      echo"</td>";
      echo"<td>";
      echo"lat";
      echo"</td>";
      echo"<td width=44>";
      echo"% utl.";
      echo"</td>";
      echo"<td>";
      echo"loss";
      echo"</td>";
      echo"<td>";
      echo"+crc";
      echo"</td>";
      echo"<td>";
      echo"+erros";
      echo"</td>";
      echo"<td>";
      echo"+resets";
      echo"</td>";
      echo"<td>";
      echo"hostname interface";
      echo"</td>";
      echo"<td>";
      echo"ip";
      echo"</td>";
      echo"<td>";
      echo"descricao";
      echo"</td>";
      echo"<td>";
      echo"";
      echo "</td>";
      echo "</tr>";

      rsort($fp);
##################paginacao

      $i=1;

      $inicio=$num_pagina*$num_reg-($num_reg);

      $fim=$inicio+$num_reg;



         $total=$crit;

      $total_paginas=(int) ($total/$num_reg);

##################fim paginacao

      foreach ( $fp as $linha )
      {

         $res=split(";",$linha);
         $resx=split(";",$linha);

      $tstp=$resx[0];
      $data_reg=$resx[1];
      $ip_a=$resx[2];
      $host_a=$resx[10];
      $int_a=$resx[11];
      $status=$resx[7];
      $cod=$resx[8];
      $ip_b=$resx[9];
      $host_b=$resx[12];
      $int_b=$resx[13];
      $descr=$resx[14];
      $vel=$resx[18];
      $desig=$resx[19];
      $tipo_link=$resx[20];
      $mn_tipo=$resx[21];
      $check_info=$resx[22];
      $tstp_check=$resx[23];
      $operadora=$resx[38];

      $mfr_a=$resx[15];
      $mfr_b=$resx[16];
      $envia_email=$resx[17];

#   $tel_operadora=$resx[38];

      $vcpu_a=$resx[32];
      $vcpu_b=$resx[33];

      $v_mem_io_a=$resx[36];
      $v_mem_io_b=$resx[37];
      $v_mem_proc_a=$resx[34];

      $ipla=$resx[56];
      $iplb=$resx[57];

      $pct_utl_a=$resx[42];
      $pct_utl_b=$resx[43];
      $in_err_a=$resx[44];
      $in_err_b=$resx[45];
      $out_err_a=$resx[46];
      $out_err_b=$resx[47];
      $coll_a=$resx[48];
      $coll_b=$resx[49];
      $int_resest_a=$resx[50];
      $int_resest_b=$resx[51];
      $drop_a=$resx[52];
      $drop_b=$resx[53];
      $crc_a=$resx[54];
      $crc_b=$resx[55];
      $tipo_rtt=$res[59];
      $ambiente=$res[60];

      $teste_rtt=split(" ",$resx[4]);
      $teste_lat=split("#",$resx[6]);

      $teste_loss=split("#",$resx[5]);

      $teste_fping=split(" ",$resx[3]);

       #satus cpu e mem
$status_cx=$res[30];
$status_info=$res[31];
$status_med="cpu: $res[32]  |  mem proc: $res[34] - mem io: $res[36]";

#echo "$statusn $res[30]||| $res[9] |||$res[7]<br>";
#echo "$ver -- $teste_ver <br>";
         if (preg_match('/alarme|utl|crit/i', $status_cx) or preg_match('/alarme|utl|crit/i', $res[7])) {

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


         $corx="99CCFF";
         $vcolor="99CCFF";
         $vfont_color="white"; 
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


$link_cfg_a=link_cfg($host_a);

$link_cfg_b=link_cfg($host_b);

$link_gauge_a=link_cpu($vcpu_a,$host_a,"24");

$link_gauge_b=link_cpu($vcpu_b,$host_b,"24");

$link_mem_proc_a=link_mem_proc($v_mem_proc_a,$host_a);

$link_mem_proc_b=link_mem_proc($v_mem_proc_b,$host_b);

$link_gerar_evento=link_cadastro($cod,"falha",$operadora,$desig,$vel);

$link_lat=link_latx($cod,"lat",$host_a,$ipla,$int_a,$ip_a,$teste_lat[0],$host_b,$int_b,$iplb,$teste_lat[1],$ip_b,$ambiente);

$link_loss_a=link_loss($cod,"loss",$host_a,$ipla,$int_a,$ip_b,$teste_loss[0],$host_b,$int_b);

$link_loss_b=link_loss($cod,"loss",$host_b,$iplb,$int_b,$ip_a,$teste_loss[1],$host_a,$int_a);



$teste_rtt=split(" ",$res[4]);

#echo ",$teste_rtt[0] | ,$teste_rtt[1]<br>";
if ($res[58]=="sim"){

$lk_rtt=link_rttx($cod,"rtt",$host_b,$iplb,$int_b,$ip_a,$teste_rtt[1],$host_a,$int_a,$tipo_rtt,$ipla,$teste_rtt[0],$ip_b);
}
else{


$lk_rtt=link_rttx($cod,"rtt",$host_a,$ipla,$int_a,$ip_b,$teste_rtt[0],$host_b,$int_b,$tipo_rtt,$iplb,$teste_rtt[1],$ip_a);
}
         $corx="99CCFF";
         $vcolor="CC99FF";
         $vfont_color="black";



if ($pct_utl_a==-1){

   $link_utl_a=link_utl($cod,"utl",$host_b,$iplb,$int_b,$ip_a,$pct_utl_b,$host_a,$int_a);

}
else{

   $link_utl_a=link_utl($cod,"utl",$host_a,$ipla,$int_a,$ip_b,$pct_utl_a,$host_b,$int_b);

}


$crc=$crc_a." ".$crc_b;
$link_crc=link_errors($cod,"crc",$host_b,$iplb,$int_b,$ip_a,$crc,$host_a,$int_a);
$int_errors=$in_err_a." ".$in_err_b;
$link_errors=link_errors($cod,"errors",$host_b,$iplb,$int_b,$ip_a,$link_errors,$host_a,$int_a);
$int_resets=$int_resest_a." ".$int_resest_b;
$link_resets=link_errors($cod,"int resets",$host_b,$iplb,$int_b,$ip_a,$int_resets,$host_a,$int_a);
$cory="FFFFFF";

      $cor=$corx;

      if ($pct_utl_a==-1){

         $link_utl_a=link_utl($cod,"utl",$host_b,$iplb,$int_b,$ip_a,$pct_utl_b,$host_a,$int_a);

      }
      else{

         $link_utl_a=link_utl($cod,"utl",$host_a,$ipla,$int_a,$ip_b,$pct_utl_a,$host_b,$int_b);

      }


      echo "<tr bgcolor=$cor>";
      echo "<td width='32' bgcolor='$corx' align='center'>$link_gerar_evento</td>";
      echo "<td width=150>";
      echo "<font color='$cor_rtt_font'>$data_reg";
      echo "</td>";
      echo "<td bgcolor='$cory' width='1' style='border-bottom: 1 solid $vcolor'>".$link_mem_proc_a."<br><br>".$link_mem_proc_b."</td>";
      echo "<td bgcolor='$cory' width='1' style='border-bottom: 1 solid $vcolor'>".$link_gauge_a."<br>".$link_gauge_b."</td>";
      echo "<td bgcolor='$cory' width='32' style='border-bottom: 1 solid $vcolor'>".$link_cfg_a."<br>".$link_cfg_b."</td>";
      echo "<td width='24' bgcolor='$cory'>".$lk_rtt."</td>";
      echo "<td bgcolor='$cory'>";
      echo "$link_lat";
      echo "</td>";
      echo "<td width=38 bgcolor='$cory'>";
      echo "$link_utl_a";
      echo "</td>";
      echo "<td width=38 bgcolor='$cory'>";
      echo $link_loss_a."<br>".$link_loss_b;
      echo "</td>";
      echo "<td bgcolor='$cory'>";
      echo "$link_crc";
      echo "</td>";
      echo "<td bgcolor='$cory'>";
      echo "$link_errors";
      echo "</td>";
      echo "<td bgcolor='$cory'>";
      echo "$link_resets";
      echo "</td>";
      echo "<td width=290>";
      echo "<font color='$cor_rtt_font'>$host_a $int_a <br>$host_b $int_b";
      echo "</td>";
      echo "<td>";
      echo "<font color='$cor_rtt_font'>$ip_a<br>$ip_b";
      echo "</td>";
      echo "<td>";
      echo "$descri";
      echo "</td>";
      echo "</tr>";
         $c++;

         }
      }
      echo "</table>";

include_once("/fping4.0/web/list/paginacao.php");

   }

?>
