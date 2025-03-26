// Diego Jared Jimenez Silva
// Gael Ramses Alvarado Lomelí

//Memoria de datos
module MD(
	input [31:0] ADR,
	input [31:0] DIN,
	input W,
	input R,
	output reg [31:0] DOUT
);

reg [31:0]mem[0:127]; // Memoria con valores de 32 bits y 128 posiciones 2^7

//Leemos el archivo
initial
begin 
	#100
	$readmemb("Mdatos", mem); 
end

//Asignaciones
// Utilizamos <= por ser comun en operaciones de lectura y escritura 
// para leer y escribir difernetes datos en paralelo si es necesario
always @(*) begin
    if (W && !R) begin
        mem[ADR] = DIN; // Escritura
    end
    if (R && !W) begin
        DOUT = mem[ADR]; // Lectura
    end
	else begin
		DOUT = 32'd0;	// Default
	end
end
endmodule
