//Diego Jared Jimenez Silva
// Gael Ramses Alvarado Lomelí

// Modulo Jericalla
module Jericalla(
	input [16:0] instruccion,
	input clk,
	output [31:0] salida
);

// Buffer para WA al inicio
wire [4:0] WAB1, WAB2;
// Control
wire C1, C2, C3, C4;
wire [3:0] CALU;
wire [3:0] CALUB1;
wire C1B1, C2B1, C3B1, C4B1;
wire C1B2, C3B2, C4B2;
// Banco de datos
wire [31:0] CDR1, CDR2;
wire [31:0] CDR1B1, CDR2B1;
wire [31:0] CDR1DX, CDR2DX;
wire [31:0] CDR1B2, CDR2B2;
//Buffer
wire [76:0] cable_combinado1;
wire [76:0] cable_salida1;
wire [103:0] cable_combinado2;
wire [103:0] cable_salida2;
// Demultiplexor
wire [31:0]DM1,DM2;
// ALU
wire [31:0] CRES;
wire [31:0] CRESB2;

// Instanciamos
CTRL	CtTest (.IN(instruccion [16:15]),.WE(C1),.ALUOP(CALU),.DMUX(C2),.W(C3),.R(C4));		
BR		BrTest (.RA1(instruccion [9:5]),.RA2(instruccion [4:0]),.WA(instruccion [14:10]),.DW(CRESB2),.WE(C1B2),.DR1(CDR1),.DR2(CDR2));
DX		D1Test (.IN(CDR1B1),.select(C2B1),.OUT0(DM1),.OUT1(CDR1DX));
DX		D2Test (.IN(CDR2B1),.select(C2B1),.OUT0(DM2),.OUT1(CDR2DX));
ALU		ALUTest(.A(DM1),.B(DM2),.OP(CALUB1),.RES(CRES));
MD		MDTest (.ADR(CDR1B2),.DIN(CDR2B2),.W(C3B2),.R(C4B2),.DOUT(salida));

// Pasamos todos los datos por el buffer 1
assign	cable_combinado1 = {instruccion[14:10],C1,C2,C3,C4,CALU,CDR1,CDR2};
BF#(77)	B1Test (.IN(cable_combinado1),.CLK(clk),.OUT(cable_salida1));

assign WAB1 = cable_salida1[76:72]; 	// WA ocupa los bits del 76 al 72
assign C1B1 = cable_salida1[71];    	// C1 ocupa el bit 71
assign C2B1 = cable_salida1[70];    	// C2 ocupa el bit 70
assign C3B1 = cable_salida1[69];    	// C3 ocupa el bit 69
assign C4B1 = cable_salida1[68];    	// C4 ocupa el bit 68
assign CALUB1 = cable_salida1[67:64]; 	// CALU ocupa los bits del 67 al 64
assign CDR1B1 = cable_salida1[63:32];  	// DR1 ocupa los bits del 63 al 32
assign CDR2B1 = cable_salida1[31:0];   	// DR2 ocupa los bits del 31 al 0

// Pasamos todos los datos por el buffer 2
assign	cable_combinado2 = {WAB1,C1B1,C3B1,C4B1,CRES,CDR1DX,CDR2DX};
BF#(104)	B2Test (.IN(cable_combinado2),.CLK(clk),.OUT(cable_salida2));

assign WAB2 = cable_salida2[103:99];    // WA ocupa los bits del 103 al 99
assign C1B2 = cable_salida2[98];        // C1 ocupa el bit 98
assign C3B2 = cable_salida2[97];        // C3 ocupa el bit 97
assign C4B2 = cable_salida2[96];        // C4 ocupa el bit 96
assign CRESB2 = cable_salida2[95:64];   // CRES ocupa los bits del 95 al 64
assign CDR1B2 = cable_salida2[63:32];  	// CDR1DX ocupa los bits del 63 al 32
assign CDR2B2 = cable_salida2[31:0];   	// CDR2DX ocupa los bits del 31 al 0
endmodule 


// Testbench
module Jericalla_tb();

// Parámetro: número de instrucciones en el archivo "datos.txt"
 parameter NUM_INSTR = 6;
  
reg [16:0] instruccion;
reg clk;
wire [31:0] salida;

// Memoria para almacenar las instrucciones leídas del archivo
  reg [16:0] instr_mem [0:NUM_INSTR-1];

// Instancia del módulo Jericalla
Jericalla JTestBench (.instruccion(instruccion),.clk(clk),.salida(salida));

 integer i;
 
// Reloj
initial begin
    clk = 0;
    forever #100 clk = ~clk; //Tiempo para que se procesen los datos devidamente
end

initial begin	
// Esperar un breve lapso para que se inicialicen otros bloques
    #1000;
    // Cargar el archivo binario generado por Python ("datos.txt") en la memoria instr_mem
    $readmemb("datos.txt", instr_mem);
	
      // Recorremos las instrucciones una a una
    for (i = 0; i < NUM_INSTR; i = i + 1) begin
      instruccion = instr_mem[i];
      // Esperar tiempo suficiente para que la instrucción se ejecute (ajusta según tu diseño)
      #1000;
    end
    
    $stop;
  end
  
endmodule
