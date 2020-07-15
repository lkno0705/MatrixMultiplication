package require Thread

proc randMatrix { m n } {
    set a {}
    for {set index 0} { $index < $n } { incr index } {
        for {set iindex 0} { $iindex < $m } { incr iindex } {
            lappend a [expr rand()]
        }
    }
    return $a
}

set size 1440
set threads 24

set n $size
set m $size
set p $size

set step [expr {$m / $threads}]

set tp [tpool::create -minworkers $threads -maxworkers $threads]
tpool::suspend $tp

tsv::object a a
tsv::object b b

tsv::set a a [randMatrix $m $n]
tsv::set b b [randMatrix $n $p]

for {set index 0} { $index < $threads } { incr index } {
    set script ""
    append script {
        package require Thread

    }

    set lower [expr {$step * $index}]
    set upper [if {$index == ($threads - 1)} {expr $m} {expr {$step * $index + $step}}]

    append script "set n $n\n"
    append script "set m $m\n"
    append script "set p $p\n"
    append script "set lower $lower\n"
    append script "set upper $upper\n"

    append script {
        set b [tsv::get b b]
        for {set i $lower} { $i < $upper } { incr i } {
            set a_row [tsv::lrange a a [expr {$n * $i}] [expr {$n * $i + $n}]]
            for {set k 0} { $k < $p } { incr k } {
                set sum 0
                for {set j 0} { $j < $n } { incr j } {
                    set sum [expr {$sum + [lindex $a_row $j] * [lindex $b [expr {$p * $j + $k}]]}]
                }
                tsv::array set c [expr {$p * $i + $k}] $sum
            }
        }
        unset b
    }
    set jid [tpool::post $tp $script]
    lappend jids $jid
}
set taken [time {
    tpool::resume $tp
    foreach jid $jids {
        tpool::wait $tp [list $jid]   
    }
}]

tpool::release $tp
puts $taken
tsv::unset a
tsv::unset b
tsv::unset c
unset jids
unset taken
unset tp