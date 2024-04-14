<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Refresh" content="30">
<title>status</title>
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" marginwidth="0" marginheight="0">
<?php

#######################################################
## CASO O ARQUIVO NAO ESTAJA PRONTO AINDA EU AGUARDO ##
#######################################################

        //set content type and xml tag
	        #header("Content-type:text/html");
	       # print("<?html version=\"1.0\"");





    //define variables from incoming values
    if(isset($_GET["posStart"]))
        $posStart = $_GET['posStart'];
    else
        $posStart = 0;
    if(isset($_GET["count"]))
        $count = $_GET['count'];
    else
        $count = 100;
		

$font=" &lt;font size='2' bgcolor='black' color='red'&gt;";
$font2=" &lt;font size='4' bgcolor='black' color='red'&gt;";
$b=" &lt;b&gt;";

$arqv="/fping4.0/web/log_dial_claro.txt";

if (file_exists("$arqv")) {

$fx = file("$arqv");


	echo "<table>";

        echo "<tr bgcolor='CCCCCC'><font size=1>TUNEL CLARO MON 2.0</font><td></td></tr>";
#        echo "<tr bgcolor='CCCCCC'>";
#        echo "<td>tempo</td>";
#        echo "<td>host</td>";
#        echo "<td>qte</td>";
#        echo "</tr>";
        $x="";
	foreach ( $fx as $linha ){
	
	$lin=split(";",$linha);

	$data=$lin[1];
	$hostname=$lin[0];
	$cor=$lin[4];
	$status=$lin[3];
	$qte=$lin[2];

if ($cor=="yellow"){

$cor_t="black";
}
else {

$cor_t="white";

}


 	echo "<tr bgcolor='$cor'>";
 	echo "<td><font color='$cor_t'>$data</font></td>";
 	echo "<td><font color='$cor_t'>$hostname</font></td>";	
 	echo "<td><font color='$cor_t'>$qte</font></td>";
 	echo "</tr>"; 
		
	}
	echo "</table>";	
} 

?>
</body>
</html>
