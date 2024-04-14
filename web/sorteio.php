<html>

<head>
<meta http-equiv="Content-Language" content="pt-br">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Pagina de Sorteio de grupos</title>
<style type="text/css">
@import url("estilo.css");
</style>
</head>

<body>

<?php

set_time_limit(0);

include("cnx.php");

#$numero = rand(1,999);
#
#echo"Seu número da sorte é $numero";

$nome=$_POST['nome_sorteio'];

$qtd=$_POST['quantidade'];

$times=$_POST['times'];

echo "$times ; $qtd <br>";

$data_hora=date("d/m/Y H:i:s ");
$data_reg=date("Y-m-d H:i:s");

$arr_times=split(";",$times);

$qtd_times=sizeof($arr_times);

$result="";

$num_sai=0;

foreach ($arr_times as $ti){

#echo "$ti<br>";
   $num=rand(1,999);

   if ($num_sai==$num){

      $num_i=$num_sai+10;
      $num_f=$num_sai+30;

      $num=rand($num_i,$num_f);

   }

$len=strlen($ti);

   if ($len>0){
   $ordem[$num]=$num.";".$ti;

   echo "$num;$ti;<br>";
   }

}

#ordena hash

sort($ordem);

$conta=0;

$num_grupo=1;

$ct=0;

echo "<br> :: Sorteio $nome_sorteio $data_hora <br>";

$result="<br> :: Sorteio $nome_sorteio $data_hora <br>";

echo "<br>::: grupo 1: <br>";

$result=$result."<br>::: grupo 1: <br>";

foreach ($ordem as $key => $val){

$conta++;

$ct++;

echo "$num_grupo;$conta;$ordem[$key];<br>";

$result=$result."$num_grupo;$conta;$ordem[$key];<br>";

$chave=$num_grupo."_".$conta;

$time_nome=split(";",$ordem[$key]);

$grupo[$chave]=$time_nome[1];

   if ($conta==$qtd){

      if ($qtd%2==1){

         $completa=$conta+1;

         $chave=$num_grupo."_".$completa;
         $grupo[$chave]="-";
         
      }

      $conta=0;
      if ($ct<$qtd_times){

         $num_grupo++;
         echo "<br>::: grupo $num_grupo<br>";
         $result=$result."<br>::: grupo $num_grupo<br>";
      }
   }


}

####monta tabela de jogos

$fator_ida_e_volta=2;
$num_rodadas=($qtd-1)*$fator_ida_e_volta;

if ($qtd%2==1){

$qtx=$qtd+1;   

}
else{

$qtx=$qtd;

}

$metade_grupo=$qtx/2;

#echo "$qtx --- $metade_grupo <br>";

#testa se ja existe campeonato sorteado

$sql="select nome_sorteio from registro_sorteio where nome_sorteio='$nome_sorteio'";

$resultado = mysql_query($sql,$cnx);

$mysq=mysql_affected_rows();

if ($mysq == 0){

$sqli="insert into registro_sorteio (data_sorteio,nome_sorteio,resultado) values ('$data_reg','$nome_sorteio','$result')";

$resultado = mysql_query($sqli,$cnx);

$sql="select * from registro_sorteio where nome_sorteio='$nome_sorteio'";
$resultadoi3 = mysql_query($sql,$cnx);
$retorno=mysql_fetch_assoc($resultadoi3);

$cod_sorteio=$retorno['cod'];
$testa="sim";
}
else{

echo "já existe sorteio para $nome_sorteio, utilize outro nome, ou acrescente a versao do torneio ao fim do nome $nome_sorteio <br>";
$testa="nao";

}



if ($testa=="sim"){

   for ($size=1;$size<=$num_grupo;$size++) {

      #rodadas
      $rod=1;

#      echo "teste $size<br>";

      $tabela=1;

      for ($tabela=1;$tabela < $metade_grupo+1;$tabela++){

         $chave=$size."_".$tabela;

         $a[$chave]=$grupo[$chave];
#         echo "a $chave = $grupo[$chave] <br>";
     }

     $tabela=1;

     for ($tabela=1;$tabela<$metade_grupo+1;$tabela++){

        $chave=$size."_".$tabela;

       $cb=$tabela+$metade_grupo;

        $chave_b=$size."_".$cb;
      
        $b[$chave]=$grupo[$chave_b];

#        echo "b $chave = $grupo[$chave_b] i--- $chave_b <br>";

     }

#rodadas

   $rod=1;
      for ($rod=1;$rod<$num_rodadas+1;$rod++){

         echo "<br>rodada $rod grupo $size <br>";
         $result=$result."rodada $rod grupo $size <br>";

         $t=1;

         for ($t=1;$t<$metade_grupo+1;$t++){

            $chave=$size."_".$t;

            if ($rod<=$num_rodadas/2){

               echo "$a[$chave] x $b[$chave]<br>";
               $result=$result."$a[$chave] x $b[$chave]<br>";

               $sql_i="insert into jogos (campeonato,time_a,time_b,data_jogo,cod_sorteio,grupo,rodada) values ('$nome_sorteio','$a[$chave]','$b[$chave]','$data_reg','$cod_sorteio','$size','$rod')";
            }
            else{

               echo "$b[$chave] x $a[$chave]<br>";
               $result=$result."$b[$chave] x $a[$chave]<br>";
               $sql_i="insert into jogos (campeonato,time_a,time_b,data_jogo,cod_sorteio,grupo,rodada) values ('$nome_sorteio','$b[$chave]','$a[$chave]','$data_reg','$cod_sorteio','$size','$rod')";

            }    

#              echo "$sql_i <br>";
              $resultado2 = mysql_query($sql_i,$cnx);
         }
###fim imprime jogos

#armazena a em a_old | b em b_old

         $t=1;

         for ($t=1;$t<$metade_grupo+1;$t++){

            $chave=$size."_".$t;
            $a_old[$chave]=$a[$chave];
            $b_old[$chave]=$b[$chave];

#            echo "a old $chave = $a[$chave]<br>";
         }


###troca fila

        $t=1;

#monta troca de fila ####################

         for ($t=1;$t<$metade_grupo+1;$t++){


            if ($t==1){

               $ta=$t+1;

               $chave_a=$size."_".$ta;
               $chave_a_novo=$size."_".$t;

               $chave_b=$size."_".$t;
               $chave_b_novo=$size."_".$ta;

               $a[$chave_a]=$b_old[$chave_a_novo];
               $b[$chave_b]=$b_old[$chave_b_novo];

            }
            else{

               if ($t == $metade_grupo){

                 # echo "fim de grupo";

                  $ta=$t+1;

                  $ta_old=$t;

                  $chave_a=$size."_".$ta;
                  $chave_a_novo=$size."_".$t;

                  $chave_b=$size."_".$t;
                  $chave_b_novo=$size."_".$ta;

                  $b[$chave_b]=$a_old[$chave_a_novo];

               }
               else{

                  $ta=$t+1;

                  $chave_a=$size."_".$ta;
                  $chave_a_novo=$size."_".$t;

                  $chave_b=$size."_".$t;
                  $chave_b_novo=$size."_".$ta;

                  $a[$chave_a]=$a_old[$chave_a_novo];
                  $b[$chave_b]=$b_old[$chave_b_novo];

               }
            }
        }
#fim troca fila
###fim rodadas
      } 
#     echo "aqui $tabela $metade_grupo <br>";

   }


} 
?>
<p align="left"><a href="pesquisa_sorteio.php">sorteios realizados</a> | </p>
</body>
</html>
