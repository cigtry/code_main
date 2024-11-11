`timescale  1ns/1ns
module testbench;

//----------------------------------------------------------------------
//  clk & rst_n
  reg                                            clk             ;
  reg                                            rst_n           ;

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial
begin
    rst_n = 1'b0;
    repeat(15) @(posedge clk);
    rst_n = 1'b1;
end
    reg                       [  07:00]        data_in                    ;
    wire                      [  07:00]        data_out                   ;
    wire                                       data_out_valid             ;

pipe u_pipe(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .data_in                            (data_in                   ),
    .data_out                           (data_out                  ),
    .data_out_valid                     (data_out_valid            )
);

initial
begin
  data_in = 0;
    wait(rst_n);
    repeat(1) @(posedge clk);
    data_in = 3;
    repeat(1) @(posedge clk);
    data_in = 6;
    repeat(1) @(posedge clk);
    data_in = 7;
    repeat(1) @(posedge clk);
    data_in = 4;
    repeat(1) @(posedge clk);
    data_in = 7;
    repeat(1) @(posedge clk);
    data_in = 5;
    repeat(1) @(posedge clk);
    data_in = 5;
    repeat(1) @(posedge clk);
    data_in = 1;
    repeat(10)begin
      @(posedge clk);
      data_in = {$random}%100;
    end
    $stop;
end
endmodule