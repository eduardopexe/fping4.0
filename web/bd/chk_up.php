<?PHP
##############################################################################
/* Dados recebidos do Formulario de UPDATE Do Registro Selecionado*/
##############################################################################

# Chamo Arquivo contento as conexoes com o MySQL. #
include_once("/fping4.0/web/var_glob.php");

$v_acao=$_GET['v_acao'];
$v_acao=$_GET['v_acao'];
$acao=$_GET['acao'];
$cod=$_GET['cod'];
$codf=$_GET['codh'];
$data=$_GET['dt'];
$time_stamp=$_GET['tstp'];
$cli=$_GET['cli'];
$cnxa=$_GET['cnx'];
$st=$_GET['stalm'];   

   if ($acao=="check"){

   $sql = "Select * from check_fp where time_stamp='$time_stp' AND cod_fping='$codf'";
   #$sql = "insert into check_rtt (time_stamp,interface,cli,hostname,obs) values ('$time_stamp','$int','bb','$host','check')";
   $resultado = mysql_query($sql,$con);
   $retorno=mysql_fetch_assoc($resultado);


   $cli=$retorno["cli"];
   $codf=$retorno["cod_fping"];
   $obs=$retorno["obs"];   
   $time=$retorno["time_stamp"];
   $cod=$retorno["cod"];
   $cnx=$retorno["cnx"];
   $stalm=$retorno["stalm"];

   }



#################

if ($v_acao=="alt"){

#echo "entrou <br>";
$cli=$_POST['txt_cli'];
$codf=$_POST['txt_codf'];
$obs=$_POST['txt_obs'];
$time_stp=$_POST['txt_time_stamp'];
$cod=$_POST['txt_cod'];
$sql2 = "UPDATE check_fp SET obs='$obs' WHERE time_stamp='$time_stp' AND cod_fping='$codf'";
#echo $sql2;
$uptade = mysql_query($sql2,$con);

###############

$sql = "Select * from check_fp where time_stamp='$time_stp' AND cod_fping='$codf'";
$resultado = mysql_query($sql,$con);
$retorno=mysql_fetch_assoc($resultado);

#echo "$sql <br>";
   $cli=$retorno["cli"];
   $codf=$retorno["cod_fping"];
   $obs=$retorno["obs"];
   $time=$retorno["time_stamp"];
   $cod=$retorno["cod"];
   $cnx=$retorno["cnx"];
   $stalm=$retorno["stalm"];
#echo "$obs <br>";
}

###################


   if ($v_acao=="altx"){

   #echo "entrou <br>";
   $int=$_GET['int'];
   $cli=$_GET['cli'];
   $cnx=$_POST['cnx'];
   $time_stp=$_GET['tstp'];
   $obs=$_POST['txt_obs'];
   $codf=$_GET['codh'];
 
   $sql2 = "UPDATE check_fp SET obs='$obs' WHERE time_stamp='$time_stp' AND cod_fping='$codf'";
#   echo "$sql2";
   $uptade = mysql_query($sql2,$con);

###############

   $sql = "Select * from check_fp where time_stamp='$time_stp' AND cod_fping='$codf'";
   #$sql = "insert into check_rccf (time_stamp,interface,cli,hostname,obs) values ('$time_stamp','$int','bb','$host','check')";
   $resultado = mysql_query($sql,$con);
   $retorno=mysql_fetch_assoc($resultado);

   #echo "$sql <br>";
   $cli=$retorno["cli"];
   $codf=$retorno["cod_fping"];
   $obs=$retorno["obs"];
   $time=$retorno["time_stamp"];
   $cod=$retorno["cod"];
   $cnx=$retorno["cnx"];
   $stalm=$retorno["stalm"];
   #echo "$obs <br>";
   }

#################

if ($v_acao=="com"){

#echo "entrou <br>";
$int=$_GET['int'];
$cli=$_GET['cli'];;
$cnx=$_GET['cnx'];
$time_stp=$_GET['tstp'];
$cod=$_GET['cod'];
$codf=$_GET['codh'];
$sql = "Select * from check_fp where time_stamp='$time_stp' AND cod_fping='$codf'";
#$sql = "insert into check_rccf (time_stamp,interface,cli,hostname,obs) values ('$time_stamp','$int','rccf','$host','check')";
$resultado = mysql_query($sql,$con);
$retorno=mysql_fetch_assoc($resultado);

#echo "$sql <br>";
   $cli=$retorno["cli"];
   $codf=$retorno["cod_fping"];
   $obs=$retorno["obs"];
   $time=$retorno["time_stamp"];
   $cod=$retorno["cod"];
   $cnx=$retorno["cnx"];
   $stalm=$retorno["stalm"];
#echo "$obs <br>";
}

#echo "<br><br><a href='javascript:history.back(1);'>Para Voltar Clique aqui</a><br>";

echo "<br><br><a href='javascript:window.close();'>Para Fechar esta Janela Clique aqui</a><br>";
######################################
echo "<br>";
echo "<form method='POST' action='http://$ips/fping4.0/bd/chk_up.php?v_acao=alt'>";
echo "  <p>&nbsp;</p>";
echo "  <table width=600 border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>";
echo "    <tr>";
echo "      <td width='100%'>";
echo "      <p align='center'><font size='2'>ATUALIZA ALARME:</font></td>";
echo "    </tr>";
echo "    <tr>";
echo "      <td width='100%'>";
echo "      <p align='center'><b>CNX</b> ".$cnx."<b> ambiente:</b> ".$cli."</td>";
echo "    </tr>";
echo "    <tr>";
echo "      <td width='100%'><textarea rows='15' name='txt_obs' cols='71' >".$obs."</textarea></td>";
echo "    </tr>";
echo "    <tr>";
echo "      <td width='100%'>";
echo "     <p align='center'><input type='submit' value='atualizar' name='B1'></td>";
echo "    </tr>";
echo "  </table>";
echo "  <p align='center'>&nbsp;</p>";
echo "  <input type='hidden' name='txt_cnx' value='$cnx'>";
echo "  <input type='hidden' name='txt_time_stamp' value='$time'>";
echo "  <input type='hidden' name='txt_cod' value='$cod'>";
echo " <input type='hidden' name='txt_cli' value='$cli'>";
   echo "<input type='hidden' name='txt_st' value='$st'>";
   echo "<input type='hidden' name='txt_codf' value='$codf'>";
echo "</form>";


#echo "<br><br><a href='javascript:history.back(1);'>Para Voltar Clique aqui</a><br>";

#echo "<br><br><a href='javascript:window.close();'>Para Fechar esta Janela Clique aqui</a><br>";

#################


#      $arq_chk=$time_stamp."_".$host."_".$int;
#      $novoarquivo = fopen("/fping_mon/novo/lista/check_list/$arq_chk", "a+");
#      fwrite($novoarquivo, "check");
#      fclose($novoarquivo);
#      #echo "Tudo concluí!";

?>

