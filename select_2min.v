`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/05 09:52:26
// Design Name: 
// Module Name: select_2min
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module select_2min(
    input clk,
    input rst_n,
    input data_in_start_en,
    input data_count_finish,
    
    input [8:0]data_num_count_w9,   //数据9的频度 下同
    input [8:0]data_num_count_w8,
    input [8:0]data_num_count_w7,
    input [8:0]data_num_count_w6,
    input [8:0]data_num_count_w5,
    input [8:0]data_num_count_w4,
    input [8:0]data_num_count_w3,
    input [8:0]data_num_count_w2,
    input [8:0]data_num_count_w1,
    input [8:0]data_num_count_w0,
    
    input [4:0] new_root_index, //新增枝节的索引
    
//    output [8:0]nummem_0,
//    output [8:0]nummem_1,
//    output [8:0]nummem_2,
//    output [8:0]nummem_3,
//    output [8:0]nummem_4,
//    output [8:0]nummem_5,
//    output [8:0]nummem_6,
//    output [8:0]nummem_7,
//    output [8:0]nummem_8,
//    output [8:0]nummem_9,
    output reg [3:0] min1_num_index,
    output reg [3:0] min2_num_index,
    output [9:0] min1_mask,
    output [9:0] min2_mask,
    output reg [4:0]min1,
    output reg [4:0]min2

    );
    
    reg [8:0] freqMem [9:0];
    reg [4:0] numMem [9:0];
    wire [8:0] new_freq;
    wire [4:0] num_max;
    wire [8:0] freq_max;
    reg init = 0; //初始化标志
    reg [3:0] code_count = 4'b0000;   //记录九个周期处理时间

    wire [8:0] comp_0;  //比较矩阵  //左移操作那个真的需要扩展1bit吗？？？？？？？？？？？
    wire [8:0] comp_1;
    wire [8:0] comp_2;
    wire [8:0] comp_3;
    wire [8:0] comp_4;
    wire [8:0] comp_5;
    wire [8:0] comp_6;
    wire [8:0] comp_7;
    wire [8:0] comp_8;
    wire [8:0] comp_9;
    
    assign new_freq = freqMem[min1_num_index]+freqMem[min2_num_index];
    assign num_max = 5'b11111;
    assign freq_max = 9'b1111_11111;
    //以下代码用来找出最小的两个
    assign comp_0 = {(freqMem[0] > freqMem[1]), (freqMem[0] > freqMem[2]), (freqMem[0] > freqMem[3]),
                     (freqMem[0] > freqMem[4]), (freqMem[0] > freqMem[5]), (freqMem[0] > freqMem[6]),
                     (freqMem[0] > freqMem[7]), (freqMem[0] > freqMem[8]), (freqMem[0] > freqMem[9])};
    assign comp_1 = {(freqMem[1] >= freqMem[0]), (freqMem[1] > freqMem[2]), (freqMem[1] > freqMem[3]), 
                     (freqMem[1] > freqMem[4]), (freqMem[1] > freqMem[5]), (freqMem[1] > freqMem[6]),
                     (freqMem[1] > freqMem[7]), (freqMem[1] > freqMem[8]), (freqMem[1] > freqMem[9])};
    assign comp_2 = {(freqMem[2] >= freqMem[0]), (freqMem[2] >= freqMem[1]), (freqMem[2] > freqMem[3]), 
                     (freqMem[2] > freqMem[4]), (freqMem[2] > freqMem[5]), (freqMem[2] > freqMem[6]),
                     (freqMem[2] > freqMem[7]), (freqMem[2] > freqMem[8]), (freqMem[2] > freqMem[9])};
    assign comp_3 = {(freqMem[3] >= freqMem[0]), (freqMem[3] >= freqMem[1]), (freqMem[3] >= freqMem[2]),
                     (freqMem[3] > freqMem[4]), (freqMem[3] > freqMem[5]), (freqMem[3] > freqMem[6]),
                     (freqMem[3] > freqMem[7]), (freqMem[3] > freqMem[8]), (freqMem[3] > freqMem[9])};
    assign comp_4 = {(freqMem[4] >= freqMem[0]), (freqMem[4] >= freqMem[1]), (freqMem[4] >= freqMem[2]), 
                     (freqMem[4] >= freqMem[3]), (freqMem[4] > freqMem[5]), (freqMem[4] > freqMem[6]),
                     (freqMem[4] > freqMem[7]), (freqMem[4] > freqMem[8]), (freqMem[4] > freqMem[9])};
    assign comp_5 = {(freqMem[5] >= freqMem[0]), (freqMem[5] >= freqMem[1]), (freqMem[5] >= freqMem[2]), 
                     (freqMem[5] >= freqMem[3]), (freqMem[5] >= freqMem[4]), (freqMem[5] > freqMem[6]),
                     (freqMem[5] > freqMem[7]), (freqMem[5] > freqMem[8]), (freqMem[5] > freqMem[9])};
    assign comp_6 = {(freqMem[6] >= freqMem[0]), (freqMem[6] >= freqMem[1]), (freqMem[6] >= freqMem[2]), 
                     (freqMem[6] >= freqMem[3]), (freqMem[6] >= freqMem[4]), (freqMem[6] >= freqMem[5]),
                     (freqMem[6] > freqMem[7]), (freqMem[6] > freqMem[8]), (freqMem[6] > freqMem[9])};
    assign comp_7 = {(freqMem[7] >= freqMem[0]), (freqMem[7] >= freqMem[1]), (freqMem[7] >= freqMem[2]), 
                     (freqMem[7] >= freqMem[3]), (freqMem[7] >= freqMem[4]), (freqMem[7] >= freqMem[5]),
                     (freqMem[7] >= freqMem[6]), (freqMem[7] > freqMem[8]), (freqMem[7] > freqMem[9])};
    assign comp_8 = {(freqMem[8] >= freqMem[0]), (freqMem[8] >= freqMem[1]), (freqMem[8] >= freqMem[2]), 
                     (freqMem[8] >= freqMem[3]), (freqMem[8] >= freqMem[4]), (freqMem[8] >= freqMem[5]),
                     (freqMem[8] >= freqMem[6]), (freqMem[8] >= freqMem[7]), (freqMem[8] > freqMem[9])};
    assign comp_9 = {(freqMem[9] >= freqMem[0]), (freqMem[9] >= freqMem[1]), (freqMem[9] >= freqMem[2]), 
                     (freqMem[9] >= freqMem[3]), (freqMem[9] >= freqMem[4]), (freqMem[9] >= freqMem[5]),
                     (freqMem[9] >= freqMem[6]), (freqMem[9] >= freqMem[7]), (freqMem[9] >= freqMem[8])};
    
//    assign min1_mask = {(comp_9==9'd0)?1'b1:1'b0,(comp_8==9'd0)?1'b1:1'b0,(comp_7==9'd0)?1'b1:1'b0,(comp_6==9'd0)?1'b1:1'b0,(comp_5==9'd0)?1'b1:1'b0,
//                      (comp_4==9'd0)?1'b1:1'b0,(comp_3==9'd0)?1'b1:1'b0,(comp_2==9'd0)?1'b1:1'b0,(comp_1==9'd0)?1'b1:1'b0,(comp_0==9'd0)?1'b1:1'b0};
    
     assign min1_mask = {(comp_9==9'd0),(comp_8==9'd0),(comp_7==9'd0),(comp_6==9'd0),(comp_5==9'd0),
                      (comp_4==9'd0),(comp_3==9'd0),(comp_2==9'd0),(comp_1==9'd0),(comp_0==9'd0)};
    
     assign min2_mask = {((comp_9==9'd1)||(comp_9==9'd2)||(comp_9==9'd4)||(comp_9==9'd8)||(comp_9==9'd16)||
                         (comp_9==9'd32)||(comp_9==9'd64)||(comp_9==9'd128)||(comp_9==9'd256)),
                         ((comp_8==9'd1)||(comp_8==9'd2)||(comp_8==9'd4)||(comp_8==9'd8)||(comp_8==9'd16)||
                         (comp_8==9'd32)||(comp_8==9'd64)||(comp_8==9'd128)||(comp_8==9'd256)),
                         ((comp_7==9'd1)||(comp_7==9'd2)||(comp_7==9'd4)||(comp_7==9'd8)||(comp_7==9'd16)||
                         (comp_7==9'd32)||(comp_7==9'd64)||(comp_7==9'd128)||(comp_7==9'd256)),
                         ((comp_6==9'd1)||(comp_6==9'd2)||(comp_6==9'd4)||(comp_6==9'd8)||(comp_6==9'd16)||
                         (comp_6==9'd32)||(comp_6==9'd64)||(comp_6==9'd128)||(comp_6==9'd256)),
                         ((comp_5==9'd1)||(comp_5==9'd2)||(comp_5==9'd4)||(comp_5==9'd8)||(comp_5==9'd16)||
                         (comp_5==9'd32)||(comp_5==9'd64)||(comp_5==9'd128)||(comp_5==9'd256)),
                         ((comp_4==9'd1)||(comp_4==9'd2)||(comp_4==9'd4)||(comp_4==9'd8)||(comp_4==9'd16)||
                         (comp_4==9'd32)||(comp_4==9'd64)||(comp_4==9'd128)||(comp_4==9'd256)),
                         ((comp_3==9'd1)||(comp_3==9'd2)||(comp_3==9'd4)||(comp_3==9'd8)||(comp_3==9'd16)||
                         (comp_3==9'd32)||(comp_3==9'd64)||(comp_3==9'd128)||(comp_3==9'd256)),
                         ((comp_2==9'd1)||(comp_2==9'd2)||(comp_2==9'd4)||(comp_2==9'd8)||(comp_2==9'd16)||
                         (comp_2==9'd32)||(comp_2==9'd64)||(comp_2==9'd128)||(comp_2==9'd256)),
                         ((comp_1==9'd1)||(comp_1==9'd2)||(comp_1==9'd4)||(comp_1==9'd8)||(comp_1==9'd16)||
                         (comp_1==9'd32)||(comp_1==9'd64)||(comp_1==9'd128)||(comp_1==9'd256)),
                         ((comp_0==9'd1)||(comp_0==9'd2)||(comp_0==9'd4)||(comp_0==9'd8)||(comp_0==9'd16)||
                         (comp_0==9'd32)||(comp_0==9'd64)||(comp_0==9'd128)||(comp_0==9'd256))};
 
                         
 
     always @(comp_0 or comp_1 or comp_2 or comp_3 or comp_4 or comp_5 or comp_6 or comp_7 or comp_8 or comp_9 or min1_mask)
     begin
         case(min1_mask)
             10'b10000_00000 : min1 <= numMem[9];
             10'b01000_00000 : min1 <= numMem[8];
             10'b00100_00000 : min1 <= numMem[7];
             10'b00010_00000 : min1 <= numMem[6];
             10'b00001_00000 : min1 <= numMem[5];
             10'b00000_10000 : min1 <= numMem[4];
             10'b00000_01000 : min1 <= numMem[3];
             10'b00000_00100 : min1 <= numMem[2];
             10'b00000_00010 : min1 <= numMem[1];
             default : min1 <= numMem[0];
         endcase
     end
     
     always @(comp_0 or comp_1 or comp_2 or comp_3 or comp_4 or comp_5 or comp_6 or comp_7 or comp_8 or comp_9 or min2_mask)
     begin
         case(min2_mask)
             10'b10000_00000 : min2 <= numMem[9];
             10'b01000_00000 : min2 <= numMem[8];
             10'b00100_00000 : min2 <= numMem[7];
             10'b00010_00000 : min2 <= numMem[6];
             10'b00001_00000 : min2 <= numMem[5];
             10'b00000_10000 : min2 <= numMem[4];
             10'b00000_01000 : min2 <= numMem[3];
             10'b00000_00100 : min2 <= numMem[2];
             10'b00000_00010 : min2 <= numMem[1];
             default : min2 <= numMem[0];
         endcase
     end
     
     always @(comp_0 or comp_1 or comp_2 or comp_3 or comp_4 or comp_5 or comp_6 or comp_7 or comp_8 or comp_9 or min1_mask)
     begin
         case(min1_mask)
             10'b10000_00000 : min1_num_index <= 4'd9;
             10'b01000_00000 : min1_num_index <= 4'd8;
             10'b00100_00000 : min1_num_index <= 4'd7;
             10'b00010_00000 : min1_num_index <= 4'd6;
             10'b00001_00000 : min1_num_index <= 4'd5;
             10'b00000_10000 : min1_num_index <= 4'd4;
             10'b00000_01000 : min1_num_index <= 4'd3;
             10'b00000_00100 : min1_num_index <= 4'd2;
             10'b00000_00010 : min1_num_index <= 4'd1;
             default : min1_num_index <= 4'd0;  
         endcase
     end
     
     always @(comp_0 or comp_1 or comp_2 or comp_3 or comp_4 or comp_5 or comp_6 or comp_7 or comp_8 or comp_9 or min2_mask)
     begin
         case(min2_mask)
             10'b10000_00000 : min2_num_index <= 4'd9;
             10'b01000_00000 : min2_num_index <= 4'd8;
             10'b00100_00000 : min2_num_index <= 4'd7;
             10'b00010_00000 : min2_num_index <= 4'd6;
             10'b00001_00000 : min2_num_index <= 4'd5;
             10'b00000_10000 : min2_num_index <= 4'd4;
             10'b00000_01000 : min2_num_index <= 4'd3;
             10'b00000_00100 : min2_num_index <= 4'd2;
             10'b00000_00010 : min2_num_index <= 4'd1;
             default : min2_num_index <= 4'd0;
         endcase
     end
    
    //以下的代码用来更新频率数组
    
    always @(posedge clk)
    begin
      if(rst_n == 0)
        begin
        code_count <= 0;
        
        freqMem[0] <= 9'b000000000;
        freqMem[1] <= 9'b000000000;
        freqMem[2] <= 9'b000000000;
        freqMem[3] <= 9'b000000000;
        freqMem[4] <= 9'b000000000;
        freqMem[5] <= 9'b000000000;
        freqMem[6] <= 9'b000000000;
        freqMem[7] <= 9'b000000000;
        freqMem[8] <= 9'b000000000;
        freqMem[9] <= 9'b000000000;
          
        numMem[0] <= 5'd0;
        numMem[1] <= 5'd1;
        numMem[2] <= 5'd2;
        numMem[3] <= 5'd3;
        numMem[4] <= 5'd4;
        numMem[5] <= 5'd5;
        numMem[6] <= 5'd6;
        numMem[7] <= 5'd7;
        numMem[8] <= 5'd8;
        numMem[9] <= 5'd9;
        end
      else if(data_count_finish && code_count < 9)   //仿真确定9还是10
          begin //编码过程在进行
            code_count <= code_count + 1'b1;
            numMem[min1_num_index]<=new_root_index;
            numMem[min2_num_index]<=num_max;
            freqMem[min1_num_index]<=new_freq;
            freqMem[min2_num_index]<=freq_max;
          end
      else if(data_in_start_en && ~data_count_finish)  //没有完成统计并且已经开始输入数据的时候，持续更新频度统计数据
      begin
          freqMem[0] <= data_num_count_w0;
          freqMem[1] <= data_num_count_w1;
          freqMem[2] <= data_num_count_w2;
          freqMem[3] <= data_num_count_w3;
          freqMem[4] <= data_num_count_w4;
          freqMem[5] <= data_num_count_w5;
          freqMem[6] <= data_num_count_w6;
          freqMem[7] <= data_num_count_w7;
          freqMem[8] <= data_num_count_w8;
          freqMem[9] <= data_num_count_w9;
        end
        else
        begin
            code_count <= code_count;
        end
    end
    endmodule
