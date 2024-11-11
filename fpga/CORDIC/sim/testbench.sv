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
    repeat(50) @(posedge clk);
    rst_n = 1'b1;
end

  reg      signed[  31:00]                       angle           ;
  wire           [  31:00]                       cos_out         ;
  wire           [  31:00]                       sin_out         ;

cordic_rotate u_cordic_rotate(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .angle                                             (angle          ),
  .cos_out                                           (cos_out        ),
  .sin_out                                           (sin_out        ) 
);




  reg      signed[  31:00]                       x_value         ;
  reg      signed[  31:00]                       y_value         ;
  wire                                           out_valid       ;
  wire           [  31:00]                       phase           ;
  wire           [  31:00]                       value           ;

cordic_vector u_cordic_vector(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .x_value                                           (x_value        ),
  .y_value                                           (y_value        ),
  .out_valid                                         (out_valid      ),
  .phase                                             (phase          ),
  .value                                             (value          ) 
);




initial
begin
    angle = 0;
    x_value =0;
    y_value = 0;
    wait(rst_n);
    //repeat(5) @(posedge clk); 
    //angle = 45;
    //repeat(50) @(posedge clk); 
    //angle = 30;
    //repeat(50) @(posedge clk); 
    //angle = 60;
    //repeat(50) @(posedge clk); 
    repeat(1)begin
       angle =0;
       x_value = 3 <<< 16;
       y_value = 4 <<<16;
      repeat(360)begin
        repeat(20) @(posedge clk);
        angle = angle + 1 ;
        x_value = (-8) <<< 16;
        y_value = (-6) <<<16;
      end
    end
    repeat(500) @(posedge clk);
    $stop(2);
end

endmodule