identification division.
program-id. kintai-user-show.

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
data division.
file section.
       fd user-file.
           01 Fuser-rec.
               03 Fuserid pic 9(7).
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
working-storage section.
       01 mode-select pic 9.
       01 user-key pic 9(7).
       01 roll-key pic 9(2).
       01 user-status pic XX.
       01 roll-status pic XX.
       01 inspect-address pic N(70).
       01 inspect-address-cnt pic 99.
       01 read-cnt pic 9(7).
       01 yes-no pic X.
       01 Iuser-rec.
               03 Iuserid pic 9(7).
               03 Iusername pic X(64).
               03 Ifirstname pic N(32) usage national.
               03 Ilastname pic N(32).
               03 Ipswd pic X(20).
               03 Igender pic 9(2).
               03 Iaddress pic N(70).
               03 Iemail pic X(254).
               03 Iphone-number pic X(14).
               03 Iroll pic 9(2).
               03 Ijoin-date pic X(21).

procedure division.
       display "勤怠管理システム".
       display "ユーザ照会モード".

main-procedure.
       display "対応した数字を入力してください".
       display "1. ユーザIDから".
       display "2. ユーザ名から".
       display "3. 姓から".
       display "4. 名から".
       display "5. 電話番号から".
       display "6. メールアドレスから".
       display "7. 住所から".
       display "8. 役職から".
       accept mode-select.

       evaluate mode-select
       when 1
           go to search-userid
       when 2
           go to search-username
       when 3
           go to search-lastname
       when 4
           go to search-firstname
       when 5
           go to search-phone
       when 6
           go to search-email
       when 7
           go to search-address
       when 8
           go to search-roll
       when other
           display "指定されたモードがありません"
           go to main-procedure
       end-evaluate.

search-userid.
       display "ユーザIDを入力してください".
       accept Iuserid.
       move 1 to read-cnt.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           if Iuserid = Fuserid then
               close user-file
               perform display-user
               go to end-procedure
           end-if
       end-perform.
       close user-file.
       go to search-failed.
       
search-username.
       display "ユーザ名を入力してください".
       accept Fusername.
       move 1 to read-cnt.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           if Iusername = Fusername then
               close user-file
               perform display-user
               go to end-procedure
           end-if
       end-perform.
       close user-file.
       go to search-failed.

search-lastname.
       display "姓を入力してください".
       accept Flastname.
       move 1 to read-cnt.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           if Ilastname = Flastname then
               perform display-user
           end-if
           add 1 to read-cnt
       end-perform.
       close user-file.
       go to end-procedure.

search-firstname.
       display "名を入力してください".
       accept Ffirstname.
       move 1 to read-cnt.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           if Ifirstname = Ffirstname then
               perform display-user
           end-if
           add 1 to read-cnt
       end-perform.
       close user-file.
       go to end-procedure.

search-phone.
       display "電話番号を入力してください".
       display "ハイフンの有無を区別します".
       accept Fphone-number.
       move 1 to read-cnt.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           if Iphone-number = Fphone-number then
               close user-file
               perform display-user
               go to end-procedure
           end-if
       end-perform.
       close user-file.
       go to search-failed.

search-email.
       display "メールアドレスを入力してください".
       accept Femail.
       move 1 to read-cnt.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           if Iemail = Femail then
               close user-file
               perform display-user
               go to end-procedure
           end-if
       end-perform.
       close user-file.
       go to search-failed.

search-address.
       display "住所を入力してください（全角半角区別します)".
       accept Faddress.
       move 1 to read-cnt.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           inspect function trim(inspect-address) tallying
               inspect-address-cnt for all function trim(Faddress)

           if inspect-address-cnt > 0 then
               perform display-user
           end-if

           add 1 to read-cnt
       end-perform.
       close user-file.
       go to end-procedure.

search-roll.
       display "役職IDを入力してください".

       open input roll-file.
       perform until roll-status not = "00"
           read roll-file
           display roll-rec
       end-perform.
       close roll-file.

       accept Froll-id.

       open input user-file.
       perform until user-status not = "00"
           read user-file
           if Froll-id = Iroll then
               perform display-user
           end-if

           add 1 to read-cnt
       end-perform.
       close roll-file.
       go to end-procedure.

search-failed.
       display "見つかりませんでした".
       go to main-procedure.

end-procedure.
       display "照会を続けますか？ [y/n]".
       if yes-no = "y" then
           display " "
           go to main-procedure
       end-if.

       stop run.

display-user section.
       display read-cnt "件目のデータです".
       display "userid: " Fuserid.
       display "username: " Fusername.
       display "name: " function trim(Flastname) function trim(Ffirstname).
       display "gender: " Fgender.
       display "address: " function trim(Faddress).
       display "email: " function trim(Femail).
       display "phone: " Fphone-number.
       display "roll: " Froll.
       display "join date:" Fjoin-date(1:4) "年" Fjoin-date(5:2) "月" Fjoin-date(7:2) "日".
       display " "
       exit.