#!/usr/bin/perl 

use Net::Telnet::Cisco();

my $login="caincl";
my $pass="abacaxi";

# INICIO DO SCRTPT

$diretorio="/fping4.0/routers_ebt";

# abro o diretó
#opendir (MEUDIR, "$diretorio");
#@pegoodir = readdir(MEUDIR);
#closedir (MEUDIR);

#   foreach (@pegoodir) {

#   $dados = $_; # como sóiste uma coluna no vetor, utilizei o $_ para pegar esta coluna.


#      if ($dados eq '.'){next}

#      if ($dados eq '..'){next}

my $dados=$ARGV[0];

my      @dd=split(/\./,$dados);

open(teste,">/fping4.0/robo_ping/t.txt");      

      open (log_rtt,"$diretorio/$dados");

      @rttx=<log_rtt>;

      close (log_rtt);

      my $s = Net::Telnet::Cisco->new(Timeout=>90);

my      $host=$dd[0].".".$dd[1].".embratel.net.br";

      $s->open($host);
      $s->cmd("$login\n$pass\n");
#      $s->cmd("en\n$pass\n");

      foreach $ln (@rttx){

my         @inf=split(/;/,$ln);

my         $hostname_a=$inf[1];
my         $interface_a=$inf[2];
my         $ip_a=$inf[3];
my         $hostname_b=$inf[4];
my         $interface_b=$inf[5];
my         $ip_b=$inf[6];
my         $cod=$inf[7];
my         $vrf=$inf[8];
#         $interface_a=~s/[A-Za-z]//g;

#         $interface_a="Serial".$interface_a;

         if (length($vrf)>2){

            $vrf="vrf ".$inf[8];
         }
         else{

            $vrf="";
         }

my         @ping=$s->cmd("ping $vrf $ip_b\n");

         $s->waitfor_pause(1);

         foreach my $res (@ping){

#            print "$res \n";
############rtt

            if ($res=~/Success rate/){

print "#####entrou##### $res \n";
               if ($res=~/=/){

                  @inf=split(/=/,$res);

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

                  $status="ok";
 
               }
               else{

                  $res=~s/\)/#/g;
                  $res=~s/\(/#/g;

                  @sents=split(/#/,$res); 
 
                  @pkt=split(/\//,$sents[1]);

                  $sent=$pkt[0];

                  $received=$pkt[1];

                  $status="falha";

                  $min=".";
                  $med=".";
                  $max=".";

                  
               }


            }

         }

#print "$min;$med;$max;$status\n";

         if ($interface_a=~/[0-9]\.[0-9]$/){

            @show_int=$s->cmd("sh int $interface_a\n");

#############interface cheia

            $int_status="";
            $int_line_protocol_status="";

            $int_rely="";
            $int_load="";
            $int_load_tx="";
            $int_load_rx="";
            $int_pkt_in="";
            $int_pkt_out="";

#            $int_broadcast="";

            $int_input_errors="";
            $int_crc="";
            $int_out_errors="";
            $int_collisions="";
            $int_resets="";  

            foreach my $res (@show_int){

               print "$res\n";

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

               if ($res=~/minute input rate/){

                  $rate_in=$res;
                  $rate_in=~s/minute input rate /#/g;
                  $rate_in=~s/ bits/#/g;                  
           
                  @ri=split(/#/,$rate_in);         

                  $int_pkt_in=$ri[1];
                   
               }


######################pkt out 

               if ($res=~/minute output rate/){

                  $rate_in=$res;
                  $rate_in=~s/minute output rate /#/g;
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


#############################

            }

            @intc=split(/\./,$interface_a);

            $sub=pop(@intc);

            $nint="";
            $n=0;
            foreach $si (@intc){

               if ($n==0){

                 $nint=$si;
                }
                else{
                  $nint=$nint.".".$si;


                }
               $n++;
            }

            @show_int=$s->cmd("sh int $nint\n");

####subinterface 

            $sub_int_status="";
            $sub_int_line_protocol_status="";
            $sub_int_rely="";
            $sub_int_load="";

            foreach my $res (@show_int){

                  $res=~s/\n//g;
                  $res=~s/\r//g;
               print "$res\n";

               if ($res=~/line protocol/){

                  $res=~s/is /#/g;
                  $res=~s/,/#/g;
                  @ist=split(/#/,$res);

                  $sub_int_status=$ist[1];
                  $sub_int_line_protocol_status=$ist[2];

               }

################rely e load 
################rely e load 1
               if ($res=~/reliability/){

                  @ist=split(/,/,$res);

                  $reli=$ist[0];


                  $reli=~s/ reliability //g;
                  $reli=~s/ //g;

                  @rel=split(/\//,$reli);

                  if ($rel[1]>0){

                     $int_rely=$rel[0]/$rel[1];
                     $sub_int_rely=sprintf("%.0f",$int_rely);
                  }
                  else{

                     $sub_int_rely="";

                  }

########################

                  $loadtx=$ist[1];

                  $loadtx=~s/ txload //g;

                  @lo=split(/\//,$loadtx);

                  if ($lo[1]>0){

                     $int_load_tx=$lo[0]/$lo[1];
                     $sub_int_load_tx=sprintf("%.1f",$int_load_tx);
                  }
                  else{

                     $sub_int_load_tx="";

                  }

######################
                  $loadrx=$ist[2];

                  $loadrx=~s/ rxload //g;

                  @lo=split(/\//,$loadrx);

                  if ($lo[1]>0){

                     $int_load_rx=$lo[0]/$lo[1];
                     $sub_int_load_rx=sprintf("%.1f",$int_load_rx);
                  }
                  else{

                     $sub_int_load_rx="";

                  }

                }

               if ($res=~/rely/){

                  @ist=split(/,/,$res);

                  $reli=$ist[3];


                  $reli=~s/ rely //g;

                  @rel=split(/\//,$reli); 

                  if ($rel[1]>0){

                     $sub_int_rely=$rel[0]/$rel[1];
                     $sub_int_rely=sprintf("%.1f",$sub_int_rely);  
                  }
                  else{

                     $sub_int_rely="";

                  }
  
                  $loadx=$ist[4];

                  $loadx=~s/ load //g;

                  @lo=split(/\//,$loadx);  
                
                  if ($load[1]>0){

                     $sub_int_load=$lo[0]/$lo[1];
                     $sub_int_load_tx=sprintf("%.1f",$sub_int_load);
                     $sub_int_load_rx=sprintf("%.1f",$sub_int_load); 
                  }
                  else{

                     $sub_int_load="";

                  }   
               }

            }
#############fim for sub

#fim if
         }
         else{

            @show_int=$s->cmd("sh int $interface_a\n");

            $int_status="";
            $int_line_protocol_status="";

            $int_rely="";
            $int_load="";

            $int_pkt_in="";
            $int_pkt_out="";

#            $int_broadcast="";

            $int_input_errors="";
            $int_crc="";
            $int_out_errors="";
            $int_collisions="";
            $int_resets="";  
            $sub_int_status="-";
            $sub_int_line_protocol_status="-";
            $sub_int_rely="-";
            $sub_int_load="-";
            $sub_int_load_tx="-";
            $sub_int_load_rx="-";
            $int_rely="";
            $int_load="";
            $int_load_tx="";
            $int_load_rx="";

            foreach my $res (@show_int){

                  $res=~s/\n//g;
                  $res=~s/\r//g;
               #print "$res";

#print "$res \n";
################interface status

               if ($res=~/line protocol/){

                  $res=~s/is /#/g;
                  $res=~s/,/#/g;
                  @ist=split(/#/,$res);
#print "$res \n";
                  $int_status=$ist[1];
                  $int_line_protocol_status=$ist[3];

               }


################rely e load 1 
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

#print "$res \n";
                  @ist=split(/,/,$res);

                  $reli=$ist[3];
#print "@ist \n";

                  $reli=~s/ rely //g;

                  @rel=split(/\//,$reli); 

                  if ($rel[1]>0){

                     $int_rely=$rel[0]/$rel[1];
  
                  }
                  else{

                     $int_rely="";

                  }
  
                  $loadx=$ist[4];

                  $loadx=~s/ load //g;

                  @lo=split(/\//,$loadx);  
                
                  if ($lo[1]>0){


                     $int_load=$lo[0]/$lo[1];

                     $int_load_tx=sprintf("%.1f",$int_load);
                     $int_load_rx=sprintf("%.1f",$int_load);

                  }
                  else{

                     $int_load="";

                  }   
                

               }
########################## PKT in out

               if ($res=~/minute input rate/){

                  $rate_in=$res;
                  $rate_in=~s/minute input rate /#/g;
                  $rate_in=~s/ bits/#/g;                  
           
                  @ri=split(/#/,$rate_in);         

                  $int_pkt_in=$ri[1];
                   
               }


######################pkt out 

               if ($res=~/minute output rate/){

                  $rate_in=$res;
                  $rate_in=~s/minute output rate /#/g;
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



            }

         }

#####fim coleta interfaces
my        $t=time();

my        ($seg,$min,$hora,$dia_m,$mes,$ano,$dia_s,$dia_a,$isdst)=localtime($t);

my        $mess=$mes+1;

my        $anos=1900+$ano;

my        $data_reg=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$anos,$mess,$dia_m,$hora,$min,$seg);

my        $intx=$interface_a;
        $intx=~s/\//_/g; 
my        $arqs=$cod."_".$hostname_a."_".$intx;

my        $name=$cod."_".$hostname_a;
#print "$arqs\n";
        open(his,"/fping4.0/robo_ping/log/$arqs");

my        @dados=<his>;

        close(his);

my        $c=0;

my        %teste_ant=();

        foreach my $item (@dados){

           $item=~s/\n//g;
           $item=~s/\r//g;
           @dd=split(/;/,$item);

           $ref=$dd[2]."_".$dd[3];
            
           $teste_ant{$ref}=$item;
           last;
        }

my        $refx=$hostname_a."_".$interface_a;

my        @st_old=split(/;/,$teste_ant{$refx});

my        $status_ant=$st_old[7];


        if ($status_ant eq $status){


           $tx=$st_old[0];
           $data_regx=$st_old[1];

        }
        else{
           $tx=$t;
           $data_regx=$data_reg;
        }



        open($name,">/fping4.0/robo_ping/log/$arqs");


    print $name "$t;$data_reg;$hostname_a;$interface_a;$cod;$tx;$data_regx;$status;$sent;$received;$min;$med;$max;";
    print $name "$int_status;$int_line_protocol_status;$sub_int_status;$sub_int_line_protocol_status;";
    print $name "$int_crc;$int_input_errors;$int_out_errors;$int_load_rx;$int_load_tx;$int_collisions;$int_resets;";
    print $name "$int_rely;$int_pkt_in;$int_pkt_out;$sub_int_load_rx;$sub_int_load_tx;";
    print $name "$sub_int_rely;\n";

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


       }
      $s->close();
#  print "$vrf"; 
#   } 

exit


