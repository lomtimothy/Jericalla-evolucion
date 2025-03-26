// Diego Jared Jimenez Silva
// Gael Ramses Alvarado Lomelí

module BR(
	input [4:0] RA1,		// Read Adress 1
	input [4:0] RA2,		// Read Adress 1
	input [4:0] WA,			// Write Adress 
	input [31:0] DW,		// Data Write
	input WE,				// Write Enable
	output reg [31:0] DR1,	// Data Read 1
	output reg [31:0] DR2	// Data Read 1
);

reg [31:0]mem[0:31]; // Memoria con valores de 32 bits y 32 posiciones 2^5

//Leemos el archivo
initial
begin 
	#100
	$readmemb("Bdatos", mem); 
end

//Asignamos
always @(*) begin
	if (WE) begin
		mem[WA] <= DW;	// Escribimos si WE está activo
	end
end
always @(*) begin
	DR1 = mem[RA1];	// Leemos mem[RA1]
	DR2 = mem[RA2];	// Leemos mem[RA2]
end
endmodule
//--------------