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
working-storage section.
       01 out-key pic 9(7).
       01 gender-key pic 9(2).
       01 roll-key pic 9(2).
       01 user-key pic 9(7).
       01 gender-status pic XX.
       01 roll-status pic XX.
       01 user-status pic XX.
       01 idx pic 9(7) value 0.
       01 yesno pic X.
       
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
                   go to occurred-username-double
               end-if
       end-perform.
       close user-file.

       if function length(function trim(Ousername)) < 1 then
           go to occurred-username-minimum
       end-if.

       if function length(function trim(Ousername)) > 64 then
           go to occurred-username-maximum
       end-if.

       go to exec-accept-lastname.

occurred-username-double.
       display "ユーザ名が重複しています".
       close user-file.
       go to exec-accept-username.
occurred-username-double-exit.

occurred-username-minimum.
       display "ユーザ名は1文字以上にしてください".
       go to exec-accept-username.

occurred-username-maximum.
       display "ユーザ名は64文字以下にしてください".
       go to exec-accept-username.

exec-accept-lastname.
       display "姓 ([1-32]文字)".
       accept Olastname.

       if function length(function trim(Olastname)) < 1 then
           go to occurred-lastname-minimum
       end-if.

       if function length(function trim(Olastname)) > 32 then
           go to occurred-lastname-maximum
       end-if.

       go to exec-accept-firstname.

occurred-lastname-minimum.
       display "1文字以上の姓を入力してください".
       go to exec-accept-lastname.

occurred-lastname-maximum.
       display "32文字以下の姓を入力してください".
       go to exec-accept-lastname.

exec-accept-firstname.
       display "名 ([1-32]文字)".
       accept Ofirstname.

       if function length(function trim(Ofirstname)) < 1 then
           go to occurred-firstname-minimum
       end-if.

       if function length(function trim(Ofirstname)) > 32 then
           go to occurred-firstname-maximum
       end-if.

       go to exec-accept-password.

occurred-firstname-minimum.
       display "1文字以上の名を入力してください".
       go to exec-accept-firstname.

occurred-firstname-maximum.
       display "32文字以下の名を入力してください".
       go to exec-accept-firstname.

exec-accept-password.
       display "パスワード ([1-20]文字)".
       accept Opswd.

       if function length(function trim(Opswd)) < 1 then
           go to occurred-password-minimum
       end-if.

       if function length(function trim(Opswd)) > 20 then
           go to occurred-password-maximum
       end-if.

       go to exec-accept-gender.

occurred-password-minimum.
       display "1文字以上のパスワードを入力してください".
       go to exec-accept-password.

occurred-password-maximum.
       display "20文字以下のパスワードを入力してください".
       go to exec-accept-password.

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
       perform until gender-status = "00"
           read gender-file
               not at end if Ogender = Fgender-id then
                   go to exec-accept-roll
               end-if
       end-perform.

       close gender-file.
       display "性別IDが一致しません"
       go to exec-accept-gender.

exec-accept-roll.
       close gender-file.
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
                  go to exec-accept-address *> 該当項目を見つけた
              end-if
       end-perform.

       close roll-file.
       display "役職IDが一致しません"
       go to exec-accept-roll.

exec-accept-address.
       close roll-file.
       display "住所 ([1-70]文字)".
       accept Oaddress.

       if function length(function trim(Oaddress)) < 1
           perform occurred-address-minimum
       end-if.

       if function length(function trim(Oaddress)) > 70
           perform occurred-address-maximum
       end-if.

       go to exec-accept-email.

occurred-address-minimum section.
       display "住所は1文字以上で入力してください".
       go to exec-accept-address.
occurred-address-minimum-exit.

occurred-address-maximum section.
       display "住所は70文字以下で入力してください".
       go to exec-accept-address.
occurred-address-maximum-exit.

exec-accept-email.
       display "メールアドレス:".
       accept Oemail.
       
exec-accept-phone.
       display "電話番号:".
       accept Ophone-number.

exec-accept-join.
       display "入社年月日(21桁): (例: YYYYMMDDhhmmss00+0900)".
       accept Ojoin-date.

exec-yesno.
       display "入力された項目".
       display Ouserid.
       display function trim(Ousername).
       display function trim(Ofirstname).
       display function trim(Olastname).
       display function trim(Opswd).
       display Ogender.
       display function trim(Oaddress).
       display function trim(Oemail).
       display function trim(Ophone-number).
       display Oroll.
       display Ojoin-date.

       display "間違いはないですか？ [y/n]".
       accept yesno.
       if yesno = "y" then
           go to exec-write
       else
           go to exec-search-maximum-userid
       end-if.

exec-write.
       open output out-user.
       write out-user-rec.
       close out-user.

       stop run.

