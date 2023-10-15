identification division.
program-id. 002-seed-roll.
environment division.
input-output section.
       file-control.
       select outfile assign to "./dat/roll.dat"
           organization is relative
           access mode sequential
           relative key is key-num.
data division.
file section.
       fd outfile.
           01 Froll.
               03 Frollid pic 9(2) comp-x.
               03 Fname pic N(10).
working-storage section.
       01 key-num pic 9(2).

procedure division.
main-procedure.
       display "初期ユーザを追加します"

       open output outfile.
       move 1 to Frollid.
       move "平社員" to Fname.
       write Froll.
       display Froll.
       
       add 1 to Frollid.
       move "役員" to Fname.
       write Froll.
       display Froll.

       add 1 to Frollid.
       move "派遣" to Fname.
       write Froll.
       display Froll.

       add 1 to Frollid.
       move "アルバイト" to Fname.
       write Froll.
       display Froll.

       add 1 to Frollid.
       move "課長" to Fname.
       write Froll.
       display Froll.

       add 1 to Frollid.
       move "部長" to Fname.
       write Froll.
       display Froll.

       add 1 to Frollid.
       move "係長" to Fname.
       write Froll.
       display Froll.

       close outfile.
       stop run.