<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Refresh" content="1200">
<title>RPA BDNS</title>
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

$lk="rpa_bdn.php";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=0>lote0</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=1>lote1</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=2>lote2</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=3>lote3</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=4>lote4</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=5>lote5</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=6>lote6</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=7>lote7</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=8>lote8</a>&nbsp;|&nbsp;";

echo " | RPA PAA ---> | ";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=9>lote9</a>&nbsp;|&nbsp;";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=10>lote10</a>&nbsp;|&nbsp;";

echo " | PABS ### |/_-> ";

echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=pab>pabs</a>&nbsp;|&nbsp;";

echo " - lote 2x -->";
echo "<a href=http://10.98.22.11/fping4.0/$lk?lote=2x>2x</a>&nbsp;|&nbsp;";

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

$lote="lote".$gcod;

$sql="select * from controle_bdn_upgrade where lote_rpa='$lote' order by data_rpa desc";

if ($gcod=="pab"){

$sql="select * from controle_bdn_upgrade where left(status_rpa,1) in ('8') order by data_rpa desc";
}


if ($gcod=="2x"){

$sql="select * from controle_bdn_upgrade where lote_rpa='2x' order by data_rpa desc";
}


$resultado = mysql_query($sql,$con);



#echo "total de registros: $total_registros <br>";
echo "<tr>";
echo "<td bgcolor='CCCCCC' width=50>lote</td>";
echo "<td bgcolor='CCCCCC' width=50>cod</td>";
echo "<td bgcolor='CCCCCC' width=220>data_upgrade</td>";
echo "<td bgcolor='CCCCCC' width=230>status</td>";
echo "<td bgcolor='CCCCCC' width=150>ip l237</td>";
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

$lote=$retorno['lote_rpa'];
$cod=$retorno['cod'];
$hostname_a=$retorno['hostname_a'];
$status_upgrade=$retorno['status_rpa'];
$data_upgrade=$retorno['data_rpa'];
$ipwan=$retorno['ipwan'];
$hostname_b=$retorno['hostname_b'];
$interface_b=$retorno['interface_b'];
$interface_a=$retorno['interface_a'];
$obs=$retorno['obs'];

$usuario=$retorno['usuario'];
$juncao=$retorno['juncao'];

$ipl237=$retorno['ipl237'];

$v_cor="CCCCCC";

if ($status_upgrade=="1-acl_aplicado"){

$v_cor="green";

}


if ($status_upgrade=="3-acl_nao_aplicado"){

$v_cor="red";

}

echo "<tr>";
echo "<td bgcolor='$v_cor' width=50>$lote</td>";
echo "<td bgcolor='$v_cor' width=50>$cod</td>";
echo "<td bgcolor='$v_cor' width=220>$data_upgrade</td>";
echo "<td bgcolor='$v_cor' width=230>$status_upgrade</td>";
echo "<td bgcolor='$v_cor' width=150>$ipl237</td>";
echo "<td bgcolor='$v_cor' width=150>$hostname_a</td>";
echo "<td bgcolor='$v_cor' width=150>$interface_a</td>";
echo "<td bgcolor='$v_cor' width='80'>$hostname_b</td>";
echo "<td bgcolor='$v_cor' width=150>$interface_b</td>";
echo "<td bgcolor='$v_cor' width=350>$juncao - $usuario</td>";
echo "</tr>";


}

echo "</table>";

#print "total: $total | ok: $ok | upgrade erro: $e2 | upgrade nao realizado : $e3 | em acesso telnet: $e9 |";


?>
</body>
</html>
