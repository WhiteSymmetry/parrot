#! perl -w

use Parrot::Test tests => 2;

TODO: {
    local $TODO="t/src doesn't work on Windows" if $^O =~ /Win32/;
    $TODO=$TODO;  #warnings

    c_output_is(<<'CODE', <<'OUTPUT', "Parrot_exit");
        #include <stdio.h>
        #include "parrot/parrot.h"

        int main(int argc, char* argv[]) {
            printf("pre-exit\n");
            Parrot_exit(0);
            printf("post-exit\n");
        }
CODE
pre-exit
OUTPUT

    c_output_is(<<'CODE', <<'OUTPUT', "Parrot_on_exit / Parrot_exit");
        #include <stdio.h>
        #include "parrot/parrot.h"

        void print_message(int status, void* arg) {
            printf("%s", (char*)arg);
        }       

        int main(int argc, char* argv[]) {
            Parrot_on_exit(print_message, "exit1\n");
            Parrot_on_exit(print_message, "exit2\n");
            Parrot_on_exit(print_message, "exit3\n");
            printf("pre-exit\n");
            Parrot_exit(0);
            printf("post-exit\n");
        }
CODE
pre-exit
exit1
exit2
exit3
OUTPUT
}
1;
