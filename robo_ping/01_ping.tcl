#!/usr/bin/expect -f

  set linha [split $argv *]

  set logpath "/fping4.0/robo_ping/log_telnet/"

  #####Password e Enable Password
  set pass "caincl"
  set enapass "abacaxi"
  ##############################################################################
  set timeout 5
  set data [exec date +%Y%m%d]


log_file "$logpath/[lindex $linha 1]-[lindex $linha 2]-[lindex $linha 10].txt"

  spawn ssh "10.98.22.213"
  expect "word:"
  send "1910\n"
  expect "#"
  send "telnet [lindex $linha 2].embratel.net.br\n"
  expect "name:"  
  send "$pass\n"
  expect "word:"
  send "$enapass\n"
  expect "#"
  send "show interface [lindex $linha 3]\n   "
           set timeout 15
           set ponteiro 1

  expect {

         "More" {
           while { $ponteiro < 1549 } {
                send " "
                expect {
                        "More" {
                                incr ponteiro
                        }
                        "#" {
                                set ponteiro 11250
                        }
                }
            incr ponteiro
           }
       
         }
        "#" {

           send "\n"

        }

}
 expect "#"
 send "show interface [lindex $linha 9]\n"
 expect "#"
 send "ping [lindex $linha 8] [lindex $linha 7]\n"

expect "#"
send "exit\n"

  log_file

  exit




