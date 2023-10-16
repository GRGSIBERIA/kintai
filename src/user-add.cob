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
       
procedure division.
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
               not at end perform validate-username-double
       end-perform.
       close user-file.

       if function length(function trim(Ousername)) < 1 then
           perform occurred-username-minimum
       end-if.

       if function length(function trim(Ousername)) > 64 then
           perform occurred-username-maximum
       end-if.

       go to exec-accept-lastname.

validate-username-double section.
       if Ousername equal Fusername then
           perform occurred-username-double
       end-if.
validate-username-double-exit.

occurred-username-double section.
       display "ユーザ名が重複しています".
       close user-file.
       go to exec-accept-username.
occurred-username-double-exit.

occurred-username-minimum section.
       display "ユーザ名は1文字以上にしてください".
       go to exec-accept-username.
occurred-username-minimum-exit.

occurred-username-maximum section.
       display "ユーザ名は64文字以下にしてください".
       go to exec-accept-username.
occurred-username-maximum-exit.

exec-accept-lastname.
       display "姓 ([1-32]文字)".
       accept Olastname.

       if function length(function trim(Olastname)) < 1 then
           perform occurred-lastname-minimum
       end-if.

       if function length(function trim(Olastname)) > 32 then
           perform occurred-lastname-maximum
       end-if.

       go to exec-accept-firstname.

occurred-lastname-minimum section.
       display "1文字以上の姓を入力してください".
       go to exec-accept-lastname.
occurred-lastname-minimum-exit.

occurred-lastname-maximum section.
       display "32文字以下の姓を入力してください".
       go to exec-accept-lastname.
occurred-lastname-maximum-exit.

exec-accept-firstname.
       display "名 ([1-32]文字)".
       accept Ofirstname.

       if function length(function trim(Ofirstname)) < 1 then
           perform occurred-firstname-minimum
       end-if.

       if function length(function trim(Ofirstname)) > 32 then
           perform occurred-firstname-maximum
       end-if.

       go to exec-accept-password.

occurred-firstname-minimum section.
       display "1文字以上の名を入力してください".
       go to exec-accept-firstname.
occurred-firstname-minimum-exit.

occurred-firstname-maximum section.
       display "32文字以下の名を入力してください".
       go to exec-accept-firstname.
occurred-firstname-maximum-exit.

exec-accept-password.
       display "パスワード:".
       accept Opswd.

       if function length(function trim(Opswd)) < 1 then
           perform occurred-password-minimum
       end-if.

       if function length(function trim(Opswd)) > 20 then
           perform occurred-password-maximum
       end-if.

       go to exec-accept-gender.

occurred-password-minimum section.
       display "1文字以上のパスワードを入力してください".
       go to exec-accept-password.
occurred-password-minimum-exit.

occurred-password-maximum section.
       display "20文字以下のパスワードを入力してください".
       go to exec-accept-password.
occurred-password-maximum-exit.

exec-accept-gender.
       display "性別ID:".

       open input gender-file.
       perform until gender-status not = "00"
           read gender-file
               not at end display Fgender-rec
       end-perform.
       close gender-file.
       accept Ogender. *> ここで入力
*>
*>       open read genderfile.
*>       perform until gender-status == "00"
*>           read Igender.
*>           if Igenderid == Fgender
*>               close genderfile.
*>               goto exec-accept-roll.  *> 該当項目を見つけた
*>           end-if.
*>       end-perform.
*>       close genderfile.
*>       display "性別IDが一致しません"
*>       goto exec-accept-gender.
*>
*>exec-accept-roll.
*>       display "役職ID:".
*>       
*>       open read rollfile.
*>       perform until roll-status == "00"
*>           read Iroll.
*>           display Iroll.
*>       end-perform.
*>       close rollfile.
*>       accept Froll. *> ここで入力
*>
*>       open read rollfile.
*>       perform until roll-status == "00"
*>           read Iroll.
*>           if Irollid == Froll
*>               close rollfile.
*>               goto exec-accept-address. *> 該当項目を見つけた
*>           end-if.
*>       end-perform.
*>       close rollfile.
*>       display "役職IDが一致しません"
*>       goto exec-accept-roll.
*>
*>exec-accept-address.
*>       display "住所:".
*>       accept Faddress.
*>
*>       if function length(Faddress) < 1
*>           display "住所は1文字以上で入力してください".
*>           goto exec-accept-address.
*>       end-if.
*>
*>       if function length(Faddress) > 70
*>           display "住所は70文字以下で入力してください".
*>           goto exec-accept-address.
*>       end-if.
*>
*>exec-accept-email.
*>       display "メールアドレス:".
*>       accept Femail.
*>       
*>exec-accept-phone.
*>       display "電話番号:".
*>       accept Fphone.
*>       
*>exec-accept-join.
*>       display "入社年月日(21桁): (例: YYYYMMDDhhmmss00+0900)".
*>       accept Fjoin-date.
*>
*>
*>       open output userfile.
*>           write Fuser.
*>       close userfile.
       stop run.
*>
