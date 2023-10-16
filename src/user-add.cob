identification division.
program-id. kintai-user-add.
environment division.
input-output section.
       file-control.
       select userfile assign to "./dat/user.dat"
           organization is relative
           access mode sequential
           relative key is outfile-idx.
       select infile assign to "./dat/user.dat"
           organization is relative
           access mode sequential
           relative key is infile-idx
           status infile-status.
       select genderfile assign to "./dat/gender.dat"
           organization is relative
           access mode sequential
           relative key is gender-id
           status gender-status.
       select rollfile assign to "./dat/roll.dat"
           organization is relative
           access mode sequential
           relative key is roll-id
           status roll-status.
data division.
file section.
       fd userfile.
           01 Fuser.
               03 Fuserid pic 9(7).
               03 Fusername pic X(64).
               03 Ffirstname pic N(32).
               03 Flastname pic N(32).
               03 Fpswd pic X(20).
               03 Fgender pic 9(2).
               03 Faddress pic N(70).
               03 Femail pic X(254).
               03 Fphone pic X(14).
               03 Froll pic N(2).
               03 Fjoin-date pic X(21).
       fd infile.
           01 Iuser.
               03 Iuserid pic 9(7).
               03 Iusername pic X(64).
               03 Ifirstname pic N(32).
               03 Ilastname pic N(32).
               03 Ipswd pic X(20).
               03 Igender pic 9(2).
               03 Iaddress pic N(70).
               03 Iemail pic X(254).
               03 Iphone pic X(14).
               03 Iroll pic N(2).
               03 Ijoin-date pic X(21).
       fd genderfile.
           01 Igender.
               03 Igenderid pic 9(2).
               03 Igender-name pic N(10).
       fd rollfile.
           01 Iroll.
               03 Irollid pic 9(2).
               03 Iroll-name pic N(10).
working-storage section.
       01 gender-status pic XX.
       01 roll-status pic XX.
       01 infile-status pic XX.
       01 infile-idx pic 9(7).
       01 outfile-idx pic 9(7).
       01 idx pic 9(7) value 0.
       01 gender-id pic 9(2).
       01 roll-id pic 9(2).
       
procedure division.
main-procedure.
       display "勤怠管理システム".
       display "ユーザー追加モード".

       open input infile.
       perform until infile-status not = "00"
           read infile
               not at end
                   compute idx = idx + 1
           end-read
       end-perform.
       compute idx = idx + 1.
       close infile.

       move idx to Fuserid.

exec-accept-username.
       display "ユーザ名:".
       accept Fusername.
       
       open input infile.
       perform until infile-status not = "00"
           read infile.
           if Iusername == Fusername
               display "ユーザ名が重複しています".
               close infile.
               goto exec-accept-username.
           end-if.
       end-perform.
       close infile.

       if function length(Fusername) < 1
           display "1文字以上のユーザ名を指定してください".
           goto exec-accept-username.
       end-if.

       if function length(Fusername) > 64
           display "64文字以下のユーザ名を指定してください".
           goto exec-accept-username.
       end-if.
           
exec-accept-lastname.
       display "姓:".
       accept Flastname.

       if function length(Flastname) < 1
           display "1文字以上の姓を入力してください".
           goto exec-accept-lastname.
       end-if

       if function length(Flastname) > 32
           display "32文字以下の姓を入力してください".
           goto exec-accept-lastname.
       end-if

exec-accept-firstname.
       display "名:".
       accept Ffirstname.

       if function length(Ffirstname) < 1
           display "1文字以上の名を入力してください".
           goto exec-accept-firstname.
       end-if

       if function length(Ffirstname) > 32
           display "32文字以下の名を入力してください".
           goto exec-accept-firstname.
       end-if

exec-accept-password.
       display "パスワード:".
       accept Fpswd.

       if function length(Fpswd) < 1
           display "1文字以上のパスワードを入力してください".
           goto exec-accept-password.
       end-if

       if function length(Fpswd) > 20
           display "20文字以下のパスワードを入力してください".
           goto exec-accept-password.
       end-if

exec-accept-gender.
       display "性別ID:".

       open read genderfile.
       perform until gender-status == "00"
           read Igender.
           display Igender.
       end-perform.
       accept Fgender. *> ここで入力

       open read genderfile.
       perform until gender-status == "00"
           read Igender.
           if Igenderid == Fgender
               close genderfile.
               goto exec-accept-roll.
           end-if
       end-perform.
       close genderfile.
       display "性別IDが一致しません"

exec-accept-roll.
       display "役職ID:".
       accept Froll.

       display "住所:".
       accept Faddress.

       display "メールアドレス:".
       accept Femail.
       
       display "電話番号:".
       accept Fphone.
       
       display "入社年月日(21桁): (例: YYYYMMDDhhmmss00+0900)".
       accept Fjoin-date.
       
       open output userfile.
           write Fuser.
       close userfile.
       stop run.
