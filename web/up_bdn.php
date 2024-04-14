<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Refresh" content="1200">
<title>Upgrade BDNS</title>
</head>
<body>
<?

###db login

$dblogin="noc";
$dbpass="noc";
$dbname="noc";
$ipbd="10.98.22.7";

#base de dados
$db_server=$ipbd;
$db_login=$dblogin;
$db_pass=$dbpass;
$db_name=$dbname;

$con = @mysql_connect($db_server,$db_login,$db_pass,"");

#echo $_con."###################<br>";
if($con == FALSE) {
echo "Nao foi possivel conectar ao Mysql <br>";
mysql_erro();
exit;
} else {

mysql_select_db($db_name,$con);

}

#echo "<a href=http://10.98.22.11/fping4.0/up_bdn.php?lote=1>lote1</a>&nbsp;|&nbsp;";

#echo "<a href=http://10.98.22.11/fping4.0/up_bdn.php?lote=2>lote2</a>&nbsp;|&nbsp;";

#echo "<a href=http://10.98.22.11/fping4.0/up_bdn.php?lote=3>lote3</a>&nbsp;|&nbsp;";

#echo "<a href=http://10.98.22.11/fping4.0/up_bdn.php?lote=4>lote4</a>&nbsp;|&nbsp;";

#echo "<a href=http://10.98.22.11/up_bdn.php?lote=5>lote5</a>&nbsp;|&nbsp;";

#echo "<a href=http://10.98.22.11/up_bdn.php?lote=6>lote6</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/up_bdn.php?lote=lotex>lotex</a>&nbsp;|&nbsp;";

#echo "<a href=http://10.98.22.11/fping4.0/up_bdn.php?lote=8>upgrade realizado</a>&nbsp;|&nbsp;";

#echo "<a href=http://10.98.22.11/fping4.0/up_bdn.php?lote=11>PAA</a>&nbsp;|&nbsp;";
#echo "<a href=http://10.98.22.11/fping4.0/up_bdn.php?lote=9>upgrade erro</a>&nbsp;|&nbsp;";

#echo "<a href=http://10.98.22.11/fping4.0/up_bdn.php?lote=7>cyclades</a>&nbsp;|&nbsp;";

#echo "<a href=http://10.98.22.11/fping4.0/up_bdn.php?lote=10>satelite</a>&nbsp;|&nbsp;";

echo "<form method='POST' target='_self' action='up_bdn.php'>";
echo "<input type='text' name='buscatxt' size='20' style='font-size: 10 px'><input type='submit' value='localizar' name='B1' style='font-size: 10 px'>";


echo "<br><font size=2></font></form>";



echo "<table width='2000'>";

$busca="";

$busca=$_POST['buscatxt'];


if ($busca==""){

   $sql="select * from controle_bdn_upgrade where length(status_upgrade)>3 order by data_upgrade desc limit 100";


}
else{

    $sql="select * from controle_bdn_upgrade where hostname_a like '%$busca%'";
    $sql=$sql." or usuario like '%$busca%'";
    $sql=$sql." or juncao like '%$busca%'";
    $sql=$sql." or hostname_b like '%$busca%' order by status_upgrade,data_upgrade desc";


}


$gcod=$_GET['lote'];

if ($gcod<8){

if ($gcod==1){

$sq="data_upgrade BETWEEN '2011-03-12 00:00:00' and '2011-03-24 23:59:59'";

}

if ($gcod==2){

$sq="lote='lote2'";

}

if ($gcod==3){

$sq="lote='lote3'";

}

if ($gcod==4){

$sq="lote='lote4'";

}

   $sql="select * from controle_bdn_upgrade where ".$sq." order by data_upgrade desc";

if ($gcod==7){

$sql="select * from controle_bdn_upgrade where left(status_upgrade,1) in ('7') order by data_upgrade desc";
}




}
else{

#echo "$";
if ($gcod==9){


$n="('3-','04')";
}
else{

$n="('2-')";

}

    $sql="select * from controle_bdn_upgrade where left(status_upgrade,2) in $n order by data_upgrade desc";

if ($gcod==10){

$sql="select * from controle_bdn_upgrade where left(status_upgrade,1) in ('5') order by data_upgrade desc";
}


}

if ($gcod==4){

$sql="select * from controle_bdn_upgrade where lote in ('lote4') order by data_upgrade ";
}


if ($gcod==5){

$sql="select * from controle_bdn_upgrade where lote in ('lote5') order by data_upgrade ";
}


if ($gcod==11){

$sql="select * from controle_bdn_upgrade where usuario like '%PAA %' order by data_upgrade ";
}

#$sql="select * from controle_bdn_upgrade where data_upgrade>'2011-03-01 00:00:00' order by data_upgrade desc";
echo "$sql <br>";


if ($gcod==lotex){

$sql="select * from controle_bdn_upgrade where lote='lotex' order by data_upgrade ";
}

$resultado = mysql_query($sql,$con);



#echo "total de registros: $total_registros <br>";
echo "<tr>";
echo "<td bgcolor='CCCCCC' width=50>lote</td>";
echo "<td bgcolor='CCCCCC' width=50>cod</td>";
echo "<td bgcolor='CCCCCC' width=220>data_upgrade</td>";
echo "<td bgcolor='CCCCCC' width=230>status</td>";
echo "<td bgcolor='CCCCCC' width=150>obs</td>";
echo "<td bgcolor='CCCCCC' width=50>ping upgrade</td>";
echo "<td bgcolor='CCCCCC' width=50>dlsw antes</td>";
echo "<td bgcolor='CCCCCC' width=50>dlsw depois</td>";
echo "<td bgcolor='CCCCCC' width=150>ip l237</td>";
echo "<td bgcolor='CCCCCC' width=150>ip_wan_cpe</td>";
echo "<td bgcolor='CCCCCC' width=150>hostname_a</td>";
echo "<td bgcolor='CCCCCC' width=150>hostname_a</td>";
echo "<td bgcolor='CCCCCC' width='80'>hostname_b</td>";
echo "<td bgcolor='CCCCCC' width=150>interface_b</td>";
echo "<td bgcolor='CCCCCC' width=350>usuario</td>";
echo "</tr>";

$tot=0;
$ok=0;
$e2=0;
$e3=0;
$e0=0;
$e5=0;
$e6=0;
$e7=0;
$e9=0;
$e4=0;

while ($retorno = mysql_fetch_array($resultado)) {


   #cod,hostname_a,status_upgrade,data_upgrade,ping_du,dlsw_au,dlsw_du,ipwan

$lote=$retorno['lote'];
$cod=$retorno['cod'];
$hostname_a=$retorno['hostname_a'];
$status_upgrade=$retorno['status_upgrade'];
$data_upgrade=$retorno['data_upgrade'];
$ping_du=$retorno['ping_du'];
$dlsw_au=$retorno['dlsw_au'];
$dlsw_du=$retorno['dlsw_du'];
$ipwan=$retorno['ipwan'];
$hostname_b=$retorno['hostname_b'];
$interface_b=$retorno['interface_b'];
$interface_a=$retorno['interface_a'];
$obs=$retorno['obs'];

$usuario=$retorno['usuario'];
$juncao=$retorno['juncao'];

$ipl237=$retorno['ipl237'];

$v_cor="CCCCCC";


if ($status_upgrade=="0-coletar info"){

$v_cor="CCCCC";
$e0++;
}

if ($status_upgrade=="2-upgrade_realizado"){

$v_cor="green";
$ok++;
}

if ($status_upgrade=="3-downgrade nao realizado"){

$v_cor="red";
$e2++;
}

#if ($status_upgrade=="3-downgrade nao realizado"){

#$v_cor="yellow";
#$e3++;
#}

if ($status_upgrade=="04-erro telnet"){

$v_cor="orange";
$e6++;
}


if ($status_upgrade=="7-cyclades"){

$v_cor="CCCCC";
$e7++;
}

if ($status_upgrade=="5-satelite"){

$v_cor="CCCCC";
$e5++;
}

if ($status_upgrade=="01-teste_downgrade"){

$v_cor="CCCCC";
$e9++;
}

if ($status_upgrade=="04-erro telnet"){

$v_cor="CCCCC";
$e9++;
}


if ($status_upgrade=="4-pe ra|rx|re|rp"){

$v_cor="CCCCC";
$e4++;
}

echo "<tr>";
echo "<td bgcolor='$v_cor' width=50>$lote</td>";
echo "<td bgcolor='$v_cor' width=50>$cod</td>";
echo "<td bgcolor='$v_cor' width=220>$data_upgrade</td>";
echo "<td bgcolor='$v_cor' width=230>$status_upgrade</td>";
echo "<td bgcolor='$v_cor' width=150>$obs</td>";
echo "<td bgcolor='$v_cor' width=50>$ping_du</td>";
echo "<td bgcolor='$v_cor' width=100>$dlsw_au</td>";
echo "<td bgcolor='$v_cor' width=100>$dlsw_du</td>";
echo "<td bgcolor='$v_cor' width=150>$ipl237</td>";
echo "<td bgcolor='$v_cor' width=150>$ipwan</td>";
echo "<td bgcolor='$v_cor' width=150>$hostname_a</td>";
echo "<td bgcolor='$v_cor' width=150>$interface_a</td>";
echo "<td bgcolor='$v_cor' width='80'>$hostname_b</td>";
echo "<td bgcolor='$v_cor' width=150>$interface_b</td>";
echo "<td bgcolor='$v_cor' width=350>$juncao - $usuario</td>";
echo "</tr>";


}

echo "</table>";

print "total: $total | ok: $ok | upgrade erro: $e2 | upgrade nao realizado : $e3 | em acesso telnet: $e9 |";

print "<br> cyclades: $e7 | satelite: $e5 | sem senha : $e6 ";

print "<br> pe ra|rx|re|rp: $e4 |   ";
?>
</body>
</html>
