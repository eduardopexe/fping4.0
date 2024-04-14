<html> 
<head> 
<title>Resultado Sorteio - Jogos</title> 
<style type="text/css"> 
@import url("estilo.css");

</style> 
</head> 
<body> 

<?php

$busca=$_POST['txt_busca'];
include_once("form_include_pesq.php");
include_once("cnx.php");


if (strlen($busca)<1){

$busca="copa";

}

$sql="select * from jogos where campeonato like '%$busca%'";

#echo "$sql <br>";
$resultado = mysql_query($sql,$cnx);

$mysq=mysql_affected_rows();

echo "$mysql <br>";

echo "<table border='0px' cellpadding='5px' cellspacing='2' id='alter' width=800>";
echo "<tr class='tit'>";
echo "<td>";
echo "-";
echo "</td>";
echo "<td>";
echo "data";
echo "</td>";
echo "<td>";
echo "campeonato";
echo "</td>";
echo "<td>";
echo "grupo";
echo "</td>";
echo "<td>";
echo "rodada";
echo "</td>";
echo "<td>";
echo "time a";
echo "</td>";
echo "<td>";
echo "gols a";
echo "</td>";
echo "<td>";
echo " x ";
echo "</td>";
echo "<td>";
echo "gols b";
echo "</td>";
echo "<td>";
echo "time b";
echo "</td>";
echo "</tr>";

$c=0;

   while ($retorno = mysql_fetch_array($resultado)) {

      $cod=$retorno['cod'];
      $cod_sorteio=$retorno['cod_sorteio'];
      $data_jogo=$retorno['data_jogo'];
      $campeonato=$retorno['campeonato'];
      $grupo=$retorno['grupo'];
      $rodada=$retorno['rodada'];

      $time_a=$retorno['time_a'];
      $gols_a=$retorno['gols_a'];
      $time_b=$retorno['time_b'];
      $gols_b=$retorno['gols_b'];
      $obs=$retorno['obs'];
      $senha=$retorno['senha'];

$c++;

if ($c%2==0){

   $class="dif";

}
else{

   $class="";

}

echo "<tr $class>";
echo "<td>";
echo "-";
echo "</td>";
echo "<td>";
echo "$data_jogo";
echo "</td>";
echo "<td>";
echo "$campeonato";
echo "</td>";
echo "<td>";
echo "$grupo";
echo "</td>";
echo "<td>";
echo "$rodada";
echo "</td>";
echo "<td>";
echo "$time_a";
echo "</td>";
echo "<td>";
echo "$gols_a";
echo "</td>";
echo "<td>";
echo " x ";
echo "</td>";
echo "<td>";
echo "$gols_b";
echo "</td>";
echo "<td>";
echo "$time_b";
echo "</td>";
echo "</tr>";

   }

echo "</table>";
?>
</body> 
</html> 
