#!/usr/bin/perl 


$dir="/fping4.0/robo_ping/log_telnet";

$cod=$ARGV[0];

$pe=$ARGV[1];

$int_pe=$ARGV[2];

$arquivo=$cod."-".$pe."-".$int_pe.".txt";

open(rit,"$dir/$arquivo");

@info=<rit>;

close(rit);

$telnet_st="nao";

#######

#############interface cheia

$int_status="";
$int_line_protocol_status="";

$int_rely=-1;
$int_load=-1;
$int_load_tx=-1;
$int_load_rx=-1;
$int_pkt_in=-1;
$int_pkt_out=-1;

$int_input_errors=-1;
$int_crc=-1;
$int_out_errors=-1;
$int_collisions=-1;
$int_resets=-1;  
$status_ping="";
$status_interface="";

%hostname_interface=();

foreach $res (@info){


   if ($res=~/#show interface|#ping/){

      $telnet_st="sim";

      if (length($hostname_a)<3){ 

         @pei=split(/#/,$res);
         $hostname_a=@pei[0];
     #    print "$hostname_a\n"; 
      }

      if (length($interface)>3){

         $saida="$hostname_a;$interface;$int_status;$int_line_protocol_status;";
         $saida=$saida."$int_crc;$int_input_errors;$int_out_errors;$int_load_rx;$int_load_tx;";
         $saida=$saida."$int_collisions;$int_resets;";
         $saida=$saida=$saida."$int_rely;$int_pkt_in;$int_pkt_out;";

#         print "### --- > $saida\n";

         $ref=$hostname_a."_".$interface;

         $hostname_interface{$ref}=$saida;

      }

   }


####################errors

################interface status

   if ($res=~/line protocol/){

      $res=~s/\n//g;
      $res=~s/\r//g;
      $res=~s/is /#/g;
      $res=~s/,/#/g;
      @ist=split(/#/,$res);

#print "###### $res \n";
      $int_status=$ist[1];
      $int_line_protocol_status=$ist[3];
      $int_line_protocol_status=~s/ //g;

      $interface=$ist[0];

      $interface=~s/ //g;

      if ($interface=~/[0-9]\.[0-9]$/){

     #    print "entrou interface logica\n";
         $interface_logica=$interface;

      }
      else{


         $interface_fisica=$interface;

      }

   }


################rely e load 
   if ($res=~/reliability/){

      @ist=split(/,/,$res);

      $reli=$ist[0];


      $reli=~s/ reliability //g;
      $reli=~s/ //g;

      @rel=split(/\//,$reli); 

      if ($rel[1]>0){

         $int_rely=$rel[0]/$rel[1];
 
         $int_rely=sprintf("%.0f",$int_rely); 
      }
      else{

         $int_rely="";

      }

########################

      $loadtx=$ist[1];

      $loadtx=~s/ txload //g;

      @lo=split(/\//,$loadtx);  
    
      if ($lo[1]>0){

         $int_load_tx=$lo[0]/$lo[1];
         $int_load_tx=sprintf("%.1f",$int_load_tx);
      }
      else{

         $int_load_tx="";

      }   

######################

      $loadrx=$ist[2];

      $loadrx=~s/ rxload //g;

      @lo=split(/\//,$loadrx);  
    
      if ($lo[1]>0){

         $int_load_rx=$lo[0]/$lo[1];
         $int_load_rx=sprintf("%.1f",$int_load_rx);
      }
      else{

         $int_load_rx="";

      }   

    }
   if ($res=~/rely/){

      @ist=split(/,/,$res);

      $reli=$ist[3];


      $reli=~s/ rely //g;

      @rel=split(/\//,$reli); 

      if ($rel[1]>0){

         $int_rely=$rel[0]/$rel[1];
         $int_rely=sprintf("%.0f",$int_rely); 
      }
      else{

         $int_rely="";

      }
  
      $loadx=$ist[4];

      $loadx=~s/ load //g;

      @lo=split(/\//,$loadx);  
    
      if ($load[1]>0){

         $int_load=$lo[0]/$lo[1];
         $int_load_tx=sprintf("%.1f",$int_load);
         $int_load_rx=sprintf("%.1f",$int_load);

      }
      else{

         $int_load="";

      }   
   }
########################## PKT in out

   if ($res=~/input rate/){

      $rate_in=$res;
      $rate_in=~s/input rate /#/g;
      $rate_in=~s/ bits/#/g;      
           
      @ri=split(/#/,$rate_in);         

      $int_pkt_in=$ri[1];
       
   }


######################pkt out 

   if ($res=~/output rate/){

      $rate_in=$res;
      $rate_in=~s/output rate /#/g;
      $rate_in=~s/ bits/#/g;      
           
      @ri=split(/#/,$rate_in);         

      $int_pkt_out=$ri[1];
       
   }

#####int in errors | crc

   if ($res=~/input errors/){

      $rate_in=$res;
      #$rate_in=~s/minute output rate /#/g;
      #$rate_in=~s/ bits/#/g;      
           
      @ri=split(/,/,$rate_in);         

      $int_input_errors=$ri[0];

      $int_crc=$ri[1];

      $int_input_errors=~s/ input errors//g;
      $int_input_errors=~s/ //g;

      $int_crc=~s/ CRC//g;
      $int_crc=~s/ //g;
       
   }


#####int out errors | collisions | int resets ::: 0 output errors, 0 collisions, 0 interface resets

   if ($res=~/output errors/){

      $rate_in=$res;
           
      @ri=split(/,/,$rate_in);  

      $int_out_errors=$ri[0];
      $int_collisions=$ri[1];
      $int_resets=$ri[2];         


      $int_out_errors=~s/ output errors//g;
      $int_out_errors=~s/ //g;

      $int_collisions=~s/ collisions//g;
      $int_collisions=~s/ //g;

      $int_resets=~s/ interface resets//g;
      $int_resets=~s/ //g;
      $int_resets=~s/\n//g;
      $int_resets=~s/\r//g;
       
   }


############rtt

   if ($res=~/Success rate/){


      if ($res=~/=/){

         @inf=split(/ = /,$res);

         @rtts=split(/ /,$inf[1]);

         @rtt=split(/\//,@rtts[0]);

         $min=$rtt[0];
         $med=$rtt[1];
         $max=$rtt[2];
       
         $inf[0]=~s/\)/#/g;
         $inf[0]=~s/\(/#/g;

         @sents=split(/#/,$inf[0]); 
 
         @pkt=split(/\//,$sents[1]);

         $sent=$pkt[0];

         $received=$pkt[1];

         $status_ping="ok";
 
      }
      else{

         $res=~s/\)/#/g;
         $res=~s/\(/#/g;

         @sents=split(/#/,$res); 
 
         @pkt=split(/\//,$sents[1]);

         $sent=$pkt[0];

         $received=$pkt[1];

         $status_ping="falha";

         $min=".";
         $med=".";
         $max=".";

         
      }


   }



}


    $refi=$hostname_a."_".$interface_fisica;
    $refl=$hostname_a."_".$interface_logica;

    @fis=split(/;/,$hostname_interface{$refi});

    $int_status=$fis[2];
    $int_status=$fis[3];
    $int_crc=$fis[4];
    $int_input_errors=$fis[5];
    $int_out_errors=$fis[6];
    $int_load_rx=$fis[7];
    $int_load_tx=$fis[8];
    $int_collisions=$fis[9];
    $int_resets=$fis[10];
    $int_rely=$fis[11];
    $int_pkt_in=$fis[12];
    $int_pkt_out=$fis[13];

#print "$interface_logica ||| $refl --- $hostname_interface{$refl}\n";
    @log=split(/;/,$hostname_interface{$refl});

    $sub_int_status=$log[2];
    $sub_int_line_protocol_status=$log[3];

    $sub_int_crc=$log[4];
    $sub_int_input_errors=$log[5];
    $sub_int_out_errors=$log[6];
    $sub_int_load_rx=$log[7];
    $sub_int_load_tx=$log[8];
    $sub_int_collisions=$log[9];
    $sub_int_resets=$log[10];
    $sub_int_rely=$log[11];
    $sub_int_pkt_in=$log[12];
    $sub_int_pkt_out=$log[13];

if (length($interface_logica)>3){

$teste_st=$int_status." ".$int_line_protocol_status;
$teste_st=$teste_st." ".$sub_int_status." ".$sub_int_line_protocol_status;

}
else{

$teste_st=$int_status." ".$int_line_protocol_status;

}

   if ($teste_st=~/down/){

      $status="falha";

   }
   else {

      $status="ok";

   }

####

#####fim coleta interfaces
my        $t=time();

my        ($seg,$min,$hora,$dia_m,$mes,$ano,$dia_s,$dia_a,$isdst)=localtime($t);

my        $mess=$mes+1;

my        $anos=1900+$ano;

my        $data_reg=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$anos,$mess,$dia_m,$hora,$min,$seg);

my        $intx=$int_pe;
#          $intx=~s/\//_/g; 

          $inty=$int_pe;
          $inty=~s/_/\//g;  

my        $arqs=$cod."_".$hostname_a."_".$intx;

my        $name=$cod."_".$hostname_a;
#print "$arqs\n";
        open(his,"/fping4.0/robo_ping/log/$arqs");

my        @dados=<his>;

        close(his);

my        $c=0;

my        %teste_ant=();

$total_sent=0;
$total_recebido=0;

        foreach my $item (@dados){

           $item=~s/\n//g;
           $item=~s/\r//g;
           @dd=split(/;/,$item);

           $total_sent=$total_sent+$dd[9];

           $total_recebido=$total_recebido+$dd[10];

#print "$dd[9] --- $dd[10] \n";
           if ($c==0){

              $ref=$dd[2]."_".$dd[3];
           print "$ref ---- $item ### \n"; 
              $teste_ant{$ref}=$item;

           }

           if ($c<7){

#####crc
              if ($dd[33]>100){

                 $conta_crc++;

              }

#### in e out errors

             if ($dd[34]>100 or $dd[35]>100){

                $conta_errors++

             }
#### collisions

             if ($dd[36]>100){

                $conta_collisions++

             }

###int resets

             if ($dd[37]>1){

                $conta_resets++;

             }
###trafego

             if ($dd[23]>79 or $dd[24]>79){

                $conta_trafego++;

             }

             if ($dd[27]<1 and $dd[27]>0){

               $conta_reli++; 

             }
           }

           $c++;
 
           if ($c>20){ 

               last;

           } 
        }


if ($total_sent>0){
$pkt_loss=($total_sent-$total_recebido)/$total_sent;
}
#print "loss $pkt_loss\n";
$intx=$int_pe;
$intx=~s/_/\//g;

my        $refx=$hostname_a."_".$intx;

print "!!!!! $refx @@@@@ $teste_ant{$refx} !!!!!  \n";

my        @st_old=split(/;/,$teste_ant{$refx});

my        $status_ant=$st_old[7];

        $crc_o=$st_old[20];
        $err_in_o=$st_old[21];
        $err_out_o=$st_old[22];
        $collisions_o=$st_old[25];
        $resetes_o=$st_old[26];

$inc_crc=$int_crc-$crc_o;
$inc_err_in=$int_input_errors-$err_in_o;
$inc_err_out=$int_out_errors-$err_out_o;
$inc_collisions=$int_collisions-$collisions_o;
$inc_resets=$int_resets-$resetes_o;

$st_errors="ok";

if ($inc_crc>100){

   $conta_crc++;
}

if ($conta_crc>2){

$st_errors=~s/ok//g;
$st_errors=$st_errors." crc";

}

if ($inc_err_in>100 or $inc_err_out>100){

   $conta_errors++;

}

if ($conta_err>2){

$st_errors=~s/ok//g;
$st_errors=$st_errors." in/out errors";

}

if ($inc_collisions>100){

   $conta_collisions++;
}

if ($conta_collisions>5){

$st_errors=~s/ok//g;
$st_errors=$st_errors." collisions";

}

if ($inc_resets>1){

   $conta_resets++;
}

if ($conta_resets>5){

$st_errors=~s/ok//g;
$st_errors=$st_errors." int resets";

}

if ($st_errors=~/ok/){


}
else{

$st_errors="loss ".$st_errors;

}

#print "$status_ant ---- $status \n";


        if ($status_ant eq $status){

           $tx=$st_old[5];
           $data_regx=$st_old[6];
print "aqui $tx --- $data_regx \n";
        }
        else{
           $tx=$t;
           $data_regx=$data_reg;
        }



        open($name,">/fping4.0/robo_ping/log/$arqs");


    print $name "$t;$data_reg;$hostname_a;$inty;$cod;$tx;$data_regx;$status;$status_ping;$sent;$received;$min;$med;$max;";
    print $name "$interface_fisica;$interface_logica;$int_status;$int_line_protocol_status;$sub_int_status;";
    print $name "$sub_int_line_protocol_status;$int_crc;$int_input_errors;$int_out_errors;$int_load_rx;$int_load_tx;";
    print $name "$int_collisions;$int_resets;$int_rely;$int_pkt_in;$int_pkt_out;$sub_int_load_rx;$sub_int_load_tx;";
    print $name "$sub_int_rely;$inc_crc;$inc_err_in;$inc_err_out;$inc_collisions;$inc_resets;";
    print $name "$telnet_st;$total_sent;$total_recebido;\n";

        foreach $item (@dados){

           $item=~s/\n//g;
           $item=~s/\r//g;           
           print $name "$item\n";

           $c++;

           if ($c>288){
              last;
           }
        }

    close($name);
####

exit
