module seven_seg_ctrl
(
    input wire [15:0] i_data,
    output reg [7:0] o_display,
    output wire [3:0] o_anode,
    input wire i_clk,
    input wire i_rstn
);

reg [3:0] anode = 4'b1111;
reg [3:0] data_slice = 4'b0000;
reg [17:0] counter = 0;

assign o_anode = anode;

always @(posedge i_clk) begin
    if (!i_rstn) begin
        o_display <= 8'h7E;
        anode <= 4'b1111;
        data_slice <= 0;
        counter <= 0;
    end else begin
        counter <= counter + 1;

        case(counter[17:16]) 
            2'b00 : begin
                data_slice <= i_data[3:0];
                anode = 4'b1110;
            end
            2'b01: begin
                data_slice = i_data[7:4];
                anode = 4'b1101;
            end
            2'b10: begin
                data_slice = i_data[11:8];
                anode = 4'b1011;
            end
            2'b11: begin
                data_slice = i_data[15:12];
                anode = 4'b0111;
            end
        endcase

        case (data_slice)
            4'b0000:
                o_display <= 8'b01000000;  
            4'b0001:
                o_display <= 8'b01111001; 
            4'b0010:
                o_display <= 8'b00100100;  
            4'b0011:
                o_display <= 8'b00110000;  
            4'b0100:
                o_display <= 8'b00011001;  
            4'b0101:
                o_display <= 8'b00010010;  
            4'b0110:
                o_display <= 8'b00000010; 
            4'b0111:
                o_display <= 8'b01111000;  
            4'b1000:
                o_display <= 8'b00000000;  
            4'b1001:
                o_display <= 8'b00010000; 
            4'b1010:
                o_display <= 8'b00001000;
            4'b1011:
                o_display <= 8'b00000011;
            4'b1100:
                o_display <= 8'b01000110;
            4'b1101:
                o_display <= 8'b00100001;
            4'b1110:
                o_display <= 8'b00000110; 
            4'b1111:
                o_display <= 8'b00001110; 
        endcase
    end
end
endmodule
