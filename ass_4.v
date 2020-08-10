module traffic_lights(clk, reset, Ta, Tb, La, Lb);
input clk, reset, Ta, Tb;

output reg [2:0] La,Lb; //001 for green; 010 for yellow; 100 for red

parameter S0 = 2'b00; // La=001 & Lb=100
parameter S1 = 2'b01; // La=100 & Lb=010
parameter S2 = 2'b10; // La=100 & Lb=001
parameter S3 = 2'b11; // La=010 & Lb=100

reg [1:0]present, next;

always@(posedge clk, posedge reset)
	if(reset) present <= S0;
	else present <= next;

always@(present, Ta, Tb)
	case(present)
	S0 : begin 
		La = 3'b001; Lb = 3'b100;
		if(Ta==0&&Tb==1) next = S1;
		else next = S0;
	     end
	S1 : begin
		La=3'b100; Lb = 3'b010;
		next = S2;
	     end
	S2 : begin
		La = 3'b100; Lb= 3'b001;
		if(Tb) next = S2;
		else next = S3;
	     end
	S3 : begin
		La = 3'b010; Lb = 3'b100;
		next = S0;
	     end
	default : begin 
		    La = 3'b001; Lb = 3'b100;
		    next = S0;
	         	end
	endcase

endmodule

module test_trafficcontroller;
reg clk, reset, Ta, Tb;
wire [2:0]La,Lb;
traffic_lights controller(clk, reset, Ta, Tb, La, Lb);

initial
	begin
	clk = 0;
	forever #2 clk = ~clk;  
end
initial 
fork
	reset = 0;
	#7 Ta=0;Tb=0;
	#11 Ta=1;
	#17 Ta=0;Tb=1;
	#23 Ta=1;
	#27 Tb=0;
	#35 Ta=1;Tb=1;
	#39 Tb=0;
	#50 $finish;
join

endmodule
