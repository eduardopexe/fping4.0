#!/usr/bin/perl

use Shell;
        open(fp_m,"/fping4.0/lista_geral/geral.txt");
        @metrica=<fp_m>;
        close(fp_m);

        %fping_geral = ();


        ###hash geral fping

           foreach $mttr (@metrica){

              $mttr=~s/\n//g;
              $mttr=~s/\r//g;

              @dados_mttr=split(/;/,$mttr);
              @dados_mttr[0]=~s/\r//g;
              @dados_mttr[0]=~s/\n//g;
              @dados_mttr[0]=~s/ //g;

        #if ($mttr=~/14703;/){
        #print "---! $mttr !!!!\n";
        #}
        ###testa se ip � do mesmo ambiente campo cli
        #print "@dados_mttr[33]\n";

              $fping_geral{@dados_mttr[0]} = $mttr;

 
           }

$diretorio="/fping4.0/robo_ping/log";

# abro o diretório
opendir (MEUDIR, "$diretorio");
@pegoodir = readdir(MEUDIR);
closedir (MEUDIR);

$ok=0;
$rtt=0;
$falha=0;
$loss=0;

open(res,">/fping4.0/web/resultado/cqmri/res_cqmri.txt");

   foreach (@pegoodir) {

   $arquivo = $_; # como só existe uma coluna no vetor, utilizei o $_ para pega esta coluna.

      if ($arquivo eq '.') {next}

      if ($arquivo eq '..') {next}


      open (MEUFILE, "$diretorio/$arquivo");

      @minhas_linhas = <MEUFILE>;

      close (MEUFILE);


      foreach $item (@minhas_linhas) {


          @dd=split(/;/,$item);

          $t=$dd[0];
          $data_reg=$dd[1];
          $hostname_a=$dd[2];
          $inty=$dd[3];
          $cod=$dd[4];
          $tx=$dd[5];
          $data_regx=$dd[6];
          $status=$dd[7];
          $status_ping=$dd[8];
          $sent=$dd[9];
          $received=$dd[10];
          $min=$dd[11];
          $med=$dd[12];
          $max=$dd[13];
          $interface_fisica=$dd[14];
          $interface_logica=$dd[15];
          $int_status=$dd[16];
          $int_line_protocol_status=$dd[17];
          $sub_int_status=$dd[18];
          $sub_int_line_protocol_status=$dd[19];
          $int_crc=$dd[20];
          $int_input_errors=$dd[21];
          $int_out_errors=$dd[22];
          $int_load_rx=$dd[23];
          $int_load_tx=$dd[24];
          $int_collisions=$dd[25];
          $int_resets=$dd[26];
          $int_rely=$dd[27];
          $int_pkt_in=$dd[28];
          $int_pkt_out=$dd[29];
          $sub_int_load_rx=$dd[30];
          $sub_int_load_tx=$dd[31];
          $sub_int_rely=$dd[32];
          $inc_crc=$dd[33];
          $inc_err_in=$dd[34];
          $inc_err_out=$dd[35];
          $inc_collisions=$dd[36];
          $inc_resets=$dd[37];
          $telnet_st=$dd[38];
          $total_sent=$dd[39];
          $total_recebido=$dd[40];

   @dados_geral=split(/;/,$fping_geral{$cod});

   $host_a=@dados_geral[8];
   $int_a=@dados_geral[9];
   $host_b=@dados_geral[13];
   $int_b=@dados_geral[14];
   $descr=@dados_geral[18];
   $mfr_a=@dados_geral[11];
   $mfr_b=@dados_geral[16];
   $envia_email=@dados_geral[20];
   $vel=@dados_geral[27];
   $designacao=@dados_geral[28];
   $tipo_ll=@dados_geral[30];
   $operadora=@dados_geral[31];

   $iplocal=@dados_geral[10];
   $ip_loopback_host=@dados_geral[43];
   $ip_loopback_host_b=@dados_geral[44];

   if (@dados_geral[58]=~/rtt/){

      $teste_rtt_exec="y";
   }
   else{

      $teste_rtt_exec="n";
   }


   $rtt_limiar=@dados_geral[52];

   $tipo_link=substr(@dados_geral[30],0,2);

   $crc_a=$inc_crc;
   $int_resest_a=$inc_resets;

   $coll_a=$inc_collisions;

   $in_err_a=$inc_err_in;
   
   $out_err_a=$inc_err_out;

   $pct_utl_a=$int_load_tx;

   $pct_utl_b=$int_load_rx;

   $saida="$tx;$data_regx;$iplocal;$status_ping;$status_rtt;$status_loss;$status_fp_rtt;$status;$cod;"; 
   $saida=$saida."$ip_remoto;$host_a;$int_a;$host_b;$int_b;$descr;$mfr_a;$mfr_b;$envia_email;$vel;";
   $saida=$saida."$designacao;$tipo_ll;$sub_tipo;$check_info;$tcheck;$posx;$posy;$told;$status_oldx;";
   $saida=$saida."$uf;$status_snmp_get;$st_cpus;$st_cpu;$cpu_a;$cpu_b;$mem_proc_a;$mem_proc_b;$mem_io_a;";
   $saida=$saida."$mem_io_b;$operadora;$status_col_telnet;$lst_clear_a;$lst_clear_b;$pct_utl_a;";
   $saida=$saida."$pct_utl_b;$in_err_a;$in_err_b;$out_err_a;$out_err_b;$coll_a;$coll_b;$int_resest_a;";
   $saida=$saida."$int_resest_b;$drop_a;$drop_b;$crc_a;$crc_b;$ip_loopback_host;$ip_loopback_host_b;$inverte;\n";

   print res "$saida";

print "$host_a $int_a $status\n";
          if ($status=~/ok/){

             $ok++;

          }

          if ($status=~/falha/){

             $falha++;

          }

          if ($status=~/loss/){

             $loss++;

          }

          if ($status=~/rtt|lat/){

             $rtt++;

          }
          
last;
      }


   }

my        $t=time();

my        ($seg,$min,$hora,$dia_m,$mes,$ano,$dia_s,$dia_a,$isdst)=localtime($t);

my        $mess=$mes+1;

my        $anos=1900+$ano;

my        $data_reg=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$anos,$mess,$dia_m,$hora,$min,$seg);

close(res);
open(grl,">/fping4.0/web/resultado/cqmri/geral_web_cqmri.txt");


print grl "$t;$data_reg;$bkb_ok;$ok;-;;$loss;$rtt;;$falha$falha_bkb;$chk;$som;;";

close(grl);

my $sh = Shell->new;

$sh->scp("/fping4.0/web/resultado/cqmri/res_cqmri.txt","root\@10.98.22.213:/fping4.0/web/resultado/cqmri/res_cqmri.txt");

$sh->scp("/fping4.0/web/resultado/cqmri/geral_web_cqmri.txt","root\@10.98.22.213:/fping4.0/web/resultado/cqmri/geral_web_cqmri.txt");


exit
