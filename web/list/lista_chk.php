<?

####exibicao para falha

   if ($ver=="chk"){

$link_chk_all="<a href='http://$ips/fping4.0/bd/check_Update_all_n.php?dir=$dir&cor=$ver' target=_blank>";
$link_chk_all=$link_chk_all."<img border='0' src='http://$ips/fping4.0/icones/checkall.png' width='24' height='24' title='marcar todos os alarmes'>";
$link_chk_all=$link_chk_all."</a>";

      echo "<table width=1200>";
      echo "<tr bgcolor='CCCCCC'>";
      echo "<td width='32' colspan='1'>proc</td>";
      echo "<td width='32' colspan='1'>cpu</td>";
      echo "<td width='32' colspan='1'>cfg</td>";
      echo "<td width='80'>data</td>";
      echo "<td width='220'>host_a int_a - host_b int_b</td>";
      echo "<td width='80'>ipa - ipb</td>";
      echo "<td width='250'>Descricao</td>";
      echo "<td width='39'></td>";
      echo "<td width='32'></td>";    
      echo "<td width='200'>obs</td>";
      echo "<td width='100'>info</td>";
      echo "</tr>";
      rsort($fp);
##################paginacao

      $i=1;

      $inicio=$num_pagina*$num_reg-($num_reg);

      $fim=$inicio+$num_reg;

      if ($ver=="vmc"){


         $total=$qt_check;

      }

      if ($ver=="falha"){

         $total=$falha;

      }

      $total_paginas=(int) ($total/$num_reg);

##################fim paginacao

      foreach ( $fp as $linha )
      {

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

         $mfr_a=$res[15];
         $mfr_b=$res[16];
         $envia_email=$res[17];

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
         $v_mem_proc_b=$res[35];


$link_cfg_a="<a href='http://10.98.22.10/relatorio_routers/controle_de_hosts/controle_de_hosts.asp?str_texto=$host_a' target=_blank>";
$link_cfg_a=$link_cfg_a."<img border='0' src='http://$ips/fping4.0/icones/cfg.png' width='24' height='24' title='ver cofiguração $host_a'>";
$link_cfg_a=$link_cfg_a."</a>";


$link_cfg_b="<a href='http://10.98.22.10/relatorio_routers/controle_de_hosts/controle_de_hosts.asp?str_texto=$host_b' target=_blank>";
$link_cfg_b=$link_cfg_b."<img border='0' src='http://$ips/fping4.0/icones/cfg.png' width='24' height='24' title='ver cofiguração $host_b'>";
$link_cfg_b=$link_cfg_b."</a>";


####imagem cpu a
$img_cpua="nogauge.png";

if ($vcpu_a<0){

$img_cpua="nogauge.png";
$vcpu_a="nao coletado";
}

if ($vcpu_a>0 and $vcpu_a<40){

$img_cpua="gauge1.png";


}

if ($vcpu_a>39 and $vcpu_a<60){

$img_cpua="gauge2.png";


}


if ($vcpu_a>59 and $vcpu_a<85){

$img_cpua="gauge3.png";


}

if ($vcpu_a>84 and $vcpu_a<96){

$img_cpua="gauge4.png";


}


if ($vcpu_a>95){

$img_cpua="gauge5.png";


}

$link_gauge_a="<a href='http://' target=_blank>";
$link_gauge_a=$link_gauge_a."<img border='0' src='http://$ips/fping4.0/icones/$img_cpua' width='24' height='24' title='cpu $host_a: $vcpu_a %'>";
$link_gauge_a=$link_gauge_a."</a>";
###############################

####imagem cpu b
$img_cpub="nogauge.png";

if ($vcpu_b<0){

$img_cpub="nogauge.png";
$vcpu_b="nao coletado";
}


if ($vcpu_b>0 and $vcpu_b<40){

$img_cpub="gauge1.png";


}

if ($vcpu_b>39 and $vcpu_b<60){

$img_cpub="gauge2.png";


}


if ($vcpu_b>59 and $vcpu_b<85){

$img_cpub="gauge3.png";


}


if ($vcpu_b>84 and $vcpu_b<96){

$img_cpub="gauge4.png";


}


if ($vcpu_b>95){

$img_cpub="gauge5.png";


}

$link_gauge_b="<a href='http://' target=_blank>";
$link_gauge_b=$link_gauge_b."<img border='0' src='http://$ips/fping4.0/icones/$img_cpub' width='24' height='24' title='cpu $host_b: $vcpu_b %'>";
$link_gauge_b=$link_gauge_b."</a>";
###############################

#############IO

$img_mem_io_a="disk2.png";
$img_mem_io_b="disk2.png";

$link_mem_io_a="<a href='http://' target=_blank>";
$link_mem_io_a=$link_mem_io_a."<img border='0' src='http://$ips/fping4.0/icones/$img_mem_io_a' width='32' height='5' title='mem I/O $host_a: $v_mem_io_a %'>";
$link_mem_io_a=$link_mem_io_a."</a>";

$link_mem_io_b="<a href='http://' target=_blank>";
$link_mem_io_b=$link_mem_io_b."<img border='0' src='http://$ips/fping4.0/icones/$img_mem_io_b' width='32' height='5' title='mem I/O $host_b: $v_mem_io_b %'>";
$link_mem_io_b=$link_mem_io_b."</a>";


$img_mem_proc_a="disk2.png";
$img_mem_proc_b="disk2.png";

if ($v_mem_proc_a<0){
$v_mem_proc_a="nao coletado";
$img_mem_proc_a="nodisk.png";
}

if ($v_mem_proc_a>0 and $v_mem_proc_a<10){

$img_mem_proc_a="disk1.png";

}





if ($v_mem_proc_a>9 and $v_mem_proc_a<31){

$img_mem_proc_a="disk2.png";

}

if ($v_mem_proc_a>30 and $v_mem_proc_a<61){

$img_mem_proc_a="disk3.png";

}


if ($v_mem_proc_a>60 and $v_mem_proc_a<95){

$img_mem_proc_a="disk4.png";

}


if ($v_mem_proc_a>94){

$img_mem_proc_a="disk5.png";

}

if ($v_mem_proc_b<0){

$v_mem_proc_b="nao coletado";
$img_mem_proc_b="nodisk.png";

}


if ($v_mem_proc_b>0 and $v_mem_proc_b<10){

$img_mem_proc_b="disk1.png";

}

if ($v_mem_proc_b>9 and $v_mem_proc_b<31){

$img_mem_proc_b="disk2.png";

}

if ($v_mem_proc_b>30 and $v_mem_proc_b<61){

$img_mem_proc_b="disk3.png";

}


if ($v_mem_proc_b>60 and $v_mem_proc_b<95){

$img_mem_proc_b="disk4.png";

}


if ($v_mem_proc_b>94){

$img_mem_proc_b="disk5.png";


}

$link_mem_proc_a="<a href='http://' target=_blank>";
$link_mem_proc_a=$link_mem_proc_a."<img border='0' src='http://$ips/fping4.0/icones/$img_mem_proc_a' width='32' height='5' title='mem processador $host_a: $v_mem_proc_a %'>";
$link_mem_proc_a=$link_mem_proc_a."</a>";

$link_mem_proc_b="<a href='http://' target=_blank>";
$link_mem_proc_b=$link_mem_proc_b."<img border='0' src='http://$ips/fping4.0/icones/$img_mem_proc_b' width='32' height='5' title='mem processador $host_b: $v_mem_proc_b %'>";
$link_mem_proc_b=$link_mem_proc_b."</a>";

###############################

         if ($check_info=="check") {

            $res=split(";",$linha);

            if ($check_info=="nocheck"){

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
$link_gerar_evento=link_cadastro($cod,"falha",$operadora,$desig,$vel);

         $corx="CCCCCC";
         $vcolor="CCCCCC";
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
$ty=$tstp;

         $link_chk="<a href='http://$ips/fping4.0/bd/check_Update_n.php?acao=check&codh=$cod&dt=$res[1]&tstp=$ty&cli=$dir";
         $link_chk=$link_chk."&cnx=$host_a $int_a' target='_blank'>";
         $link_chk=$link_chk."<img border='0' src='http://$ips/fping4.0/icones/check.png' width='39' height='48' title='marcar alarme'>";
         $link_chk=$link_chk."</a>";

         $corinfo="#FFFFFF";

         if ($tstp==$tstp_checky) {

#echo "entrou <br>";
            $corx="#CCCCCC";
            $corinfo="#FFFFFF";

         $link_chk="<a href='http://$ips/fping4.0/bd/chk_up.php?cod=$cod_chky$cod_chk&codh=$cod&tstp=$ty";
         $link_chk=$link_chk."&v_acao=com&cli=$dir' target='_blank'>";
         $link_chk=$link_chk."<img border='0' src='http://$ips/fping4.0/icones/comentar.png' width='54' height='48' title='comentar'>";
         $link_chk=$link_chk."</a>";

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
         echo "<td width='39' bgcolor='$corx'>$link_chk</td>";
        echo "<td width='32' bgcolor='$corx' align='center'>".$link_gerar_evento."</td>";
         echo "<td width='200' bgcolor='$corx'>$obsx</td>";
         echo "<td bgcolor='$vcolor' width='100'>$mn_tipo</td>";
         echo "</tr>";

         $c++;

         }
      }
      echo "</table>";

include_once("/fping4.0/web/list/paginacao.php");

   }

?>
