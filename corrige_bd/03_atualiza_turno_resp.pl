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

open(tsite,"/fping4.0/corrige_bd/turno_site.txt");

@ts=<tsite>;

close(tsite);

%noc_turno_site=();

foreach $it (@ts){

  $it=~s/\n//g;
  $it=~s/\r//g;

  @dd=split(/;/,$it);

  $noc_turno_site{$dd[0]}=$dd[1];

}

###

$sql="select cod,hostname,hostname_remoto from devices where left(ativo,1) in ('1') and length(hostname)>3";

   $stf = $dbh->prepare("$sql");
   $stf->execute();

   if ($stf->rows==0){

print "nao entrou\n";

   }
   else{

      while (($cod,$hostname,$hostname_remoto) = $stf->fetchrow_array){


         if ($hostname=~/\./){

            @ha=split(/\./,$hostname);
 
            $site=lc($ha[1]);

            $resp_a=$noc_turno_site{$site};

            if ($hostname=~/^(acc|ACC|GACC|gacc)|Embratel|embratel/){


               $resp_a="ebt";
            }        

            if ($hostname=~/\.unib/){


               $resp_a="unib";
            }

            if (length($resp_a)>0){

               $sqla="update devices set turno_resp_a='$resp_a',site='$site' where cod='$cod'";

#               print "$sqla\n";
            }
            else{

               print "site nao encontrado $site - $hostname - $resp_a \n"

            }
            

         }

         if ($hostname_remoto=~/\./){

            @hb=split(/\./,$hostname_remoto);

            $site_b=lc($hb[1]);

            $resp_b=$noc_turno_site{$site_b};

            if ($hostname_remoto=~/\.unib/){


               $resp_b="unib";
            }

            if ($hostname_remoto=~/^(acc|ACC|GACC|gacc)|Embratel|embratel/){


              $resp_b="ebt";
            }


            if (length($resp_b)>0){

               $sqlb="update devices set turno_resp_b='$resp_b',site='$site_b' where cod='$cod'";

#               print "$sqlb\n";
            }
            else{


               print "site nao encontrado $site_b $hostname_remoto\n"

            }

            
         }

      }


   }

   $stf->finish();
exit
