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




echo "<table width='2000'>";

$sql="select * from controle_bdn_upgrade where lote='lotex' order by data_upgrade ";

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
