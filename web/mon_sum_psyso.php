<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta http-equiv="Cache-Control" content="no-cache, no-store" />
<meta http-equiv="Refresh" content="30">
<meta http-equiv="expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />

<?
$dir="psys";
echo "<title>$dir - FPING MON 4.0</title>";
?>
<?


#$arquivo=getenv("SCRIPT_NAME");

#echo "$arquivo ############## <br>";
$t=strlen($liga_som);

if ($t==0){

$liga_som=$_GET['key_som'];

}

###menu som

$menu_som=$_GET['menu_som'];

if (strlen($menu_som)==0){

$menu_som=$liga_som;

}

####informaçs default - diretorio e ip servidor

include_once('var_glob.php');

$tit=$dir;

label_tit($tit);
#############################

#echo "<table width=250><tr><td><a href='mon.php?key_som=$menu_som'>menu principal</a></td>";

#$link="onclick=\"window.open('http://$ips/fping_mon/mon_".$dir."_sum.php?key_som=$menu_som','cx$dir','height=160,width=320,status=no,toolbar=no,menubar=no,location=no')\"";

#echo "<td><a href='#'$link>caixa</a></td></tr></table>";

$fp = file("/fping4.0/web/resultado/$dir/geral_web_$dir.txt");

#echo "#######vermelho#########<br>";

foreach ( $fp as $linha ){

$res=split(";",$linha);

$cspan=8;
$tstp=$res[0];
$data_reg=$res[1];
$dev_ok=$res[2];
$lf_ok=$res[3];
$ll_ok=$res[4];
$loss=$res[5]+$res[6];
$rtt=$res[7]+$res[8];
$falha=$res[9];
$dev_falha=$res[10];
$chk=$res[11];
$som=$res[12];
$crit=$res[13];
$som=$res[12];

}


#echo "$som ; $liga_som ; http://$ips/fping_mon/alerta_sonoro/alarme_$dir.wav <br>";


?>

<link rel="stylesheet" href="./css/principal.css" type="text/css">


</head>
<body>

<?
   if ($som=="y" and $liga_som=="y"){

#echo "$som ; $liga_som ; http://$ips/fping4.0/alerta_sonoro/alarme_$dir.wav <br>";
      echo "<bgsound src=\"./alerta_sonoro/alarme_$dir.wav\" loop=1 hidden=true volume=100 >";
#echo "<EMBED SRC='http://$ips/fping4.0/alerta_sonoro/alarme_$dir.wav' WIDTH='0' HEIGHT='0' AUTOSTART='true' STARTTIME='00:00'
   }

echo "<table width='350'>";

echo "<tr bgcolor='CCCCCC'><td colspan='6' width='250' height='0'>";

echo "<font size=1>$tit - $res[1]</font>";

echo "</td>";

echo "<td colspan='1' width='50' height='0'>";
echo "<a href='http://$ips/fping4.0/topo_link_fis_$dir.php' target='_blank'><font size=1>mapa</font></a>";
echo "</td>"; 

echo "<td colspan='1' width='50' height='0'>";
echo "<a href='http://$ips/fping4.0/sum.php' target='_self'><font size=1>home</font></a>";
echo "</td>";

echo "</td></tr>";

#echo "<tr bgcolor='CCCCCC'><td colspan='5' width='250' weight='1'>$res[0]</td></tr>";

echo "<tr bgcolor='CCCCCC'>";
echo "<td width='50' bgcolor='00FF00' align='center'>dev</td>";
echo "<td width='50' bgcolor='00FF00' align='center'>lk fis</td>";
echo "<td width='50' bgcolor='00FF00' align='center'>lk log</td>";
echo "<td width='50' bgcolor='FFFF00' align='center'>loss</td>";
echo "<td width='50' bgcolor='#9900CC' align='center'><font color='white'>rtt</font></td>";
echo "<td width='50' bgcolor='blue' align='center'><font color='white'>!crit</font></td>";
echo "<td width='50' bgcolor='FF0000' align='center'><font color='white'>falha</font></td>";
echo "<td width='50' bgcolor='black' align='center'><font color='white'>#!dev</font></td>";
echo "<td width='50' bgcolor='CCCCCC' align='center'><font color='red'>chk</font></td>";
echo "</tr>";


$busca=$_POST['pesq'];

#echo "####################################$busca <br>";
#fim conta check
#links?::::

echo "<tr>";

$link_dev_ok="<a href=\"#\" onclick=\"window.open('http://$ips/fping4.0/mon_det.php?ver=dev_ok&key_som=n&menu_som=$menu_som&dir=$dir','blank','height=500,width=1400,resizable=yes,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no')\">$dev_ok</a>";

$link_lf_ok="<a href=\"#\" onclick=\"window.open('http://$ips/fping4.0/mon_det.php?ver=lf_ok&key_som=n&menu_som=$menu_som&dir=$dir','blank','height=500,width=1400,resizable=yes,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no')\">$lf_ok</a>";

$link_ll_ok="<a href=\"#\" onclick=\"window.open('http://$ips/fping4.0/mon_det.php?ver=ll_ok&key_som=n&menu_som=$menu_som&dir=$dir','blank','height=500,width=1400,resizable=yes,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no')\">$ll_ok</a>";

$link_loss="<a href=\"#\" onclick=\"window.open('http://$ips/fping4.0/mon_det.php?ver=loss&key_som=n&menu_som=$menu_som&dir=$dir','blank','height=500,width=1400,resizable=yes,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no')\"><font color='black'>$loss</font></a>";

$link_falha="<a href=\"#\" onclick=\"window.open('http://$ips/fping4.0/mon_det.php?ver=falha&key_som=n&menu_som=$menu_som&dir=$dir','blank','height=500,width=1400,resizable=yes,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no')\"><font color=white>$falha</font></a>";

$link_dev_falha="<a href=\"#\" onclick=\"window.open('http://$ips/fping4.0/mon_det.php?ver=dev_falha&key_som=n&menu_som=$menu_som&dir=$dir','blank','height=500,width=1400,resizable=yes,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no')\"><font color=white>$dev_falha</font></a>";

$link_rtt="<a href=\"#\" onclick=\"window.open('http://$ips/fping4.0/mon_det.php?ver=rtt&key_som=n&menu_som=$menu_som&dir=$dir','blank','height=500,width=1400,resizable=yes,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no')\"><font color=white>$rtt</font></a>";

$link_chk="<a href=\"#\" onclick=\"window.open('http://$ips/fping4.0/mon_det.php?ver=chk&key_som=n&menu_som=$menu_som&dir=$dir','blank','height=500,width=1400,resizable=yes,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no')\"><font color=red>$chk</font></a>";

$link_crit="<a href=\"#\" onclick=\"window.open";
$link_crit=$link_crit."('http://$ips/fping4.0/mon_det.php?ver=crit&key_som=n";
$link_crit=$link_crit."&menu_som=$menu_som&dir=$dir','blank','height=500,width=1400,";
$link_crit=$link_crit."resizable=yes,scrollbars=yes,status=yes,toolbar=no,menubar=no,";
$link_crit=$link_crit."location=no')\"><font color=white>$crit</font></a>";

echo "<td width='80' bgcolor='00FF00' align='center'>";
echo "$link_dev_ok</td>";
echo "<td width='80' bgcolor='00FF00' align='center'>";
echo "$link_lf_ok</td>";
echo "<td width='80' bgcolor='00FF00' align='center'>";
echo "$link_ll_ok</td>";

echo "<td width='80' bgcolor='FFFF00' align='center'>";
echo "$link_loss</td>";

echo "<td width='80' bgcolor='#9900CC' align='center'>";
echo "$link_rtt</td>";

echo "<td width='80' bgcolor='blue' align='center'>";
echo "$link_crit</td>";

echo "<td width='80' bgcolor='FF0000' align='center'>";
echo "$link_falha</td>";

echo "<td width='80' bgcolor='black' align='center'>";
echo "$link_dev_falha</td>";

echo "<td width='80' bgcolor='CCCCCC' align='center'>";
echo "$link_chk</td>";


echo "</tr>";



echo "</table>";

#echo "<EMBED SRC='http://$ips/fping4.0/alerta_sonoro/alarme_$dir.wav' HIDDEN='true' AUTOSTART='true'  STARTTIME='00:01' ENDTIME='00:30'>";
?>
</body>
</html>

