#!/usr/bin/perl

use DBI();
require "/fping4.0/db/dbinc.pl";

my $dbh = DBI->connect
("DBI:mysql:database=$database;host=$host","$usuario", "$senha",
{'RaiseError' => 1});


#cod,cod_fping,cod_iris,igxa,igxa_porta,igxb,igxb_portb,origem,hostname,interface,ip,mfr_a,housing_a,hostname_remoto,interface_remoto,ip_remoto,mfr_b,housing_b,descricao,servico,envia_email,user_up,data_up,user_inc,obs,endereco_b,endereco_a,vel,designacao_link,designacao_link_b,tipo_link,operadora,operadora_b,cli,ativo,data_alm,st_alm,site,site_b,uf,uf_b,data_inc,atualizado_por,ip_loopback_host,ip_loopback_host_b,ipdest,ipdest_b,ipdest_hex,ipdest_hex_b,id_int,pings,tam_pct,lim_rtt_avg,lim_rtt_max,lim_descartes,ping_snmp,atualizar_snmp_ping,fping,rtt,mnemo_hostname,mnemo_hostname_remoto,id_int_b,e1_a,e1_b



$sql="select cod,cod_fping,cod_iris,igxa,igxa_porta,igxb,igxb_portb,origem,";
$sql=$sql."hostname,interface,ip,mfr_a,housing_a,hostname_remoto,interface_remoto,";
$sql=$sql."ip_remoto,mfr_b,housing_b,descricao,servico,envia_email,user_up,data_up,";
$sql=$sql."user_inc,obs,endereco_b,endereco_a,vel,designacao_link,designacao_link_b,";
$sql=$sql."tipo_link,operadora,operadora_b,cli,ativo,data_alm,st_alm,site,site_b,uf,uf_b,";
$sql=$sql."data_inc,atualizado_por,ip_loopback_host,ip_loopback_host_b,ipdest,ipdest_b,";
$sql=$sql."ipdest_hex,ipdest_hex_b,id_int,pings,tam_pct,lim_rtt_avg,lim_rtt_max,lim_descartes,";
$sql=$sql."ping_snmp,atualizar_snmp_ping,fping,rtt,mnemo_hostname,mnemo_hostname_remoto,id_int_b,e1_a,e1_b,";
$sql=$sql."vrf,nsr";
$sql=$sql." from devices where left(ativo,1) in ('1') and left(fping,1) in ('2','3')";


#print "$sql\n";
%ambiente_a=();
%ambiente_b=();

%snmp_a=();
%snmp_b=();
%hosts=();
%hosts_ebt=();
%hosts_ebt_int=();

%rtt_hosts=();
%rtt_man_hosts=();

%rtt=();
%rtt_man=();

###lista de hosts para receber snmpwalk
%hostname_walk=();
%host_ip_loop=();

   $stf = $dbh->prepare("$sql");
   $stf->execute();

   if ($stf->rows==0){

#print "nao entrou\!$sql\n";
   }
   else{

open(lger,">/fping4.0/lista_geral/geral.txt");

      while(($cod,$cod_fping,$cod_iris,$igxa,$igxa_porta,$igxb,$igxb_portb,$origem,$hostname,$interface,$ip,$mfr_a,$housing_a,$hostname_remoto,$interface_remoto,$ip_remoto,$mfr_b,$housing_b,$descricao,$servico,$envia_email,$user_up,$data_up,$user_inc,$obs,$endereco_b,$endereco_a,$vel,$designacao_link,$designacao_link_b,$tipo_link,$operadora,$operadora_b,$cli,$ativo,$data_alm,$st_alm,$site,$site_b,$uf,$uf_b,$data_inc,$atualizado_por,$ip_loopback_host,$ip_loopback_host_b,$ipdest,$ipdest_b,$ipdest_hex,$ipdest_hex_b,$id_int,$pings,$tam_pct,$lim_rtt_avg,$lim_rtt_max,$lim_descartes,$ping_snmp,$atualizar_snmp_ping,$fping,$rtt,$mnemo_hostname,$mnemo_hostname_remoto,$id_int_b,$e1_a,$e1_b,$vrf,$nsr) = $stf->fetchrow_array) {

     $hostname=~s/#//g;
     $hostname=~s/-/\./g;
     $hostname=~s/_/\./g;
     $hostname_remoto=~s/#//g;
     $hostname_remoto=~s/-/\./g;
     $hostname_remoto=~s/_/\./g;

print lger "$cod;$cod_fping;$cod_iris;$igxa;$igxa_porta;$igxb;$igxb_portb;$origem;$hostname;$interface;$ip;$mfr_a;$housing_a;$hostname_remoto;$interface_remoto;$ip_remoto;$mfr_b;$housing_b;$descricao;$servico;$envia_email;$user_up;$data_up;$user_inc;$obs;$endereco_b;$endereco_a;$vel;$designacao_link;$designacao_link_b;$tipo_link;$operadora;$operadora_b;$cli;$ativo;$data_alm;$st_alm;$site;$site_b;$uf;$uf_b;$data_inc;$atualizado_por;$ip_loopback_host;$ip_loopback_host_b;$ipdest;$ipdest_b;$ipdest_hex;$ipdest_hex_b;$id_int;$pings;$tam_pct;$lim_rtt_avg;$lim_rtt_max;$lim_descartes;$ping_snmp;$atualizar_snmp_ping;$fping;$rtt;$mnemo_hostname;$mnemo_hostname_remoto;$id_int_b;$e1_a;$e1_b;$vrf;$nsr;\n";

         if ($cli=~/brad|unib|psys/){ 

         @ha=split(/\./,$hostname);
         @hb=split(/\./,$hostname_remoto);

         }
         else{

         @ha=split(/ /,$hostname);
         @hb=split(/ /,$hostname_remoto);
         }


         if ($cli=~/cqmri/){

            $ref=$ha[0]."_".$interface;

            $hosts_ebt_int{$ref}=$ha[0].";".$hostname.";".$interface.";".$ip.";".$hostname_remoto.";".$interface_remoto.";".$ip_remoto.";".$cod.";".$vrf.";".$nsr.";";

            $hosts_ebt{$ha[0]}=$ha[0];

         }


         if(lc($interface)=~/loo|vlan/ and $tipo_link=~/3-/){
 
            $rl=@ha[0]."-".@ha[2];
            $host_ip_loop{$rl}=$ip;         

         }
         #testa ipa


         $ipa="nao";

##################RTT

      if ($rtt eq 'rtt'){

         $rl=@ha[0]."-".@ha[2];
         $hostname_walk{$rl}=$hostname;

      $sleep=($lim_rtt_avg/1000)*($pings+($pings*0.3));

         if ($sleep<2){
      
            $sleep=2;
         }

         if (length($ipdest_hex)>5){

         #  $rh=
            $rtt_hosts{@ha[0]}=$hostname;
            $ref=@ha[0]."_".$interface."_".$cod;
            $tst="shown0cro $ip_loopback_host $ipdest $ipdest_hex $id_int $pings $tam_pct $hostname"."-".$lim_rtt_avg."-"."$lim_rtt_max"."-"."$lim_descartes $interface $sleep $cod;\n";
            $tst=~s/\n//g;
            $tst=~s/\r//g;

            $rtt{$ref}=$tst;
         }


         if (length($ipdest_hex_b)>5){

            $rl=@hb[0]."-".@hb[2];
            $hostname_walk{$rl}=$hostname_remoto;

            $rtt_hosts{@hb[0]}=$hostname_remoto;
            $ref=@hb[0]."_".$interface_remoto."_".$cod;
            $tst="shown0cro $ip_loopback_host_b $ipdest_b $ipdest_hex_b $id_int_b $pings $tam_pct $hostname_remoto"."-".$lim_rtt_avg."-"."$lim_rtt_max"."-"."$lim_descartes $interface_remoto $sleep $cod;\n";
            $tst=~s/\n//g;
            $tst=~s/\r//g;
            $rtt{$ref}=$tst;

         }

      }


      if ($rtt eq 'rtt man'){

         if ($sleep<2){

            $sleep=2;
         }

         if (length($ipdest_hex)>5){

            $rl=@ha[0]."-".@ha[2];
            $hostname_walk{$rl}=$hostname;
            $rtt_man_hosts{@ha[0]}=$hostname;
            $ref=@ha[0]."_".$interface."_".$cod;
            $tst="shown0cro $ip_loopback_host $ipdest $ipdest_hex $id_int $pings $tam_pct $hostname"."-".$lim_rtt_avg."-"."$lim_rtt_max"."-"."$lim_descartes $interface $sleep $cod;\n";
            $tst=~s/\n//g;
            $tst=~s/\r//g;

            $rtt_man{$ref}=$tst;
         }


         if (length($ipdest_hex_b)>5){

            $rl=@hb[0]."-".@hb[2];
            $hostname_walk{$rl}=$hostname_remoto;

            $rtt_man_hosts{@hb[0]}=$hostname_remoto;
            $ref=@hb[0]."_".$interface_remoto."_".$cod;
            $tst="shown0cro $ip_loopback_host_b $ipdest_b $ipdest_hex_b $id_int_b $pings $tam_pct $hostname_remoto"."-".$lim_rtt_avg."-"."$lim_rtt_max"."-"."$lim_descartes $interface_remoto $sleep $cod;\n";
            $tst=~s/\n//g;
            $tst=~s/\r//g;

            $rtt_man{$ref}=$tst;

         }



      }



##############RTT

         if ($ip=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/ and $fping=~/2-/){

            $ipa="sim";            

            if ($cli=~/cqmri/ and length($vrf)>2){


            }
            else{

               $amb=$cli."-".$ip;
               $ambiente_a{$amb}=$ip;
            }

         }   


        #testa ipb
        
        $ipb="nao";

          if ($ip_remoto=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/ and $fping=~/2-/){

            $ipb="sim";            

            if ($cli=~/cqmri/ and length($vrf)>2){


            }
            else{

               $amb=$cli."-".$ip_remoto;
               $ambiente_b{$amb}=$ip_remoto;

            }

         }   

###### se ipa=nao e ipb=nao ----> get snmp de interface


         if ($ipa eq 'nao' and $ipb eq 'nao'){

            ####coleta interfaces

            #a:
            if ($interface ne '-'){

               $ref=$hostname."_".$interface;

               $snmp_a{$ref}=$interface; 

               if (length(@ha[0])>2){

                  $hosts{@ha[0]}=@ha[2];
 
               }

            }
            #b:

            if ($interface_remoto ne '-'){

               $ref=$hostname_remoto."_".$interface_remoto;

               $snmp_b{$ref}=$interface_remoto; 

               if (length(@hb[0])>2){

                  $hosts{@hb[0]}=@hb[2];
 
               }
            }
  
         }


#### se mfra =~ MFR ----> get seriais e controlers

         #mfra a

         if ($mfr_a=~/MFR/){

               $ref=$hostname."_".$interface;

               $snmp_a{$ref}=$interface; 

               if (length(@ha[0])>2){

                  $hosts{@ha[0]}=@ha[2];
 
               }

         $rl=@ha[0]."-".@ha[2];
         $hostname_walk{$rl}=$hostname;

         $ver_mfra="y";
         }


         #mfra b

         if ($mfr_b=~/MFR/){

               $ref=$hostname_remoto."_".$interface_remoto;

               $snmp_b{$ref}=$interface_remoto; 
               if (length(@hb[0])>2){

                  $hosts{@hb[0]}=@hb[2];
 
               }
         $rl=@hb[0]."-".@hb[2];
         $hostname_walk{$rl}=$hostname_remoto;

         $ver_mfrb="y";
         }

####no ip A

        if ($ip=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/ and $fping=~/2-/ or $ver_mfra eq 'y'){ 

        

        } 
        else {

           if ($tipo_link=~/1-/ or $fping=~/3-/){

             $rl=@ha[0]."-".@ha[2];
             $hostname_walk{$rl}=$hostname;
             $ref=$hostname."_".$interface;
             $snmp_a{$ref}=$interface;

           }

        }

#### no ip B
        if ($ip_remoto=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/ and $fping=~/2-/ or $ver_mfrb eq 'y'){



        }
        else {

           if ($tipo_link=~/1-/ or $fping=~/3-/){

             $rl=@hb[0]."-".@hb[2];
             $hostname_walk{$rl}=$hostname_remoto;
             $ref=$hostname_remoto."_".$interface_remoto;
             $snmp_b{$ref}=$interface_remoto;

           }

        }


       $ver_mfra="n";
       $ver_mfrb="n";

####################################fim while
      }

   }
###fim if select

open(hint,">/fping4.0/lista_ip/hosts/host_interface.txt");
   $stf->finish();

close(lger);
###gera listas

%lista_ip=();

#############

$sql_l="select distinct cli as cli from devices where left(fping,1) in ('2') and left(ativo,1) in ('1')";

   $stf = $dbh->prepare("$sql_l");
   $stf->execute();

$dir_lista="/fping4.0/lista_ip/";

while(($ambiente) = $stf->fetchrow_array) {

$lista_ip{$ambiente}=$ambiente;

$arquivo=$dir_lista.$ambiente.".txt";

open($ambiente,">$arquivo");


}

   $stf->finish();

#| psys      |
#| unib      |
#| brad      |
#| ebtv      |
#| pabx      |
#| ATA       |
#| captura   |
#| corporate |
#| consorcio |
#+-----------+

######grava ip

###A:

foreach $item (keys(%ambiente_a)){

@dd=split(/-/,$item);

$ambi=@dd[0];

$ipa1=@dd[1];

print $ambi "$ipa1\n";

}

###B:

foreach $item (keys(%ambiente_b)){

@dd=split(/-/,$item);

$ambi=@dd[0];

$ipa1=@dd[1];

print $ambi "$ipa1\n";

}

####


#fecha arquivos

foreach $item (keys(%lista_ip)){

close($item);

}

#########

####final

%hosts_ip=();


foreach $hs (keys(%hosts)){

#$ints="Loopback0";

#print "$hs\n";

#  if ($hosts{$hs}=~/\.brad/){


#      $ints="Loopback100";


#   }

$p=".".$hosts{$hs};

$sql="select ip_loopback from controle_de_hosts where hostname like '%".$hs."%' and hostname like '%".$p."%' limit 1";


   $stf = $dbh->prepare("$sql");
   $stf->execute();

   if ($stf->rows==0){


   }
   else{


      while(($ipx) = $stf->fetchrow_array) {


         $hosts_ip{$hs}=$ipx;

      }


   }

   $stf->finish();

}


####abre arqivo de cada host

$dir_snmp="/fping4.0/lista_ip/lista_snmp/";

foreach $hx (keys(%hosts_ip)){

#nome do arquivo


   $ah=$dir_snmp.$hx."-".$hosts{$hx}.".txt";

#print "abre $hx || $ah \n";
   open($hx,">$ah");


}



# gera lista coleta snmp a

foreach $sn (keys(%snmp_a)){

@ddd=split(/_/,$sn);

#hostname
@hh=split(/\./,@ddd[0]);

#iploop host

$iphh=$hosts_ip{@hh[0]};
$saida=@hh[0];

if ($iphh=~/[0-9]{1,3}\./){
#print "$saida,@hh[0];$iphh;@ddd[1];\n";

print $saida "@hh[0];$iphh;@ddd[1];snmpa;\n";
}


print hint "@ddd[0];@ddd[1];snmpa;\n";
}


# gera lista coleta snmp b

foreach $sn (keys(%snmp_b)){

@ddd=split(/_/,$sn);

#hostname
@hh=split(/\./,@ddd[0]);

#iploop host

$iphh=$hosts_ip{@hh[0]};
$saida=@hh[0];

if ($iphh=~/[0-9]{1,3}\./){

#print $saida "@hh[0];$iphh;@ddd[1];\n";
print $saida "@hh[0];$iphh;@ddd[1];snmpb;\n";
}

print hint "@ddd[0];@ddd[1];snmpb;\n";
}
###########


####fecha arqivo de cada host


foreach $hx (keys(%hosts_ip)){


   close($hx);


}

###########

###arquivo RTT
####abre arqivo de cada host rtt

$dir_snmp="/fping4.0/lista_ip/lista_rtt/";

foreach $rttx (keys(%rtt_hosts)){

#nome do arquivo


   $ah=$dir_snmp.$rtt_hosts{$rttx}.".txt";

   open($rttx,">$ah");


}

##############

##

# gera lista coleta rtt

foreach $sn (keys(%rtt)){

@ddd=split(/_/,$sn);

#hostname
@hh=split(/\./,@ddd[0]);

$tp=length($rtt{$sn});

$saida=@hh[0];
#print "$saida ||| $tp\n";

if (length($saida>3)){

#print "$saida | $tp | $rtt{$sn}\n";
   print $saida "$rtt{$sn}\n";
}
print hint "@ddd[0];@ddd[1];rtt;\n";
}
##
#####fecha arquivos rtt


foreach $rttx (keys(%rtt_hosts)){

#nome do arquivo



   close($rttx);


}


####abre arqivo de cada host rtt man

$dir_snmp="/fping4.0/lista_ip/lista_rtt_man/";

foreach $rttx (keys(%rtt_man_hosts)){

#nome do arquivo


   $ah=$dir_snmp.$rtt_man_hosts{$rttx}.".txt";

   open($rttx,">$ah");


}


##

# gera lista coleta rtt man

foreach $sn (keys(%rtt_man)){

@ddd=split(/_/,$sn);

#hostname
@hh=split(/\./,@ddd[0]);

#iploop host

$saida=@hh[0];
print $saida "$rtt_man{$sn}\n";


print hint "@ddd[0];@ddd[1];rttm;\n";
}
##
##############




foreach $rttx (keys(%rtt_man_hosts)){

#nome do arquivo


   open($rttx);


}

###
####snmp walk

$arq_hosts="/fping4.0/lista_ip/hosts/hosts_snmpwalk.txt";
$arq_hosts_err="/fping4.0/lista_ip/hosts/hosts_ip_ne.txt";

open(snmpw,">$arq_hosts");
open(herr,">$arq_hosts_err");

foreach $hx (keys(%hostname_walk)){

if (length($hx)>2){

}
else{

next;
}
#print "$hx\n";
$ipl=$host_ip_loop{$hx};
@info=split(/-/,$hx);
$ambiente=@info[1];

if ($ipl=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){



}
else{

#consulta
#print "$hostname_walk{$hx}\n";
   $sql="select ip_loopback from controle_de_hosts where hostname like '%".$hostname_walk{$hx}."%' and hostname like '%".$ambiente."%' limit 1";
   $stdv = $dbh->prepare("$sql");
   $stdv->execute();

   if ($stdv->rows==0){
 
#      print "nao manda email";
#      $ip_host{$device}=$device;
#      print "$hostname_walk{$hx} ; nao encontrado\n";

       $sql2="select ip_inf from controle_replaces where hostname like '%".$hostname_walk{$hx}."%' and hostname like '%".$ambiente."%' limit 1"; 

      $stdv2 = $dbh->prepare("$sql2");
      $stdv2->execute();

      if ($stdv2->rows==0){

#rint "$sql2\n";
         $ipl="ne";
      }
      else{

         while(($hostx2) = $stdv2->fetchrow_array) {

            $ipl=$hostx2;

         }

      }
   }
   else{

      while(($hostx) = $stdv->fetchrow_array) {

         $ipl=$hostx;

      }

   }


}
#$stdv->finish();

   if ($ipl ne 'ne'){
      print snmpw "$hostname_walk{$hx};$ipl;\n";
   }
   else{

      print herr "$hostname_walk{$hx};$ipl;\n";
   }
}

close(smpw);
close(hint);
####fim snmp walk
#i#ebt
####abre arqivo de cada host embratel

$dir_snmp="/fping4.0/routers_ebt/";

open(ebtg,">/fping4.0/routers_ebt/ebt_geral.txt");
open(hebt,">/cfg_ebt/lista/routers.txt");
open(hebt2,">/fping4.0/routers_ebt/routers.txt");

foreach $it (keys(%hosts_ebt)){

#nome do arquivo
   $ah=$dir_snmp.$it.".txt";
#print "abre $hx || $ah \n";
if (length($it)>2){
   open($it,">$ah");
   print hebt "$it\n";
}

}

close(hebt);

%host_lista=();
foreach $it (keys(%hosts_ebt_int)){


@dd=split(/;/,$hosts_ebt_int{$it});

$sai=$dd[0];
   if (length($sai)>1){

$pe=$dd[1];
$interface_a=$dd[2];
$ip_pe=$dd[3];
$host_remoto=$dd[4];
$serial_remoto=$dd[5];
$ip_remoto=$dd[6];
$cod=$dd[7];
$vrf=$dd[8];

if (length($vrf)>2){

$vrf="vrf ".$vrf;
}
else{

$vrf="";

}
$nsr=$dd[9];
$ser_arq=$interface_a;
$ser_arq=~s/\//_/g;
   if ($interface_a=~/[0-9]\.[0-9]$/){

      $int_cheia_pe="";

      @intc=split(/\./,$interface_a);

      $sub=pop(@intc);

      $nint="";
      $n=0;
      foreach $si (@intc){

         if ($n==0){

            $nint=$si;
         }
         else{

            $nint=$nint.".".$si;

         }
            $n++;
      }

      $int_cheia_pe=$nint;
   }
   else{

      $int_cheia_pe=$interface_a;

   }

      
      print $sai  "*$cod*$pe*$interface_a*$ip_pe*$host_remoto*$serial_remoto*$ip_remoto*$vrf*$int_cheia_pe*$ser_arq*\n";
      print hebt "$hosts_ebt_int{$it}\n";
      if (length($host_lista{$sai})<3 and length($sai)>3){
      print hebt2 "$dd[0]".".txt\n";
      $host_lista{$sai}=$sai;
      }  
   }
}

foreach $it (keys(%hosts_ebt)){


   close($it);


}

close(ebtg);
close(ebtg2);
xit
