identification division.
program-id. 001-seed-gender.
environment division.
input-output section.
       file-control.
       select outfile assign to "./dat/gender.dat"
           organization is relative
           access mode sequential
           relative key is key-num.
data division.
file section.
       fd outfile.
           01 Fgender.
               03 Fgenderid pic 9(2).
               03 Fname pic N(10).
working-storage section.
       01 key-num pic 9(2).

procedure division.
main-procedure.
       display "初期性別を追加します"

       open output outfile.
       move 1 to Fgenderid.
       move "男" to Fname.
       write Fgender.
       display Fgender.
       
       move 2 to Fgenderid.
       move "女" to Fname.
       write Fgender.
       display Fgender.

       move 3 to Fgenderid.
       move "その他" to Fname.
       write Fgender.
       *>display Fgender.
       
       close outfile.
       stop run.
