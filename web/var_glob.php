<?

###db login

$dblogin="noc";
$dbpass="noc";
$dbname="noc";

#tabela

$tabela="devices_bb";

#ip servidor local:
$ips="10.98.22.11";

#ip servidor banco de dados:
$ipbd="10.98.22.7";

#echo "$_SERVER[REMOTE_ADDR]";

#registros por pagina
#$ipbd="localhost";
$num_reg=30;

#
#######db select

#base de dados
$db_server=$ipbd;
$db_login=$dblogin;
$db_pass=$dbpass;
$db_name=$dbname;

$con = @mysql_connect($db_server,$db_login,$db_pass,"");

#echo $_con."###################<br>";
if($con == FALSE) {
echo "Nao foi possivel conectar ao Mysql <br>";
#mysql_erro();
exit;
} else {

mysql_select_db($db_name,$con);

}

################

#funÃ§ de titulos

####

function label_tit (&$fdir)
{

   if ($fdir=="psys"){

      $fdir="BKB MPLS PSYS";

   }

   if ($fdir=="brad"){

      $fdir="BKB BRAD";

   }

   if ($fdir=="unib"){

      $fdir="BKB UNIB";

   }

   if ($fdir=="ebtv"){

      $fdir="EMBRATEL VERTICAL";

   }


}
###

#VARIAVEIS DE DATA PARA RELATORIOS
$chave=$_GET['periodo'];

$data_timestamp = time("d/m/Y G:i:s");
if ($chave=="dia"){ 

$dt_i=$data_timestamp-86400;

}

if ($chave=="semana"){ 

$dt_i=$data_timestamp-604800;

}


if ($chave=="mes"){ 

$dt_i=$data_timestamp-2592000;

}

if ($chave==""){ 

$dt_i=$data_timestamp-86400;

}

$data_tf=date("d/m/Y G:i:s", $data_timestamp);


$data_ti=date("d/m/Y G:i:s", $dt_i);

###funcao para construir link de detalhes do link -cod, alarme
#ip front end
$ip_f="10.98.22.10";
$ip_s="10.98.22.11";

function link_cadastro ($cod_fx,$stfc,$operadorac,$desigc,$velc){

$link_c="";

$link_c="<a href='http://10.98.22.10/links_bkb2.0/views/links_fping.asp?str_status_link=codu&cod=$cod_fx&alm=$stfc' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/gerar_evento.png' width='32' height='32' title='clique para ver o cadastro:\n$operadorac \n Desig: $desigc \n $velc'>";
#$link_c=$link_c."</a>";

#echo "Exemplo de função. $cod_fx,$stfc ----- $link_c\n<br>";
#echo $link_c." <br>";
    return $link_c;
}

#link configuraçao

function link_cfg ($hostc){

$link_c="";

$link_c="<a href='http://10.98.22.10/relatorio_routers/controle_de_hosts/controle_de_hosts.asp";
$link_c=$link_c."?str_texto=$hostc' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/cfg.png'";
$link_c=$link_c." width='24' height='24' title='ver cofiguração $hostc'></a>";

    return $link_c;
}

###cpu link

function link_cpu ($vcpu_c,$hostc,$tamc){

####imagem cpu 
$img_cpuc="nogauge.png";

if ($vcpu_c<0){

$img_cpuc="nogauge.png";
$vcpu_c="nao coletado";
}

if ($vcpu_c>0 and $vcpu_c<40){

$img_cpuc="gauge1.png";


}

if ($vcpu_c>39 and $vcpu_c<60){

$img_cpuc="gauge2.png";


}


if ($vcpu_c>59 and $vcpu_c<85){

$img_cpuc="gauge3.png";


}

if ($vcpu_c>84 and $vcpu_c<96){

$img_cpuc="gauge4.png";


}


if ($vcpu_c>95){

$img_cpuc="gauge5.png";


}

$link_c="";

$link_c="<a href='http://10.98.22.14/rtt_mon/grafico_cpu.php";
$link_c=$link_c."?ahost=$hostc' target=_blank>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_cpuc'";
$link_c=$link_c." width='$tamc' height='$tamc' title='cpu $hostc: $vcpu_c %'></a>";

    return $link_c;
}


#mem proc link

function link_mem_proc ($v_mem_proc_c,$hostc){

$link_c="";

$img_mem_proc_c="disk2.png";

if ($v_mem_proc_c<0){
$v_mem_proc_c="nao coletado";
$img_mem_proc_c="nodisk.png";
}

if ($v_mem_proc_c>0 and $v_mem_proc_c<10){

$img_mem_proc_c="disk1.png";

}

if ($v_mem_proc_c>9 and $v_mem_proc_c<31){

$img_mem_proc_c="disk2.png";

}

if ($v_mem_proc_c>30 and $v_mem_proc_c<61){

$img_mem_proc_c="disk3.png";

}


if ($v_mem_proc_c>60 and $v_mem_proc_c<95){

$img_mem_proc_c="disk4.png";

}

if ($v_mem_proc_c>94){

$img_mem_proc_c="disk5.png";

}

$link_c="<a href='http://10.98.22.14/rtt_mon/grafico_mem.php";
$link_c=$link_c."?ahost=$hostc' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_mem_proc_c'";
$link_c=$link_c." width='24' height='5' title='mem processador $hostc: $v_mem_proc_c %'></a>";

    return $link_c;
}


###link rtt

function link_rtt ($cod_fx,$stfc,$hostc,$iplc,$intc,$ipdestc,$rtt_statusc,$hostbc,$intbc,$tp){

$link_c="";
$intc2=str_replace("/","_",$intc);
$img_rtt="nogauge.png";

if ($rtt_statusc=="ok"){

$img_rtt="rttok.png";

}

if ($rtt_statusc=="rtt"){

$img_rtt="rtt_lat.png";

}
if ($tp=="rtt"){

$ipsr="10.98.22.14";
$dir_t="rtt_mon";
}
else{

   if ($tp == "rtt man"){

      $ipsr="10.98.22.11";
      $dir_t="rtt_monm";
   }
   else{

      $ipsr="$tp";
   }
}
$link_c="<a href='http://".$ipsr."/".$dir_t."/mon_grap.php";
$link_c=$link_c."?ahost=$iplc-$hostc-$intc2-$ipdestc-$cod_fx-.txt&rhost=$hostbc-$intbc' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_rtt'";
$link_c=$link_c." width='24' height='24' title='clique para ver o grafico de rtt ponto a ponto'></a>";

    return $link_c;
}

###
###link rtt

function link_rttx ($cod_fx,$stfc,$hostc,$iplc,$intc,$ipdestc,$rtt_statusc,$hostbc,$intbc,$tp,$iplbc,$rtt_stbc,$ipdestbc){

$link_c="";
$intc2=str_replace("/","_",$intc);
$intbc2=str_replace("/","_",$intbc);

$img_rtt="nogauge.png";

if ($rtt_statusc=="ok"){

$img_rtt="rttok.png";

}

if ($rtt_stbc=="ok"){

$img_rtt="rttok.png";

}

if ($rtt_statusc=="rtt" or $rtt_stbc=="rtt"){

$img_rtt="rtt_lat.png";

}



if ($tp=="rtt"){

$ipsr="10.98.22.14";
$dir_t="rtt_mon";
}
else{

   if ($tp == "rtt man"){

      $ipsr="10.98.22.11";
      $dir_t="rtt_monm";
   }
   else{


      $ipsr="$tp";
   }
}

$link_c="<a href='http://".$ipsr."/".$dir_t."/monx.php";
$link_c=$link_c."?ahost=$iplc-$hostc-$intc2-$ipdestc-$cod_fx-.txt&rhost=$hostbc-$intbc";
$link_c=$link_c."&bhost=$iplbc-$hostbc-$intbc2-$ipdestbc-$cod_fx-.txt&rbhost=$hostc-$intc' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_rtt'";
$link_c=$link_c." width='32' height='32' title='clique para ver o grafico de rtt ponto a ponto'></a>";

    return $link_c;
}
###
######################

###link latencia

function link_latx ($cod_fx,$stfc,$hostc,$iplc,$intc,$ipdestc,$rtt_statusc,$hostbc,$intbc,$iplbc,$rtt_statusbc,$ipdestbc,$ambx){

$link_c="";
#$intc2=str_replace("/","_",$intc);

$teste_info_a=split(" ",$rtt_statusc);
$teste_info_b=split(" ",$rtt_statusbc);

$img_rtt="nogauge.png";

if ($teste_info_a[0]=="ok"){

$img_rtt="rttok.png";

}

if ($teste_info_b[0]=="ok"){

$img_rtt="rttok.png";

}

if ($teste_info_a[0]=="lat" or $teste_info_b[0]=="lat"){

$img_rtt="rtt_lat.png";

}

$link_c="<a href='http://10.98.22.11/fping4.0/grafico_lat.php";
$link_c=$link_c."?ahost=$iplc-$hostc-$intc-$ipdestc-$cod_fx";
$link_c=$link_c."&rhost=$iplbc-$hostbc-$intbc-$ipdestbc-$cod_fx&amb=$ambx' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_rtt'";
$link_c=$link_c." width='24' height='24' title='latencia a partir do servidor 10.98.22.11:";
$link_c=$link_c." $teste_info_a[1] ms \n $teste_info_b[1] ms \n";
$link_c=$link_c."clique para ver o grafico de latencia a partir do servidor'></a>";

    return $link_c;

}

###link latencia

function link_lat ($cod_fx,$stfc,$hostc,$iplc,$intc,$ipdestc,$rtt_statusc,$hostbc,$intbc){

$link_c="";
#$intc2=str_replace("/","_",$intc);

$teste_info=split(" ",$rtt_statusc);

$img_rtt="nogauge.png";

if ($teste_info[0]=="ok"){

$img_rtt="rttok.png";

}

if ($teste_info[0]=="lat"){

$img_rtt="rtt_lat.png";

}


$link_c="<a href='http://10.98.22.11/fping4.0/grafico_lat.php";
$link_c=$link_c."?ahost=$iplc-$cod_fx&rhost=$hostc-$intc-$iplc-$hostbc-$intbc-$ipdestc' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_rtt'";
$link_c=$link_c." width='24' height='24' title='latencia a partir do servidor 10.98.22.11:  $teste_info[1] ms \nclique para ver o grafico de latencia a partir do servidor'></a>";

    return $link_c;
}

###loss

###link loss

function link_loss ($cod_fx,$stfc,$hostc,$iplc,$intc,$ipdestc,$rtt_statusc,$hostbc,$intbc){

$link_c="";
#$intc2=str_replace("/","_",$intc);

$teste_info=split(" ",$rtt_statusc);

#echo "$rtt_statusc - $teste_info[0] -- $teste_info[1]<br>";
$img_rtt="nostatus.png";

if ($teste_info[1]==""){

#echo "aqui";
$img_rtt="nostatus.png";

}

if ($teste_info[1]==0){

#echo "aqui";
$img_rtt="ok.png";

}

if ($teste_info[1]>0){

#echo "aqui";
$img_rtt="ok.png";

}

if ($teste_info[1]>10){

$img_rtt="loss11.png";

}

if ($teste_info[1]>30){

$img_rtt="loss12.png";

}

if ($teste_info[1]>80){

$img_rtt="falha.png";

}


$link_c="<a href='http://10.98.22.11/fping4.0/grafico_loss.php";
$link_c=$link_c."?ahost=$iplc-$cod_fx&rhost=$hostc-$intc-$iplc-$hostbc-$intbc-$ipdestc' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_rtt'";
$link_c=$link_c." width='18' height='18' title='perda de pacote :  $teste_info[1] % \nclique para ver o grafico de loss'></a>";

    return $link_c;
}

###link utl
function link_utl ($cod_fx,$stfc,$hostc,$iplc,$intc,$ipdestc,$rtt_statusc,$hostbc,$intbc){

$link_c="";
#$intc2=str_replace("/","_",$intc);

$teste_info=split("#",$rtt_statusc);

$tx=split(" ",$teste_info[0]);

$rx=split(" ",$teste_info[1]);

#echo "$rtt_statusc - $teste_info[0] -- $teste_info[1]<br>";

$img_tx="nobar.png";
$img_rx="nobar.png";

if ($tx[1]==0){

#echo "aqui";
$img_tx="bar0.png";

}

if ($tx[1]>0){

#echo "aqui";
$img_tx="bar1.png";

}

if ($tx[1]>10){

$img_tx="bar2.png";

}

if ($tx[1]>20){

$img_tx="bar2.png";

}

if ($tx[1]>30){

$img_tx="bar3.png";

}


if ($tx[1]>40){

$img_tx="bar4.png";

}

if ($tx[1]>50){

$img_tx="bar5.png";

}

if ($tx[1]>60){

$img_tx="bar6.png";

}

if ($tx[1]>80){

$img_tx="bar7.png";

}

####################

if ($rx[1]==0){

#echo "aqui";
$img_rx="bar0.png";

}

if ($rx[1]>0){

#echo "aqui";
$img_rx="bar1.png";

}

if ($rx[1]>10){

$img_rx="bar2.png";

}

if ($rx[1]>20){

$img_rx="bar2.png";

}

if ($rx[1]>30){

$img_rx="bar3.png";

}


if ($rx[1]>40){

$img_rx="bar4.png";

}

if ($rx[1]>50){

$img_rx="bar5.png";

}

if ($rx[1]>60){

$img_rx="bar6.png";

}

if ($rx[1]>80){

$img_rx="bar7.png";

}


$link_c="<a href='http://10.98.22.18/fping4.0/grafico_int.php";
$link_c=$link_c."?ahost=$iplc-$cod_fx&rhost=$hostc-$intc-$iplc-$hostbc-$intbc-$ipdestc&tip=rxload' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_tx' width='17' height='48' title='tx :  $tx[1] % rx: $rx[1] %\n'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_rx' width='17' height='48' title='tx :  $tx[1] % rx: $rx[1] %\n'>";
$link_c=$link_c."</a>";

return $link_c;
}


###############
###link errors (crc;errors;resets)

function link_errors ($cod_fx,$stfc,$hostc,$iplc,$intc,$ipdestc,$rtt_statusc,$hostbc,$intbc){

$link_c="";


$teste_info=split(" ",$rtt_statusc);



if ($stfc=="crc"){

$tp="crc";
$lim_amarelo=300;

}

if ($stfc=="errors"){

$tp="errors";
$lim_amarelo=300;

}

if ($stfc=="int resets"){
$tp="resets";
$lim_amarelo=2;

}

$img_err0="nostatus.png";
$img_err1="nostatus.png";

if ($teste_info[0]==""){

#echo "aqui";
$img_err0="nostatus.png";

}

if ($teste_info[0]==-1){

#echo "aqui";
$img_err0="nostatus.png";

}

if ($teste_info[0]==0){

#echo "aqui";
$img_err0="ok.png";

}

if ($teste_info[0]>0){

#echo "aqui";
$img_err0="loss11.png";

}

if ($teste_info[0]>$lim_amarelo){

$img_err0="falha.png";

}

if ($teste_info[1]==""){

#echo "aqui";
$img_err1="nostatus.png";

}

if ($teste_info[1]==-1){

#echo "aqui";
$img_err1="nostatus.png";

}

if ($teste_info[1]==0){

#echo "aqui";
$img_err1="ok.png";

}

if ($teste_info[1]>0){

#echo "aqui";
$img_err1="loss11.png";

}

if ($teste_info[1]>$lim_amarelo){

$img_err1="falha.png";

}



$link_c="<a href='http://10.98.22.18/fping4.0/grafico_int.php";
$link_c=$link_c."?ahost=$hostc-$intc-$iplc-$cod_fx-$stfc&rhost=$hostc-$intc-$iplc-$hostbc-$intbc-$ipdestc&tip=$tp' target='_blank'>";
$link_c=$link_c."<img border='0' src='http://10.98.22.11/fping4.0/icones/$img_err0' width='18' height='18' title='$hostc $intc $stfc: $teste_info[0]\nclique para ver o grafico de $stfc'>";
$link_c=$link_c."<br><img border='0' src='http://10.98.22.11/fping4.0/icones/$img_err1' width='18' height='18' title='$hostbc-$intbc $stfc: $teste_info[1]\nclique para ver o grafico de $stfc'>";
$link_c=$link_c."</a>";

    return $link_c;


}

###############
	?>

