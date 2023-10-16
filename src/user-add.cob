identification division.
program-id. kintai-user-add.

environment division.
input-output section.
       file-control.
       select out-user assign to "./dat/user.dat"
           organization relative
           access mode sequential
           relative key out-key.
data division.
file section.
       fd out-user.
           01 out-user-rec.
               03 Ouserid pic 9(7).
               03 Ousername pic X(64).
               03 Ofirstname pic N(32).
               03 Olastname pic N(32).
               03 Opswd pic X(20).
               03 Ogender pic 9(2).
               03 Oaddress pic N(70).
               03 Oemail pic X(254).
               03 Ophone-number pic X(14).
               03 Oroll pic 9(2).
               03 Ojoin-date pic X(21).
working-storage section.
       01 out-key pic 9(7).
       01 out-status pic XX.

       
procedure division.
       display "勤怠管理システム".
       display "ユーザー追加モード".


*>       open input in-file.
*>       perform until infile-status not = "00"
*>           read in-file
*>               not at end
*>                   compute idx = idx + 1
*>           end-read
*>       end-perform.
*>       compute idx = idx + 1.
*>       close in-file.
*>
*>       move idx to Fuserid.
*>
*>exec-accept-username.
*>       display "ユーザ名:".
*>       accept Fusername.
*>       
*>       if function validate-user-username(Iusername) != 0
*>           goto exec-accept-username.
*>       end-if.
*>       stop run.

*>exec-accept-lastname.
*>       display "姓:".
*>       accept Flastname.
*>
*>       if function length(Flastname) < 1
*>           display "1文字以上の姓を入力してください".
*>           goto exec-accept-lastname.
*>       end-if
*>
*>       if function length(Flastname) > 32
*>           display "32文字以下の姓を入力してください".
*>           goto exec-accept-lastname.
*>       end-if
*>
*>exec-accept-firstname.
*>       display "名:".
*>       accept Ffirstname.
*>
*>       if function length(Ffirstname) < 1
*>           display "1文字以上の名を入力してください".
*>           goto exec-accept-firstname.
*>       end-if
*>
*>       if function length(Ffirstname) > 32
*>           display "32文字以下の名を入力してください".
*>           goto exec-accept-firstname.
*>       end-if
*>
*>exec-accept-password.
*>       display "パスワード:".
*>       accept Fpswd.
*>
*>       if function length(Fpswd) < 1
*>           display "1文字以上のパスワードを入力してください".
*>           goto exec-accept-password.
*>       end-if.
*>
*>       if function length(Fpswd) > 20
*>           display "20文字以下のパスワードを入力してください".
*>           goto exec-accept-password.
*>       end-if.
*>
*>exec-accept-gender.
*>       display "性別ID:".
*>
*>       open read genderfile.
*>       perform until gender-status == "00"
*>           read Igender.
*>           display Igender.
*>       end-perform.
*>       accept Fgender. *> ここで入力
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
*>       stop run.
*>
