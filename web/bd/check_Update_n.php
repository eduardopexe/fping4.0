<?PHP
##############################################################################
/* Dados recebidos do Formulario de UPDATE Do Registro Selecionado*/
##############################################################################

# Chamo Arquivo contento as conexoes com o MySQL. #
include_once("/fping4.0/web/var_glob.php");

$acao=$_GET['acao'];
$cod=$_GET['cod'];
$codf=$_GET['codh'];
$data=$_GET['dt'];
$time_stamp=$_GET['tstp'];
$cli=$_GET['cli'];
$cnx=$_GET['cnx'];
$st=$_GET['stalm'];

   if ($acao=="check"){


      $sql = "insert into check_fp (time_stamp,cli,cod_fping,status,cnx,stalm) values ('$time_stamp','$cli','$codf','$acao','$cnx','$st')";

      $resultado = mysql_query($sql,$con);

      # Mostro com esta funcao do Mysql quando registros foram alterados.
      #echo "<br>teste $sql : ".mysql_affected_rows($con)."<br>";

      #echo "<br> $sql";

      $arq_chk=$time_stamp."_".$codf.".txt";
      $novoarquivo = fopen("/fping4.0/web/bd/check_list/$arq_chk", "a+");
      fwrite($novoarquivo, "check");
      fclose($novoarquivo);
      #echo "Tudo concluí!";
#echo "/fping_mon/novo/web/bd/check_list/ $novoarquivo  -- $arq_chk <br>";

   echo "atualizacao ok ---- ";
   echo "check ok<br>";
   echo "<br><br><a href='javascript:window.close();'>Para Fechar esta Janela Clique aqui</a><br>";

   echo "<form method='POST' action='http://$ips/fping4.0/bd/chk_up.php?v_acao=altx&codh=$codf&tstp=$time_stamp'>";
   echo "<p>&nbsp;</p>";
   echo "<table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='73%' id='AutoNumber1'>";
   echo "<tr>";
   echo "<td width='100%'>";
   echo "<p align='center'><font size='2'>COMENTRIO DO ALARME: $cnx - $st</font></td>";
   echo "</tr>";
   echo "<tr>";
   echo "<td width='100%'>";
   echo "<p align='center'>&nbsp;</td>";
   echo "</tr>";
   echo "<tr>";
   echo "<td width='100%'><textarea rows='15' name='txt_obs' cols='61'></textarea></td>";
   echo "</tr>";   
   echo "<tr>";
   echo "<td width='100%'>";
   echo "<p align='center'><input type='submit' value='enviar' name='B1'></td>";
   echo "</tr>";
   echo "</table>";
   echo "<p align='center'>&nbsp;</p>";
   echo "<input type='hidden' name='txt_st' value='$st'>";
   echo "<input type='hidden' name='txt_cnx' value='$cnx'>";
   echo "<input type='hidden' name='txt_codf' value='$codf'>";
   echo "<input type='hidden' name='txt_time_stamp' value='$time_stamp'>";
   echo "<input type='hidden' name='txt_cod' value='0'>";
   echo "</form>";

}
   if ($acao=="checkall"){

      $dir=$cli;

      $fpc = file("/fping4.0/web/resultado/$dir/res_$dir.txt");

echo "/fping4.0/web/resultado/$dir/res_$dir.txt";

      foreach ( $fpc as $linha ){

#echo "$linha <br>";
         $resc=split(";",$linha);

         $time_stamp=$resc[0];
         $data_reg=$resc[1];
         $ip_a=$resc[2];
         $host_a=$resc[10];
         $int_a=$resc[11];
         $status=$resc[7];
         $codf=$resc[8];
         $ip_b=$resc[9];
         $host_b=$resc[12];
         $int_b=$resc[13];
         $descr=$resc[14];
         $vel=$resc[18];
         $tipo_link=$res[20];
         $mn_tipo=$res[21];
         $check_info=$res[22];
         $tstp_check=$res[23];
         $operadora=$res[38];

         $mfr_a=$res[15];
         $mfr_b=$res[16];
         $envia_email=$res[17];

         $tel_operadora=$res[38];

         $vcpu_a=$res[32];
         $vcpu_b=$res[32];

         $v_mem_io_a=$res[36];
         $v_mem_io_b=$res[37];

         $v_mem_proc_a=$res[34];
         $v_mem_proc_b=$res[35];

         $cnx=$host_a." ".$int_a;

         if (preg_match('/$st/i', $status) or $st==$status) {

         }
         else{
#echo "nao entrou $st -- $status <br>";

         continue;
         }
         if ($check_info=="check"){

               continue;
         }

echo "$host_a $int_a - check _/ <br>";

      $sql = "insert into check_fp (time_stamp,cli,cod_fping,status,cnx,stalm) values ('$time_stamp','$cli','$codf','$status','$cnx','$status')";

      $resultado = mysql_query($sql,$con);

      # Mostro com esta funcao do Mysql quando registros foram alterados.
      #echo "<br>teste $sql : ".mysql_affected_rows($con)."<br>";

      #echo "<br> $sql";

      $arq_chk=$time_stamp."_".$codf.".txt";
      $novoarquivo = fopen("/fping4.0/web/bd/check_list/$arq_chk", "a+");
      fwrite($novoarquivo, "check");
      fclose($novoarquivo);
      #echo "Tudo concluí!";


      }

     echo "check all $cli ok<br>";

   }
?>

