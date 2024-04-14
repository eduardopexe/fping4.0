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

#echo "<table width=1 cellspacing=1 cellpading=0><tr><td width=350>";

echo "<font size=2><a href='http://10.98.22.10/links_bkb2.0/views/links_fping.asp' target='_blank'>atualizar </a></font> | ";

$liga_som=$_GET['key_som'];

if ($liga_som=="y"){

echo "som ativo - <a href='http://10.98.22.11/fping4.0/sum.php?key_som=n'>desativar</a>";
}
else{

echo "som desativado - <a href='http://10.98.22.11/fping4.0/sum.php?key_som=y'>ativar</a>";

}
include_once("form_include.php");

include_once("/fping_mon/www/fping_mon/mon_rttm_sum.php");
include_once("mon_sum_psys.php");
include_once("mon_sum_brad.php");
include_once("mon_sum_unib.php");
include_once("mon_sum_ebtv.php");
include_once("/fping_mon/www/fping_mon/mon_spb_sum.php");
include_once("/fping4.0/web/load_sum2.php");
#echo "</table>";
?> 
