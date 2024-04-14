<?php

$host="fdb2.awardspace.com";
$host="10.98.22.7";
$user="epexe_sorteio";
$db="epexe_sorteio";
$senha_db="1910";


//conexão com o servidor
$cnx = mysql_connect("$host", "$user", "$senha_db");

// Caso a conexão seja reprovada, exibe na tela uma mensagem de erro
if (!$cnx) die ("<h1>Falha na coneco com o Banco de Dados!</h1>");

// Caso a conexão seja aprovada, então conecta o Banco de Dados.	
$dtb = mysql_select_db("$db");

/*Configurando este arquivo, depois é só você dar um include em suas paginas php, isto facilita muito, pois caso haja necessidade de mudar seu Banco de Dados
você altera somente um arquivo*/



?>
