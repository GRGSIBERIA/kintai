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
           select gender-file assign to "./dat/gender.dat"
               organization relative
               access mode sequential
               relative key gender-key
               status gender-status.
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
       fd gender-file.
           01 gender-rec.
               03 Fgender-id pic 9(2).
               03 Fgender-name pic N(10).
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
       01 flags-rec.
           03 flag-username pic 9 value 0.
           03 flag-firstname pic 9 value 0.
           03 flag-lastname pic 9 value 0.
           03 flag-pswd pic 9 value 0.
           03 flag-address pic 9 value 0.
           03 flag-email pic 9 value 0.
           03 flag-phone-number pic 9 value 0.
           03 flag-roll pic 9 value 0.
       01 select-userid pic 9(7).
       01 mode-select pic 9.
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
       perform until user-status not = "00"
           read user-file
           if Ousername = Fusername then
               display "ユーザ名が重複しています"
               display "ほかの候補を考えてください"
               close user-file
               go to correct-username
           end-if
       end-perform.

       move 1 to flag-username.
       go to authenticate-procedure.

correct-firstname.
       
correct-lastname.

correct-pswd.

correct-address.

correct-email.

correct-phone-number.

correct-roll.

authenticate-procedure.

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
       go to stop-procedure.

finalize-procedure.
       *> user-keyに書き出す相対番号を指定する
       move select-userid to user-key.
       open output user-file.
       write Fuser-rec.    *> user-keyにレコードが転記される
       close user-file.

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
