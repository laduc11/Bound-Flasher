module bound_flasher_tb;
  
  parameter HALF_CYCLE = 5;
  parameter CYCLE = HALF_CYCLE * 2;
  
  reg flick, clk, rst;
  wire [15:0] led;
  
  bound_flasher dut(.flick(flick), .clk(clk), .rst(rst), .led(led));
    
  //generate clock
  always begin
    clk = 1'b0;
    #HALF_CYCLE clk = 1'b1;
    #HALF_CYCLE;
  end
  
  initial begin
    rst = 0;		// second 0
    flick = 0; 		// second 0
    #2 rst = 1; 	// second 2

    // Test case :
    #5 flick = 1;	// second 7			(Test case 1) Normal flow
    #3 flick = 0; 	// second 10
	
    #580 flick = 1;	// second 590		(Test case 5) Flick signal to repeat the process
    #3 flick = 0; 	// second 593
	
    #261 flick = 1;	// second 854		(Test case 2) Flick at led 5 in state 2
    #3 flick = 0;	// second 857
    
    #338 flick = 1; // second 1195		(Test case 3) Flick at led 5 in state 4
    #3 flick = 0;	// second 1198
    
    #147 flick = 1;	// second 1345		(Test case 7) Flick between led 5 and led 0 in state 4
    #3 flick = 0;	// second 1348
    
    #16 flick = 1;	// second 1364		(Test case 4) Flick at led 0 in state 4
    #3 flick = 0;	// second 1367
    
    #233 flick = 1;	// second 1600		(Test case 6) Flick at any time slot
    #60 flick = 0;	// second 1660	
    
    #6 rst = 0;		// second 1666		(Test case 8) Reset at any time slot
    #3 rst = 1;		// second 1669
    
    #50 flick = 1;	// second 1719
    #3 flick = 0;	// second 1722

    #264 flick = 1; // second 1986 (Test case 9) Reset signal and flick signal at same time
    rst = 0;
    #3 flick = 0;
    rst = 1;

    //////////////////////////////  
    #(CYCLE*45) $finish;
  end

initial begin
    $recordfile("waves");
    $recordvars("depth=0", bound_flasher_tb);
end

endmodule
