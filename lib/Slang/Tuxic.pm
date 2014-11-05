sub EXPORT(|) {
    sub atkeyish(Mu \h, \k) {
        nqp::atkey(nqp::findmethod(h, 'hash')(h), k)
    }
    my role Tuxic {
        token term:sym<identifier> {
            :my $pos;
            <identifier> <!{ $*W.is_type([atkeyish($/, 'identifier').Str]) }> <?before <.unsp>|\s*'('> \s* <![:]>
            { $pos := $/.CURSOR.pos }
            <args>
            { self.add_mystery(atkeyish($/, 'identifier'), atkeyish($/, 'args').from, nqp::substr(atkeyish($/, 'args').Str, 0, 1)) }
        }
    }
    nqp::bindkey(%*LANG, 'MAIN', %*LANG<MAIN>.HOW.mixin(%*LANG<MAIN>, Tuxic));

    {}
}
