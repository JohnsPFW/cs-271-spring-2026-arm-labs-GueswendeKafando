//----------------------------------------------------------------------------
//The information contained in this file may only be used by a person
//authorised under and to the extent permitted by a subsisting licensing 
//agreement from Arm Limited or its affiliates 
//
//(C) COPYRIGHT 2020 Arm Limited or its affiliates
//ALL RIGHTS RESERVED.
//Licensed under the ARM EDUCATION INTRODUCTION TO COMPUTER ARCHITECTURE 
//EDUCATION KIT END USER LICENSE AGREEMENT.
//See https://www.arm.com/-/media/Files/pdf/education/computer-architecture-education-kit-eula
//
//This entire notice must be reproduced on all copies of this file
//and copies of this file may only be made by a person if such person is
//permitted to do so under the terms of a subsisting license agreement
//from Arm Limited or its affiliates.
//----------------------------------------------------------------------------
module test();
reg     clk, in, out;
reg [3:0]   fifo;
reg [7:0] memory [0:3]; //four 8-bit data
reg [7:0] m0, m1, m2, m3;

   initial
    begin
		//$dumpvars(0, test);
        clk = 0; in = 1; out = 0; 
        fifo[3] = 0; fifo[2] = 0; fifo[1] = 0; fifo[0] = 0;
		$display("Reading memory file now.");
		$readmemh("data.mem", memory);
		m0 <= memory[0];
		m1 <= memory[1];
		m2 <= memory[2];
		m3 <= memory[3];
        #90 $finish;
    end

    always #5 clk = ~clk;

    always@(posedge clk)
    begin
        out = fifo[3];
        fifo[3] = fifo[2]; fifo[2] = fifo[1]; fifo[1] = fifo[0];
        fifo[0] = in;
        $display("At time = %t, fifo in = %d, fifo out = %d \n\n", $time, in, out);
    end
    
endmodule
