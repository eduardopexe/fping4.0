#!/usr/bin/perl

use DBI();
require "/fping4.0/db/dbinc.pl";


my $dbh = DBI->connect
("DBI:mysql:database=$database;host=$host","$usuario", "$senha",
{'RaiseError' => 1});


#$sql="select cod,trim(hostname),trim(interface),trim(hostname_remoto),trim(interface_remoto),ip,ip_remoto,mfr_a,mfr_b from devices";
#$sql=$sql." where mfr_a like '%mfr%' or mfr_b like '%mfr%'";


$sql="select cod,hostname,ip,interface,hostname_remoto,interface_remoto,ip_remoto from devices where left(ativo,1) in ('1') and left(fping,1) in ('2','3') and left(hostname,3) not in ('swc','swb','mb_','swm')";

   $stf = $dbh->prepare("$sql");
   $stf->execute();

   if ($stf->rows==0){

print "nao entrou\n";

   }
   else{

      while (($cod,$hostname,$ip,$interface,$hostname_remoto,$interface_remoto,$ip_remoto) = $stf->fetchrow_array){

#print "$cod,$hostname,$ip,$interface,$hostname_remoto,$interface_remoto,$ip_remoto\n";

         if ($ip=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){

         $sqlt1="select hostname,ip,interface";
         $sqlt1=$sqlt1." from controle_interfaces where";
         $sqlt1=$sqlt1." hostname like '$hostname' and ip='$ip' and left(interface,3) not in ('MFR','con') limit 1";

         $st1 = $dbh->prepare("$sqlt1");
         $st1->execute();

         $teste1="ok";
         $teste2="ok";

#print "$sqlt1\n";
         if ($st1->rows==0){

#            print "nao encontrou 1: $hostname; $interface ; $ip\n";

            $teste1="erro a";

         }
         else{

            while (($host_ci,$ip_ci,$int_ci) = $st1->fetchrow_array){  

#               print "!! teste $hostname eq $host_ci and $interface eq $int_ci\n";
               if ($hostname eq $host_ci and $interface eq $int_ci){

                  $atu1="nao";
#                  print " nao atualiza --- ";
               }
               else{


                  @inf=split(/\./,$hostname);

                  $cli=$inf[2];

                  if (length($cli)>2){

                     $sq_cli="cli='$cli',";

                  }
                  else{

                     $sq_cli="";

                  }

                  $sqlu1="update devices set ";
                  $sqlu1=$sqlu1.$sq_cli;
                  $sqlu1=$sqlu1."hostname='$host_ci',interface='$int_ci'";
                  $sqlu1=$sqlu1." where cod='$cod'";


                  print "antigo : $hostname - $interface $ip --- ";
                  print "$sqlu1\n";

                  $dbh->do("$sqlu1");
               }       

            }


         }

         $st1->finish();

         }
###
#################verifica hostname remoto

         if (length($hostname_remoto)>3 and $ip_remoto=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){

         $sqlt2="select hostname,ip,interface";
         $sqlt2=$sqlt2." from controle_interfaces where";
         $sqlt2=$sqlt2." hostname like '$hostname_remoto' and ip='$ip_remoto'  and left(interface,3) not in ('MFR','con') limit 1";

         $st2 = $dbh->prepare("$sqlt2");
         $st2->execute();

         $teste1="ok";
         $teste2="ok";

         if ($st2->rows==0){

#            print "#nao encontrou 2: $hostname_remoto; $interface_remoto ; $ip_remoto\n";

            $teste1="erro a";

         }
         else{

            while (($host_ci2,$ip_ci2,$int_ci2) = $st2->fetchrow_array){  

               if ($hostname_remoto eq $host_ci2 and $interface_remoto eq $int_ci2){

                  $atu1="nao";

               }
               else{


#                  @inf=split(/\./,$hostname);

#                  $cli=$inf[2];

#                  if (length($cli)>2){

#                     $sq_cli="cli='$cli',";

#                  }
#                  else{

#                     $sq_cli="cli='$cli',";

#                  }

                  $sqlu2="update devices set ";
                  $sqlu2=$sqlu2."hostname_remoto='$host_ci2',interface_remoto='$int_ci2'";
                  $sqlu2=$sqlu2." where cod='$cod'";

                  print "antigo: $hostname_remoto - $interface_remoto $ip_remoto --- ";
                  print "$sqlu2\n";

                  $dbh->do("$sqlu2");
               }       

            }


         }

         $st2->finish();
###

         }
         
      }

   }

#$stf->finish();
exit
