<?

## Include File - sumario ##

$dir=$_GET['dir'];

$arq="mon_sum_$dir.php";

#echo "aqui teste $arq";
include_once($arq);

#chave de exibicao

$ver=$_GET['ver'];

$pagina=$_GET['pg'];

###paginacao
if ($pagina==""){

$num_pagina=1;
}
else {

$num_pagina=$pagina;

}

###fim paginacao


      $fp = file("/fping4.0/web/resultado/$dir/res_$dir.txt");
#inicio vermelho

include_once("/fping4.0/web/list/list_falha.php");
############################verelho fim

#falha dev

include_once("/fping4.0/web/list/list_falha_dev.php");

#ok

include_once("/fping4.0/web/list/list_ok.php");

#loss

include_once("/fping4.0/web/list/list_loss.php");

#rtt

include_once("/fping4.0/web/list/list_rtt.php");

#chk
include_once("/fping4.0/web/list/lista_chk.php");
#echo "#######laranja#########<br>";

include_once("/fping4.0/web/list/list_crit.php");

?> 
</body>
</html>


