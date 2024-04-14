#!/usr/bin/perl

#$t;0
#$dt;1
#$hostname; 2
#$int_s; 3
#$int_status / $protocolo_st; 4
#$descr;5
#$dcd;6
#$dsr;7
#$dtr;8
#$rts;9
#$cts;10
#$lt_clear;11 -> 1
#$pkt_in;12
#$bytes_in;13
#$pkt_out;14
#$bytes_out;15
#$input_error;16 -> 3
#$out_err;17 -> 4
#$collissions;18 -> 5
#$int_resets;19 ->6
#$total_drop;20 -> 7
#$crc_x;21 -> 8
#$data_reg;22
#$amb;23
#$cli;24
#$site;25
#$serv;26
#$usuario;27
#$crit;28
#$reli_m;29 -> 2
#$rxload;30
#$txload;31
#$status;\n";32

#################################################################
        #### abre hash get snmp

        $diretorio_errs="/coleta_crc/www";

%host_int_errs= () ;

        open(errh,"$diretorio_errs/coleta_cti_err_geral.txt");

        @rtt_linhas=<errh>;

        close(errh);

#print "$diretorio_errs/coleta_cti_err_geral.txt \n";
        foreach $lin (@rtt_linhas){

#print "$lin";
           $lin=~s/\n//g;
           $lin=~s/\r//g;

           @dd=split(/;/,$lin);

           #host_interface

           $ref=$dd[2]."_".$dd[3];

           $lst_clear_n=$dd[11];
           $pct_utl_n=$dd[29];
           $in_err_n=$dd[16];
           $out_err_n=$dd[17];
           $coll_n=$dd[18];
           $int_resest_n=$dd[19];
           $drop_n=$dd[20];
           $crc_n=$dd[21];

           $err_info=$lst_clear_n.";";
           $err_info=$err_info.$pct_utl_n.";";
           $err_info=$err_info.$in_err_n.";";
           $err_info=$err_info.$out_err_n.";";
           $err_info=$err_info.$coll_n.";";
           $err_info=$err_info.$int_resest_n.";";
           $err_info=$err_info.$drop_n.";";
           $err_info=$err_info.$crc_n.";";
#print "$ref - loss: int errors;$err_info \n";
           $host_int_errs{$ref}="loss: int errors;".$err_info;


        }

##


        open(errh1,"$diretorio_errs/coleta_cti_crc_geral.txt");

        @rtt_linhas=<errh1>;

        close(errh1);


        foreach $lin (@rtt_linhas){

           $lin=~s/\n//g;
           $lin=~s/\r//g;

           @dd=split(/;/,$lin);

           #host_interface

           $ref=$dd[2]."_".$dd[3];

           $lst_clear_n=$dd[11];
           $pct_utl_n=$dd[29];
           $in_err_n=$dd[16];
           $out_err_n=$dd[17];
           $coll_n=$dd[18];
           $int_resest_n=$dd[19];
           $drop_n=$dd[20];
           $crc_n=$dd[21];

           $err_info=$lst_clear_n.";";
           $err_info=$err_info.$pct_utl_n.";";
           $err_info=$err_info.$in_err_n.";";
           $err_info=$err_info.$out_err_n.";";
           $err_info=$err_info.$coll_n.";";
           $err_info=$err_info.$int_resest_n.";";
           $err_info=$err_info.$drop_n.";";
           $err_info=$err_info.$crc_n.";";

           $host_int_errs{$ref}="loss: int crc;".$err_info;


        }

###


        open(errh2,"$diretorio_errs/coleta_cti_trf_geral.txt");

        @rtt_linhas=<errh2>;

        close(errh2);


        foreach $lin (@rtt_linhas){

           $lin=~s/\n//g;
           $lin=~s/\r//g;

           @dd=split(/;/,$lin);

           #host_interface

           $ref=$dd[2]."_".$dd[3];

           $lst_clear_n=$dd[11];
           $pct_utl_n=$dd[29];
           $in_err_n=$dd[16];
           $out_err_n=$dd[17];
           $coll_n=$dd[18];
           $int_resest_n=$dd[19];
           $drop_n=$dd[20];
           $crc_n=$dd[21];

           $err_info=$lst_clear_n.";";
           $err_info=$err_info.$pct_utl_n.";";
           $err_info=$err_info.$in_err_n.";";
           $err_info=$err_info.$out_err_n.";";
           $err_info=$err_info.$coll_n.";";
           $err_info=$err_info.$int_resest_n.";";
           $err_info=$err_info.$drop_n.";";
           $err_info=$err_info.$crc_n.";";

           $host_int_errs{$ref}="crit: alto trafego;".$err_info;


        }

        #### fim int

#foreach $item (keys(%host_int_errs)){


#print "$host_int_errs{$item}\n";

#}
