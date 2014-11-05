use v6;
use lib 'lib';
use Test;
use Slang::Tuxic;

plan 3;

sub foo($a, $b) { $a * $b };

is( (foo 3, 5), 15, 'foo 3, 5'); # <-- yes, that is supposed to look ugly
is foo (3, 5), 15, 'foo (3, 5)';
is foo(3, 5),  15, 'foo(3, 5)';
