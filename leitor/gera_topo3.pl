#!/usr/bin/perl

require "/fping4.0/db/dbinc.pl";
require "/fping4.0/leitor/chk_leitor.pl";

$cli=@ARGV[0];

$ex_link=@ARGV[1];

$tipo_mapa=@ARGV[2];

#abrir os resultados do fping e data para leitura
open (result, "/fping4.0/coleta/coleta_$cli.txt");

#resultado do fping atual
@minhas_linhas = <result>;

close (result);

print "/fping4.0/coleta/coleta_$cli.txt \n";
#### time da coleta e data da coleta

($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat("/fping4.0/coleta/coleta_$cli.txt");

($seg,$min,$hora,$dia_m,$mes,$ano,$dia_s,$dia_a,$isdst)=localtime($mtime);

$mess=$mes+1;

$anos=1900+$ano;

$data_reg=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$anos,$mess,$dia_m,$hora,$min,$seg);
$tc=$mtime;

#print "$tc | $data_reg \n";
#diretorio de log:::
$dir="/fping4.0/web/resultado/$cli";



#hash de metricas fping

#10.47.176.129;ce;BSB_10_47_176_129;1200;sat;-;sat;128;lote2;G-ECT-PBN-01- GO - vel: 128 <br> acesso: EMBRATEL;

open(fp_m,"/fping4.0/lista_geral/geral.txt");
@metrica=<fp_m>;
close(fp_m);

%fping_geral = ();
%fping_ip=();
%fping_host_int=();
%fping_mfr=();
%fping_teste=();

#####construir todos os hashs necessarios
# ipa-cli=cod
# ipb-cli=cod
# host-interface=cod
# host-interface_remtoo=cod
# host-mfr_a=cod
# host-mfr_b=cod

#hash pra topologia

#%devices_bkb=();
%devices=();
%devices_log=();


$raiob=100;
$total_bkb_fis=1;
$total_bkb_log=1;
$total_dev_fis=1;
$total_dev_log=1;

##############variaveis abaixo dependem do total de devices

$lin=1;
$xl=40;
$yl=50;

##inicio e fim de y

$xb=620;
$yb=350;
# inicio e fim x
$xli=20;
$xlf=1180;
$xlb=20;
$ylb=680;

############################

if ($cli=~/psys/){

$xli_bkb=20;
$yli_bkb=350;
$xli=20;
$yli=50;
$xlb=20;
$ylb=680;

}
else {

$xli_bkb=20;
$yli_bkb=50;

$xlf_bkb=20;
$ylf_bkb=100;
$xli=20;
$yli=250;
$xlb=20;
$ylb=680;

}


$total_dev=1;
$ctl=0;
$devices{"-"}="400,355";

#cod,cod_fping,cod_iris,igxa,igxa_porta,igxb,igxb_portb,origem,hostname,interface,ip,mfr_a,housing_a,hostname_remoto,interface_remoto,ip_remoto,mfr_b,housing_b,descricao,servico,envia_email,user_up,data_up,user_inc,obs,endereco_b,endereco_a,vel,designacao_link,designacao_link_b,tipo_link,operadora,operadora_b,cli,ativo,data_alm,st_alm,site,site_b,uf,uf_b,data_inc,atualizado_por,ip_loopback_host,ip_loopback_host_b,ipdest,ipdest_b,ipdest_hex,ipdest_hex_b,id_int,pings,tam_pct,lim_rtt_avg,lim_rtt_max,lim_descartes,ping_snmp,atualizar_snmp_ping,fping,rtt,mnemo_hostname,mnemo_hostname_remoto,id_int_b,e1_a,e1_b

# cod - 0
# cod_fping - 1
# cod_iris - 2
# igxa - 3
# igxa_porta - 4
# igxb - 5
# igxb_portb - 6
# origem - 7
# hostname - 8
# interface - 9
# ip - 10
# mfr_a - 11
# housing_a - 12
# hostname_remoto - 13
# interface_remoto - 14
# ip_remoto - 15
# mfr_b - 16
# housing_b - 17
# descricao - 18
# servico - 19
# envia_email - 20
# user_up - 21
# data_up - 22
# user_inc - 23
# obs - 24
# endereco_b - 25
# endereco_a - 26
# vel - 27
# designacao_link - 28
# designacao_link_b - 29
# tipo_link - 30
# operadora - 31
# operadora_b - 32
# cli - 33
# ativo - 34
# data_alm - 35
# st_alm - 36
# site - 37
# site_b - 38
# uf - 39
# uf_b - 40
# data_inc - 41
# atualizado_por - 42
# ip_loopback_host - 43
# ip_loopback_host_b - 44
# ipdest - 45
# ipdest_b - 46
# ipdest_hex - 47
# ipdest_hex_b - 48
# id_int - 49
# pings - 50
# tam_pct - 51
# lim_rtt_avg - 52
# lim_rtt_max - 53
# lim_descartes - 54
# ping_snmp - 55
# atualizar_snmp_ping - 56
# fping - 57
# rtt - 58
# mnemo_hostname - 59
# mnemo_hostname_remoto - 60
# id_int_b - 61
# e1_a - 62
# e1_b - 63

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
###testa se ip é do mesmo ambiente campo cli
#print "@dados_mttr[33]\n";

      if (lc(@dados_mttr[33])=~/$cli/){

         #posicao na tela###

         @ha=split(/\./,@dados_mttr[8]);
         @hb=split(/\./,@dados_mttr[13]);  

         #desenha apenas link fisico

         if (@dados_mttr[30]=~/$ex_link/){


            $mna=substr(@ha[0],0,2);
            $mnb=substr(@hb[0],0,2);

            ####host a define se eh bkb se eh bkb guarda em posicoes de bkb
###########posiciona no centro para psys

            if ($mna=~/mb|sw|rb/ and @dados_mttr[8]=~/psys/ ){

            ####posicao bkb a

               if ($total_bkb>6){


                  $raiob=$raiob+$raiob/2; 

                  $total_bkb=1;
               }


               if (length($devices{@ha[0]})<2){

                  if ($total_bkb==1){

                     $xn=$raiob;
                     $fatory=1;
                     $fatorx=1;
                  }

                  if ($total_bkb==2){

                     $xn=$raiob;
                     $fatory=-1;
                     $fatorx=1;
                  }

                  if ($total_bkb==3){

                     $xn=$raiob-$raiob*0.2;
                     $fatory=-1;
                     $fatorx=1;
                  }                   

                  if ($total_bkb==4){

                     $xn=$raiob-$raiob*0.2;
                     $fatory=-1;
                     $fatorx=-1;
                  }


                  if ($total_bkb==5){

                     $xn=$raiob-$raiob*0.2;
                     $fatory=1;
                     $fatorx=1;
                  }


                  if ($total_bkb==6){

                     $xn=$raiob-$raiob*0.2;
                     $fatory=1;
                     $fatorx=-1;
                  }

                  #equacao de circunferencia de raiob

                  $yn=sqrt($raiob*$raiob-$xn*$xn);

                  $xf=$xb+$fatorx*$xn;
                  $yf=$yb+$fatory*$yn;

                  $pos=$xf.",".$yf;

                  $devices{@ha[0]}=$pos;
print "@ha[0] --- $pos\n";                    
                  $total_bkb++;
               }

###########posiciona no centro para psys
            #### fim posicao bkb a

            }
            else{

               ###posiciona bkb no alto::::


               if ($cli=~/brad|unib/ and @dados_mttr[8]=~/rbave|rboco|rbcti|swcti|rbcau/ and length($devices{@ha[0]})<2){

                  $xli_bkb=80+$xli_bkb;

                  if ($xli_bkb>1180){

                   $xli_bkb=40;
                   $yli_bkb=$yli_bkb+65;

                  }

                  $pos=$xli_bkb.",".$yli_bkb;
                  $devices{@ha[0]}=$pos;                  
print "@ha[0] - $pos ; ####bkb#######\n";

               }
               else {

                  if ($ctl>10){

                     $ctl=1;
                  } 
 
                  if (length($devices{@ha[0]})<2){

                     $xl=80+$xl;

                     if ($xl>1180){

                           $xli=$xli+50;  
                           $yli=$yli+65;  
                           $yl=$yli;
                           $xl=$xli;

                        if ($yl<50){

                           
                           $yl=80;
                        }

                        if ($yl>680){

                           $yli=40;
                           $yl=40;  
                       }
                        $lin++;
                        $ctl++;
                     }

                     $pos=$xl.",".$yl;

                     print "@ha[0] - $pos ; ##############\n";
                     $devices{@ha[0]}=$pos;

#                    $lin++;

                  }

               }
            }
            #fim host a

           ####host b

            if ($mnb=~/mb|sw|rb/ and @dados_mttr[13]=~/psys/){

            ####posicao bkb b

               if ($total_bkb>6){


                  $raiob=$raiob+$raiob/2; 

                  $total_bkb=1;
               }


               if (length($devices{@hb[0]})<2){

                  if ($total_bkb==1){

                     $xn=0;
                     $fatory=1;
                     $fatorx=1;
                  }

                  if ($total_bkb==2){

                     $xn=0;
                     $fatory=-1;
                     $fatorx=1;
                  }

                  if ($total_bkb==3){

                     $xn=$raiob-$raiob*0.2;
                     $fatory=-1;
                     $fatorx=1;
                  }                   

                  if ($total_bkb==4){

                     $xn=$raiob-$raiob*0.2;
                     $fatory=-1;
                     $fatorx=-1;
                  }


                  if ($total_bkb==5){

                     $xn=$raiob-$raiob*0.2;
                     $fatory=1;
                     $fatorx=1;
                  }


                  if ($total_bkb==6){

                     $xn=$raiob-$raiob*0.2;
                     $fatory=1;
                     $fatorx=-1;
                  }

                  #equacao de circunferencia de raiob

                  $yn=sqrt($raiob*$raiob-$xn*$xn);

                  $xf=$xb+$fatorx*$xn;
                  $yf=$yb+$fatory*$yn;

                  $pos=$xf.",".$yf;

                  $devices{@hb[0]}=$pos;
                    
                  $total_bkb++;
               }

            #### fim posicao bkb a

            }
            else{

               ###posiciona bkb no alto::::


               if ($cli=~/brad|unib/ and @dados_mttr[13]=~/rbave|rboco|rbcti|swcti|rbcau/ and length($devices{@ha[0]})<2){


                  $xlf_bkb=80+$xlf_bkb;

                  if ($xlf_bkb>1180){

                   $xlf_bkb=40;
                   $ylf_bkb=$ylf_bkb+65;

                  }

                  $pos=$xlf_bkb.",".$ylf_bkb;
                  $devices{@hb[0]}=$pos;

                  print " @hb[0] -- $pos  !!bkb!!!\n";
               }
               else {
            
                  if (length($devices{@hb[0]})<2){

                     $xlb=$xlb+80;

                     if ($xlb>1180){

                        $xlb=40;
                        $ylb=$ylb-70;

                        $lin++;

                        if ($ylb<50){

                        $ylb=350;

                        } 

                     }

                     $pos=$xlb.",".$ylb;

                     $devices{@hb[0]}=$pos;
                    print "@hb[0] - $pos ;!!!!!!!!!!!!!!\n";

                  }

               }

            #fim host b

            #inicio host b

            #fim host b

            }

         }
### fim   desenha apenas link fisico

         $fping_geral{@dados_mttr[0]} = $mttr;
         $fping_teste{@dados_mttr[0]}="nao";

         ####testa ipa

         if (@dados_mttr[10]=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){

 
            $fping_ip{@dados_mttr[10]}=@dados_mttr[0];

            if (@dados_mttr[15]=~/172\.28\.126\./){

#               print "---!!! @dados_mttr[10] | @dados_mttr[0]\n";

            }

#            print "entrou  @dados_mttr[10] --- @dados_mttr[0]\n";

         }
         else{

#            print "nao entrou @dados_mttr[10] --- @dados_mttr[0]\n";

         }
         #ipb
         if (@dados_mttr[15]=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){

            if (@dados_mttr[15]=~/172\.28\.126\./){

#               print "---!!! @dados_mttr[15] | @dados_mttr[0]\n";

            }
            $fping_ip{@dados_mttr[15]}=@dados_mttr[0];
#print "entrou  @dados_mttr[15] --- @dados_mttr[0]\n";
         }
         else{

#            print "nao entrou @dados_mttr[15] ---- @dados_mttr[0]\n";

         }
         ###testa host interface
         #a: hostname interface

         if (length(@dados_mttr[8])>2 and length(@dados_mttr[9])>2){

           $ref=@dados_mttr[8]."_".@dados_mttr[9];

           $fping_host_int{$ref}=@dados_mttr[0];

         }

         #b: hostname_remoto interface_remoto

         if (length(@dados_mttr[13])>2 and length(@dados_mttr[14])>2){

           $ref=@dados_mttr[13]."_".@dados_mttr[14];

           $fping_host_int{$ref}=@dados_mttr[0];

         }

         #MFR

         #a: hostname - mfr_a

         if (length(@dados_mttr[8])>2 and length(@dados_mttr[11])>2){

           $ref=@dados_mttr[8]."_".@dados_mttr[11];

           $fping_mfr{$ref}=@dados_mttr[0];

         }

         #b hostname_remoto - mfr_b 

         if (length(@dados_mttr[13])>2 and length(@dados_mttr[16])>2){

           $ref=@dados_mttr[13]."_".@dados_mttr[16];

           $fping_mfr{$ref}=@dados_mttr[0];

         } 

      }
      # fim teste de ambiente

   }

### fim hash geral fping

#### abre hash rtt

%rtt_coleta=();

open(rttc,"/coleta_rtt/log_result/lista_geral.txt");

@rtt_linhas=<rttc>;

close(rttc);


$origem_rtt="rtt";

foreach $lin (@rtt_linhas){

   $lin=~s/\n//g;
   $lin=~s/\r//g;

   @dd_r=split(/;/,$lin);
   
#   if (@dd_r[15]=~/rtt|descarte|falha/){

      $rtt_coleta{@dd_r[5]}=$lin.";".$origem_rtt; 

#   }

}

#### fim hash rtt

#### abre hash rtt man


open(rttc,"/coleta_rttm/log_result/lista_geral.txt");

@rtt_linhas=<rttc>;

close(rttc);


$origem_rtt="rttm";

foreach $lin (@rtt_linhas){

   $lin=~s/\n//g;
   $lin=~s/\r//g;

   @dd_r=split(/;/,$lin);
   
#   if (@dd_r[15]=~/rtt|descarte|falha/){

      $rtt_coleta{@dd_r[5]}=$lin.";".$origem_rtt; 

#   }

}

### fim hash rtt man
#resultado do fping anterior loss

open (loss_old,"$dir/loss_$cli.txt");

@pkloss=<loss_old>;

close(loss_old);

%loss_old = ();

   foreach $ploss (@pkloss){

      $ploss=~s/\n//g;
      $ploss=~s/\r//g;

      @dados_loss_old=split(/;/,$ploss);


      #t;cod;ip;loss[1];......;loss[n];
         
      #ip-cod

      $ref_i=@dados_loss_old[2]."-".@dados_loss_old[1];

      $loss_hist="";

      $cl=0;
 
      #qtd de registros:

      #buffer = $buf - 3
 
      $buf=63;

      foreach $ll (@dados_loss_old){

         if ($cl>2){

            $loss_hist=$loss_hist.$ll.";";

         } 

         if ($cl<$buf){


         }

         if ($cl>$buf){

            last;
         }
         $cl++;

      }

      $loss_old{$ref_i} = $loss_hist;

   }

###############loss


###media


#resultado do fping anterior loss

open (fpr_old,"$dir/fping_rtt_media_$cli.txt");

@fpingrtt=<fpr_old>;

close(fpr_old);

%fpingrtt_old = ();

   foreach $rttfp (@fpingrtt){

      $rttfp=~s/\n//g;
      $rttfp=~s/\r//g;

      @dados_fpr_old=split(/;/,$rttfp);


      #t;cod;ip;avg[1];......;avg[n];
         
      #ip-cod

      $ref_i=@dados_fpr_old[2]."-".@dados_fpr_old[1];

      $avg_hist="";

      $cl=0;
 
      #qtd de registros:

      #buffer = $buf - 3
 
      $buf=63;

      foreach $ll (@dados_fpr_old){

         if ($cl>2){

            $avg_hist=$avg_hist.$ll.";";

         } 

         if ($cl<$buf){


         }

         if ($cl>$buf){

            last;  
         }  
         $cl++;

      }

#print "#$ref_i -- $avg_hist #\n";
if (length($avg_hist)>2){
      $fpingrtt_old{$ref_i} = $avg_hist;
}
   }

###############fim media
########
#resultado do fping anterior

open (fp_old,"$dir/res_$cli.txt");

@fp_old=<fp_old>;

close(fp_old);

%fping_old = ();

   foreach $st_old (@fp_old){

      $st_old=~s/\n//g;
      $st_oldr=~s/\r//g;

      @dados_st_old=split(/;/,$st_old);

      @dados_st_old[2]=~s/\r//g;
      @dados_st_old[2]=~s/\n//g;
      @dados_st_old[2]=~s/ //g;

      #grava hash no padrao: ip = linha de metrica
      #1240742205;Sun Apr 26 07:36:45 BRT 2009;10.47.176.129 ;100;.;.;.;vermelho;nocheck;
      #1240939305;Tue Apr 28 14:21:45 BRT 2009;10.70.196.1;0; 64.0;85.3;108;verde;;

      $fping_old{@dados_st_old[2]} = $st_old;

   }


####coleta resultado e armazena em hash

#### ip -- status;min;max;med;loss;$tc;$data_reg;

%fping_coleta=();

   foreach $rtt (@minhas_linhas){


      if ($rtt=~/=/ and $rtt=~/,/){

         #print "ok - $rtt";

         $rtt=~s/:/=/;
         $rtt=~s/,/\//;
         @result=split(/=/,$rtt);

         $ip=@result[0];

         @loss=split(/\//,@result[2]);

         $loss=@loss[0]-@loss[1];

         $qtde_enviado=@loss[0];

         @tempo=split(/\//,@result[3]);

         $min=@tempo[0];
         $avg=@tempo[1];
         $max=@tempo[2];

#############################3
         $ip=~s/ //g;

         $max=~s/ //;
         $max=~s/\n//;
         $max=~s/\r//;

         $loss=~s/%//;

         $status_ip="ok";



      }
      else{

         if ($rtt=~/=/){

         #print "nao ok - $rtt";

         $rtt=~s/:/=/;
         $rtt=~s/,/\//;
         @result=split(/=/,$rtt);

         $ip=@result[0];

         @loss=split(/\//,@result[2]);

#        $loss=@loss[2];

#       $loss=~s/\n//;
#        $loss=~s/\r//;

#        $loss=~s/%//;
         $loss=@loss[0]-@loss[1];

         $qtde_enviado=@loss[0];

         $ip=~s/ //;

         $status_ip="falha";

         $min=".";
         $max=".";
         $avg=".";

         }

      }

   ####fim daextracao guarda no hash

      $ip=~s/ //g;
      $ip=~s/\n//g;
      $ip=~s/\r//g; 

#### ip -- $status;$min;$max;$avg;$loss;$tc;$data_reg;

###fping_coleta=();
      $min =~ s/^\s*//g;
      $min =~ s/\s*$//g;

      if ($ip=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){   
      
         $fping_coleta{$ip}="$status_ip;$min;$max;$avg;$loss;$tc;$data_reg;$qtde_enviado;";

      }

   }

###contador resultado fpint

%total_teste=();


$total_teste{"ok_ll"}=0;
$total_teste{"ok_lf"}=0;
$total_teste{"ok_dev"}=0;

$total_teste{"falha_ll"}=0;
$total_teste{"falha_lf"}=0;
$total_teste{"falha_dev"}=0;

$total_teste{"rtt_ll"}=0;
$total_teste{"rtt_lf"}=0;
$total_teste{"rtt_dev"}=0;

$total_teste{"descarte_ll"}=0;
$total_teste{"descarte_lf"}=0;
$total_teste{"descarte_dev"}=0;


$total_teste{"loss_ll"}=0;
$total_teste{"loss_lf"}=0;
$total_teste{"loss_dev"}=0;


$total_teste{"lat_ll"}=0;
$total_teste{"lat_lf"}=0;
$total_teste{"lat_dev"}=0;
$total_teste{"chk"}=0;

%device_status=();

%fis_line_ok=();
%fis_line_falha=();
%fis_line_loss=();
%fis_line_rtt=();

###fim variaveis contador resultado fpint
#### abre arquivos para gravar resultados

###arquivo topologia fisica; finalmente!!!! :)
$arq_topo="topo_link_fis_".$cli."_".$tipo_mapa.".php";

open(topo,">/fping4.0/web/mapa/$arq_topo");

print topo "<html>\n";
print topo "<head>";
print topo "   <title>FPING 4.0 - NETWORK MAP - $dir - $arq_topo</title>\n";
print topo "<meta http-equiv=\"Cache-Control\" content=\"no-cache, no-store\" />\n";
print topo "<meta http-equiv=\"Refresh\" content=\"30\">\n";
print topo "<meta http-equiv=\"expires\" content=\"Mon, 06 Jan 1990 00:00:01 GMT\" />\n";
print topo "    <style type=\"text/css\">\n";
print topo "      canvas { border: 2px solid black; }\n";
print topo "    </style> ";

print topo "</head>\n";

print topo "<body>\n";

print topo "<canvas id=\"meucanvas\" width=\"1240\" height=\"700\" border=1>\n";
print topo "Este texto se mostra para os navegadores não compatíveis com canvas.\n";
print topo "<br>";
print topo "Por favor, utiliza Firefox, Chrome, Safari ou Opera.\n";

print topo "<script>\n";

print topo "   var elemento = document.getElementById('meucanvas');\n";

print topo "      var ctx = elemento.getContext('2d');\n";

print topo "ctx.beginPath();\n";
print topo "ctx.fillStyle = \"black\";\n";
print topo "ctx.font=\"8pt Arial\";\n";
print topo "ctx.fillText(\"".$data_reg."\",10,10);\n";
print topo "ctx.closePath();\n";


###########################################################


#### compara resultado atual com anterior e compara com teste de rtt ou rtt_man

foreach $ipc (keys(%fping_coleta)){

#print "# $ipc#";

   $ref_cod=$fping_ip{$ipc};

#print "$ref_cod \n";
   ### se o teste do link ja foi feito proximo

   if ($ipc=~/[0-9]{1,3}\./ and $ref_cod>0){


   }
   else{

      next;

   }
   if ($fping_teste{$ref_cod} eq 'sim'){

      next;

   }

      $loss_a="";
      $min_a="";
      $avg_a="";
      $max_a="";

      $loss_b="";
      $min_b="";
      $avg_b="";
      $max_b="";
      $sta="";
      $stb="";

      $iplocal="";
      $ip_remoto="";
      $status_atual_b="";
      $status_atual_a="";

   @status_old=split(/;/,$fping_old{$ipc});
   $status_antigo=@status_old[7];

   @status_a=split(/;/,$fping_coleta{$ipc});
   $status_atual_a=@status_a[0];



   ###status ip b

   @dados_geral=split(/;/,$fping_geral{$ref_cod});

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

   $inverte="nao";

#print "$iplocal ||| $ipc ||| remoto --- @dados_geral[15]\n";

   if ($iplocal eq $ipc){

#rint "$ip_remoto";
      $ip_remoto=@dados_geral[15];
#print "########$ip_remoto | $iplocal  \n";

   }
   else{

      $ip_remoto=@dados_geral[10];
      $iplocal=@dados_geral[15];
      $inverte="sim";

   }

   #### testa ponta b se $ip_remoto é padrao ip

   $testa_b="nao";

#print "testa se ip remoto $ip_remoto e padrao ip \n";
   #status rtta
   @rtt_a=split(/;/,$rtt_coleta{$iplocal});
   $status_rtt_a=@rtt_a[15];

   if ($ip_remoto=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){

         $testa_b="sim";
# print "coleta ######### $fping_coleta{$ip_remoto}\n"; 
        @status_b=split(/;/,$fping_coleta{$ip_remoto});
         $status_atual_b=@status_b[0];

        @rtt_b=split(/;/,$rtt_coleta{$ip_remoto});
        $status_rtt_b=@rtt_b[15];
   }
   else {

        @status_b=split(/;/,";;");
        $status_atual_b=@status_b[0];
        $status_rtt_b="";
   }
#print " resultado do teste:::: $ip_remoto   | $testa_b | @status_b \n";
   #### fim guarda b

   $sta=$status_atual_a;
   $stb=$status_atual_b;

   if ($inverte eq 'sim'){

      $sta=$status_atual_b;
      $stb=$status_atual_a;


      $min_a=@status_b[1];
      $max_a=@status_b[2];
      $avg_a=@status_b[3];
      $loss_a=@status_b[4];
      $env_a=@status_b[7];

      $min_b=@status_a[1];
      $max_b=@status_a[2];
      $avg_b=@status_a[3];
      $loss_b=@status_a[4];
      $env_b=@status_a[7];

      $status_rtt=$status_rtt_b." ".$status_rtt_a;
   }
   else {

   #### rtt info
      $status_rtt=$status_rtt_a." ".$status_rtt_b;
#print " ### @status_a | @status_b \n";
      $min_a=@status_a[1];
      $max_a=@status_a[2];
      $avg_a=@status_a[3];
      $loss_a=@status_a[4];
      $env_a=@status_a[7];

      $min_b=@status_b[1];
      $max_b=@status_b[2];
      $avg_b=@status_b[3];
      $loss_b=@status_b[4];
      $env_b=@status_b[7];

   }


      $status_atual=$sta." ".$stb;

#### se mantem status nao loga


  $status_fping=$status_atual;
  $status_fping =~ s/^\s*//g;  
  $status_fping =~ s/\s*$//g;
  $fping_teste{$ref_cod}="sim";
  
  ## status rtt

  $status_rtt=~ s/^\s*//g;
  $status_rtt=~ s/\s*$//g;

###########
##########################teste de loss a e b ###################################

   $ref_local=$iplocal."-".@dados_geral[0];

#   print " ! $ref_local | @dados_geral[0] ! $iplocal - $ip_remoto";

   $status_loss_b="";

   $status_loss_a="";

##########################

   $tot_loss_a=$loss_a.";".$loss_old{$ref_local};
#print "$tot_loss_a --- ";
   @l_t=split(/;/,$tot_loss_a);

   #qtde pacotes enviados no teste default 3

   $pkt_send=$env_a;

   #contador de pacote valido

   $cpk=0;

   ###total perdido

   $tot_loss=0;

   foreach $lll (@l_t){

      if ($lll=~/[0-9]/){

           $tot_loss=$tot_loss+$lll;
           
           $cpk++;
      }

   }


   $total_enviado=$cpk*$pkt_send;
#print "$cpk ####### $pkt_send ########\n";

   if ($total_enviado>0){

#sprintf("%2.2f",$media12);
      $pct_loss_a=sprintf("%2.2f",$tot_loss/$total_enviado*100);

   }
   else {

      $pct_loss_a=0;

   }

   if ($pct_loss_a>10 and $cpk>29){

       $status_loss_a="loss $pct_loss_a";
  
   }
   else{

       $status_loss_a="ok $pct_loss_a";

   }

###########################

#b:
   if ($testa_b eq 'sim'){

########################## loss b

      $tot_loss_b=$loss_b.";".$loss_old{$ref_local};

      @l_t=split(/;/,$tot_loss_b);

      #qtde pacotes enviados no teste default 3

      $pkt_send=$env_b;

      #contador de pacote valido

      $cpk=0;

      ###total perdido

      $tot_loss=0;

      foreach $lll (@l_t){

         if ($lll=~/[0-9]/){

            $tot_loss=$tot_loss+$lll;
           
            $cpk++;
         }

      }

      $total_enviado=$cpk*$pkt_send;

      if ($total_enviado>0){
   
         $pct_loss_b=sprintf("%2.2f",$tot_loss/$total_enviado*100);

      }
      else {

         $pct_loss_b=0;

      }

      if ($pct_loss_b>10 and $cpk>29){

         $status_loss_b="loss $pct_loss_b";
  
      }
      else {
         $status_loss_b="ok $pct_loss_b";
      }
      
###########################loss b

   }
### fim loss b

  $status_loss=$status_loss_a." | ".$status_loss_b;
  $status_loss =~ s/^\s*//g;
  $status_loss =~ s/\s*$//g;

#################################### fim teste de loss ##################################################
##########
#teste de media a e b

#print "$avg_a || $fpingrtt_old{$ref_local} -- $ref_local \n";
   $tot_media_a=$avg_a.";".$fpingrtt_old{$ref_local};

   @l_t=split(/;/,$tot_media_a);

   #qtde de testes acima da media em porcentagem

   $rtt_end=75;

   #limiar rtt

   $rtt_limiar=@dados_geral[52]; 

   if ($rtt_limiar<2){

      $rtt_limiar=70;

   }
   else {

     $rtt_limiar=$rtt_limiar+10;

   }
  #contador de pacote valido

   $cpk=0;

   #contador limite excedido

   $exc=0;

   $tot_rtt=0; 

   foreach $lll (@l_t){

      if ($lll=~/[0-9]/){
        
         $cpk++;
         $tot_rtt=$tot_rtt+$lll;

         if ($lll>$rtt_limiar){

            $exc++;

         }         

      }

   }

   if ($cpk>0){

      $rtt_periodo=sprintf("%2.2f",$tot_rtt/$cpk);
      $rtt_tp_lim=sprintf("%2.2f",$exc/$cpk*100);

   }
   else {

      $rtt_periodo="";
      $rtt_tp_lim=0;

   }

   if ($rtt_tp_lim>$rtt_end and $cpk>29){

      $status_fp_rtt_a="rtt a: media - $rtt_periodo - $exc/$cpk ";
   }
   else {
 
      $status_fp_rtt_a="ok $rtt_periodo";
  
   }
################

#b:
   if ($testa_b eq 'sim'){

      $tot_media_b=$avg_b.";".$fpingrtt_old{$ref_local};

      @l_t=split(/;/,$tot_media_b);

      #qtde de testes acima da media em porcentagem

      $rtt_end=75;

      #limiar rtt
   
      #contador de pacote valido

      $cpk=0;

      #contador limite excedido

      $exc=0;

      $tot_rtt=0; 

      foreach $lll (@l_t){

         if ($lll=~/[0-9]/){
        
            $cpk++;
            $tot_rtt=$tot_rtt+$lll;

            if ($lll>$rtt_limiar){

               $exc++;

            }         

         }

      }


      if ($cpk>0){

         $rtt_periodo=sprintf("%2.2f",$tot_rtt/$cpk);
         $rtt_tp_lim=sprintf("%2.2f",$exc/$cpk*100);

      }
      else {

         $rtt_periodo="";
         $rtt_tp_lim=0;

      }

      if ($rtt_tp_lim>$rtt_end and $cpk>29){

         $status_fp_rtt_b="rtt b: media - $rtt_periodo - $exc/$cpk ";
      }
      else{

         $status_fp_rtt_b="ok $rtt_periodo";

      }
################


   }

   $status_fp_rtt=$status_fp_rtt_a." | ".$status_fp_rtt_b;

  #definicao de status_teste

######

#inicio de status teste

   $status_teste="ok";

   if ($status_fping=~/falha/){

      $status_teste="falha";

   }
   else{

      if ($status_rtt=~/rtt|descarte/){

         if ($status_rtt=~/descarte/){

            $status_teste="descarte";

         }  

         if ($status_rtt=~/rtt/){

            $status_teste="rtt";

         }       

      }
      else{

         if ($status_loss=~/loss/){

            $status_teste="loss";

         }
         else{

            if ($status_fp_rtt=~/rtt/){

               $status_teste="lat";

            }
 
         }
    
      }


   } 


########fim de status


   if ($status_teste eq $status_antigo){

      $log_p="n";
      $t=@status_old[0];
      $dt=@status_old[1];
   }
   else {

      $t=$tc;
      $dt=$data_reg;
      $log_p="y";
  }

###contador

###check

   $check_info="nocheck";
   $tcheck="-1";

   if ($t==$fping_mttrx{@dados_geral[0]}){

      $check_info="check";
      $tcheck=$t;

   }


###

#####
  $tipo_link=substr(@dados_geral[30],0,2);

  @hxa=split(/\./,$host_a);
  @hxb=split(/\./,$host_b);

 $posx="";
 $posy="";

  if ($tipo_link eq '3-'){

     $device_status{@hxa[0]}=$status_teste;

     if (length(@hxb[0])>3 and length($device_status{@hxb[0]})<2){

        $device_status{@hxb[0]}=$status_teste;
     }
  }

  if($tipo_link=~/$ex_link/){

     $sub_tipo="lf"; 

     $posx=$devices{@hxa[0]};
     $posy=$devices{@hxb[0]};

  }

  if($tipo_link eq '2-' or $tipo_link eq '4-'){

     $sub_tipo="ll"; 

  }


  if($tipo_link eq '3-'){

     $sub_tipo="dev"; 

  }

   if ($check_info eq 'check'){

     $chave="chk";

     $total_teste{$chave}=$total_teste{$chave}+1;      

   }

  if ($status_teste eq 'ok' and $check_info ne 'check'){

     $chave="ok_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }
   

  if ($status_teste eq 'falha' and $check_info ne 'check'){

     $chave="falha_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }


  if ($status_teste eq 'rtt' and $check_info ne 'check'){

     $chave="rtt_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }


  if ($status_teste eq 'descarte' and $check_info ne 'check'){

     $chave="descarte_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }

  if ($status_teste eq 'loss' and $check_info ne 'check'){

     $chave="loss_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }

  if ($status_teste eq 'lat' and $check_info ne 'check'){

     $chave="lat_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }



############
  
#print res "$t;$dt;$iplocal;$status_fping;$status_rtt;$status_loss;$status_fp_rtt;$status_teste;$ref_cod;$ip_remoto;$host_a;$int_a;$host_b;$int_b;$descr;$mfr_a;$mfr_b;$envia_email;$vel;$designacao;$tipo_ll;$sub_tipo;$check_info;$tcheck;$posx;$posy;\n";

#print gloss "$t;$ref_cod;$iplocal;$tot_loss_a;\n";

#print gavg "$t;$ref_cod;$iplocal;$tot_media_a;\n";

if ($testa_b eq 'sim'){

#print gloss "$t;$ref_cod;$iplocal;$tot_loss_b;\n";
#print gavg "$t;$ref_cod;$iplocal;$tot_media_b;\n";

}

#####   

###desenha linhas do teste --- no futuro deve guardar em hash....

   #imprime linha

   if ($tipo_link=~/$ex_link/){

      if ($status_teste=~/ok/){

         $posn=$posx."-".$posy;

         $fis_line_ok{$posn}="#00FF00";

      }

      if ($status_teste=~/falha/){

         $posn=$posx."-".$posy;

         $fis_line_falha{$posn}="#FF0000";

      }

      if ($status_teste=~/rtt|lat/){

         $posn=$posx."-".$posy;

         $fis_line_rtt{$posn}="#9900CC";

      }

      if ($status_teste=~/loss|descarte/){

         $posn=$posx."-".$posy;

         $fis_line_loss{$posn}="#FFFF00";

      }
   }
####

  $status_fp_rtt="";
  $status_fp_rtt_b="";
  $status_fp_rtt_a="";

}



#close(res);
#close(gloss);
#close(gavg);

#open (geral,">$dir/geral_web_$cli.txt");

$tot_falha=$total_teste{"falha_ll"}+$total_teste{"falha_lf"};
$tot_rtt=$total_teste{"rtt_ll"}+$total_teste{"rtt_lf"}+$total_teste{"rtt_dev"};
$tot_descarte=$total_teste{"descarte_ll"}+$total_teste{"descarte_lf"}+$total_teste{"descarte_dev"};
$tot_loss=$total_teste{"loss_ll"}+$total_teste{"loss_lf"}+$total_teste{"loss_dev"};
$tot_lat=$total_teste{"lat_ll"}+$total_teste{"lat_lf"}+$total_teste{"lat_dev"};

$som="n";

if ($tot_falha>0){
   $som="y";
}
#print geral "$t;$data_reg;$total_teste{'ok_dev'};$total_teste{'ok_lf'};$total_teste{'ok_ll'};$tot_descarte;$tot_loss;$tot_rtt;$tot_lat;$tot_falha;$total_teste{'falha_dev'};$total_teste{'chk'};$som;";
#imprime sumario

close(geral);


#imprime verde

foreach $lnf (keys(%fis_line_ok)){

@xy=split(/-/,$lnf);

      print topo "ctx.beginPath();\n";

      print topo "ctx.lineWidth=2;\n";
      print topo "ctx.strokeStyle = \"".$fis_line_ok{$lnf}."\";\n";

      print topo "ctx.lineTo(".@xy[0].");\n";
      print topo "ctx.lineTo(".@xy[1].");\n";

      print topo "ctx.stroke();\n";

      print topo "ctx.closePath();\n";

}

#loss
foreach $lnf (keys(%fis_line_loss)){

@xy=split(/-/,$lnf);

      print topo "ctx.beginPath();\n";

      print topo "ctx.lineWidth=2;\n";
      print topo "ctx.strokeStyle = \"".$fis_line_loss{$lnf}."\";\n";

      print topo "ctx.lineTo(".@xy[0].");\n";
      print topo "ctx.lineTo(".@xy[1].");\n";

      print topo "ctx.stroke();\n";

      print topo "ctx.closePath();\n";

}

#rtt

foreach $lnf (keys(%fis_line_rtt)){

@xy=split(/-/,$lnf);

      print topo "ctx.beginPath();\n";

      print topo "ctx.lineWidth=2;\n";
      print topo "ctx.strokeStyle = \"".$fis_line_rtt{$lnf}."\";\n";

      print topo "ctx.lineTo(".@xy[0].");\n";
      print topo "ctx.lineTo(".@xy[1].");\n";

      print topo "ctx.stroke();\n";

      print topo "ctx.closePath();\n";

}

###falha

foreach $lnf (keys(%fis_line_falha)){

@xy=split(/-/,$lnf);

      print topo "ctx.beginPath();\n";

      print topo "ctx.lineWidth=2;\n";
      print topo "ctx.strokeStyle = \"".$fis_line_falha{$lnf}."\";\n";

      print topo "ctx.lineTo(".@xy[0].");\n";
      print topo "ctx.lineTo(".@xy[1].");\n";

      print topo "ctx.stroke();\n";

      print topo "ctx.closePath();\n";

}

#imprime hosts map
foreach $p (keys(%devices)){

if ($p eq '-'){

   next;

} 

#print "$p - $devices{$p}\n";

   #host

   $phost=$devices{$p};
   $st_h=$device_status{$p};

   $cor_line="rgba(74,255,116,0.7)";

   if ($st_h=~/falha/){

       $cor_line="rgba(227,31,9,0.5)";

   }

   if ($st_h=~/rtt|lat/){

       $cor_line="rgba(120,5,110,0.7)";

   }

   if ($st_h=~/loss|descarte/){

       $cor_line="rgba(248,252,0,0.7)";

   }

   print topo "ctx.fillStyle = \"".$cor_line."\";\n";
   print topo "ctx.beginPath();\n"; 
   print topo "ctx.arc(".$phost.",14,0,Math.PI*2,false);\n";
   print topo "ctx.fill();\n";
   print topo "ctx.closePath();\n";

#14 e o diametro do host

@xy=split(/,/,$phost);

$x=@xy[0]-14;
$y=@xy[1]-14;

$phost=$x.",".$y;

print topo "ctx.beginPath();\n";
print topo "ctx.fillStyle = \"black\";\n";
print topo "ctx.font=\"8pt Arial\";\n";
print topo "ctx.fillText(\"".$p."\",".$x.",".$y.");\n";
print topo "ctx.closePath();\n";


}

   print topo "</script>";
   print topo "</canvas>";

   print topo "</body>";
   print topo "</html>";

close(topo);
exit



