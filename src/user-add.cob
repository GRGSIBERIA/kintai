identification division.
program-id. kintai-user-add.

environment division.
input-output section.
       file-control.
           select out-user assign to "./dat/user.dat"
               organization relative
               access mode sequential
               relative key out-key.
           select gender-file assign to "./dat/gender.dat"
               organization relative
               access mode sequential
               relative key gender-key
               status gender-status.
           select roll-file assign to "./dat/roll.dat"
               organization relative
               access mode sequential
               relative key roll-key
               status roll-status.
           select user-file assign to "./dat/user.dat"
               organization relative
               access mode sequential
               relative key user-key
               status user-status.
           select log-file assign to "./dat/log.dat"
               organization line sequential.
data division.
file section.
       fd out-user.
           01 out-user-rec.
               03 Ouserid pic 9(7).
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
       fd gender-file.
           01 Fgender-rec.
               03 Fgender-id pic 9(2).
               03 Fgender-name pic N(10).
       fd roll-file.
           01 Froll-rec.
               03 Froll-id pic 9(2).
               03 Froll-name pic N(10).
       fd user-file.
           01 user-rec.
               03 Fuserid pic 9(7).
               03 Fusername pic X(64).
               03 Ffirstname pic N(32).
               03 Flastname pic N(32).
               03 Fpswd pic X(20).
               03 Fgender pic 9(2).
               03 Faddress pic N(70).
               03 Femail pic X(254).
               03 Fphone-number pic X(14).
               03 Froll pic 9(2).
               03 Fjoin-date pic X(21).
       fd log-file.
           01 log-rec.
               03 log-timestamp pic X(21).
               03 log-comments pic X(128).
working-storage section.
       01 out-key pic 9(7).
       01 gender-key pic 9(2).
       01 roll-key pic 9(2).
       01 user-key pic 9(7).
       01 gender-status pic XX.
       01 roll-status pic XX.
       01 user-status pic XX.
       01 log-status pic XX.
       01 idx pic 9(7) value 0.
       01 yesno pic X.
       01 email-inspect pic 999.
       01 email-length pic 999.
       01 email-domain pic XXX.
       01 email-domain1 pic XXX.
       01 email-domain2 pic XXX.
       01 email-local pic XXX.
       01 email-tallying pic 9.
       01 pidx pic 99.
       01 pjdx pic 99.
       01 phone-inspect pic 9.
       01 phone-flag pic 9.
       01 phone-length pic 99.
       01 phone-numeric-array occurs 11.
           03 pnitem pic X.
       01 auth-user pic X(64).
       01 join-user pic X(64).
       01 auth-pass pic X(20).
       01 auth-times pic 9 values 0.
       
procedure division.
main section.
       display "勤怠管理システム".
       display "ユーザー追加モード".

exec-search-maximum-userid.
       move zero to idx.
       
       open input user-file.
       perform until user-status not = "00"
           read user-file
               not at end add 1 to idx
       end-perform.
       close user-file.

       add 1 to idx.
       move idx to Fuserid.
       display Fuserid.

exec-accept-username.
       display "ユーザ名 ([1-64]文字)".
       accept Ousername.

       open input user-file.
       perform until user-status not = "00"
           read user-file
               not at end if Ousername = Fusername then
                   display "ユーザ名が重複しています"
                   close user-file
                   go to exec-accept-username
               end-if
       end-perform.
       close user-file.

       if function length(function trim(Ousername)) < 1 then
           display "ユーザ名は1文字以上にしてください"
           go to exec-accept-username
       end-if.

       if function length(function trim(Ousername)) > 64 then
           display "ユーザ名は64文字以下にしてください"
           go to exec-accept-username
       end-if.

exec-accept-lastname.
       display "姓 ([1-32]文字)".
       accept Olastname.

       if function length(function trim(Olastname)) < 1 then
           display "1文字以上の姓を入力してください"
           go to exec-accept-lastname
       end-if.

       if function length(function trim(Olastname)) > 32 then
           display "32文字以下の姓を入力してください"
           go to exec-accept-lastname
       end-if.

exec-accept-firstname.
       display "名 ([1-32]文字)".
       accept Ofirstname.

       if function length(function trim(Ofirstname)) < 1 then
           display "1文字以上の名を入力してください"
           go to exec-accept-firstname
       end-if.

       if function length(function trim(Ofirstname)) > 32 then
           display "32文字以下の名を入力してください"
           go to exec-accept-firstname
       end-if.

exec-accept-password.
       display "パスワード ([1-20]文字)".
       accept Opswd.

       if function length(function trim(Opswd)) < 1 then
           display "1文字以上のパスワードを入力してください"
           go to exec-accept-password
       end-if.

       if function length(function trim(Opswd)) > 20 then
           display "20文字以下のパスワードを入力してください"
           go to exec-accept-password
       end-if.

exec-accept-gender.
       display "性別ID:".

       open input gender-file.
       perform until gender-status not = "00"
           read gender-file
               not at end display Fgender-rec
       end-perform.
       close gender-file.
       accept Ogender. *> ここで入力

       open input gender-file.
       perform until gender-status not = "00"
           read gender-file
               not at end if Ogender = Fgender-id then
                   close gender-file
                   go to exec-accept-roll
               end-if
       end-perform.

       close gender-file.
       display "性別IDが一致しません"
       go to exec-accept-gender.

exec-accept-roll.
       display "役職ID:".
       
       open input roll-file.
       perform until roll-status not = "00"
           read roll-file
               not at end display Froll-rec
       end-perform.
       close roll-file.
       accept Oroll. *> ここで入力

       open input roll-file.
       perform until roll-status not = "00"
           read roll-file
               not at end if Oroll = Froll-id
                   close roll-file
                  go to exec-accept-address *> 該当項目を見つけた
              end-if
       end-perform.

       close roll-file.
       display "役職IDが一致しません"
       go to exec-accept-roll.

exec-accept-address.
       display "住所 ([1-70]文字)".
       accept Oaddress.

       if function length(function trim(Oaddress)) < 1
           display "住所は1文字以上で入力してください"
           go to exec-accept-address
       end-if.

       if function length(function trim(Oaddress)) > 70
           display "住所は70文字以下で入力してください"
           go to exec-accept-address
       end-if.

exec-accept-email.
       display "メールアドレス ([1-254]文字)".
       accept Oemail.

       initialize email-domain.
       initialize email-local.
       initialize email-domain1.
       initialize email-domain2.

       if function length(function trim(Oemail)) < 1 then
           display "1文字以上のメールアドレスを入力してください"
           go to exec-accept-email
       end-if.
       
       if function length(function trim(Oemail)) > 254 then
           display "254文字以下のメールアドレスを入力してください"
           go to exec-accept-email
       end-if.

       move zero to email-tallying.
       unstring Oemail delimited by "@"
           into email-local email-domain
           tallying in email-tallying.
       
       if email-tallying not = 2 then
           display "ローカル部とドメイン部の区切り@が正しくありません"
           go to exec-accept-email
       end-if.

       if Oemail(1:1) = "." then
           display "始端にドットがあります"
           go to exec-accept-email
       end-if.

       move function length(function trim(Oemail)) to email-length.
       if Oemail(email-length:1) = "." then
           display "終端にドットがあります"
           go to exec-accept-email
       end-if.

       move zero to email-inspect.
       inspect function trim(Oemail) tallying
           email-inspect for all " ".
       
       if email-inspect > 0 then
           display "空白文字が存在します"
           go to exec-accept-email
       end-if.

       move zero to email-inspect.
       inspect Oemail tallying
           email-inspect for all "..".
       
       if email-inspect > 0 then
           display "ピリオドが連続しています"
           go to exec-accept-email
       end-if.

       move function length(function trim(email-local)) to email-length.
       if email-local(email-length:1) = "." then
           display "ローカル部の終端にピリオドがあります"
           go to exec-accept-email
       end-if.

       move zero to email-tallying.
       unstring email-domain delimited by "."
       into email-domain1 email-domain2
       tallying in email-tallying.
       
       if email-tallying <= 2 then
           display "ドメイン部のピリオドが1つ以上必要です"
           go to exec-accept-email
       end-if.

exec-accept-phone.
       display "電話番号".
       accept Ophone-number.

       if function length(function trim(Ophone-number)) < 1 then
           display "1文字以上の電話番号を入力してください"
           go to exec-accept-phone
       end-if.

       if function length(function trim(Ophone-number)) > 14 then
           display "14文字以下の電話番号を入力してください"
           go to exec-accept-phone
       end-if.

       *> is numericの挙動が不思議なので最後に判定する
       move "1" to pnitem(1).
       move "2" to pnitem(2).
       move "3" to pnitem(3).
       move "4" to pnitem(4).
       move "5" to pnitem(5).
       move "6" to pnitem(6).
       move "7" to pnitem(7).
       move "8" to pnitem(8).
       move "9" to pnitem(9).
       move "0" to pnitem(10).
       move "-" to pnitem(11).

       move function length(function trim(Ophone-number)) to phone-length.
       
       perform varying pidx from 1 by 1
       until pidx > phone-length
           
           move zero to phone-flag
           
           perform varying pjdx from 1 by 1
           until pjdx > 11
               if Ophone-number(pidx:1) = pnitem(pjdx) then
                   add 1 to phone-flag
               end-if
           end-perform

           if phone-flag = 0 then
               display "数字と-のみを入力してください"
               go to exec-accept-phone
           end-if
       
       end-perform.

       move zero to phone-inspect.
       inspect function trim(Ophone-number) tallying
           phone-inspect for all "--".
       
       if phone-inspect > 0 then
           display "ハイフン-が連続しています"
           go to exec-accept-phone
       end-if.
       
exec-accept-join.
       display "入社年月日(21桁): (例: YYYYMMDDhhmmss00+0900)".
       accept Ojoin-date.

       if function length(function trim(Ojoin-date)) not = 21 then
           display "書式に沿って入力してください"
           go to exec-accept-join
       end-if.

exec-yesno.
       display "入力された項目".
       display Ouserid.
       display function trim(Ousername).
       display function trim(Ofirstname).
       display function trim(Olastname).
       display "****"

       open input gender-file.
       perform until gender-status not = "00"
           if Fgender-id = Ogender then
               display Fgender-name
           end-if
       end-perform.
       close gender-file.

       open input roll-file.
       perform until roll-status not = "00"
           if Froll-id = Oroll then
               display Froll-name
           end-if
       end-perform.
       
       display function trim(Oaddress).
       display function trim(Oemail).
       display function trim(Ophone-number).
       display Ojoin-date.

       display "間違いはないですか？ [y/n]".
       accept yesno.
       if function trim(yesno) not = "y" then
           go to exec-search-maximum-userid
       end-if.

exec-authenticate-user.
       move Fuserid to join-user.
       move zero to auth-times.
       display "承認者のユーザ名".
       accept auth-user.
       display "承認者のパスワード".
       accept auth-pass.

       open input user-file.
       perform until user-status not = "00"
           read user-file

           if Fusername = auth-user then
               go to exec-user-auth *> ユーザ名が見つかった
           end-if
       end-perform.

exec-user-auth.
       if Fpswd not = auth-pass then
           display "認証できませんでした"
           display "再認証を行います"
           
           add 1 to auth-times

           if auth-times >= 3 then
               display "3回認証に失敗しました"
               display "プログラムを中断します"

               move function current-date to log-timestamp
               string
                   "[ERRO] " delimited by size
                   Fusername delimited by size
                   " running add_user, but failed 3 times authentication." delimited by size
                   into log-comments
               
               open extend log-file
               write log-rec
               close log-file

               stop run
           end-if

           close user-file
           go to exec-authenticate-user
       end-if.

       close user-file.
       
exec-write.
       open extend out-user.
       write out-user-rec.
       close out-user.
       display "書き込みが完了しました".

       open extend log-file.
       move function current-date to log-timestamp.
       string
           "[INFO] " delimited by size
           Fusername delimited by size
           " running add_user, joined " delimited by size
           join-user delimited by size
           into log-comments.
       write log-rec.
       stop run.
