identification division.
program-id. kintai-user-add.
environment division.
input-output section.
       file-control.
       select userfile assign to "./dat/user.dat"
           organization is indexed
           record key is Fuserid.
       select infile assign to "./dat/user.dat"
           organization is indexed
           record key is Iuserid.
data division.
file section.
       fd userfile.
           01 Fuser.
           03 Fuserid pic N(7).
           03 Fusername pic X(64).
           03 Ffirstname pic X(32).
           03 Flastname pic X(32).
           03 Fpswd pic X(256).
           03 Fgender pic Z(1).
           03 Froll pic N(2).
           03 Fjoin-date.
               05 Fyear PIC 9999.
               05 Fmonth PIC 99.
               05 Fdaynum PIC 99.
       fd infile.
           01 Iuser.
           03 Iuserid pic N(7).
           03 Iusername pic X(64).
           03 Ifirstname pic X(32).
           03 Ilastname pic X(32).
           03 Ipswd pic X(256).
           03 Igender pic Z(1).
           03 Iroll pic N(2).
           03 Ijoin-date.
               05 Iyear PIC 9999.
               05 Imonth PIC 99.
               05 Idaynum PIC 99.
working-storage section.
       01 user.
           03 userid pic 9(7).
           03 username pic X(64).
           03 firstname pic X(32).
           03 lastname pic X(32).
           03 gender pic Z(1).
           03 pswd pic X(256).
           03 roll pic Z(2).
           03 join-date.
               05 year PIC 9999.
               05 month PIC 99.
               05 daynum PIC 99.
       07 infile-status pic XX.
procedure division.
main-procedure.
       display "勤怠管理システム".
       display "ユーザー追加モード".

       open input infile.
       perform until infile-status not = "00"
           read infile
               not at end
                   move Iuserid to userid.
           end-read
       end-perform.
       compute userid = userid + 1.
       close infile.

       display "ユーザ名:".
       accept Fusername.
       display "姓:".
       accept Flastname.
       display "名:".
       accept Ffirstname.
       display "パスワード:".
       accept Fpswd.
       display "役職ID:".
       accept Froll.
       display "入社年:".
       accept Fyear.
       display "入社月:".
       accept Fmonth.
       display "入社日:".
       accept Fdaynum.

       open output userfile.

       close userfile.
       stop run.
