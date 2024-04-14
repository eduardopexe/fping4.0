#!/usr/bin/perl

use DBI();
require "/fping4.0/db/dbinc.pl";

my $dbh = DBI->connect
("DBI:mysql:database=$database;host=$host","$usuario", "$senha",
{'RaiseError' => 1});


$sql="select cod,hostname,interface,hostname_remoto,interface_remoto,ip,ip_remoto from devices";
#$sql=$sql." where left(tipo_link,1) in ('3','4') and length(hostname_remoto)>5";

#print "$sql \n";

   $stf = $dbh->prepare("$sql");
   $stf->execute();

   if ($stf->rows==0){

print "nao entrou\n";

   }
   else{

      while (($cod,$hostname,$interface,$hostname_remoto,$interface_remoto,$ip,$ip_remoto) = $stf->fetchrow_array){

#teste A
         if ($ip=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){

   #print "proximo";
   #          next;

#############teste a por ip

            $sql_u="";
            $sqla="select hostname,interface,ip,mfr from controle_interfaces where ip='$ip' and status not in ('shutdown') limit 1";
            $stfa = $dbh->prepare("$sqla");
            $stfa->execute();

            if ($stfa->rows==0){

            print "nao entrou\n$sqla\n";

            }
            else{

               while (($host,$int,$ipa) = $stfa->fetchrow_array){


                  if ($interface eq $int and $hostname eq $host){
                   

                  }
                  else{

                     $host_a=$host;
                     $int_a=$int;

                     if ($int=~/MFR/ and $interface=~/MFR/){

                     @hint=split(/\./,$int);

                     $sql_int="mfr_a='@hint[0]'";
                     $sql_int="interface='$int'";
                     }
                     else{
                     @hint=split(/\./,$int);

                     $sql_int="mfr_a='@hint[0]'";
                     }
                     @h=split(/\./,$host_a);

                     $sql_u="update devices set hostname='$host_a',".$sql_int.",";
                     $sql_u=$sql_u."site='@h[1]',mnemo_hostname='@h[0]',cli='@h[2]'";
                     $sql_u=$sql_u." where cod='$cod'";

                     $sql_int="";
                  }


               }

               if (length($sql_u)>5){

                  print "$sql_u\n";
                  $dbh->do($sql_u);

               }
            }      

#######################fim update a

         }
         else{


            next;

         }
#####fim teste A

#B

##### update b

         if ($ip_remoto=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){

   #print "proximo";
   #          next;

            $sql_u="";
            $sqlb="select hostname,interface,ip from controle_interfaces where ip='$ip_remoto' and status not in ('shutdown') limit 1";
            $stfb = $dbh->prepare("$sqlb");
            $stfb->execute();

            if ($stfb->rows==0){

            print "nao entrou\n$sqlb\n";

            }
            else{

               while (($host,$int,$ipa) = $stfb->fetchrow_array){


                  if ($interface_remoto eq $int and $hostname_remoto eq $host){
                   

                  }
                  else{

                     $host_b=$host;
                     $int_b=$int;

                     if ($int=~/MFR/ and $interface=~/MFR/){

                     $sql_intb="interface_remoto='$int'";
                     }
                     else{
                     @hint=split(/\./,$int);

                     $sql_intb="mfr_b='@hint[0]'";
                     }

                     @h=split(/\./,$host_b);

                     $sql_u="update devices set hostname_remoto='$host_b',".$sql_intb.",";
                     $sql_u=$sql_u."site_b='@h[1]',mnemo_hostname_remoto='@h[0]'";
                     $sql_u=$sql_u." where cod='$cod'";
                     $sql_intb="";
                  }


               }

               if (length($sql_u)>5){

                  print "$sql_u\n";
                  $dbh->do($sql_u);

               }
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
