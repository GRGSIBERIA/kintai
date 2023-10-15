identification division.
program-id. seed-user.
environment division.
input-output section.
       file-control.
       select outfile assign to "./dat/user.dat"
           organization is relative
           access mode sequential
           relative key is key-num.
data division.
       file section.
       fd outfile.
           01 Iuser.
               03 Iuserid pic 9(7).
               03 Iusername pic X(64).
               03 Ifirstname pic N(32).
               03 Ilastname pic N(32).
               03 Ipswd pic X(20).
               03 Igender pic 9(2).
               03 Iaddress pic N(70).
               03 Iemail pic X(254).
               03 Iphone-number pic X(14).
               03 Iroll pic 9(2).
               03 Ijoin-date pic X(21).
working-storage section.
       01 key-num pic 9(7).
procedure division.
main-procedure.
       display "初期ユーザを追加します"

       open output outfile.

       move 1 to Iuserid.
       move "fujita" to Iusername.
       move "藤田" to Ilastname.
       move "茜" to Ifirstname.
       move "1234" to Ipswd.
       move 2 to Igender.
       move "東京都千代田区１－１" to Iaddress.
       move "fujita@test.jp" to Iemail.
       move "080-1234-5678" to Iphone-number.
       move 1 to Iroll.
       move function current-date to Ijoin-date.
       write Iuser.
       display Iuser.

       add 1 to Iuserid.
       move "yamada" to Iusername.
       move "山田" to Ilastname.
       move "太郎" to Ifirstname.
       move "1234" to Ipswd.
       move 1 to Igender.
       move "神奈川県横浜市港区１－１" to Iaddress.
       move "yamada@test.jp" to Iemail.
       move "080-8765-4321" to Iphone-number.
       move 2 to Iroll.
       move function current-date to Ijoin-date.
       write Iuser.
       display Iuser.

       close outfile.
       stop run.
