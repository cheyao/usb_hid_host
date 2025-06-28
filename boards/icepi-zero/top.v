//
// Example using the usb_hid_host core, for icesugar-pro
// nand2mario, 8/2023
//

module top (
    input clk,
    input [1:0] button,

    // UART
    input usb_rx,
    output usb_tx,

    // LEDs
    output [4:0] led,

    // USB
    inout [1:0] usb_dp,
    inout [1:0] usb_dn,
    // output [1:0] usb_pull_dp,
    // output [1:0] usb_pull_dn
);

wire clk_usb;
wire [1:0] usb_type;
wire [7:0] key_modifiers, key1, key2, key3, key4;
wire [7:0] mouse_btn;
wire signed [7:0] mouse_dx, mouse_dy;
wire [63:0] hid_report;
wire usb_report, usb_conerr, game_l, game_r, game_u, game_d, game_a, game_b, game_x, game_y;
wire game_sel, game_sta;
wire [13:0] dbg_pc;
wire [3:0] dbg_inst;

// assign usb_pull_dp = 2'b0;
// assign usb_pull_dn = 2'b0;

pll clock(
    .clk(clk),
    .clkout0(clk_usb),       // 12Mhz usb clock
    .locked()
);

usb_hid_host usb (
    .usbclk(clk_usb), .usbrst_n(button[0]),
    .usb_dm(usb_dn[0]), .usb_dp(usb_dp[0]),	
    .typ(usb_type), .report(usb_report),
    .key_modifiers(key_modifiers), .key1(key1), .key2(key2), .key3(key3), .key4(key4),
    .mouse_btn(mouse_btn), .mouse_dx(mouse_dx), .mouse_dy(mouse_dy),
    .game_l(game_l), .game_r(game_r), .game_u(game_u), .game_d(game_d),
    .game_a(game_a), .game_b(game_b), .game_x(game_x), .game_y(game_y), 
    .game_sel(game_sel), .game_sta(game_sta),
    .conerr(usb_conerr), .dbg_hid_report(hid_report)
);

hid_printer prt (
    .clk(clk_usb), .resetn(button[0]),
    .uart_tx(usb_tx), .usb_type(usb_type), .usb_report(usb_report),
    .key_modifiers(key_modifiers), .key1(key1), .key2(key2), .key3(key3), .key4(key4),
    .mouse_btn(mouse_btn), .mouse_dx(mouse_dx), .mouse_dy(mouse_dy),
    .game_l(game_l), .game_r(game_r), .game_u(game_u), .game_d(game_d),
    .game_a(game_a), .game_b(game_b), .game_x(game_x), .game_y(game_y), 
    .game_sel(game_sel), .game_sta(game_sta)
);

reg report_toggle;      // blinks whenever there's a report
always @(posedge clk_usb) if (usb_report) report_toggle <= ~report_toggle;

assign led[1:0] = usb_type;
assign led[2] = report_toggle;
assign led[3] = usb_rx;
assign led[4] = usb_tx;

endmodule
