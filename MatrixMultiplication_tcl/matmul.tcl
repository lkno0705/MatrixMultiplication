package require Thread

proc randMatrix { m n } {
    for {set index 0} { $index < $n } { incr index } {
        for {set iindex 0} { $iindex < $m } { incr iindex } {
            set a([expr {$n * $index + $iindex}]) [expr rand()]
        }
    }
    return [array get a]
}

set size 340
set threads 24

set n $size
set m $size
set p $size

set step [expr {$m / $threads}]

set tp [tpool::create -minworkers $threads -maxworkers $threads]
tpool::suspend $tp

tsv::array set a [randMatrix $m $n]
tsv::array set b [randMatrix $n $p]

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
        array set a [tsv::array get a]
        array set b [tsv::array get b]
        for {set i $lower} { $i < $upper } { incr i } {
            for {set k 0} { $k < $p } { incr k } {
                set sum 0
                for {set j 0} { $j < $n } { incr j } {
                    set sum [expr {$sum + $a([expr {$n * $i + $j}]) + $b([expr { $p * $j + $k }])}]
                }
                tsv::array set c [expr {$p * $i + $k}] $sum
            }
        }
    }
    lappend scripts {$script}
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