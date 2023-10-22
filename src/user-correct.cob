identification division.
program-id. kintai-user-correct.

environment division.
input-output section.
       file-control.
           select user-file assign to "./dat/user.dat"
               organization relative
               access mode sequential
               relative key user-key
               status user-status.
           select roll-file assign to "./dat/roll.dat"
               organization relative
               access mode sequential
               relative key roll-key
               status roll-status.
           select log-file assign to "./dat/log.dat"
               organization line sequential.
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
       fd roll-file.
           01 roll-rec.
               03 Froll-id pic 9(2).
               03 Froll-name pic N(10).
       fd log-file.
           01 log-rec.
               03 log-timestamp pic X(21).
               03 log-comments pic X(128).
working-storage section.
       01 file-keys.
           03 user-key pic 9(7).
           03 roll-key pic 99.
           03 gender-key pic 99.
       01 file-statuses.
           03 user-status pic XX.
           03 roll-status pic XX.
           03 gender-status pic XX.
       01 Ouser-rec.
           03 Ouser-id pic 9(7).
           03 Ousername pic X(64).
           03 Ofirstname pic N(32) usage national.
           03 Olastname pic N(32).
           03 Opswd pic X(20).
           03 Ogender pic 9(2).
           03 Oaddress pic N(70).
           03 Oemail pic X(254).
           03 Ophone-number pic X(14).
           03 Oroll pic 9(2).
           03 Ojoin-date pic X(21).
       01 select-userid pic 9(7).
       01 mode-select pic 9.
       01 phone-tallying pic 9.
       01 mail-rec.
           03 mail-tallying pic 9.
           03 mail-domain pic X(254).
           03 mail-local pic X(254).
       
       01 auth-rec.
           03 auth-username pic X(64).
           03 auth-password pic X(20).
           03 auth-cnt pic 9 value 0.
procedure division.
       display "勤怠管理システム".
       display "ユーザデータ修正モード".

main-procedure.
       display "修正する人のユーザIDを入力してください".
       accept select-userid.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           if Fuser-id = select-userid then
               close user-file
               go to correct-procedure
           end-if
       end-perform.
       close user-file.
       display "ユーザが見つかりませんでした".
       go to main-procedure.

correct-procedure.
       display "修正するユーザの情報は下記の通りです"
       display Fuser-id.
       display function trim(Fusername).
       display function trim(Flastname) " " function trim(Ffirstname).
       display Fgender.
       display function trim(Faddress).
       display function trim(Femail).
       display function trim(Fphone-number).
       display Froll.
       display Fjoin-date.

       *> Ouser-recに変更したい内容が転記される
       *> これによって、Ouser-recを変更した項目のみが反映される
       *> Fuser-recを使わないのは、データの照会に
       move Fuser-rec to Ouser-rec.

attention-procedure.
       display "修正したい項目の数字を入力してください".
       display "1. ユーザ名を".
       display "2. 姓を".
       display "3. 名を".
       display "4. 電話番号を".
       display "5. メールアドレスを".
       display "6. 住所を".
       display "7. 役職を".
       display "8. パスワードを".
       accept mode-select.

       evaluate mode-select
       when 1
           go to correct-username
       when 2
           go to correct-lastname
       when 3
           go to correct-firstname
       when 4
           go to correct-phone-number
       when 5
           go to correct-email
       when 6
           go to correct-address
       when 7
           go to correct-roll
       when 8
           go to correct-pswd
       when other
           display "指定されたモードがありません"
           go to attention-procedure
       end-evaluate.

       display "修正する内容を入力してください".

correct-username.
       accept Ousername.

       if function length(function trim(Ousername)) < 0 then
           display "ユーザ名は1文字以上で入力してください"
           go to correct-username
       end-if.
       
       if function length(function trim(Ousername)) > 64 then
           display "ユーザ名は64文字以下で入力してください"
           go to correct-username
       end-if.

       open input user-file.
       move select-userid to user-key.
       read user-file.
       if Ousername = Fusername then
           display "ユーザ名が重複しています"
           display "ほかの候補を考えてください"
           close user-file
           go to correct-username
       end-if.

       go to authenticate-procedure.

correct-firstname.
       accept Ofirstname.

       if function length(function trim(Ofirstname)) < 0 then
           display "名は1文字以上で入力してください"
           go to correct-firstname
       end-if.

       if function length(function trim(Ofirstname)) > 64 then
           display "名は64文字以下で入力してください"
           go to correct-firstname
       end-if.

       go to authenticate-procedure.
correct-lastname.
       accept Olastname.

       if function length(function trim(Olastname)) < 0 then
           display "姓は1文字以上で入力してください"
           go to correct-lastname
       end-if.

       if function length(function trim(Olastname)) > 64 then
           display "姓は64文字以下で入力してください"
           go to correct-lastname
       end-if.

       go to authenticate-procedure.

correct-pswd.
       accept Opswd.

       if function length(function trim(Opswd)) < 0 then
           display "パスワードは1文字以上で入力してください"
           go to correct-pswd
       end-if.

       if function length(function trim(Opswd)) > 64 then
           display "パスワードは64文字以下で入力してください"
           go to correct-pswd
       end-if.

       go to authenticate-procedure.

correct-address.
       accept Oaddress.

       if function length(function trim(Oaddress)) < 0 then
           display "住所は1文字以上で入力してください"
           go to correct-address
       end-if.

       if function length(function trim(Oaddress)) > 70 then
           display "住所は70文字以下で入力してください"
           go to correct-address
       end-if.

       go to authenticate-procedure.

correct-email.
       accept Oemail.

       if function length(function trim(Oemail)) < 5 then
           display "メールアドレスは5文字以上で入力してください"
           go to correct-email
       end-if.

       if function length(function trim(Oemail)) > 254 then
           display "メールアドレスは254文字以下で入力してください"
           go to correct-email
       end-if.

       move 0 to mail-tallying.
       inspect function trim(Oemail)
           tallying mail-tallying for all "..".
       
       if mail-tallying > 0 then
           display "メールアドレスでピリオドが2つ連続しています"
           go to correct-email
       end-if.

       if Oemail(function length(function trim(Oemail)):1) = "." then
           display "メールアドレス終端にピリオドがあります"
           go to correct-email
       end-if.

       move 0 to mail-tallying.
       inspect function trim(Oemail)
           tallying mail-tallying for all " ".

       if mail-tallying > 0 then
           display "メールアドレスに空白があります"
           go to correct-email
       end-if.

       if Oemail(1:1) = "." then
           display "メールアドレス始端にピリオドがあります"
           go to correct-email
       end-if.

       move 0 to mail-tallying.
       unstring Oemail delimited by "@"
           into mail-local mail-domain
           tallying in mail-tallying.
       
       if mail-tallying > 1 then
           display "@が2以上あります"
           go to correct-email
       end-if.

       if mail-local(function length(function trim(mail-local)):1) = "." then
           display "ローカル部の終端にピリオドがあります"
           go to correct-email
       end-if.

       move 0 to mail-tallying.
       inspect function trim(mail-domain)
           tallying mail-tallying for all ".".
       
       if mail-tallying <= 0 then
           display "ドメイン部には1つ以上のピリオドが必要です"
           go to correct-email
       end-if.

       go to authenticate-procedure.

correct-phone-number.
       accept Ophone-number.

       if function length(function trim(Ophone-number)) < 0 then
           display "電話番号は1文字以上で入力してください"
           go to correct-pswd
       end-if.

       if function length(function trim(Ophone-number)) > 14 then
           display "電話番号は14文字以下で入力してください"
           go to correct-pswd
       end-if.

       move 0 to phone-tallying.
       inspect function trim(Ophone-number)
           tallying phone-tallying for all "--".
           
       if phone-tallying > 0 then
           display "ハイフンが連続しています"
           go to correct-phone-number
       end-if.

       go to authenticate-procedure.
correct-roll.
       display "役職IDを表示します".
       open input roll-file.
       perform until roll-status not = "00"
           read roll-file
           display roll-rec
       end-perform.
       close roll-file.

       display "役職IDを入力してください".
       accept Oroll.

       open input roll-file.
       perform until roll-status not = "00"
           read roll-file
           if Froll-id = Oroll then
               close roll-file
               go to authenticate-procedure    *> ここで認証に飛ばす
           end-if
       end-perform.
       close roll-file.

       display "役職IDが正しくありません".
       go to correct-roll.

authenticate-procedure.
       display "承認者のユーザ名を入力してください".
       accept auth-username.
       display "承認者のパスワードを入力してください".
       accept auth-password.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           if Fuser-id = auth-username and Fpswd = auth-password then
               close user-file
               go to end-procedure
           end-if
       end-perform.
       close user-file.

       if auth-cnt < 3 then
           display "該当する承認者がいません"
           display "もう一度入力してください"
           add 1 to auth-cnt
           go to authenticate-procedure
       end-if.

       display "3回間違えたのでプログラムを強制終了します".

       move function current-date to log-timestamp.
       string
           "[ERRO] " delimited by size
           function trim(auth-username) delimited by size
           " failed authenticattion 3 times."
           into log-comments
       end-string.

       open extend log-file.
       write log-rec.
       close log-file.

       stop run.

end-procedure.
       open input user-file.
       perform until user-status not = "00"
           read user-file
           if select-userid = Fuser-id then
               close user-file
               go to finalize-procedure
           end-if
       end-perform.
       close user-file.

       display "ユーザが見つかりませんでした:" select-userid.
       display "強制終了します".
       stop run.

finalize-procedure.
       *> user-keyに書き出す相対番号を指定する
       move select-userid to user-key.
       move Ouser-rec to Fuser-rec.
       open output user-file.
       write Fuser-rec.    *> user-keyにレコードが転記される
       close user-file.

logging-procedure.
       move function current-date to log-timestamp.
       open extend log-file.
       string
           "[INFO] " delimited by size
           "corrected for mode " delimited by size
           mode-select delimited by size
           into log-comments
       end-string.
       write log-rec.
       close log-file.

stop-procedure.
       stop run.
