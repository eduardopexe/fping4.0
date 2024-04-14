<?

####exibicao para falha

   if ($ver=="dev_ok" or $ver=="lf_ok" or $ver=="ll_ok"){



      $link_chk_all="<a href='http://$ips/fping4.0/bd/check_Update_all_n.php?dir=$dir&cor=$ver' target=_blank>check all</a>";
      echo "<table width=1200>";
      echo "<tr bgcolor='CCCCCC'>";
      echo "<td width='80'>data</td>";
      echo "<td width='220'>host_a int_a - host_b int_b</td>";
      echo "<td width='80'>ipa - ipb</td>";
      echo "<td width='250'>Descricao</td>";
      echo "<td width='100'>info</td>";
      echo "<td width='100'>rtt</td>";
      echo "<td width='100' colspan='2'>loss</td>";
      echo "</tr>";
      rsort($fp);
##################paginacao

      $i=1;

      $inicio=$num_pagina*$num_reg-($num_reg);

      $fim=$inicio+$num_reg;

      if ($ver=="dev_ok"){


         $total=$dev_ok;

      }

      if ($ver=="lf_ok"){

         $total=$lf_ok;

      }

      if ($ver=="ll_ok"){

         $total=$ll_ok;

      }

      $total_paginas=(int) ($total/$num_reg);

##################fim paginacao

      foreach ( $fp as $linha )
      {

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
         $operadora=$res[17];

$teste_ver=$mn_tipo."_ok";
#echo "$ver -- $teste_ver <br>";
         if (preg_match('/ok/i', $status) and $ver==$teste_ver or preg_match('/ok/i', $status) or $dir=="kpmg") {

            $res=split(";",$linha);
            if ($ver==$teste_ver and $check_info=="check" or strlen($host_a)<3){

               continue;
            }

#pula linha se tela de exibiç e vermelho check - pula vermelho sem check

            if ($ver=="chk" and $check_info=="nocheck"){

              #    echo "entrou - check <br>";
              continue;
            }

###################paginacao


         $i++;

         if ($i>=$inicio and $i<$fim){


         }
         else {

            if ($i>$fim){
               Break;
            }
            else{
               continue;

            }

         }


########################


         $corx="00FF00";
         $vcolor="00FF00";
         $vfont_color="black"; 
####check sys

#include_once("/fping4.0/web/list/check_sys.php");

################
         $link_pesquisa="<a href='http://$ips/fping4.0/mon_pesquisa.php?txt_busca=$hostname' target=_blank>$hostname</a>";


         echo "<tr>";
         echo "<td bgcolor='$vcolor' width='80'>$data_reg</td>";
         echo "<td bgcolor='$vcolor' width='220'>$host_a ".$int_a."<br>".$host_b." ".$int_b." | $cod</td>";
         echo "<td bgcolor='$vcolor' width='80'>$ip_a<br>$ip_b</td>";
         echo "<td bgcolor='$vcolor' width='250'>$descr</td>";
         echo "<td bgcolor='$vcolor' width='100'>$mn_tipo</td>";
         echo "<td width='100' bgcolor='$corx'>$res[6]</td>";
         echo "<td width='100' bgcolor='$corx'>$res[5]</td>";
         echo "</tr>";

         $c++;

         }
      }
      echo "</table>";

include_once("/fping4.0/web/list/paginacao.php");

   }

?>
