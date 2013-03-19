# ====================================================================

# Define Node Configuration paramaters

#====================================================================

set val(chan)           Channel/WirelessChannel    ;#Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             6                     ;# number of mobilenodes
set val(rp)             DSDV                       ;# routing protocol
set val(x)  	500
set val(y)		500
set opt(energymodel)    EnergyModel                ;
set opt(radiomodel)     RadioModel                 ;
set opt(initialenergy)  100                        ;# Initial energy in Joules




Phy/WirelessPhy set CPThresh_ 10.0
Phy/WirelessPhy set CSThresh_ 1.559e-11
Phy/WirelessPhy set RXThresh_ 3.652e-10
Phy/WirelessPhy set bandwidth_ 2e6
Phy/WirelessPhy set Pt_ 0.2818    
Phy/WirelessPhy set freq_ 914e+6
Mac/802_11 set dataRate_  2.0e6   

set ns_		[new Simulator]


set tracefd     [open Isth.tr w]
$ns_ trace-all $tracefd

set namtrace [open Isth.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)



set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)


create-god $val(nn)

set chan_1_ [new $val(chan)]
set chan_2_ [new $val(chan)]



$ns_ node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-movementTrace ON \
		-idlePower 0.035 \
		-rxPower 0.395 \
		-txPower 0.660 \
          	-sleepPower 0.001 \
          	-transitionPower 0.1 \
          	-transitionTime 0.003 \
                -channel $chan_1_ 


$ns_ node-config \		 channel $chan_2_ 


set node_(0) [$ns_ node]
set node_(1) [$ns_ node] 
set node_(2) [$ns_ node]
set node_(3) [$ns_ node]
set node_(4) [$ns_ node]
set node_(5) [$ns_ node]



$node_(0) random-motion 0 
$node_(1) random-motion 0
$node_(2) random-motion 0
$node_(3) random-motion 0
$node_(4) random-motion 0
$node_(5) random-motion 0

for {set i 0} {$i < $val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 20 
}


$node_(0) set X_ 242.422
$node_(0) set Y_ 285.783
$node_(0) set Z_ 10.0
	
$node_(1) set X_ 343.926
$node_(1) set Y_ 219.592
$node_(1) set Z_ 10.0

$node_(2) set X_ 320.275
$node_(2) set Y_ 96.5757
$node_(2) set Z_ 10.0

$node_(3) set X_ 205.962
$node_(3) set Y_ 167.529
$node_(3) set Z_ 10.0

$node_(4) set X_ 198.078
$node_(4) set Y_ 41.3896
$node_(4) set Z_ 10.0

$node_(5) set X_ 99.532
$node_(5) set Y_ 135.008
$node_(5) set Z_ 10.0



$node_(4) color brown
$node_(2) color green
$node_(0) color orange


$ns_ at 0 "$node_(0) setdest 242.422 285.783 10.0"
$ns_ at 0 "$node_(1) setdest 343.926 219.592 10.0"
$ns_ at 0 "$node_(2) setdest 320.275 96.5757 10.0"
$ns_ at 0 "$node_(3) setdest 205.962 167.529 10.0"
$ns_ at 0 "$node_(4) setdest 198.078 41.3896 10.0"
$ns_ at 0 "$node_(5) setdest 99.532 135.008 10.0"


$ns_ at 0.4 "$node_(0) color brown"
$ns_ at 0.4 "$node_(0) label T"

$ns_ at 0.4 "$node_(4) color blue"
$ns_ at 0.4 "$node_(4) label S1"

$ns_ at 1.0 "$node_(2) color orange"
$ns_ at 1.0 "$node_(2) label S2"





Agent/TCP set packetSize_	1000

set tcp [new Agent/TCP]
$tcp set class_ 2
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(4) $tcp
$ns_ attach-agent $node_(3) $sink1
$ns_ connect $tcp $sink1
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 1.0 "$ftp start" 
$ns_ at 10.0 "$ftp stop" 

Agent/TCP set packetSize_	1000

set tcp1 [new Agent/TCP]
$tcp1 set class_ 5
set sink2 [new Agent/TCPSink]
$ns_ attach-agent $node_(3) $tcp1
$ns_ attach-agent $node_(0) $sink2
$ns_ connect $tcp1 $sink2
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns_ at 1.0 "$ftp1 start" 
$ns_ at 10.0 "$ftp1 stop" 



Agent/TCP set packetSize_	1000

set tcp2 [new Agent/TCP]
$tcp2 set class_ 1
set sink3 [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $tcp2
$ns_ attach-agent $node_(3) $sink3
$ns_ connect $tcp2 $sink3
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns_ at 10.0 "$ftp2 start" 
$ns_ at 25.0 "$ftp2 stop" 


Agent/TCP set packetSize_	1000

set tcp3 [new Agent/TCP]
$tcp3 set class_ 4
set sink4 [new Agent/TCPSink]
$ns_ attach-agent $node_(3) $tcp3
$ns_ attach-agent $node_(0) $sink4
$ns_ connect $tcp3 $sink4
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ns_ at 10.0 "$ftp3 start" 
$ns_ at 25.0 "$ftp3 stop" 


for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 20.0 "$node_($i) reset";
}

$ns_ at 30.0 "stop"
$ns_ at 30.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
	puts "running nam..."
	exec nam Isth &
}
puts "Starting Simulation..."


$ns_ run
