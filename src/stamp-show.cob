identification division.
program-id. kintai-stamp-show.
environment division.
input-output section.
       file-control.
       select user-file assign to "./dat/user.dat"
           organization relative
           access mode sequential
           relative key is user-key
           status user-status.
       select stamp-file assign to "./dat/stamp.dat"
           organization relative
           access mode sequential
           relative key is stamp-key
           status stamp-status.
       select status-file assign to "./dat/status.dat"
           organization relative
           access mode sequential
           relative key is status-key
           status status-status.
       select log-file assign to "./sat/log.dat"
           organization relative
           access mode sequential
           status log-status.
data division.
file section.
       fd user-file.
           01 Fuser-rec.
               03 Fuser-id pic 9(7).
               03 Fusername pic X(64).
               03 Ffirstname pic N(32) usage national.
               03 Flastname pic N(32).
               03 Fpswd pic X(20).
               03 Fgender pic 9(2).
               03 Faddress pic N(70).
               03 Femail pic X(254).
               03 Fphone-number pic X(14).
               03 Froll pic 9(2).
               03 Fjoin-date pic X(21).
       fd stamp-file.
           01 Fstamp-rec.
               03 Fstamp-id pic 9(12).
               03 Fstamp-userid pic 9(7).
               03 Fstamp-datetime pic X(21).
               03 Fstamp-statusid pic 9.
       fd status-file.
           01 Fstatus-rec.
               03 Fstatus-id pic 9.
               03 Fstatus-name pic N(5).
       fd log-file.
           01 Flog-rec.
               03 Flog-timestamp pic X(21).
               03 Flog-comments pic X(128).
working-storage section.
       01 status-rec.
           03 user-status pic XX.
           03 stamp-status pic XX.
           03 status-status pic XX.
           03 log-status pic XX.
       01 key-rec.
           03 user-key pic 9(7).
           03 stamp-key pic 9(12).
           03 status-key pic 9.
       01 auth-rec.
           03 auth-username pic X(64).
           03 auth-password pic X(20).
           03 auth-cnt pic 9 value 0.
       01 Dstamp-rec-num pic 99.
       01 Dstamp-rec occurs 1 to 99
               depending on Dstamp-rec-num
               indexed by Dstamp-cnt.
           03 Dstamp-id pic 9(12).
           03 Dstamp-userid pic 9(7).
           03 Dstamp-datetime pic X(21).
           03 Dstamp-statusid pic 9.

       01 stamp-name pic N(5).
       01 Dstamp-count pic 9(12) value 0.
       01 command pic X.

procedure division.
       display "勤怠管理システム".
       display "勤怠修正モード".

authenticate-username.
       display "ユーザ認証を行います".
       display "ユーザ名を入力してください".
       accept auth-username.

       open input user-file.
       perform until user-status not = "00"
           read user-file
               at end continue
               not at end
                   if Fusername = auth-username then
                       close user-file
                       go to authenticate-password
                   end-if
       end-perform.

       display "ユーザが見つかりませんでした".
       go to authenticate-username.

authenticate-password.
       display "パスワードを入力してください".
       accept auth-password.

       if auth-cnt >= 3 then
           go to logging-and-shutdown
       end-if.

       if auth-password = Fpswd then
           go to show-stamp-procedure
       end-if.

       add 1 to auth-cnt.
       display "パスワードが間違っています".
       go to authenticate-password.

logging-and-shutdown.
       display "パスワードを3回間違えました".
       display "プログラムを強制終了します".

       output extend log-file.
       move function current-date to Flog-timestamp.
       string
           "[ERRO] "
           function trim(auth-username)
           " failed login 3 times."
           into Flog-comments.
       write Flog-rec.
       close log-file.
       stop run.

show-stamp-procedure.
       display "1ページに記入する数を入力してください [1-99]".
       accept Dstamp-rec-num.

       move zero to Dstamp-count.

       open input stamp-file.
       perform until stamp-status not = "00"
           read Dstamp-rec
           if Dstamp-userid = Fuser-id then
               add 1 to Dstamp-count
           end-if
       end-perform
       close stamp-file.

       display Dstamp-count " 件のデータが見つかりました".
       open input stamp-file.  *> プログラムが終了するまで永続化する

command-accept.
       display "[f]irst, [b]ack, [n]ext, [l]ast, [e]xit".
       accept command.

       evaluate command
       when "f"
           move 1 to stamp-key
           go to pagenation-stamp-next
       when "n"
           go to pagenation-stamp-next
       when "b"
           
       when "l"
           move Dstamp-count to stamp-key
       when "e"    *> exitコマンドが投入されたら終了する
           close stamp-file    *> プログラムが終了したので永続化を切る
           stop run
       when other
           display "認識できないコマンドです"
           go to command-accept
       end-evaluate.

pagenation-stamp-next.
       move zero to Dstamp-cnt.
       perform until stamp-status not = "00"
           read stamp-file

           if Dstamp-userid = Fuser-id then
               move Fstamp-rec to Dstamp-rec(Dstamp-cnt)
               add 1 to Dstamp-cnt
           end-if

           if Dstamp-cnt > Dstamp-rec-num then
               go to display-procedure
           end-if
       end-perform.

       display "記録はここまでです".
       go to command-accept.

pagenation-stamp-back.
       move zero to Dstamp-cnt.
       subtract 1 from stamp-key.

       if stamp-key <= 0 then
           go to command-accept
       end-if.

       perform until stamp-status not = "00"
           read stamp-file
           move stamp-file to Dstamp-rec(Dstamp-cnt)

           if Dstamp-userid = Fuser-id then
               move Fstamp-rec to Dstamp-rec(Dstamp-cnt)
               add 1 to Dstamp-cnt
               subtract 2 from stamp-key   *> 読み込むと1件進むので、2件戻す

               if stamp-key <= then
                   go to command-accept
               end-if
           end-if

           if Dstamp-cnt > Dstamp-rec-num then
               go to display-back-procedure
           end-if
       end-perform.

display-next-procedure.
       open input status-file
       move zero to Dstamp-cnt.
       perform varying Dstamp-cnt 
               from 1 by 1 until Dstamp-cnt < Dstamp-rec-num
           
           move Dstamp-statusid(Dstamp-cnt) to status-key
           read status-file
           
           display 
               Dstamp-id(Dstamp-cnt) " "
               Dstamp-datetime(Dstamp-cnt) " "
               Fstatus-name
       end-perform.
       close status-file.
       go to command-accept.

display-back-procedure.
       open input status-file
       move zero to Dstamp-cnt.
       perform varying Dstamp-cnt
               from Dstamp-rec-num by -1 until Dstamp-cnt > 0
           
           move Dstamp-statusid(Dstamp-cnt) to status-key
           read status-file

           display 
               Dstamp-id(Dstamp-cnt) " "
               Dstamp-datetime(Dstamp-cnt) " "
               Fstatus-name
       end-perform.
       close status-file.
       go to command-accept.
