identification division.
program-id. seed-status.
environment division.
input-output section.
       file-control.
       select status-file assign to "./dat/status.dat"
           organization is relative
           access mode sequential.

data division.
file section.
       fd status-file.
           01 Fstatus-rec.
               03 Fid pic 9.
               03 Fname pic N(4).
working-storage section.

procedure division.
       display "ステータスを追加します".

       open output status-file.
       
       move 1 to Fid.
       move "出勤" to Fname.
       write Fstatus-rec.

       move 2 to Fid.
       move "退勤" to Fname.
       write Fstatus-rec.

       move 3 to Fid.
       move "直行" to Fname.
       write Fstatus-rec.

       move 4 to Fid.
       move "直帰" to Fname.
       write Fstatus-rec.

       move 5 to Fid.
       move "休憩始".
       write Fstatus-rec.

       move 6 to Fid.
       move "休憩終".
       write Fstatus-rec.

       close status-file.

       stop run.
       