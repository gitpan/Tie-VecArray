# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)
use strict;

use vars qw($Total_tests $Loaded $Test_num);

$Test_num = 1;
BEGIN { $| = 1; $^W = 1; }
END {print "not ok $Test_num\n" unless $Loaded;}
print "1..$Total_tests\n";
require Tie::VecArray;
$Loaded = 1;
ok(1, 'compile');
######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):
sub ok {
    my($test, $name) = @_;
    print "not " unless $test;
    print "ok $Test_num";
    print " - $name" if defined $name;
    print "\n";
    $Test_num++;
}

sub eqarray  {
    my($a1, $a2) = @_;
    return 0 unless @$a1 == @$a2;
    my $ok = 1;
    for (0..$#{$a1}) { 
        unless($a1->[$_] eq $a2->[$_]) {
        $ok = 0;
        last;
        }
    }
    return $ok;
}

# Change this to your # of ok() calls + 1
BEGIN { $Total_tests = 13 }

my @array;
my $obj = tie @array, 'Tie::VecArray', 16;

ok( $obj->isa('Tie::VecArray'),                         'basic tie()'   );
ok( $obj->bits == 16,                                    'get bits()'   );
ok( $#array == -1,                              'null FETCHSIZE()'      );
ok( @array == 0,                                'null FETCHSIZE() again');

$#array = 5;
ok( @array == 6,                                        'STORESIZE()'   );

$array[5] = 42;
ok( $array[5] == 42,                       'simple STORE & FETCH'       );
ok( (pop(@array) == 42) and @array == 5,                'simple POP'    );
ok( (push(@array, 100)) and ($array[5] == 100) and (@array == 6),
                                                       'simple PUSH'    );
ok( $obj->bits(8) and (@array == 12),           'simple bits() change'  );


my @vec;
my $vec_obj = tie @vec, 'Tie::VecArray', 1;

@vec[0..4] = (1) x 5;

ok( scalar @vec == 5,                           'one bit FETCHSIZE'     );

$vec_obj->bits(2);
ok( scalar @vec == 3,                           'two bit FETCHSIZE'     );

$vec_obj->bits(1);
ok( scalar @vec == 6,                   'back to one bit FETCHSIZE'     );
