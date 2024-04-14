<?php

include_once('var_glob.php');

$busca=$_POST['txt_busca'];

if ($_GET['txt_busca']) {

$busca=$_GET['txt_busca'];

}
###########################
### ABRINDO OS ARQUIVOS ###
### MONTANDO O HASH #######
###########################

#psys

$arqv="/fping4.0/web/resultado/psys/res_psys.txt";

$fp = file("$arqv");
sort($fp);

foreach ( $fp as $linha ) {

   $res=split(";",$linha);

   $tstp=$res[0];
   $data_reg=$res[1];
   $ip_a=$res[2];
   $host_a=$res[10];
   $int_a=$res[11];
   $status=$res[7];
   $cod=$res[8];
   $ip_b=$res[9];
   $host_b=$res[12];
   $int_b=$res[13];
   $descr=$res[14];
   $vel=$res[18];
   $desig=$res[19];
   $tipo_link=$res[20];
   $mn_tipo=$res[21];
   $check_info=$res[22];
   $tstp_check=$res[23];
   $operadora=$res[38];

   $mfr_a=$res[15];
   $mfr_b=$res[16];
   $envia_email=$res[17];

#   $tel_operadora=$res[38];

   $vcpu_a=$res[32];
   $vcpu_b=$res[33];

   $v_mem_io_a=$res[36];
   $v_mem_io_b=$res[37];

   $v_mem_proc_a=$res[34];


#########################
####chave === cli_ip ####
#########################

   $chave=$res[8];

   if (strlen($chave)<2){

      $chave=$res[10]."_".$res[11];
   }


   $status_oper[$chave] =$linha;

}
####@@@@@


#brad
$arqv="/fping4.0/web/resultado/brad/res_brad.txt";

$fp = file("$arqv");
sort($fp);

foreach ( $fp as $linha ) {

   $res=split(";",$linha);

   $tstp=$res[0];
   $data_reg=$res[1];
   $ip_a=$res[2];
   $host_a=$res[10];
   $int_a=$res[11];
   $status=$res[7];
   $cod=$res[8];
   $ip_b=$res[9];
   $host_b=$res[12];
   $int_b=$res[13];
   $descr=$res[14];
   $vel=$res[18];
   $desig=$res[19];
   $tipo_link=$res[20];
   $mn_tipo=$res[21];
   $check_info=$res[22];
   $tstp_check=$res[23];
   $operadora=$res[38];

   $mfr_a=$res[15];
   $mfr_b=$res[16];
   $envia_email=$res[17];

#   $tel_operadora=$res[38];

   $vcpu_a=$res[32];
   $vcpu_b=$res[33];

   $v_mem_io_a=$res[36];
   $v_mem_io_b=$res[37];

   $v_mem_proc_a=$res[34];


#########################
####chave === cli_ip ####
#########################

   $chave=$res[8];

   if (strlen($chave)<2){

      $chave=$res[10]."_".$res[11];
   }


   $status_oper[$chave] =$linha;

}
####@@@@@

#unib
$arqv="/fping4.0/web/resultado/unib/res_unib.txt";

$fp = file("$arqv");
sort($fp);

foreach ( $fp as $linha ) {

   $res=split(";",$linha);

   $tstp=$res[0];
   $data_reg=$res[1];
   $ip_a=$res[2];
   $host_a=$res[10];
   $int_a=$res[11];
   $status=$res[7];
   $cod=$res[8];
   $ip_b=$res[9];
   $host_b=$res[12];
   $int_b=$res[13];
   $descr=$res[14];
   $vel=$res[18];
   $desig=$res[19];
   $tipo_link=$res[20];
   $mn_tipo=$res[21];
   $check_info=$res[22];
   $tstp_check=$res[23];
   $operadora=$res[38];

   $mfr_a=$res[15];
   $mfr_b=$res[16];
   $envia_email=$res[17];

#   $tel_operadora=$res[38];

   $vcpu_a=$res[32];
   $vcpu_b=$res[33];

   $v_mem_io_a=$res[36];
   $v_mem_io_b=$res[37];

   $v_mem_proc_a=$res[34];


#########################
####chave === cli_ip ####
#########################

   $chave=$res[8];

   if (strlen($chave)<2){

      $chave=$res[10]."_".$res[11];
   }


   $status_oper[$chave] =$linha;

}
####@@@@@

$sql2="select * from devices where CONCAT(hostname,' ',interface,' ',hostname_remoto,' ',interface_remoto,' ',ip,' ',ip_remoto) like '%$busca%' and left(ativo,1) not in ('9')";

echo $sql2." $con <br>";
$resultado2 = mysql_query($sql2,$con);

echo "#".mysql_affected_rows()."<br>";

echo "<table width=800>";
echo "<tr bgcolor='CCCCCC'>";
echo "<td>";
echo "data";
echo "</td>";
echo "<td>";
echo "hostname";
echo "</td>";
echo "<td>";
echo "interface";
echo "</td>";
echo "<td>";
echo "ip";
echo "</td>";
echo "<td>";
echo "descricao";
echo "</td>";
echo "<td>";
echo "";
echo "</td>";
echo "</tr>";

#echo $resultado;

   while ($retorno2 = mysql_fetch_array($resultado2)) {

echo "twat<br>";
 
      $cod=$retorno2['cod'];
      $hostname=$retorno2['hostname'];
      $ip=$retorno2['ip'];
      $interface=$retorno2['interface'];
      $descri=$retorno2['descricao'];
      $cli=$retorno2['cli'];

      $ref=$cod;
echo "$cod $hostname";
      $resx=split(";",$status_oper[$ref]);

echo "$status_oper[$ref] <br>";
      $tstp=$resx[0];
      $data_reg=$resx[1];
      $ip_a=$resx[2];
      $host_a=$resx[10];
      $int_a=$resx[11];
      $status=$resx[7];
      $cod=$resx[8];
      $ip_b=$resx[9];
      $host_b=$resx[12];
      $int_b=$resx[13];
      $descr=$resx[14];
      $vel=$resx[18];
      $desig=$resx[19];
      $tipo_link=$resx[20];
      $mn_tipo=$resx[21];
      $check_info=$resx[22];
      $tstp_check=$resx[23];
      $operadora=$resx[38];

      $mfr_a=$resx[15];
      $mfr_b=$resx[16];
      $envia_email=$resx[17];

#   $tel_operadora=$resx[38];

      $vcpu_a=$resx[32];
      $vcpu_b=$resx[33];

      $v_mem_io_a=$resx[36];
      $v_mem_io_b=$resx[37];

      $v_mem_proc_a=$resx[34];


      if ($status=="ok"){

      $cor="00FF00";
      $cor_rtt="00FF00";
      $cor_rtt_font="black";
      $message="";
      }

      if ($status=="loss"){

      $cor="yellow";
      $message="";
      }

      if ($status=="loss"){

      $cor="orange";
      $message="";
      }
      
      if ($status=="falha"){

      $cor="red";
      $cor_rtt="red";
      $message="";
      $cor_rtt_font="white";

      }

      if (left($fping,1)=="5"){

      $cor="#87CEEB";
      $message="Erro cadastro";

      }

      if ($status=="rtt" || $status=="lat"){

      $cor_rtt="#9900CC";
      $message="";
      $cor_rtt_font="white";
      }

      echo "<tr>";
      echo "<font color='$cor_rtt_font'>";
      echo "</td>";
      echo "<td>";
      echo "<font color='$cor_rtt_font'>$data_reg";
      echo "</td>";
      echo "<td>";
      echo "<font color='$cor_rtt_font'>$host_a $int_a <br>$host_b $int_b";
      echo "</td>";
      echo "<td>";
      echo "<font color='$cor_rtt_font'>$descri";
      echo "</td>";
      echo "<td>";
      echo "";
      echo "</td>";
      echo "</tr>";


   }

   echo "</table>";

?>
