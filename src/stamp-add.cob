identification division.
program-id. kintai-stamp-add.

environment division.
input-output section.
       file-control.
           select user-file assign to "./dat/stamp.dat"
               organization relative
               access mode sequential
               relative key user-key
               status user-status.
           select stamp-file assign to "./dat/stamp.dat"
               organization relative
               access mode sequential
               relative key stamp-key
               status stamp-status.
           select status-file assign to "./dat/status.dat"
               organization relative
               access mode sequential
               status status-status.
           select log-file assign to "./dat/log.dat"
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
               03 log-timestamp pic X(21).
               03 log-comments pic X(128).
working-storage section.
       01 key-rec.
           03 user-key pic 9(7).
           03 stamp-key pic 9(12).
       01 status-rec.
           03 user-status pic XX.
           03 stamp-status pic XX.
           03 status-status pic XX.
           03 log-status pic XX.
       01 auth-rec.
           03 auth-username pic X(64).
           03 auth-password pic X(20).
           03 miss-count pic 9 values 0.

procedure division.
       display "勤怠管理システム".
       display "勤怠追加モード".

authenticate-username.
       display "ユーザ認証を行います".
       display "ユーザ名を入力してください".
       accept auth-username.

       open input user-file.
       perform until user-status not = "00"
           if auth-username = Fusername then
               close user-file
               go to authenticate-password
           end-if
       end-perform.

       display "ユーザが見つかりません".
       display "もう一度入力してください".
       go to authenticate-username.

authenticate-password.
       display "パスワードを入力してください".
       accept auth-password.

       if miss-count >= 3 then
           display "ユーザ認証に3回失敗しました"
           display "プログラムを強制終了します"
           go to authenticate-logging
       end-if.

       if auth-password = Fpswd then
           go to stamp-procedure
       end-if.

       display "パスワードの認証に失敗しました".
       display "もう一度入力してください".
       add 1 to miss-count.

       go to authenticate-password.

authenticate-logging.
       open extend log-file.
       move function current-date to log-timestamp.
       string
           "[ERRO] " delimited by size
           function trim(auth-username) delimited by size
           " failed authentication 3 times."
           into log-comments
       end-string.
       write Flog-rec.
       close log-file.
       stop run.

stamp-procedure.
       move Fuser-id to Fstamp-userid.
       move function current-date to Fstamp-datetime.

       display "以下の番号を入力してください".
       open input status-file.
       perform until status-status not = "00"
           read status-file
           display Fstatus-rec
       end-perform.
       close status-file.

       accept Fstamp-statusid.
       open input status-file.
       perform until status-status not = "00"
           read status-file
           if Fstamp-statusid = Fstatus-id then
               move Fstatus-id to Fstamp-statusid
               go to write-procedure
           end-if
       end-perform.

       display "ステータスが存在しません".
       display "もう一度、入力してください".
       go to stamp-procedure.

write-procedure.
       move stamp-key to Fstamp-id.

       open extend stamp-file.
       write Fstamp-rec.
       close stamp-file.

       display "打刻しました".
       display function trim(Flastname) " " function trim(Ffirstname).
       display Fstamp-datetime.
       display Fstatus-name.

       stop run.