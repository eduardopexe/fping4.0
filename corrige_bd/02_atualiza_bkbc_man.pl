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


$sql="select hostname,interface,ip,servico,description from controle_interfaces where servico='BKBC_MAN'";

   $stf = $dbh->prepare("$sql");
   $stf->execute();

   if ($stf->rows==0){

print "nao entrou\n";

   }
   else{

      while (($hostname_ci,$interface_ci,$ip_ci,$servico_ci,$description_ci) = $stf->fetchrow_array){

         $sqlt1="select hostname,ip,interface,hostname_remoto,interface_remoto,ip_remoto";
         $sqlt1=$sqlt1." from devices where";
         $sqlt1=$sqlt1." hostname='$hostname_ci' and interface='$interface_ci'";
         $sqlt1=$sqlt1." or ";
         $sqlt1=$sqlt1." hostname_remoto='$hostname_ci' and interface_remoto='$interface_ci'";

         $st1 = $dbh->prepare("$sqlt1");
         $st1->execute();

         if ($st1->rows==0){

            print "nao entrou\n";

            $sqlt2="select hostname,ip,interface,hostname_remoto,interface_remoto,ip_remoto";
            $sqlt2=$sqlt2." from devices where";
            $sqlt2=$sqlt2." hostname='$hostname_ci' and interface like '%$interface_ci%'";
            $sqlt2=$sqlt2." or ";
            $sqlt2=$sqlt2." hostname_remoto='$hostname_ci' and interface_remoto like '%$interface_ci%'";

            $st2 = $dbh->prepare("$sqlt2");
            $st2->execute();

            $st2 = $dbh->prepare("$sqlt2");
            $st2->execute();

            if ($st2->rows==0){

               print "nao encontrou de novo - $hostname_ci,$interface_ci,$ip_ci,$servico_ci,$description_ci\n";

            }

         }
         else{

            next;

         }

      }

      
   }

$stf->finish();

exit
