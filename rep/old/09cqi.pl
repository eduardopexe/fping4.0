#!/usr/local/bin/perl

use DBI();
require "/fping4.0/db/dbinc.pl";

my $dbh = DBI->connect
("DBI:mysql:database=$database;host=$host","$usuario", "$senha",
{'RaiseError' => 1});

$arq="09cqmri_lista.txt";

$dir="/fping4.0/rep";


open(cqi,"$dir/$arq");

@dados=<cqi>;


close(cqi);

$tem_nsr="n";
$tem_router="n";

foreach $it (@dados){

   $it=~s/\n//g;
   $it=~s/\r//g;
   $it=~s/\t/#/g;

#print "$it \n";
   @dd=split(/#/,$it);

   if ($it=~/NSR|nsr/ or $it=~/[A-Za-z0-9]{2,10}\/[A-Za-z0-9]{2,10}\/[A-Za-z0-9]{2,10}\//){

      $nome_cliente=$dd[0];
      $desig=$dd[1];
      @nsrx=split(/NSR /,$dd[2]);   

      $nsr=$nsrx[1];
   }

   if ($it=~/Router\/Port:|Cir/){

      if($dd[1]=~/acc|ACC/){

         $cnx=lc($dd[1]);

         @cx=split(/ /,$cnx);

         foreach $ln (@cx){

            if ($ln=~/acc[0-9]{2,3}\./){

               $hostname_a=$ln;
            }          

            if ($ln=~/[0-9]{1,3}\/[0-9]{1,3}/){


                $interface_a=$ln;
                $interface_a=~s/[A-Za-z]//g;
            }

         }

      }  

      if ($dd[3]=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){

         @ip=split(/\./,$dd[3]);
       
         $ipa=int($ip[0]);
         $ipb=int($ip[1]);
         $ipc=int($ip[2]);
         $ipd=int($ip[3]);

         if ($ipd%2==0){

             $ipl=$ipd-1;
             $ip_local=$ipa.".".$ipb.".".$ipc.".".$ipl;
             $ip_remoto=$ipa.".".$ipb.".".$ipc.".".$ipd;

         }
         else{

            $ipl=$ip+1;
            $ip_local=$ipa.".".$ipb.".".$ipc.".".$ipl;
            $ip_remoto=$ipa.".".$ipb.".".$ipc.".".$ipd;
         }

      }   

      $local=$dd[4];

      if ($nome_cliente=~/CIAC|Ciac|ciac/){

         $tipo="CIAC";

      }
      else{

         $tipo="";

      }

      $nome_cliente=~s/ - Atendimento (CIAC|Ciac|ciac)//g;

#      print "$nome_cliente;$tipo;$desig;$nsr;$hostname_a;$interface_a;$ip_local;$hostname_b;$interface_b;$ip_remoto;$local;\n";

      $sql1="select vrf,velocidade,desig1,hostname,interface,cli,ip from controle_interfaces_ebt where ip='$ip_local'";

####

   $stf = $dbh->prepare("$sql1");
   $stf->execute();

   if ($stf->rows==0){

print "nao entrou----\n";
      $fping="9-nao encontrado";
      $ativo="0-nao encontrado";
      print "nao encontrado;$nome_cliente;$tipo;$desig;$nsr;$hostname_a;$interface_a;$ip_local;$hostname_b;$interface_b;$ip_remoto;$local;\n";
   }
   else{

print "entrou\n!!!!!";
      $fping="2-FPING"; 
      $ativo='1-ativo';
 
      while(($vrfx,$velocidadex,$desig1x,$hostnamex,$interfacex,$clix,$ipx) = $stf->fetchrow_array) {


         if (length($clix)>2){

            $nome_cliente=$clix;
 
         }

         $vrf=$vrfx;
         $velocidade=$velocidadex;
         $servico=$clix;

         if (length($designacao_link)<2){

            $designacao_link=$desig1x;

         }          

         $hostname_a=$hostnamex;
         $interface_a=$interfacex;
         
      }

      @dx=split(/\//,$designacao_link); 

      $desx="";

      foreach $dxi (@dx){

         if ($dxi=~/[A-Za-z0-9]{2,20}/){

            $desx=$dxi;          

         }

      }

      $hostname_b=$servico."_".$desx;
      $interface_b="Serial_".$desx;
      $stf->finish();

    }

####

#     $hostname_b=$nsr;
#     $interface_a="Serial".$interface_a;

      $sql="insert into devices";
      $sql=$sql." (hostname,interface,ip,hostname_remoto,interface_remoto,ip_remoto,cli,descricao,designacao_link,operadora,servico,fping,ativo,nome_cliente,nsr,vrf) values";      
      $sql=$sql." ('$hostname_a','$interface_a','$ip_local','$hostname_b','$interface_b','$ip_remoto','cqmri','$nome_cliente | $local $tipo','$desig','Embratel','$servico','$fping','$ativo','$nome_cliente','$nsr','$vrf')";

print "$sql\n";
     $dbh->do($sql);

   }


}


exit
