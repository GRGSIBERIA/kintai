identification division.
program-id. test-sha1.
environment division.
data division.
working-storage section.
       01 pswd pic X(80).

       01 sha1-digest pic X(20).
       01 digestable pic X(80) value "default message".

procedure division.
main-procedure.
       
       accept digestable.
       *> cobc -x -F -B -Wl,--no-as-needed -L. -lcrypto <path>

       *> Compute disgest from block of memory
       call "SHA1" using
          by reference digestable
          by value function length(function trim(digestable))
          by reference sha1-digest
          on exception
              display "link sha1.cob with OpenSSL's libcrypto" end-display
       end-call

       *> Dump the hash, as it'll unlikely be printable
       call "CBL_OC_DUMP" using
           by reference sha1-digest
           on exception continue
       end-call

       display sha1-digest.

       stop run.

       *> libcryptoへのリンクがうまく行かないので、平文でパスワードを保存する