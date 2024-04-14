<?
      echo "<table><tr>";

      $total_paginas=$total_paginas+1;

      $p=1;

      for ($p =1; $p<=$total_paginas;$p++){

         if ($num_pagina==$p){

            $f1="<font color=red size=6>";

         }
         else{

            $f1="<font color=blue size=3>";
         }


         $link="mon_det.php?ver=".$ver."&key_som=n&menu_som=n&pg=".$p."&dir=".$dir;

         echo "<td>$f1<a href='$link'target=_self>[$p]</a></font></td>";
            #echo "<td>[$p]</td>";

      }
   echo "</tr>";


   echo "</table>pagina $num_pagina: $inicio a $fim de $total<br>";

?>
