#!/usr/bin/perl

use DBI();
require "/fping4.0/db/dbinc.pl";

my $dbh = DBI->connect
("DBI:mysql:database=$database;host=$host","$usuario", "$senha",
{'RaiseError' => 1});


$sql="select cod,hostname,interface,hostname_remoto,interface_remoto,ip,ip_remoto from devices";
$sql=$sql." where left(tipo_link,1) in ('3','4') and length(hostname_remoto)>5";

print "$sql \n";

   $stf = $dbh->prepare("$sql");
   $stf->execute();

   if ($stf->rows==0){

print "nao entrou";

   }
   else{

      while (($cod,$hostname,$interface,$hostname_remoto,$interface_remoto,$ip,$ip_remoto) = $stf->fetchrow_array){


      if ($interface=~/[0-9]\.[0-9]/ or $interface_remoto=~/[0-9]\.[0-9]/){

print "proximo";
         next;

      }

      @h=split(/\./,$hostname);

      $site=@h[1];
      $cli=@h[2];
      $mnemo_hostname=@h[0];
 
      $sql_u="update devices set hostname_remoto='-',interface_remoto='-',ip_remoto='-',site_b='-',mnemo_hostname_remoto='-' where cod='$cod'";


print "$cod\n";
      $sql_i="insert into devices (hostname,interface,ip,tipo_link,mnemo_hostname,site,cli) values ";
      $sql_i=$sql_i."('$hostname','$interface','$ip','3-interface logica','$mnemo_hostname','$site','$cli')";

      if (length($cod)>0){

print "$sql_i \n $sql_u\n";
         $dbh->do($sql_u);

         $dbh->do($sql_i);

      } 
   }
   }


exit
