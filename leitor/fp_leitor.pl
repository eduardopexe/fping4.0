	#!/usr/bin/perl

	require "/fping4.0/db/dbinc.pl";
	require "/fping4.0/leitor/chk_leitor.pl";

       # require "/fping4.0/leitor/carrega_int_errs.pl";

	$cli=@ARGV[0];

	#abrir os resultados do fping e data para leitura
	open (result, "/fping4.0/coleta/coleta_$cli.txt");

	#resultado do fping atual
	@minhas_linhas = <result>;

	close (result);

#	print "/fping4.0/coleta/coleta_$cli.txt \n";
	#### time da coleta e data da coleta

	($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat("/fping4.0/coleta/coleta_$cli.txt");

         
	($seg,$min,$hora,$dia_m,$mes,$ano,$dia_s,$dia_a,$isdst)=localtime($mtime);

	$mess=$mes+1;

	$anos=1900+$ano;

#print "$data_reg";

	$data_reg=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$anos,$mess,$dia_m,$hora,$min,$seg);
	$tc=$mtime;
        $tk=time();

	#print "$tc | $data_reg \n";
	#diretorio de log:::
	$dir="/fping4.0/web/resultado/$cli";


	###
	####secao de log;;;;;;

	   if ($hlog eq 'on'){

	$lt=time();
	$arq_log="log_".$cli."_".$lt.".txt";

	      open (fplog,">$dir_log/$arq_log");
              open (logchk,">$dir_log_chk/$arq_log");
	   }

#hash telnet
#0 $ti;
#1 $data_regi;
#2 $int_status;
#3 $protocolo_st;
#4 $serv;
#5 $status_int;
#6 $status_int_errs;
#7 $crc_x;
#8 $input_error;
#9 $out_err;
#10$collissions;
#11$int_resets;
#12$total_drop;
#13$reli_m;
#13$pkt_in;
#15$pkt_out;
#16$bytes_in;
#17$bytes_out;
#18$rxload;
#19$txload;
#20$hostame;
#21$int_s;
#22$te;
#23$data_rege;
#24$inc_crc;
#25$inc_input_error;
#26$inc_out_err;
#27$inc_collissions;
#28$inc_int_resets;
#29$inc_total_drop;

        #### abre hash get snmp

        $diretorio_errs="/coleta_crc/www";

%host_int_errs= () ;

        open(errh,"$diretorio_errs/coleta_geral.txt");

        @rtt_linhas=<errh>;

        close(errh);

#print "$diretorio_errs/coleta_cti_err_geral.txt \n";
        foreach $lin (@rtt_linhas){

#print "$lin";
           $lin=~s/\n//g;
           $lin=~s/\r//g;

           @dd=split(/;/,$lin);

           #host_interface

           $ref=$dd[20]."_".$dd[21];
           #$lst_clear_n=$dd[11];
           $pct_utl_n="tx: ".$dd[19]."#rx: ".$dd[18];
           $in_err_n=$dd[25];
           $out_err_n=$dd[26];
           $coll_n=$dd[27];
           $int_resest_n=$dd[28];
           $drop_n=$dd[29];
           $crc_n=$dd[24];

           $err_info=$lst_clear_n.";";
           $err_info=$err_info.$pct_utl_n.";";
           $err_info=$err_info.$in_err_n.";";
           $err_info=$err_info.$out_err_n.";";
           $err_info=$err_info.$coll_n.";";
           $err_info=$err_info.$int_resest_n.";";
           $err_info=$err_info.$drop_n.";";
           $err_info=$err_info.$crc_n.";";
#print "$ref - loss: int errors;$err_info \n";

           $st_t="ok";

           if ($dd[6]=~/errors|resets|crc/){

              $st_t="int_errors: ".$dd[6];
           }

           if ($dd[6]=~/util/){

              $st_t="util.: ".$dd[6];
           }


           $host_int_errs{$ref}=$st_t.";".$err_info;


        }
#### fim telnet 
	#####################

        #### abre hash get snmp

        %host_int_get=();

        open(cpug,"/fping4.0/snmp/res_get.txt");

        @rtt_linhas=<cpug>;

        close(cpug);


        foreach $lin (@rtt_linhas){

           $lin=~s/\n//g;
           $lin=~s/\r//g;

           if ($lin=~/$cli/){


           }
           else{

              next;
           }

           @dd=split(/;/,$lin);

           $ref=$dd[3]."_".$dd[4];

           $host_int_get{$ref}=$lin;
          
#print "### $ref - $lin \n"; 

        }

        #### fim get snmp

        #### abre hash sum cpu

        %host_cpu_mem=();

        open(cpuc,"/fping4.0/snmp/sumario_cpu_mem.txt");

        @rtt_linhas=<cpuc>;

        close(cpuc);


        foreach $lin (@rtt_linhas){

           $lin=~s/\n//g;
           $lin=~s/\r//g;
           if ($lin=~/$cli/){


           }
           else{

              next;
           }

           @dd=split(/;/,$lin);
#print "$dd[2] - $lin \n";
           $host_cpu_mem{$dd[2]}=$lin;
           

        }

        #### fim sum cpu

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

	$xb=620;
	$yb=350;
	$raiob=100;
	$total_bkb=1;

	$lin=1;
	$xl=40;
	$yl=50;

	##inicio e fim de y
	$ylf=650;
	$yli=50;

	# inicio e fim x
	$xli=20;
	$xlf=1180;
	$xlb=20;
	$ylb=680;

	$total_dev=1;
	$ctl=0;
	$devices{"-"}="400,355";

        if ($cli=~/psys/){

           $devices{"mbpoc01"}="480,355";
           $devices{"swmigs01"}="420,355"; 
        }
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
                 if ($cli=~/psys|unib|brad/){

		 @ha=split(/\./,@dados_mttr[8]);
		 @hb=split(/\./,@dados_mttr[13]);  

                 }
                 else{

                    @ha=split(/ /,@dados_mttr[8]);
                    @hb=split(/ /,@dados_mttr[13]);
                 }
		 #desenha apenas link fisico

		 if (@dados_mttr[30]=~/1-/){


		    $mna=substr($ha[0],0,2);
		    $mnb=substr($hb[0],0,2);

		    ####host a define se eh bkb se eh bkb guarda em posicoes de bkb

		    if ($mna=~/mb|sw|rb/){

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
	#print "@ha[0] --- $pos\n";                    
			  $total_bkb++;
		       }

		    #### fim posicao bkb a

		    }
		    else{

		   
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

				$ylf=680;
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

	#print "@ha[0] - $pos ; ##############\n";
			  $devices{@ha[0]}=$pos;

	#                 $lin++;

		       }

		    }

		    #fim host a

		   ####host b

		    if ($mnb=~/mb|sw|rb/){

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

		    
		       if (length($devices{@hb[0]})<2){

			  $xlb=$xlb+80;

			  if ($xlb>1180){

			     $xlb=40;
			     $ylb=$ylb-70;

			     $lin++;

			     if ($ylb<50){

			     $ylb=50;

			     }

			  }

			  $pos=$xlb.",".$ylb;

			  $devices{@hb[0]}=$pos;
	#print "@hb[0] - $pos ;!!!!!!!!!!!!!!\n";

		       }

		    }

		    #fim host b

		    #inicio host b

		    #fim host b

		 }

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



              if ($dados_st_old[8]=~/[0-9]{1,20}/){

                  $fping_old{@dados_st_old[8]} = $st_old;

              }
              else{


                 $ref_x=$dados_st_old[10]."_".$dados_st_old[11];

                 $fping_old{$ref_x} = $st_old;
              }
 

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

        $total_teste{"utl_ll"}=0;
        $total_teste{"utl_lf"}=0;
        $total_teste{"utl_dev"}=0;
        $total_teste{"crit_dev"}=0;
	$total_teste{"chk"}=0;

        $total_teste{"int_errors_ll"}=0;
        $total_teste{"int_errors_lf"}=0;
        $total_teste{"int_errors_dev"}=0;

        $conta_som=0;
	%device_status=();

	%fis_line_ok=();
	%fis_line_falha=();
	%fis_line_loss=();
	%fis_line_rtt=();

	###fim variaveis contador resultado fpint
	#### abre arquivos para gravar resultados

	###arquivo topologia fisica; finalmente!!!! :)
	open(topo,">/fping4.0/web/topo_link_fis_$cli.php");

	print topo "<html>\n";
	print topo "<head>";
	print topo "   <title> $cli :: FPING 4.0 - NETWORK MAP</title>\n";
	print topo "<meta http-equiv=\"Cache-Control\" content=\"no-cache, no-store\" />\n";
	print topo "<meta http-equiv=\"Refresh\" content=\"30\">\n";
	print topo "<meta http-equiv=\"expires\" content=\"Mon, 06 Jan 1990 00:00:01 GMT\" />\n";
        print topo "\n<link rel=\"stylesheet\" href=\"../css/principal.css\" type=\"text/css\">";
	print topo "</head>\n";

	print topo "<body>\n";
	print topo "\n<table width='900'>";

	print topo "\n<tr bgcolor='CCCCCC'><td colspan='2' width='150' height='0'>";

	print topo "\n<font size=1>mapas:</font>";

	print topo "\n</td>";

	$ips="10.98.22.11";
	print topo "\n<td colspan='1' width='80' height='0'>";
	print topo "\n<a href='http://$ips/fping4.0/topo_link_fis_".$cli.".php' target='_self'><font size=1>mapa link fisico</font></a>";
	print topo "\n</td>";

	print topo "\n<td colspan='1' width='80' height='0'>";
	print topo "\n<a href='http://$ips/fping4.0/mapa/topo_link_fis_".$cli."_log.php' target='_self'><font size=1>mapa link logico</font></a>";

print topo "\n<td colspan='1' width='80' height='0'>";
print topo "\n<a href='http://$ips/fping4.0/mapa/topo_link_fis_".$cli."_fis_e_log.php' target='_self'><font size=1>mapa link fisico e logico</font></a>";

print topo "\n</td>";

print topo "\n</td></tr></table>";

print topo "\n\<?\ninclude_once(\"/fping4.0/web/mon_sum_".$cli.".php\")\n?>";
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
open (res,">$dir/tmp_res_$cli.txt");
open (gloss,">$dir/tmp_loss_$cli.txt");
open (gavg,">$dir/tmp_fping_rtt_media_$cli.txt");

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
   $ip_loopback_host=@dados_geral[43];
   $ip_loopback_host_b=@dados_geral[44];

   $teste_rtt=@dados_geral[58];
   ###testa setestedelatencia e cisco pingmib

   if (@dados_geral[58]=~/rtt/){

      $teste_rtt_exec="y";
   }
   else{

      $teste_rtt_exec="n";
   } 
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

   $host_a=@dados_geral[13];
   $int_a=@dados_geral[14];
   $host_b=@dados_geral[8];
   $int_b=@dados_geral[9];

   $mfr_a=@dados_geral[16];
   $mfr_b=@dados_geral[11];

   $ip_loopback_host=@dados_geral[44];
   $ip_loopback_host_b=@dados_geral[43];
   }

   #### testa ponta b se $ip_remoto é padrao ip

   $testa_b="nao";

#print "testa se ip remoto $ip_remoto e padrao ip \n";
   #status rtta
   @rtt_a=split(/;/,$rtt_coleta{$ip_remoto});
   $status_rtt_a=@rtt_a[14];

   if ($ip_remoto=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){

         $testa_b="sim";
# print "coleta ######### $fping_coleta{$ip_remoto}\n"; 
        @status_b=split(/;/,$fping_coleta{$ip_remoto});
         $status_atual_b=@status_b[0];

        @rtt_b=split(/;/,$rtt_coleta{$iplocal});
        $status_rtt_b=@rtt_b[14];
   }
   else {

        @status_b=split(/;/,";;");
        $status_atual_b=@status_b[0];
        $status_rtt_b="nc"
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
   $ref_localb=$ip_remoto."-".@dados_geral[0];
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

           if ($cli=~/psys|unib|brad/ and $lll==3 or $cli=~/ebtv|cqmri/ and $lll==10){


           }
           else{

           $tot_loss=$tot_loss+$lll;
           
           $cpk++;

           }
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

if ($cli=~/ebtv|cqmri/){

$lim_loss=60;

}
else{
$lim_loss=30;

}
   if ($pct_loss_a>$lim_loss and $cpk>29){

       $status_loss_a="loss $pct_loss_a";
  
   }
   else{

       $status_loss_a="ok $pct_loss_a";

   }

###########################

#b:
   if ($testa_b eq 'sim'){

########################## loss b

      $tot_loss_b=$loss_b.";".$loss_old{$ref_localb};

      @l_t=split(/;/,$tot_loss_b);

      #qtde pacotes enviados no teste default 3

      $pkt_send=$env_b;

      #contador de pacote valido

      $cpk=0;

      ###total perdido

      $tot_loss=0;

      foreach $lll (@l_t){

         if ($lll=~/[0-9]/){

           if ($cli=~/psys|unib|brad/ and $lll==3 or $cli=~/ebtv|cqmri/ and $lll==10){


           }
           else{

           $tot_loss=$tot_loss+$lll;

           $cpk++;

           }

#            $tot_loss=$tot_loss+$lll;
           
#            $cpk++;
         }

      }

      $total_enviado=$cpk*$pkt_send;

      if ($total_enviado>0){
   
         $pct_loss_b=sprintf("%2.2f",$tot_loss/$total_enviado*100);

      }
      else {

         $pct_loss_b=0;

      }

      if ($pct_loss_b>$lim_loss and $cpk>29){

         $status_loss_b="loss $pct_loss_b";
  
      }
      else {
         $status_loss_b="ok $pct_loss_b";
      }
      
###########################loss b

   }
### fim loss b

  $status_loss=$status_loss_a." #".$status_loss_b;
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

      $status_fp_rtt_a="lat_a: $rtt_periodo - $exc/$cpk ";
   }
   else {
 
      $status_fp_rtt_a="ok $rtt_periodo";
  
   }
################

#b:
   if ($testa_b eq 'sim'){

      $tot_media_b=$avg_b.";".$fpingrtt_old{$ref_localb};

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

         $status_fp_rtt_b="lat_b: $rtt_periodo - $exc/$cpk ";
      }
      else{

         $status_fp_rtt_b="ok $rtt_periodo";

      }
################


   }

   $status_fp_rtt=$status_fp_rtt_a."#".$status_fp_rtt_b;

  #definicao de status_teste

######

#inicio de status teste

   $status_teste="ok";

#status teste get snmp - se aplica se existe no hash host_int_get{$hosta_$inta} e ou host_int_get{$hostb_$int_b}

#===============================================
   $refg_a=$host_a."_".$int_a;
   $refg_b=$host_b."_".$int_b;

#   $refg_a=~s/controller E1 /E1/g;
#   $refg_b=~s/controller E1 /E1/g;

   $status_snmpa="nc";
   $status_snmpb="nc";

   if (length($host_int_get{$refg_a})>3){

      @gs=split(/;/,$host_int_get{$refg_a});
    
      #status interface::::

      $st_t=$gs[5]." ".$gs[6];

      if ($st_t=~/down|loop/){

         $status_snmpa="falha";

      }
      else{

         $status_snmpa="ok";

      }

#print "entrou $refg_a \n";
      $host_int_get{$refg_a}="ok";

   }

####b
   if (length($host_int_get{$refg_b})>3){

      @gs=split(/;/,$host_int_get{$refg_b});
    
      #status interface::::

      $st_t=$gs[5]." ".$gs[6];

      if ($st_t=~/down|loop/){

         $status_snmpb="falha";

      }
      else{

         $status_snmpb="ok";

      }

#print "entrou $refg_b \n";
      $host_int_get{$refg_b}="ok";

   }
   else{

#   print "nao entrou $refg_b\n";

   }
####
   $status_snmp_get=$status_snmpa."|".$status_snmpb;

   
#======================
#!!!!!!!!!!!status device cpu

$tipo_link=substr(@dados_geral[30],0,2);

$cpu_a="-1";
$cpu_b="-1";
$mem_proc_a="-1";
$mem_proc_b="-1";

$mem_io_a="-1";
$mem_io_b="-1";

$st_cpu_a="nc";

$st_cpu_b="nc";

#print "############$host_a - $host_cpu_mem{$host_a} ####\n";
   if (length($host_cpu_mem{$host_a})>3){

      @cpus=split(/;/,$host_cpu_mem{$host_a});

      $cpu_a=$cpus[3];
      $mem_proc_a=$cpus[7];
      $mem_io_a=$cpus[6];

      $st_cpu_a=$cpus[4]." | ".$cpus[5];
#     print "!!! $host_a $st_cpu_a |||$cpu_a $mem_proc_a $mem_io_a\n"; 
   }

   if (length($host_cpu_mem{$host_b})>3){

      @cpus=split(/;/,$host_cpu_mem{$host_b});

      $cpu_b=$cpus[3];
      $mem_proc_b=$cpus[7];
      $mem_io_b=$cpus[6];

      $st_cpu_b=$cpus[4]." | ".$cpus[5];
      

   }

   if ($tipo_link eq '3-'){

      #$st_cpu="ok";

      if($cpu_a==-1){

         $st_cpu="nc";

      }
      else{

         $st_cpu=$st_cpu_a;

      }
#print "######!!!$st_cpu \n";

   }
   else{

         $st_cpu="na";     

   }

   $st_cpus="ok";

#retirado| alarme mem |

   if ($st_cpu=~/critico/){

      $total_teste{"crit_dev"}=$total_teste{"crit_dev"}+1;

      $st_cpus="alarme";
#print "$total_teste{'crit_dev'}\n";
   }

###adicionar no fim da linha de teste: $status_snmp_get;$st_cpus;$st_cpu;$cpu_a;$cpu_b;$mem_proc_a;$mem_proc_b;$mem_io_a;$mem_io_b;
#!!!!!!!!!!fim status device cpu

   if ($status_fping=~/falha/ or $status_snmp_get=~/falha/){

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

            if ($status_fp_rtt=~/rtt|lat/ and $teste_rtt_exec eq 'n'){

               $status_teste="ok";

            }
 
         }
    
      }


   } 

#se satatus teste = ok testa se coleta de telnet apresenta errors crc ou alto trafego

if ($int_a=~/[0-9]\.[0-9]/){

@intx=split(/\./,$int_a);
$int_a_cheia=$intx[0];

}
else{

$int_a_cheia=$int_a;

}

if ($int_b=~/[0-9]\.[0-9]/){

@intx=split(/\./,$int_b);
$int_b_cheia=$intx[0];

}
else{

$int_b_cheia=$int_b;

}
$ref_a=$host_a."_".$int_a_cheia;

if ($testa_b eq 'sim'){

$ref_a=$host_b."_".$int_b_cheia;


}



$lst_clear_a="";
$pct_utl_a="-1";
$in_err_a="-1";
$out_err_a="-1";
$coll_a="-1";
$int_resest_a="-1";
$drop_a="-1";
$crc_a="-1";

$status_coleta_telnet_a="ok";
$status_coleta_telnet_b="ok";
$lst_clear_b="";
$pct_utl_b="-1";
$in_err_b="-1";
$out_err_b="-1";
$coll_b="-1";
$int_resest_b="-1";
$drop_b="-1";
$crc_b="-1";

if (length($host_int_errs{$ref_a})>5){

@tel_a=split(/;/,$host_int_errs{$ref_a});
$status_coleta_telnet_a=$tel_a[0];
$lst_clear_a=$tel_a[1];
$pct_utl_a=$tel_a[2];
$in_err_a=$tel_a[3];
$out_err_a=$tel_a[4];
$coll_a=$tel_a[5];
$int_resest_a=$tel_a[6];
$drop_a=$tel_a[7];
$crc_a=$tel_a[8];
}

if (length($host_int_errs{$ref_b})>5){

@tel_b=split(/;/,$host_int_errs{$ref_b});
$status_coleta_telnet_b=$tel_b[0];
$lst_clear_b=$tel_b[1];
$pct_utl_b=$tel_b[2];
$in_err_b=$tel_b[3];
$out_err_b=$tel_b[4];
$coll_b=$tel_b[5];
$int_resest_b=$tel_b[6];
$drop_b=$tel_b[7];
$crc_b=$tel_b[8];

}


$status_col_telnet=$status_coleta_telnet_a." | ".$status_coleta_telnet_b;

if ($status_col_telnet eq 'ok | ok'){


}
else{

#so altera status se estiver ok:::::

   if($status_teste eq 'ok'){

      if($status_col_telnet=~/int_errors/){

         $status_teste="int_errors";

      }
      else{

         if($status_col_telnet=~/util/){

            $status_teste="utl";

         }


      }

   }

}

$ref_a="";
$ref_b="";
########fim de status


   if ($status_teste eq $status_antigo){

      $log_p="n";
      $t=@status_old[0];
      $dt=@status_old[1];
   }
   else {

#print "teste $cod $ipc $status_teste eq $status_antigo\n";
      $told=@status_old[0];
      $status_oldx=@status_old[7];
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
      $log_chk="n";

      if ($tk-$t<600){

         $log_chk="y";
      } 
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

  if($tipo_link eq '1-'){

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

####som para alarmes nao marcados a mais de 5 min

      if ($check_info eq 'nocheck' and $status_teste eq 'falha'){


         if ($tc-$t>600){

            $conta_som++;

         }


      }

##############################################################

  if ($status_teste eq 'rtt' and $check_info ne 'check'){

     $chave="rtt_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }


  if ($status_teste eq 'descarte' and $check_info ne 'check'){

     $chave="descarte_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }

  if ($status_teste=~/loss/ and $check_info ne 'check'){

     $chave="loss_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }

  if ($status_teste eq 'lat' and $check_info ne 'check'){

     $chave="lat_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }

  if ($status_teste eq 'utl' and $check_info ne 'check'){

     $chave="utl_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }

  if ($status_teste eq 'int_errors' and $check_info ne 'check'){

     $chave="int_errors_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }

############
  
print res "$t;$dt;$iplocal;$status_fping;$status_rtt;$status_loss;$status_fp_rtt;$status_teste;$ref_cod;$ip_remoto;$host_a;$int_a;$host_b;$int_b;$descr;$mfr_a;$mfr_b;$envia_email;$vel;$designacao;$tipo_ll;$sub_tipo;$check_info;$tcheck;$posx;$posy;$told;$status_oldx;$uf;$status_snmp_get;$st_cpus;$st_cpu;$cpu_a;$cpu_b;$mem_proc_a;$mem_proc_b;$mem_io_a;$mem_io_b;$operadora;$status_col_telnet;$lst_clear_a;$lst_clear_b;$pct_utl_a;$pct_utl_b;$in_err_a;$in_err_b;$out_err_a;$out_err_b;$coll_a;$coll_b;$int_resest_a;$int_resest_b;$drop_a;$drop_b;$crc_a;$crc_b;$ip_loopback_host;$ip_loopback_host_b;$inverte;$teste_rtt;$cli;\n";

if ($log_p eq 'y'){

print fplog "$t;$dt;$iplocal;$status_fping;$status_rtt;$status_loss;$status_fp_rtt;$status_teste;$ref_cod;$ip_remoto;$host_a;$int_a;$host_b;$int_b;$descr;$mfr_a;$mfr_b;$envia_email;$vel;$designacao;$tipo_ll;$sub_tipo;$check_info;$tcheck;$posx;$posy;$told;$status_oldx;$uf;$status_snmp_get;$st_cpus;$st_cpu;$cpu_a;$cpu_b;$mem_proc_a;$mem_proc_b;$mem_io_a;$mem_io_b;$operadora;$status_col_telnet;$lst_clear_a;$lst_clear_b;$pct_utl_a;$pct_utl_b;$in_err_a;$in_err_b;$out_err_a;$out_err_b;$coll_a;$coll_b;$int_resest_a;$int_resest_b;$drop_a;$drop_b;$crc_a;$crc_b;$ip_loopback_host;$ip_loopback_host_b;$inverte;$teste_rtt;$cli;\n";

 

}

if ($log_chk eq 'y'){

print logchk "$t;$dt;$iplocal;$ref_cod;\n";
}
print gloss "$t;$ref_cod;$iplocal;$tot_loss_a;\n";

print gavg "$t;$ref_cod;$iplocal;$tot_media_a;\n";

if ($testa_b eq 'sim'){

print gloss "$t;$ref_cod;$ip_remoto;$tot_loss_b;\n";
print gavg "$t;$ref_cod;$ip_remoto;$tot_media_b;\n";

}

#####   

###desenha linhas do teste --- no futuro deve guardar em hash....

   #imprime linha

   if ($tipo_link eq '1-'){

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


####teste de interfaces que nao tem ip:::::

$ip_loopback_host="";
$ip_loopback_host_b="";

####interface no ip
foreach $itemx (keys(%host_int_get)){

#print "$itemx - $host_int_get{$itemx} \n";

####!!##########################

   if ($host_int_get{$itemx} eq 'ok' or length($host_int_get{$itemx})<3 or length($itemx)<3){

      next;

   }
   
   $ref_cod=$fping_host_int{$itemx};

#print "####--- $itemx | $ref_cod $fping_old{$ref_cod}\n";
   @status_old=split(/;/,$fping_old{$ref_cod});
   $status_antigo=$status_old[7];

   @dados_geral=split(/;/,$fping_geral{$ref_cod});
   $iplocal=@dados_geral[10];
   $ip_remoto=@dados_geral[15];

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

   $ref_a=$host_a."_".$int_a;
   $ref_b=$host_b."_".$int_b;

   $tipo_link=substr(@dados_geral[30],0,2);
   $teste_rtt=@dados_geral[58];
   $inverte="nao";

   @sta=split(/;/,$host_int_get{$ref_a});

   @stb=split(/;/,$host_int_get{$ref_b});
   
      $st_a=$sta[5]." ".$sta[6];
      $st_b=$stb[5]." ".$stb[6];

      if ($st_a=~/down|loop/ or $st_b=~/down|loop/){

         $status_snmp="falha";

      }
      else{

         $status_snmp="ok";

      }
#print "###$host_int_get{$ref_a} --- $ref_a - $ref_b - $st_a - $st_b - $status_snmp\n";
   $status_teste=$status_snmp;

#######
# status telnet se satatus teste = ok testa se coleta de telnet apresenta errors crc ou alto trafego

if ($int_a=~/[0-9]\.[0-9]/){

@intx=split(/\./,$int_a);
$int_a_cheia=$intx[0];

}
else{

$int_a_cheia=$int_a;

}

if ($int_b=~/[0-9]\.[0-9]/){

@intx=split(/\./,$int_b);
$int_b_cheia=$intx[0];

}
else{

$int_b_cheia=$int_b;

}
$ref_a=$host_a."_".$int_a_cheia;

if ($testa_b eq 'sim'){

$ref_a=$host_b."_".$int_b_cheia;


}



$lst_clear_a="";
$pct_utl_a="-1";
$in_err_a="-1";
$out_err_a="-1";
$coll_a="-1";
$int_resest_a="-1";
$drop_a="-1";
$crc_a="-1";

$status_coleta_telnet_a="ok";
$status_coleta_telnet_b="ok";
$lst_clear_b="";
$pct_utl_b="-1";
$in_err_b="-1";
$out_err_b="-1";
$coll_b="-1";
$int_resest_b="-1";
$drop_b="-1";
$crc_b="-1";

if (length($host_int_errs{$ref_a})>5){

@tel_a=split(/;/,$host_int_errs{$ref_a});
$status_coleta_telnet_a=$tel_a[0];
$lst_clear_a=$tel_a[1];
$pct_utl_a=$tel_a[2];
$in_err_a=$tel_a[3];
$out_err_a=$tel_a[4];
$coll_a=$tel_a[5];
$int_resest_a=$tel_a[6];
$drop_a=$tel_a[7];
$crc_a=$tel_a[8];
}

if (length($host_int_errs{$ref_b})>5){

@tel_b=split(/;/,$host_int_errs{$ref_b});
$status_coleta_telnet_b=$tel_b[0];
$lst_clear_b=$tel_b[1];
$pct_utl_b=$tel_b[2];
$in_err_b=$tel_b[3];
$out_err_b=$tel_b[4];
$coll_b=$tel_b[5];
$int_resest_b=$tel_b[6];
$drop_b=$tel_b[7];
$crc_b=$tel_b[8];

}


$status_col_telnet=$status_coleta_telnet_a." | ".$status_coleta_telnet_b;

if ($status_col_telnet eq 'ok | ok'){


}
else{

#so altera status se estiver ok:::::

   if($status_teste eq 'ok'){

      if($status_col_telnet=~/int_errors/){

         $status_teste="int_errors";

      }
      else{

         if($status_col_telnet=~/util/){

            $status_teste="utl";

         }


      }

   }

}

$ref_a="";
$ref_b="";

########fim de status telnet


####
#print "Teste $status_teste eq $status_antigo \n";
   if ($status_teste eq $status_antigo){

      $log_p="n";
      $t=$status_old[0];
      $dt=$status_old[1];
   }
   else {

      $told=@status_old[0];
      $status_oldx=@status_old[7];
      $t=$tc;
      $dt=$data_reg;
      $log_p="y";
  }
  
###check

   $check_info="nocheck";
   $tcheck="-1";

   if ($t==$fping_mttrx{@dados_geral[0]}){

      $check_info="check";
      $tcheck=$t;
      $log_chk="n";

      if ($tk-$t<600){

         $log_chk="y";
      }
   }

##########################################

#======================
#!!!!!!!!!!!status device cpu

$tipo_link=substr(@dados_geral[30],0,2);

$cpu_a="-1";
$cpu_b="-1";
$mem_proc_a="-1";
$mem_proc_b="-1";

$mem_io_a="-1";
$mem_io_b="-1";

$st_cpu_a="nc";

$st_cpu_b="nc";

#print "############$host_a - $host_cpu_mem{$host_a} ####\n";
   if (length($host_cpu_mem{$host_a})>3){

      @cpus=split(/;/,$host_cpu_mem{$host_a});

      $cpu_a=$cpus[3];
      $mem_proc_a=$cpus[7];
      $mem_io_a=$cpus[6];

      $st_cpu_a=$cpus[4]." | ".$cpus[5];
#     print "!!! $host_a $st_cpu_a |||$cpu_a $mem_proc_a $mem_io_a\n";
   }

   if (length($host_cpu_mem{$host_b})>3){

      @cpus=split(/;/,$host_cpu_mem{$host_b});

      $cpu_b=$cpus[3];
      $mem_proc_b=$cpus[7];
      $mem_io_b=$cpus[6];

      $st_cpu_b=$cpus[4]." | ".$cpus[5];


   }

   if ($tipo_link eq '3-'){

      #$st_cpu="ok";

      if($cpu_a==-1){

         $st_cpu="nc";

      }
      else{

         $st_cpu=$st_cpu_a;

      }
#print "######!!!$st_cpu \n";

   }
   else{

         $st_cpu="na";

   }

   $st_cpus="ok";

#retirado alarme mem

   if ($st_cpu=~/critico/){

      $total_teste{"crit_dev"}=$total_teste{"crit_dev"}+1;

      $st_cpus="alarme";
#print "$total_teste{'crit_dev'}\n";
   }

###adicionar no fim da linha de teste: $status_snmp_get;$st_cpus;$st_cpu;$cpu_a;$cpu_b;$mem_proc_a;$mem_proc_b;$mem_io_a;$mem_io_b;
#!!!!!!!!!!fim status device cpu

##########################

##########################################

  $status_fping="";
  $status_rtt="";
  $status_loss="";
  $status_fp_rtt="";

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

  if($tipo_link eq '1-'){

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

###som para ll e lf 

      if ($check_info eq 'nocheck' and $status_teste eq 'falha'){


         if ($tk-$t>600){

            $conta_som++;

         }


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

  if ($status_teste eq 'utl' and $check_info ne 'check'){

     $chave="utl_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }

  if ($status_teste eq 'int_errors' and $check_info ne 'check'){

     $chave="int_errors_".$sub_tipo;

     $total_teste{$chave}=$total_teste{$chave}+1;

  }

   
###desenha linhas do teste --- no futuro deve guardar em hash....

   #imprime linha

   if ($tipo_link eq '1-'){

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

   $saida="$t;$dt;$iplocal;$status_fping;$status_rtt;$status_loss;$status_fp_rtt;";
   $saida=$saida."$status_teste;$ref_cod;$ip_remoto;$host_a;$int_a;$host_b;$int_b;$descr;";
   $saida=$saida."$mfr_a;$mfr_b;$envia_email;$vel;$designacao;$tipo_ll;$sub_tipo;$check_info;";
   $saida=$saida."$tcheck;$posx;$posy;$told;$status_oldx;$uf;$status_snmp_get;$st_cpus;";
   $saida=$saida."$st_cpu;$cpu_a;$cpu_b;$mem_proc_a;$mem_proc_b;$mem_io_a;$mem_io_b;$operadora;";
   $saida=$saida."$status_col_telnet;$lst_clear_a;$lst_clear_b;$pct_utl_a;$pct_utl_b;$in_err_a;$in_err_b;$out_err_a;$out_err_b;$coll_a;$coll_b;$int_resest_a;$int_resest_b;$drop_a;$drop_b;$crc_a;$crc_b;";	 
   $saida=$saida."$ip_loopback_host;$ip_loopback_host_b;";
   $saida=$saida."$inverte;$teste_rtt;$cli;\n";
  
#print "$saida\n"; 
print res "$saida";

if ($log_p eq 'y'){

print fplog "$saida";

}

if ($log_chk eq 'y'){

print logchk "$t;$dt;$iplocal;$ref_cod;\n";
}

$host_int_get{$ref_a}="ok";
$host_int_get{$ref_b}="ok";


############################################
      
}

#######
########################################

if ($cli=~/psys/){
####ras e1

open(rase1,"/fping4.0/telnet/coleta_e1_ras.txt");

@rasd=<rase1>;

close(rase1);


   foreach $linr (@rasd){

######

      $t='';
      $dt='';
      $iplocal='';
      $status_fping='';
      $status_rtt='';
      $status_loss='';
      $status_fp_rtt='';
      $status_teste='';
      $ref_cod='';
      $ip_remoto='';
      $host_a='';
      $int_a='';
      $host_b='';
      $int_b='';
      $descr='';
      $mfr_a='';
      $mfr_b='';
      $envia_email='';
      $vel='';
      $designacao='';
      $tipo_ll='';
      $sub_tipo='';
      $check_info='';
      $tcheck='';
      $posx='';
      $posy='';
      $told='';
      $status_oldx='';
      $uf='';
      $status_snmp_get='';
      $st_cpus='';
      $st_cpu='';
      $cpu_a='';
      $cpu_b='';
      $mem_proc_a='';
      $mem_proc_b='';
      $mem_io_a='';
      $mem_io_b='';
      $operadora='';
      $status_col_telnet='';
      $lst_clear_a='';
      $lst_clear_b='';
      $pct_utl_a='';
      $pct_utl_b='';
      $in_err_a='';
      $in_err_b='';
      $out_err_a='';
      $out_err_b='';
      $coll_a='';
      $coll_b='';
      $int_resest_a='';
      $int_resest_b='';
      $drop_a='';
      $drop_b='';
      $crc_a='';
      $crc_b='';
      $ip_loopback_host='';
      $ip_loopback_host_b='';
      $inverte='';

      $sub_tipo="lf";
############

      @dd=split(/;/,$linr);

      $t=$dd[0];
      $data_rg=$dd[1];
      $host_a=$dd[2];
      $int_a=$dd[3];
      $st_int=$dd[4];

      $st_int=~s/\.//g;


        ($seg,$min,$hora,$dia_m,$mes,$ano,$dia_s,$dia_a,$isdst)=localtime($t);

        $mess=$mes+1;

        $anos=1900+$ano;

        $data_reg=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$anos,$mess,$dia_m,$hora,$min,$seg);


      if ($st_int=~/up/){

         $status_teste="ok";

         $chave="ok_".$sub_tipo;

         $total_teste{$chave}=$total_teste{$chave}+1;

#print "$total_teste{$chave} :: \n";
      }


      if ($st_int=~/down/){


         $status_teste="falha";

         $chave="falha_".$sub_tipo;

         $total_teste{$chave}=$total_teste{$chave}+1;
#print "falha $total_teste{$chave} :: \n";
         $conta_som++;
      }

   $ref_int=$host_a."_".$int_a;

   @status_old=split(/;/,$fping_old{$ref_int});
   $status_antigo=@status_old[7];

#print "$ref_int -- $status_antigo ---$fping_old{$ref_int} \n";
   if ($status_teste eq $status_antigo){

      $log_p="n";
      $t=$status_old[0];
      $dt=$status_old[1];
   }
   else {

#print "teste $cod $ipc $status_teste eq $status_antigo\n";
      $told=$status_old[0];
      $status_oldx=$status_old[7];
      $t=$tc;
      $dt=$data_reg;
      $log_p="y";
  }

         print res "$t;$dt;$iplocal;$status_fping;$status_rtt;$status_loss;$status_fp_rtt;$status_teste;$ref_cod;$ip_remoto;$host_a;$int_a;$host_b;$int_b;$descr;$mfr_a;$mfr_b;$envia_email;$vel;$designacao;$tipo_ll;$sub_tipo;$check_info;$tcheck;$posx;$posy;$told;$status_oldx;$uf;$status_snmp_get;$st_cpus;$st_cpu;$cpu_a;$cpu_b;$mem_proc_a;$mem_proc_b;$mem_io_a;$mem_io_b;$operadora;$status_col_telnet;$lst_clear_a;$lst_clear_b;$pct_utl_a;$pct_utl_b;$in_err_a;$in_err_b;$out_err_a;$out_err_b;$coll_a;$coll_b;$int_resest_a;$int_resest_b;$drop_a;$drop_b;$crc_a;$crc_b;$ip_loopback_host;$ip_loopback_host_b;#ras#;\n";

###falta colocar log
      
   }

}
### fim ras e1

close(fplog);
close(logchk);

close(res);
close(gloss);
close(gavg);

#################################
open (geral,">$dir/geral_web_$cli.txt");

$tot_falha=$total_teste{"falha_ll"}+$total_teste{"falha_lf"};
$tot_rtt=$total_teste{"rtt_ll"}+$total_teste{"rtt_lf"}+$total_teste{"rtt_dev"};
$tot_descarte=$total_teste{"descarte_ll"}+$total_teste{"descarte_lf"}+$total_teste{"descarte_dev"};
$tot_ping_loss=$total_teste{"loss_ll"}+$total_teste{"loss_lf"}+$total_teste{"loss_dev"};
$tot_int_err=$total_teste{"int_errors_ll"}+$total_teste{"int_errors_lf"}+$total_teste{"int_errors_dev"};
$tot_loss=$tot_ping_loss+$tot_int_err;
$tot_lat=$total_teste{"lat_ll"}+$total_teste{"lat_lf"}+$total_teste{"lat_dev"};
$tot_utl=$total_teste{"utl_ll"}+$total_teste{"utl_lf"}+$total_teste{"utl_dev"};
$tot_crit=$total_teste{"crit_dev"}+$tot_utl;
$som="n";

$tot_falhat=$total_teste{"falha_dev"};

if ($tot_falhat>0 or $conta_som>0){
   $som="y";
}

print geral "$t;$data_reg;$total_teste{'ok_dev'};$total_teste{'ok_lf'};$total_teste{'ok_ll'};$tot_descarte;$tot_loss;$tot_rtt;$tot_lat;$tot_falha;$total_teste{'falha_dev'};$total_teste{'chk'};$som;$tot_crit;";
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

#print "$p - $devices{$p}\n";

   #host

if ($p eq '-'){

next;
}
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

if ($p=~/^(rb|mb|rf|rs|swm|swcti)/){

   $cor_line="blue"; 
   print topo "ctx.lineWidth=3;\n";
   print topo "ctx.strokeStyle = \"".$cor_line."\";\n";
   print topo "ctx.beginPath();\n";
   print topo "ctx.arc(".$phost.",14,0,Math.PI*2,false);\n";
   print topo "ctx.stroke();\n";
   print topo "ctx.closePath();\n";

}
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
print topo "\n\<?\ninclude_once(\"/fping4.0/web/log_fping2.php\")\n?>";
   print topo "</body>";
   print topo "</html>";

close(topo);
exit


