<html>
<head>   <title> unib :: FPING 4.0 - NETWORK MAP</title>
<meta http-equiv="Cache-Control" content="no-cache, no-store" />
<meta http-equiv="Refresh" content="30">
<meta http-equiv="expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />

<link rel="stylesheet" href="../css/principal.css" type="text/css"></head>
<body>

<table width='900'>
<tr bgcolor='CCCCCC'><td colspan='2' width='150' height='0'>
<font size=1>mapas:</font>
</td>
<td colspan='1' width='80' height='0'>
<a href='http://10.98.22.11/fping4.0/topo_link_fis_unib.php' target='_self'><font size=1>mapa link fisico</font></a>
</td>
<td colspan='1' width='80' height='0'>
<a href='http://10.98.22.11/fping4.0/mapa/topo_link_fis_unib_log.php' target='_self'><font size=1>mapa link logico</font></a>
<td colspan='1' width='80' height='0'>
<a href='http://10.98.22.11/fping4.0/mapa/topo_link_fis_unib_fis_e_log.php' target='_self'><font size=1>mapa link fisico e logico</font></a>
</td>
</td></tr></table>
<?
include_once("/fping4.0/web/mon_sum_unib.php")
?><canvas id="meucanvas" width="1240" height="700" border=1>
Este texto se mostra para os navegadores n�o compat�veis com canvas.
<br>Por favor, utiliza Firefox, Chrome, Safari ou Opera.
<script>
   var elemento = document.getElementById('meucanvas');
      var ctx = elemento.getContext('2d');
ctx.beginPath();
ctx.fillStyle = "black";
ctx.font="8pt Arial";
ctx.fillText("2011-07-29 18:22:33",10,10);
ctx.closePath();
ctx.beginPath();
ctx.lineWidth=2;
ctx.strokeStyle = "#00FF00";
ctx.lineTo(120,50);
ctx.lineTo(180,680);
ctx.stroke();
ctx.closePath();
ctx.beginPath();
ctx.lineWidth=2;
ctx.strokeStyle = "#00FF00";
ctx.lineTo(120,50);
ctx.lineTo(100,680);
ctx.stroke();
ctx.closePath();
ctx.beginPath();
ctx.lineWidth=2;
ctx.strokeStyle = "#00FF00";
ctx.lineTo(200,50);
ctx.lineTo(620,450);
ctx.stroke();
ctx.closePath();
ctx.fillStyle = "rgba(74,255,116,0.7)";
ctx.beginPath();
ctx.arc(620,450,14,0,Math.PI*2,false);
ctx.fill();
ctx.closePath();
ctx.lineWidth=3;
ctx.strokeStyle = "blue";
ctx.beginPath();
ctx.arc(620,450,14,0,Math.PI*2,false);
ctx.stroke();
ctx.closePath();
ctx.beginPath();
ctx.fillStyle = "black";
ctx.font="8pt Arial";
ctx.fillText("rbcauc03",606,436);
ctx.closePath();
ctx.fillStyle = "rgba(74,255,116,0.7)";
ctx.beginPath();
ctx.arc(120,50,14,0,Math.PI*2,false);
ctx.fill();
ctx.closePath();
ctx.beginPath();
ctx.fillStyle = "black";
ctx.font="8pt Arial";
ctx.fillText("adliv01",106,36);
ctx.closePath();
ctx.fillStyle = "rgba(74,255,116,0.7)";
ctx.beginPath();
ctx.arc(200,50,14,0,Math.PI*2,false);
ctx.fill();
ctx.closePath();
ctx.beginPath();
ctx.fillStyle = "black";
ctx.font="8pt Arial";
ctx.fillText("rcorn01",186,36);
ctx.closePath();
ctx.fillStyle = "rgba(74,255,116,0.7)";
ctx.beginPath();
ctx.arc(100,680,14,0,Math.PI*2,false);
ctx.fill();
ctx.closePath();
ctx.beginPath();
ctx.fillStyle = "black";
ctx.font="8pt Arial";
ctx.fillText("rcrbco02",86,666);
ctx.closePath();
ctx.fillStyle = "rgba(74,255,116,0.7)";
ctx.beginPath();
ctx.arc(180,680,14,0,Math.PI*2,false);
ctx.fill();
ctx.closePath();
ctx.beginPath();
ctx.fillStyle = "black";
ctx.font="8pt Arial";
ctx.fillText("rcrbco01",166,666);
ctx.closePath();
</script></canvas>
<?
include_once("/fping4.0/web/log_fping2.php")
?></body></html>