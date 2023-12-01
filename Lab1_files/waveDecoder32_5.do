onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Decoder32_5_testbench/RegWrite
add wave -noupdate /Decoder32_5_testbench/WriteRegister
add wave -noupdate /Decoder32_5_testbench/WriteEn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {318431 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 251
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {32720 ps} {335120 ps}
