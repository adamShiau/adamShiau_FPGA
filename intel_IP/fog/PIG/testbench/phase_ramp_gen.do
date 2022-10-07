onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sim_phase_ramp_gen_tb/eachvec
add wave -noupdate /sim_phase_ramp_gen_tb/i_amp_H
add wave -noupdate /sim_phase_ramp_gen_tb/i_amp_L
add wave -noupdate -radix decimal /sim_phase_ramp_gen_tb/i_fb_ON
add wave -noupdate /sim_phase_ramp_gen_tb/i_freq_cnt
add wave -noupdate /sim_phase_ramp_gen_tb/i_gain_sel
add wave -noupdate -format Analog-Step -height 74 -max 70.0 -radix decimal /sim_phase_ramp_gen_tb/i_mod
add wave -noupdate /sim_phase_ramp_gen_tb/i_rst_n
add wave -noupdate /sim_phase_ramp_gen_tb/i_step
add wave -noupdate /sim_phase_ramp_gen_tb/o_SM
add wave -noupdate /sim_phase_ramp_gen_tb/o_change
add wave -noupdate /sim_phase_ramp_gen_tb/i_clk
add wave -noupdate -radix decimal /sim_phase_ramp_gen_tb/o_gain_sel
add wave -noupdate -radix decimal /sim_phase_ramp_gen_tb/o_gain_sel2
add wave -noupdate -format Analog-Step -height 74 -max 3000.0 -min -3000.0 -radix decimal /sim_phase_ramp_gen_tb/o_mod_out
add wave -noupdate -format Analog-Step -height 74 -max 397687.0 -radix decimal /sim_phase_ramp_gen_tb/o_phaseRamp
add wave -noupdate -format Analog-Step -height 74 -max 800000.0 -min -698000.0 -radix decimal /sim_phase_ramp_gen_tb/o_phaseRamp_pre
add wave -noupdate -format Analog-Step -height 74 -max 32756.999999999996 -min -32743.0 -radix decimal /sim_phase_ramp_gen_tb/DACP
add wave -noupdate -format Analog-Step -height 74 -max 32741.999999999996 -min -32758.0 -radix decimal /sim_phase_ramp_gen_tb/DACN
add wave -noupdate -format Analog-Step -height 74 -max 65463.000000000015 -min -65485.0 -radix decimal /sim_phase_ramp_gen_tb/DAC_diff
add wave -noupdate /sim_phase_ramp_gen_tb/o_ramp_init
add wave -noupdate /sim_phase_ramp_gen_tb/o_status
add wave -noupdate /sim_phase_ramp_gen_tb/o_stepTrig
add wave -noupdate /sim_phase_ramp_gen_tb/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {162649555 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 295
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {530001952 ps}
