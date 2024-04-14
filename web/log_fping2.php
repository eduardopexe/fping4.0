<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta http-equiv="Cache-Control" content="no-cache, no-store" />
<meta http-equiv="Refresh" content="30">
<meta http-equiv="expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
<title>FPING MON 4.0 - psys</title>
<link rel="stylesheet" href="./css/principal.css" type="text/css">
</head>
<body topmargin="0" leftmargin="0">

<?

// Front end Coleta Correio v1.0
// 10/02/09


echo "LOG FPING 4.0 <br>";


include_once('var_glob.php');


echo "<form method='POST' target='_self' action='log_fping.php'>";
echo "<input type='text' name='buscatxt' size='20' style='font-size: 10 px'><input type='submit' value='localizar' name='B1' style='font-size: 10 px'>";
echo "<br><font size=2>$res[0]</font></form>";

echo "<table width='1200'>";

$busca=$_POST['buscatxt'];




if ($busca==""){

#        $sql="select * from log_dev order by time_stp desc limit 10";

         $sql="select l.time_stp,l.datal,l.ip,l.loss,l.min,l.avg,l.status,l.data_inc,l.data_falha,l.data_retorno,l.str,l.t_stp_r,l.tempo_falha,d.uf,d.hostname,d.hostname_remoto,d.interface_remoto,d.ip_remoto,d.vel,d.lim_rtt_avg,d.site,d.descricao from log_dev as l INNER JOIN devices as d ON l.cod_dev=d.cod_dev  order by l.time_stp desc limit 10";


        #echo "$sql<br>";

#        $resultado = mysql_query($sql,$con);

}
else{

         $sql="select l.time_stp,l.datal,l.ip,l.loss,l.min,l.avg,l.status,l.data_inc,l.data_falha,";
         $sql=$sql."l.data_retorno,l.str,l.t_stp_r,l.tempo_falha,d.uf,d.hostname,d.hostname_remoto,";
         $sql=$sql."d.interface_remoto,d.ip_remoto,d.vel,d.lim_rtt_avg,d.site,d.descricao";
         $sql=$sql." from log_dev as l INNER JOIN devices as d ON l.cod_dev=d.cod";
         $sql=$sql." where l.ip like '%$busca%'";
         $sql=$sql." or d.hostname like '%$busca%'";
         $sql=$sql." or d.hostname_remoto like '%$busca%'";
         $sql=$sql." order by l.time_stp desc";

#        $resultado = mysql_query($sql,$con);

}

####consulta por links

$campo=$_GET['campo'];

$tipo_consulta=$_GET['tipo'];

$texto_busca=$_GET['texto'];

   $t_status=$_GET['stb'];

if ($tipo_consulta=="sql"){


   if (strlen($t_status)>0){

      $sq_s=" and l.status='".$t_status."' and l.str='falha'";

   }

         $sql="select l.time_stp,l.datal,l.ip,l.loss,l.min,l.avg,l.status,l.data_inc,l.data_falha,";
         $sql=$sql."l.data_retorno,l.str,l.t_stp_r,l.tempo_falha,d.uf,d.hostname,d.hostname_remoto,";
         $sql=$sql."d.interface_remoto,d.ip_remoto,d.vel,d.lim_rtt_avg,d.site,d.descricao";
         $sql=$sql." from log_dev as l INNER JOIN devices as d ON l.cod_dev=d.cod";
         $sql=$sql." where $campo = '$texto_busca' $sq_s";
         $sql=$sql." order by l.time_stp desc";

#         $resultado = mysql_query($sql,$con);


}

if ($tipo_consulta=="rtt"){

   if (strlen($t_status)>0){

      $sq_s=" and l.status='".$t_status."' and l.str='falha'";

   }

         $sql="select l.time_stp,l.datal,l.ip,l.loss,l.min,l.avg,l.status,l.data_inc,l.data_falha,";
         $sql=$sql."l.data_retorno,l.str,l.t_stp_r,l.tempo_falha,d.uf,d.hostname,d.hostname_remoto,";
         $sql=$sql."d.interface_remoto,d.ip_remoto,d.vel,d.lim_rtt_avg,d.site,d.descricao";
         $sql=$sql." from log_dev as l INNER JOIN devices as d ON l.cod_dev=d.cod";
         $sql=$sql." where $campo = '$texto_busca' and rtt_alm='y'";
         $sql=$sql." order by l.time_stp desc";

#         $resultado = mysql_query($sql,$con);


}
###################
if ($tipo_consulta=="sqlt"){


$tfim=$_GET['tstpf'];

$tini=$tfim-362;

         $sql="select l.time_stp,l.datal,l.ip,l.loss,l.min,l.avg,l.status,l.data_inc,l.data_falha,";
         $sql=$sql."l.data_retorno,l.str,l.t_stp_r,l.tempo_falha,d.uf,d.hostname,d.hostname_remoto,";
         $sql=$sql."d.interface_remoto,d.ip_remoto,d.vel,d.lim_rtt_avg,d.site,d.descricao";
         $sql=$sql." from log_dev as l INNER JOIN devices as d ON l.cod_dev=d.cod";
         $sql=$sql." where $campo = '$texto_busca' and time_stp>=$tini and time_stp<=$tfim and status='falha'";
         $sql=$sql." order by l.time_stp desc";

#         $resultado = mysql_query($sql,$con);
$data_fim=date("d/m/Y G:i:s", $tfim);


$data_inicio=date("d/m/Y G:i:s", $tini);

echo "consulta por: $texto_busca que apresentou <font color=red>falha</font> no periodo entre: $data_inicio e $data_fim<br>";
}

if ($tipo_consulta=="rtt_t"){

$tini=$_GET['tstpf'];

$tfim=$tini+36000;


         $sql="select l.time_stp,l.datal,l.ip,l.loss,l.min,l.avg,l.status,l.data_inc,l.data_falha,";
         $sql=$sql."l.data_retorno,l.str,l.t_stp_r,l.tempo_falha,d.uf,d.hostname,d.hostname_remoto,";
         $sql=$sql."d.interface_remoto,d.ip_remoto,d.vel,d.lim_rtt_avg,d.site,d.descricao";
         $sql=$sql." from log_dev as l INNER JOIN devices as d ON l.cod_dev=d.cod";
         $sql=$sql." where $campo = '$texto_busca' and rtt_alm='y' and time_stp>=$tini and time_stp<=$tfim";
         $sql=$sql." order by l.time_stp desc";

#         $resultado = mysql_query($sql,$con);

$data_fim=date("d/m/Y G:i:s", $tfim);


$data_inicio=date("d/m/Y G:i:s", $tini);

echo "consulta por: $texto_busca que apresentou <font color=purple>rtt</font> no periodo entre: $data_inicio e $data_fim<br>";
}


$tipo_log=$_GET['tlog'];

$tipo_log="alm";

if ($tipo_log=="alm"){

   $sql="select l.time_stp,l.datal,l.ip,l.loss,l.min,l.avg,l.status,l.data_inc,l.data_falha,"; 
   $sql=$sql."l.data_retorno,l.str,l.t_stp_r,l.tempo_falha,d.uf,";
   $sql=$sql."d.hostname,d.hostname_remoto,d.interface_remoto,d.ip_remoto,d.vel,";
   $sql=$sql."d.lim_rtt_avg,d.site,d.descricao,d.cod";
   $sql=$sql." from log_dev as l INNER JOIN devices as d ON";
   $sql=$sql." l.cod_dev=d.cod where l.status in ('falha','rtt','loss','lat') and l.status=l.str order by l.time_stp desc limit 150";

}

###################
$resultado = mysql_query($sql,$con);

# Quantidade de Registros por Pagina #
######################################
$pagina=$_GET['pg'];

###paginacao
        if ($pagina==""){

                $num_pagina=1;
        }
        else {

                $num_pagina=$pagina;

        }

#numero de registros por pagina
$num_reg=150;
#zera contador
##################paginacao
$i=0;

$total_registros = mysql_num_rows($resultado);


## Exibindo os Registros da Base
## Construç do SQL

###paginaç numero de paginas e range de exibiç
$inicio=$num_pagina*$num_reg-($num_reg);

$fim=$inicio+$num_reg;

$total_paginas=(int) ($total_registros/$num_reg);

#echo "$sql <br>";
echo "total de registros: $total_registros <br>";
echo "<tr>";
echo "<td bgcolor='CCCCCC' width=300>data falha / data retorno </td>";
echo "<td bgcolor='CCCCCC' width=150>hostname</td>";
echo "<td bgcolor='CCCCCC' width=150>descricao </td>";
echo "<td bgcolor='CCCCCC' width=150>host_interface_remoto : ip_wan</td>";
echo "<td bgcolor='CCCCCC' width=150>vel</td>";
echo "<td bgcolor='CCCCCC' width=150>uf</td>";
echo "<td bgcolor='CCCCCC' width=150>status</td>";
echo "<td bgcolor='CCCCCC' width='80'>tempo falha (seg)</td>";
echo "<td bgcolor='CCCCCC' width=150> data registro</td>";
echo "</tr>";

                while ($retorno = mysql_fetch_array($resultado)) {

#dentro do while

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


#########################
#  `time_stp` int(15) default NULL,
#  `datal` varchar(50) default NULL,
#  `ip` varchar(50) default NULL,
#  `loss` varchar(255) default NULL,
#  `min` varchar(50) default NULL,
#  `avg` varchar(50) default NULL,
#  `max` varchar(50) default NULL,
#  `status` varchar(50) default NULL,
#  `regiao` char(10) default NULL,
#  `data_inc` datetime NOT NULL default '0000-00-00 00:00:00',
#  `data_falha` datetime NOT NULL default '0000-00-00 00:00:00',
#  `data_retorno` datetime NOT NULL default '0000-00-00 00:00:00',
#  `str` varchar(50) NOT NULL default '',
#  `t_stp_r` int(15) default NULL,
#  `tempo_falha` int(15) default NULL

#################################################################
                        $tstp=$retorno['time_stp'];

                        $datal=$retorno['datal'];
                        $ip=$retorno['ip'];

                        $loss=$retorno['loss'];
                        $min=$retorno['min'];
                        $avg=$retorno['avg'];
                        $status=$retorno['status'];
                        $regiao=$retorno['regiao'];
                        $data_inc=$retorno['data_inc'];
                        $data_falha=$retorno['data_falha'];
                        $data_retorno=$retorno['data_retorno'];
                        $str=$retorno['str'];
                        $t_stp_r=$retorno['t_stp_r'];
                        $tempo_falha=$retorno['tempo_falha'];

#################################################################

                        $hostname=$retorno['hostname'];
                        $hostname_remoto=$retorno['hostname_remoto'];
                        $ip_remoto=$retorno['ip_remoto'];
                        $interface_remoto=$retorno['interface_remoto'];
                        $uf=$retorno['uf'];
                        $velocidade=$retorno['vel'];
                        $descricao=$retorno['descricao'];
                        $cod=$retorno['cod'];
#echo "$hostname <br>";
#################################################################
 
#if (str_len($hostname)<3){

#$hostname=$ip;

#}

#dlink="<a href=http://$ips/fping_mon/coleta_correio.php?v_chave=".$v_chave."&cod_ret=".$cod.">detalhes</a>";

        if ($str=='ok' or $str=='loss' or $str=='crc') {

           $v_cor="#7CFC00";

$stf="ok";
        } 
        elseif ($str=='falha') {
              
           $v_cor="#FF6347";
$stf="falha";
        } 
        elseif ($str=='rtt' or $str=='lat') {

           $v_cor="#CCCCFF";
           $stf="rtt";
        }

#$linkh="<a href='telnet:\\\\".$ip."' target='_self'>$hostname</a>";
$linkh="<a href='http://10.98.22.10/links_bkb2.0/forms/form_links_inc_alt.asp?tipo_form=alt&cod=".$cod."' target='_blank'>$hostname</a>";

echo "<tr>";
echo "<td bgcolor='$v_cor' width=300>$data_falha<br>$data_retorno</td>";
#echo "<td bgcolor='$v_cor' width=150>$hostname : $ip</td>";
echo "<td bgcolor='$v_cor' width=150>$linkh</td>";
echo "<td bgcolor='$v_cor' width=150>$descricao</td>";
echo "<td bgcolor='$v_cor' width=150>$hostname_remoto"."_".$interface_remoto."<br> $ip_remoto</td>";
echo "<td bgcolor='$v_cor' width=150>$velocidade</td>";
echo "<td bgcolor='$v_cor' width=150>$uf</td>";
echo "<td bgcolor='$v_cor' width=150>$status - $str</td>";
echo "<td bgcolor='#FF6347' width='80' >$tempo_falha</td>";
echo "<td bgcolor='$v_cor' width=150>".$data_inc."</td>";
echo "</tr>";

                }



echo "</table>";

###rodape
echo "<table><tr>";

$total_paginas=$total_paginas+1;

$p=1;
for ($p =1; $p<=$total_paginas;$p++){

if ($num_pagina==$p){

$f1="<font color=red size=6>";

}
else{

$f1="<font color=blue size=3>";
}

if ($busca=""){

}
else{
$texto_busca=$busca;
}
if ($var_busca=="") {

$link="log_fping.php?pg=".$p."&texto=".$texto_busca."&campo=".$campo."&tipo=".$tipo_consulta."&stb=".$t_status;
#echo "<br>$lnk_busca";
}else{

$link="log_fping.php?pg=".$p."&texto=".$texto_busca."&campo=".$campo."&tipo=".$tipo_consulta."&stb=".$t_status;
}

echo "<td>$f1<a href='$link'target=_self>[$p]</a></font></td>";
#echo "<td>[$p]</td>";

}
echo "</tr>";
#echo "</table>";

        echo "</table>pagina $num_pagina: $inicio a $fim de $total<br>";
?>
</body>
</html>       


