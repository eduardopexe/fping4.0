<?php

#$numero = rand(1,999);
#
#echo"Seu número da sorte é $numero";

$nome=$_POST['nome_sorteio'];

$qtd=$_POST['quantidade'];

$times=$_POST['times'];

echo "$times ; $qtd <br>";

$data_hora=date("d/m/Y H:i:s ");

$arr_times=split(";",$times);

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

echo "<br> :: Sorteio $nome_sorteio $data_hora <br>";

echo "<br>::: grupo 1: <br>";

foreach ($ordem as $key => $val){

$conta++;

echo "$num_grupo;$ordem[$key];<br>";

   
   if ($conta==4){

      $conta=0;
      $num_grupo++;
      echo "<br>::: grupo $num_grupo<br>";
   }
}

?>
