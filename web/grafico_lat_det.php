<?
$arq=$_GET['ahost'];

$ambx=$_GET['ambi'];
$resa=split("-",$arq);

$ipl=$resa[0];
$host=$resa[1];
$int=$resa[2];
$ipd=$resa[3];
$cod=$resa[4];

$arquivo="/fping4.0/web/resultado/".$ambx."/fping_rtt_media_".$ambx.".txt";

#echo "$arquivo";
$fp = file($arquivo);

//##############################
//## DEFININDO ARRAYS

$rtt_hora=array();
$rtt_limiar_medido=array();
$i=0;

//#############################

#rsort($fp);
$tlin=0;

$faz="nao";

foreach ( $fp as $linha ){

  $rip=split(";",$linha); 

  if ($cod==$rip[1] and $ipd==$rip[2]){

     $line=$linha;

     $faz="sim";

     $resu=split(";",$line);

     $tlin=0;

     foreach ( $resu as $resux){

        $tlin++;
     }
  }  

  if ($faz=="sim"){

     Break;

  }

}

if ($tlin<23){
$i=0;
$j=$tlin-2;
}
else{

$i=0;
$j=20;
}

if ($faz=="sim"){

$linhax=split(";",$line);

$tt_l=0;

$tstp=time();


foreach ( $linhax as $itn ){

$tt_l++;

if ($tt_l<4){

continue;

}

if ($i>$j){
Break;
}

$tstpx=$tstp-($i*120);
$data=date("d/m/Y G:i:s",$tstpx);
  
  // SEPARANDO A DATA DA HORA
    $rt_hora=split(" ",$data);
    $res_hora=$rt_hora[1];
  
  // RETIRANDO OS SEGUNDOS DA HORA 
    $res_segundo=split(":",$res_hora);  
    $res_seg=$res_segundo[0].":".$res_segundo[1];
  
  // DATA
    $res_data=$rt_hora[0];  



// UTILIZANDO ARRAYS PARA AS LINHAS DE EIXO X E Y

$ji=$j-$i;

#echo "$ji --- $itn --- $res_seg<br>";
$rtt_hora[$ji]=$res_seg;
$rtt_limiar_medido[$ji]=$itn;
$i++;

}

include ("/usr/local/jpgraph/src/jpgraph.php");
include ("/usr/local/jpgraph/src/jpgraph_line.php");

//----------------------
// Setup graph 1
//----------------------

$hx=split("\.",$host);
$titulo_1=$hx[0]."_".$int." - lat 10.98.22.11 --> ".$ipd;

$y_axis =($rtt_limiar_medido);
$x_axis =($rtt_hora);

$tam_x="580";
$tam_y="350";

#echo "$y_axis[19] <br> $x_axis[19] <br>";

$datay1 = $y_axis;
#$datay2 = $inc_lim;
// Setup the graph
$graph = new Graph($tam_x,$tam_y);

rsort($rtt_limiar_medido);
$max=$rtt_limiar_medido[0];
$graph->SetScale("textlin",0,$max);
#$theme_class=new UniversalTheme;

#$graph->SetTheme($theme_class);
$graph->img->SetAntiAliasing(false);
$graph->title->Set("$titulo_1");
$graph->SetBox(false);

$graph->img->SetAntiAliasing();

$graph->yaxis->HideZeroLabel();
$graph->yaxis->HideLine(false);
$graph->yaxis->HideTicks(false,false);

$graph->xgrid->Show();
#$graph->xgrid->SetLineStyle("solid");
$graph->xaxis->SetTickLabels($x_axis);
$graph->xaxis->SetLabelAngle(90);
$graph->xgrid->SetColor('#E3E3E3');

// Create the first line
$p1 = new LinePlot($datay1);
$graph->Add($p1);
$p1->SetColor("#6495ED");
$p1->SetLegend("$tipo");

// Create the second line
#$p2 = new LinePlot($datay2);
#$graph->Add($p2);
#$p2->SetColor("#FF0000");
#$p2->SetLegend("limiar: $nl");

#if ($n2>0){

#$p3 = new LinePlot($inc_inst2);
#$graph->Add($p3);
#$p3->SetColor("#FF00FF");
#$p3->SetLegend("$tipo2");


#}

$graph->legend->SetFrameWeight(0);
// Adjust the margin
$graph->img->SetMargin(40,40,20,70);
$graph->legend->SetLayout(LEGEND_HOR);
$graph->legend->Pos(0.5,0.99,"center","bottom");

// Output line
$graph->Stroke();

}
else{

echo "nao coletou";

}
B?>
