onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sim_err_signal_gen_tb/i_adc_data
add wave -noupdate /sim_err_signal_gen_tb/i_amp_H
add wave -noupdate /sim_err_signal_gen_tb/i_amp_L
add wave -noupdate /sim_err_signal_gen_tb/i_avg_sel
add wave -noupdate /sim_err_signal_gen_tb/i_clk
add wave -noupdate /sim_err_signal_gen_tb/i_err_offset
add wave -noupdate /sim_err_signal_gen_tb/i_freq_cnt
add wave -noupdate /sim_err_signal_gen_tb/i_polarity
add wave -noupdate /sim_err_signal_gen_tb/i_rst_n
add wave -noupdate /sim_err_signal_gen_tb/o_SM
add wave -noupdate -radix decimal /sim_err_signal_gen_tb/o_mod_out
add wave -noupdate -radix decimal /sim_err_signal_gen_tb/o_change
add wave -noupdate -radix decimal /sim_err_signal_gen_tb/o_adc
add wave -noupdate -radix decimal /sim_err_signal_gen_tb/o_adc_sum
add wave -noupdate -color Plum -radix decimal /sim_err_signal_gen_tb/o_adc_new
add wave -noupdate -color Turquoise -radix decimal /sim_err_signal_gen_tb/o_adc_old
add wave -noupdate -color {Cornflower Blue} -itemcolor {Cornflower Blue} -radix decimal /sim_err_signal_gen_tb/o_err
add wave -noupdate /sim_err_signal_gen_tb/o_sync
add wave -noupdate /sim_err_signal_gen_tb/o_stepTrig
add wave -noupdate -radix decimal /sim_err_signal_gen_tb/o_cstate
add wave -noupdate -radix decimal /sim_err_signal_gen_tb/o_nstate
add wave -noupdate /sim_err_signal_gen_tb/o_status
add wave -noupdate /sim_err_signal_gen_tb/o_flip_flag
add wave -noupdate /sim_err_signal_gen_tb/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {199800135 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 253
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
WaveRestoreZoom {198574359 ps} {206855641 ps}
