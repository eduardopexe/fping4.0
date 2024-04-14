<?

####exibicao para falha

   if ($ver=="dev_falha" or $ver=="" or $ver=="form" ){

$link_chk_all="<a href='http://$ips/fping4.0/bd/check_Update_all_n.php?dir=$dir&cor=$ver' target=_blank>";
$link_chk_all=$link_chk_all."<img border='0' src='http://$ips/fping4.0/icones/checkall.png' width='24' height='24' title='marcar todos os alarmes'>";
$link_chk_all=$link_chk_all."</a>";

      echo "<table width=1200>";
      echo "<tr bgcolor='CCCCCC'>";
      echo "<td width='32' colspan='1'>proc</td>";
      echo "<td width='32' colspan='1'>cpu</td>";
      echo "<td width='32' colspan='1'>cfg</td>";
      echo "<td width='80'>data</td>";
      echo "<td width='220'>host int</td>";
      echo "<td width='80'>ip</td>";
      echo "<td width='250'>Descricao</td>";
      echo "<td width='39' align='center'>$link_chk_all</td>";
      echo "<td width='200'>obs</td>";
      echo "<td width='100'>info</td>";
      echo "</tr>";
      rsort($fp);
##################paginacao

      $i=1;

      $inicio=$num_pagina*$num_reg-($num_reg);

      $fim=$inicio+$num_reg;

      $total=$falha_dev;

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
         $operadora=$res[19];

         $mfr_a=$res[15];
         $mfr_b=$res[16];
         $envia_email=$res[17];
#echo "$mn_tipo";


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
$link_cfg_a=$link_cfg_a."<img border='0' src='http://$ips/fping4.0/icones/cfg.png' width='24' height='24' title='ver cofiguraÁ„o $host_a'>";
$link_cfg_a=$link_cfg_a."</a>";


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
$link_gauge_a=$link_gauge_a."<img border='0' src='http://$ips/fping4.0/icones/$img_cpua' width='48' height='48' title='cpu $host_a: $vcpu_a %'>";
$link_gauge_a=$link_gauge_a."</a>";
###############################


         if (preg_match('/falha/i', $status) and $mn_tipo=="dev") {

            $res=split(";",$linha);

            if ($check_info=="check"){

               continue;
            }

#pula linha se tela de exibi√ß e vermelho check - pula vermelho sem check

            if ($ver=="chk" and $check_info=="nocheck"){

              #    echo "entrou - check <br>";
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

         $corx="000000";
         $vcolor="000000";
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

         $link_chk="<a href='http://$ips/fping4.0/bd/atualiza_check_Update_n.php?cod=$cod_chk&codh=$cod&tstp=$ty";
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
      echo "<td bgcolor='$vcolory' width='1' style='border-bottom: 1 solid $vcolor'>".$link_mem_proc_a."</td>";
      echo "<td bgcolor='$vcolory' width='1' style='border-bottom: 1 solid $vcolor'>".$link_gauge_a."</td>";
      echo "<td bgcolor='$vcolory' width='32' style='border-bottom: 1 solid $vcolor'>".$link_cfg_a."</td>";
        echo "<td bgcolor='$vcolor' width='80'><font color=$vfont_color>$data_reg</font></td>";
         echo "<td bgcolor='$vcolor' width='220'><font color=$vfont_color>$host_a ".$int_a."</font></td>";
         echo "<td bgcolor='$vcolor' width='80'><font color=$vfont_color>$ip_a</font></td>";
         echo "<td bgcolor='$vcolor' width='250'><font color=$vfont_color>$descr</font></td>";
         echo "<td width='39' bgcolor='$corx' align='center'><font color=$vfont_color>$link_chk</font></td>";
         echo "<td width='200' bgcolor='$corx'><font color=$vfont_color>$obsx</font></td>";
         echo "<td bgcolor='$vcolor' width='100'><font color=$vfont_color>$mn_tipo</font></td>";
         echo "</tr>";

         $c++;

         }
      }
      echo "</table>";

include_once("/fping4.0/web/list/paginacao.php");

   }

?>
