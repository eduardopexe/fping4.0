#!/usr/bin/perl

#chama pacote DBI
use DBI();
use Shell;
# conexao com mysql noc idc

require "/fping4.0/db/dbinc.pl";


my $dbh = DBI->connect
("DBI:mysql:database=$database;host=$host","$usuario", "$senha",
{'RaiseError' => 1});

$regiaon=@ARGV[0];

$diretorio="/var/log/fping4.0/web/log_st/temp";
#$diretorio="/fping_mon/novo/web/log_st/rep";

# abro o diretório

opendir (MEUDIR, "$diretorio");

@pegoodir = readdir(MEUDIR);

closedir (MEUDIR);

# já peguei todos os dados e armazenei no vetor, fecho o diretório

#open (listal,">/fping_mon/novo/web/log_st/lista/lista.txt");

#open (lgoi,">log.txt");
#Antes do for de diretorio
   my $sh = Shell->new;

   foreach (@pegoodir) {

   $dados = $_; # como só existe uma coluna no vetor, utilizei o $_ para pegar esta coluna.


      if ($dados eq '.'){next}

      if ($dados eq '..'){next}

      if ($dados=~/$regiaon/){

      }
      else {

#print "$dados -- $regiaon !!!!!\n:  ";
         next;

      }


      open (log_fp,"$diretorio/$dados");

      @rtt=<log_fp>;

      close (log_fp);

#print "rm $diretorio/$dados\n";
      #remove o arquivo de log
      $sh->rm("$diretorio/$dados");
#       $sh->mv("$diretorio/$dados","/var/log/fping4.0/web/log_st/$dados");

      foreach $linha (@rtt){

         $linha=~s/\n//g;
         $linha=~s/\r//g;
#         $linha=~s/\\/_/g;
         $linha=~s/\"//g;
         $linha=~s/\'//g;
         @dados=split(/;/,$linha);

         # criar campos
         $descr=@dados[14];
         $cod_dev=@dados[8];

         #receber uf - no log [28]
         #rtt alm - y - para alarmes de rtt | loss com status anterior verde,
         #n para status anterior vermelho [29]
         ###########
         $tipo_link=@dados[21];

         $tl=@dados[0];
         $dtl=@dados[1];

         $ipl=@dados[2];

         $ip_remotol=@dados[9];

         $hostnamel=@dados[10];
         $interfacel=@dados[11];

         $hostname_remotol=@dados[12];
         $interface_remotol=@dados[13];

         $lossl="0";
         $minl="0";
         $avgl="0";
         $maxl="0";
         $stl=@dados[7];

         $tl_old=@dados[26];
         $stl_old=@dados[27];

         $envia_email=@dados[17];
         $vell=@dados[18];


         $rtt_liml="";
         $check_infol=@dados[22];
         $ufl=@dados[28];

         $tpoll="";
         $data_poll="";
         $regiao=$dados;
###############################
         $regiao=~s/log_//g;
         $regiao=~s/\.txt//g;

#print "$linha -- \n $hostnamel , $interfacel -- $hostname_remotol , $interface_remotol $tipo_link\n";
         ($seg,$min,$hora,$dia_m,$mes,$ano,$dia_s,$dia_a,$isdst)=localtime(time());

         $anos=1900 + $ano;
         $mess=$mes+1;

         $data_reg=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$anos,$mess,$dia_m,$hora,$min,$seg);


$sqa="";

        @hi=split(//,$hostname);
        $site_a=@hi[1];
        $site_b=@hi[2];

         if ($stl eq 'falha'){


            $sqa="i";

            $rtt_alml="falha";

         }

         if ($stl eq 'ok'){


            $sqa="u";

         }

         if ($stl=~/rtt|loss/ and $stl_old ne 'falha'){

            $sqa="i";
            $rtt_alml="$stl";

         }

         if ($stl=~/rtt|loss/ and $stl_old eq 'falha'){

            $sqa="u";

         }

         if ($sqa eq 'i'){

            ($seg,$min,$hora,$dia_m,$mes,$ano,$dia_s,$dia_a,$isdst)=localtime($tl);
            $anos=1900 + $ano;
            $mess=$mes+1;

            $data_falha=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$anos,$mess,$dia_m,$hora,$min,$seg);

            $sqll="insert into log_dev (time_stp,datal,ip,status,regiao,data_inc,data_falha,str,vel,rtt_alm,check_info,uf,ip_remoto,interface_remoto,hostname_remoto,hostname,interface,tipo_link,site_a,site_b,cod_dev,descr) VALUES ('$tl','$data_poll','$ipl','$stl','$regiaon','$data_reg','$data_falha','$stl','$vell','$rtt_alml','$check_infol','$ufl','$ip_remotol','$interface_remotol','$hostname_remotol','$hostnamel','$interfacel','$tipo_link','$site_a','$site_b','$cod_dev','$descr')";

         }

         if ($sqa eq 'u' and length($stl_old)>1){

         #print "entrou\n";
         ($seg,$min,$hora,$dia_m,$mes,$ano,$dia_s,$dia_a,$isdst)=localtime($tl);
         $anos=1900 + $ano;
         $mess=$mes+1;

         $data_ret=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$anos,$mess,$dia_m,$hora,$min,$seg);

         $ipl=~s/ //g;

 #        if (length($tl_old)>3){

         $tempo_falha=$tl-$tl_old;

 #i        }
         $stl=~s/\r//g;
         $stl=~s/\n//g;

        
         $sqll="update log_dev set data_retorno='$data_ret',t_stp_r='$tl',tempo_falha='$tempo_falha',str='$stl' where time_stp='$tl_old' and cod_dev='$cod_dev' and status='$stl_old'";


         }



print "\n################$sqa##$dados -i $linha \n $stl !! $stl_old -- $str\n i!!!!!!!! $sqll\n#####\n";
#
          if (length($sqll)>0 and length($cod_dev)>0){

#print "$dados - \n $sqll\n";
            $dbh->do("$sqll");
         }

         $sqll="";



      }


   }


exit;
