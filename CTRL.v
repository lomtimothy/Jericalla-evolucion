// Diego Jared Jimenez Silva
// Gael Ramses Alvarado Lomelí

module CTRL(
	input [1:0] IN,    		// Entrada de 2 bits
	output reg WE,     		// Salida del banco de registros (declarada como reg para uso en always)
	output reg DMUX,   		// Para filtrar el caso SW
	output reg W,      		// Escritura de MemDatos
	output reg R,       	// Lectura de MemDatos
	output reg [3:0] ALUOP 	// Opción de operación en la ALU
);

always @(*) begin
	// Decodificador
	case (IN)
		// Caso de la suma
		2'b00: begin
			WE = 1'b1;       // Escribimos en el banco de registros
			DMUX = 1'b0;     // Describimos si uitilizaremos la ALU
			W = 1'b0;        // No utilizamos MemDatos
			R = 1'b0;        // No utilizamos MemDatos
			ALUOP = 4'b0010; // Mandamos la instrucción a la ALU
		end

		// Caso de la resta
		2'b01: begin
			WE = 1'b1;
			DMUX = 1'b0;
			W = 1'b0;
			R = 1'b0;
			ALUOP = 4'b0110;   
		end

		// Caso de la ternaria
		2'b10: begin
			WE = 1'b1;
			DMUX = 1'b0;
			W = 1'b0;
			R = 1'b0;
			ALUOP = 4'b0111;   
		end

		// Caso StoreWord
		2'b11: begin
			WE = 1'b0;
			DMUX = 1'b1;
			W = 1'b1;
			R = 1'b0;        // En esta actividad no leeremos por el momento
			ALUOP = 4'b1111; // No utilizamos la ALU aqui, forzamos el caso default
		end
	endcase
end
endmodule