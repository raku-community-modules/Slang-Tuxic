
my sub atkeyish(Mu \h, \k) {
    use nqp;
    nqp::atkey(nqp::findmethod(h, 'hash')(h), k)
}

my role Tuxic {
    use NQPHLL:from<NQP>;

    token routine_declarator:sym<sub> {
        :my $*LINE_NO := HLL::Compiler.lineof(self.orig(), self.from(), :cache(1));
        <sym>
        <.end_keyword>?
        <routine_def('sub')>
    }

    token term:sym<identifier> {
        :my $pos;
        <identifier>
        <!{
            my $ident = atkeyish($/, 'identifier').Str;
            $ident eq 'sub'|'if'|'elsif'|'while'|'until'|'for' || $*W.is_type([$ident])
        }>
        <?before <.unsp>|\s*'('> \s* <![:]>
        { $pos := $/.CURSOR.pos }
        <args>
        {
            self.add_mystery(
              atkeyish($/,'identifier'),
              atkeyish($/,'args').from,
              atkeyish($/,'args').Str.substr(0, 1)
            )
        }
    }

    token methodop {
        [
          | <longname>
          | <?[$@&]>
            <variable>
            { self.check_variable(atkeyish($/, 'variable')) }

          | <?['"]>
            [ <!{$*QSIGIL}> || <!before '"' <-["]>*? [\s|$] > ] # dwim on "$foo."
            <quote>
            [ <?before '(' | '.(' | '\\'>
                || <.panic: "Quoted method name requires parenthesized arguments. If you meant to concatenate two strings, use '~'.">
            ]
        ] \s* <.unsp>?
        [
          [
            |  <?before  \s*'('>  \s* <args>
            | ':' <?before \s | '{'> <!{ $*QSIGIL }> <args=.arglist>
          ]
          || <!{ $*QSIGIL }> <?>
          || <?{ $*QSIGIL }> <?[.]> <?>
        ] <.unsp>?
    }
}

use Slangify Tuxic, Mu;

=begin pod

=head1 NAME

Slang::Tuxic - allow whitespace between subroutine and the opening parenthesis

=head1 SYNOPSIS

=begin code :lang<raku>

foo 3, 5;   # 15, as usual
foo(3, 5);  # also 15, as usual
foo (3, 5); # 15, /o\

# It also allows to put space before argument lists in method calls:
42.fmt('-%d-');  # -42-
42.fmt: '-%d-';  # -42-
42.fmt ('-%d-'); # -42-

=end code

=head1 DESCRIPTION

The C<Slang::Tuxic> module adapts the Raku Programming Language syntax
to allow you to put whitespace between the name of a subroutine and
the opening parenthesis when calling a subroutine.

Be aware that this introduces ambiguous situations, like when you
want to pass a List to a sub, or when you need parenthesis around
the condition after the keywords `if`, `while` and so on.

=head1 AUTHOR

Tobias Leich (FROGGS)

Source can be located at: https://github.com/raku-community-modules/Slang-Tuxic .
Comments and Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2014-2018 Tobias Leich, 2023 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
