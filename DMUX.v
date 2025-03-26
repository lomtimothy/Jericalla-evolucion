// Diego Jared Jimenez Silva
// Gael Ramses Alvarado Lomelí

module DX(
    input [31:0] IN,  
    input select,     
    output reg [31:0] OUT0, // Salida 0
    output reg [31:0] OUT1  // Salida 1
);

always @(*) begin
    // Filtramos
    case (select)
        1'b0: begin
            OUT0 = IN; 		// Va a la ALU
            OUT1 = 32'b0; 	// OUT1 no se usa en este caso
        end
        1'b1: begin
            OUT0 = 32'b0; 	// OUT0 no se usa en este caso
            OUT1 = IN; 		// Va como dirección de memoria hacia la MD
        end
    endcase
end
endmodule
