#!/usr/bin/perl

use DBI();
require "/pexe/config.pl";

$database = "noc";
$host = "10.98.22.7";
$usuario = "noc";
$senha = "noc";

my $dbh = DBI->connect
("DBI:mysql:database=$database;host=$host","$usuario", "$senha",
{'RaiseError' => 1});


#$sql="select cod,trim(hostname),trim(interface),trim(hostname_remoto),trim(interface_remoto),ip,ip_remoto,mfr_a,mfr_b from devices";
#$sql=$sql." where mfr_a like '%mfr%' or mfr_b like '%mfr%'";

$squ="update devices set inf_cadastro='ok'";

$dbh->do("$squ");

$sql="select cod,hostname,ip,interface,hostname_remoto,interface_remoto,ip_remoto from devices where left(ativo,1) in ('1') and left(fping,1) in ('2','3','5')";
$sql=$sql." and cli not in ('TELMEX','unib','pabx','kpmg',";
$sql=$sql."'corporate','consorcio','captura','com','ATA',";
$sql=$sql."'igx','ebtv','cqmri','com')";

   $stf = $dbh->prepare("$sql");
   $stf->execute();

   if ($stf->rows==0){

#print "nao entrou\n";

   }
   else{

      while (($cod,$hostname,$ip,$interface,$hostname_remoto,$interface_remoto,$ip_remoto) = $stf->fetchrow_array){

         if (length($hostname)<3 or $hostname=~/^(acc|ACC)|internet|\.unib|95\.|noc|WIMAX|Internet|TACACS|dns|claro|Claro/){

            next;

         }
#         print "$cod,$hostname,$ip,$interface,#### $hostname_remoto,$interface_remoto,$ip_remoto\n";

         $sqlt1="select hostname,ip,interface";
         $sqlt1=$sqlt1." from controle_interfaces where";
         $sqlt1=$sqlt1." hostname='$hostname' and interface='$interface'";

         $st1 = $dbh->prepare("$sqlt1");
         $st1->execute();

         $teste1="ok";
         $teste2="ok";

#print "$sqlt1\n";
         if ($st1->rows==0){

#            print "nao entrou\n";

            $teste1="erro a";

         }
         else{

#            next;

         }

#################################
         if (length($hostname_remoto)<3 or $hostname_remoto=~/^(acc|ACC)|internet|\.unib|95\.|noc|WIMAX|Internet|TACACS|dns|claro|Claro/){

            next;

         }

         if (length($hostname_remoto)>3){

            $sqlt2="select hostname,ip,interface";
            $sqlt2=$sqlt2." from controle_interfaces where";
            $sqlt2=$sqlt2." hostname='$hostname_remoto' and interface='$interface_remoto'";
  
            $st2 = $dbh->prepare("$sqlt2");
            $st2->execute();
            $st2->execute();

#print "$sqlt2\n";

            if ($st2->rows==0){

               $teste2="erro b";
#print "$teste2\n";
            }

         }
#################################
#################################

         if ($teste1=~/erro/ or $teste2=~/erro/){

            $teste="erros: ".$teste1." ; ".$teste2;

            $sqlu="update devices set inf_cadastro='$teste' where cod='$cod'";

#            print "$sqlu\n";
         }
         else {

#print "ok ############ \n";
            $sqlu="update devices set inf_cadastro='ok' where cod='$cod'";

#            print "$sqlu\n";
         }

# print "$sqlu\n";
         $dbh->do("$sqlu");
      }

      
   }

$stf->finish();

exit
