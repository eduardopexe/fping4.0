#!/usr/bin/perl

use Shell;

open(fp_m,"/fping4.0/lista_geral/chk_geral.txt");
@metrica=<fp_m>;
close(fp_m);

%fping_mttrx = ();

   foreach $mttr (@metrica){

      $mttr=~s/\n//g;
      $mttr=~s/\r//g;

      @dados_mttr=split(/;/,$mttr);

      $fping_mttrx{@dados_mttr[0]} = @dados_mttr[1];


   }

$diretorio="/fping4.0/web/bd/check_list";

# abro o diretóri

opendir (MEUDIR, "$diretorio");

@pegoodir = readdir(MEUDIR);

closedir (MEUDIR);


   foreach (@pegoodir) {

      $dados = $_; # como só existe uma coluna no vetor, utilizei o $_ para pegar esta coluna.


      if ($dados eq '.'){next}

      if ($dados eq '..'){next}

      $dados2=$dados;
      $dados2=~s/\.txt//g;

      @cinfo=split(/_/,$dados2);
      @chko=split(/;/,$fping_mttrx{@cinfo[1]});
#print "@cinfo[1] --- @cinfo[0]\n";
      $fping_mttrx{@cinfo[1]}=@cinfo[0];
      rm("$diretorio/$dados");
#print "$diretorio/$dados \n";
   }

##ambientes - verifica se existe alarme para check senao limpa

$ambientes="/fping4.0/ambientes/lista_ambientes.txt";

open(amb,"$ambientes");

@ambs=<amb>;

close(amb);

%tempo_alarme=();

foreach $ita (@ambs){

@inf=split(/:/,$ita);

$dir_i=$inf[0];

$res_i="/fping4.0/web/resultado/".$dir_i."/res_".$dir_i.".txt";

#print "$res_i\n";
open(resi,"$res_i");

@alm=<resi>;

close(resi);

   foreach $alx (@alm){

      @ddalm=split(/;/,$alx);
#print "$ddalm[7] - $ddalm[8]:\n";
      if ($ddalm[7]=~/falha|loss|lat|rtt|crit|cpu|int errors|trafego/){

#         print "$ddalm[8] --- $ddalm[7] \n";
         $tempo_alarme{$ddalm[8]}=$ddalm[0];
      }
   }

}


###fim carrega alarmes

open(fpc,">/fping4.0/lista_geral/chk_geral.txt");

foreach $item (keys(%fping_mttrx)){

   if ($item=~/[0-9]{1,33}/ and $fping_mttrx{$item}>0){

      if ($tempo_alarme{$item}>0){

         print fpc "$item;$fping_mttrx{$item};sim;\n";

      }
      else{

#         print fpc "$item;$fping_mttrx{$item};nao;\n";

      }
   }
}

close(fpc);

#exit

