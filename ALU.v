// Diego Jared Jimenez Silva
// Gael Ramses Alvarado Lomelí

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] OP,
    output reg [31:0] RES
);

//En esta ocasion solo mandaremos a llamar
always @(*) begin
    case(OP)
        4'b0000: RES = A & B;      // AND
        4'b0001: RES = A | B;      // OR
        4'b0010: RES = A + B;      // ADD
        4'b0110: RES = A - B;      // SUBSTRACT
        4'b0111: RES = (A < B) ? 32'd1 : 32'd0;  // TERNARIA
        4'b1100: RES = ~(A | B); 	//NOR
        default: RES = 32'd0;
    endcase
end
endmodule

