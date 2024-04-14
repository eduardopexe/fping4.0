#!/usr/bin/perl

use DBI();
require "/fping4.0/db/dbinc.pl";

my $dbh = DBI->connect
("DBI:mysql:database=$database;host=$host","$usuario", "$senha",
{'RaiseError' => 1});


$sql="select cod,trim(hostname),trim(interface),trim(hostname_remoto),trim(interface_remoto),ip,ip_remoto,mfr_a,mfr_b from devices";
$sql=$sql." where mfr_a like '%mfr%' or mfr_b like '%mfr%'";

#print "$sql \n";

   $stf = $dbh->prepare("$sql");
   $stf->execute();

   if ($stf->rows==0){

print "nao entrou\n";

   }
   else{

      while (($cod,$hostname,$interface,$hostname_remoto,$interface_remoto,$ip,$ip_remoto,$mfr_a,$mfr_b) = $stf->fetchrow_array){

         if ($interface=~/[0-9]\.[0-9]/){

         @int=split(/\./,$interface);

         $interface=@int[0];
         }

         if ($interface_remoto=~/[0-9]\.[0-9]/){

         @int=split(/\./,$interface_remot);

         $interface_remoto=@int[0];
         }

#teste A
         if ($interface=~/Serial|ATM|serial|atm/){

   #print "proximo";
   #          next;

#############teste a por ip

            $sql_u="";
            $sqla="select hostname,interface,ip,mfr from controle_interfaces where hostname like '%$hostname%' and interface='$interface' and mfr like '%$mfr_a%'";
            $stfa = $dbh->prepare("$sqla");
            $stfa->execute();

            if ($stfa->rows==0){

               $sql_u="update devices set mfr_a='' where cod='$cod'";
               print "$sqla\n$sql_u\n";
               $dbh->do($sql_u);
            }
            else{

            }      

#######################fim update a

         }
         else{


            next;

         }
#####fim teste A

#B

##### update b

         if ($interface_remoto=~/Serial|ATM|serial|atm/){

   #print "proximo";
   #          next;

            $sql_u="";
            $sqlb="select hostname,interface,ip,mfr from controle_interfaces where hostname like '%$hostname_remoto%' and interface='$interface_remoto' and mfr like '%$mfr_b%'";
            $stfb = $dbh->prepare("$sqlb");
            $stfb->execute();

            if ($stfb->rows==0){

            print "nao entrou\n$sqlb\n";
               $sql_u="update devices set mfr_b='' where cod='$cod'";
               print "$sql_u\n";
               $dbh->do($sql_u);
            }
            else{

            }   


         }
         else{

            next;

        }   
##### fim update b

#fim B


      }
   }


exit
