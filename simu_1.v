`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/02 13:45:25
// Design Name: 
// Module Name: simu_1
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


module simu_1(

    );
    reg clk = 0;
    reg rst_n = 0;
    reg [3:0]data_ram[255:0];
    reg start_en = 0;
    reg [3:0]data_in;
    reg start = 0;
    
    wire data_count_finish;
    wire encoding_finish; 
    wire output_start;  
    wire huffman_out_finish;
    wire output_data;   
    wire output_gap;     //间隔区分不同数据种类
    wire output_done;   
    wire [8:0]data_point;
    wire [3:0]data_out;
        
//    wire [8:0]code_mask_0;
//    wire [8:0]code_mask_1;
//    wire [8:0]code_mask_2;
//    wire [8:0]code_mask_3;
//    wire [8:0]code_mask_4;
//    wire [8:0]code_mask_5;
//    wire [8:0]code_mask_6;
//    wire [8:0]code_mask_7;
//    wire [8:0]code_mask_8;
//    wire [8:0]code_mask_9;
    wire [8:0]code_0;
    wire [8:0]code_1;
    wire [8:0]code_2;
    wire [8:0]code_3;
    wire [8:0]code_4;
    wire [8:0]code_5;
    wire [8:0]code_6;
    wire [8:0]code_7;
    wire [8:0]code_8;
    wire [8:0]code_9;
    
//    wire [4:0]new_root_index;
    wire [4:0]min1;
    wire [4:0]min2;
//    wire  [3:0] min1_num_index;
//    wire  [3:0] min2_num_index;
//    wire [9:0] min1_mask;
//    wire [9:0] min2_mask;
    
//    wire [8:0]nummem_0;
//    wire [8:0]nummem_1;
//    wire [8:0]nummem_2;
//    wire [8:0]nummem_3;
//    wire [8:0]nummem_4;
//    wire [8:0]nummem_5;
//    wire [8:0]nummem_6;
//    wire [8:0]nummem_7;
//    wire [8:0]nummem_8;
//    wire [8:0]nummem_9;
     
//    wire [8:0]data_in_count_w;
    
//    wire [3:0]data_in_temp_w1;
//    wire [3:0]data_in_temp_w2;
//    wire [3:0]data_in_temp_w3;
//    wire [3:0]data_in_temp_w4;
//    wire [3:0]data_in_temp_w5;
//    wire [3:0]data_in_temp_w6;
    
//    wire [8:0]data_num_count_w9;
//    wire [8:0]data_num_count_w8;
//    wire [8:0]data_num_count_w7;
//    wire [8:0]data_num_count_w6;
//    wire [8:0]data_num_count_w5;
//    wire [8:0]data_num_count_w4;
//    wire [8:0]data_num_count_w3;
//    wire [8:0]data_num_count_w2;
//    wire [8:0]data_num_count_w1;
//    wire [8:0]data_num_count_w0;

    wire code_en;
    wire [3:0] data_select;
    integer count = 0;
    integer point = 0;
    
    always #10 clk <= ~clk;
    
    initial
    begin
    #200
    rst_n <= 0;
    #200 
    rst_n <= 1;
    $readmemb("E:/FPGA/Huffman/final/HuffmanCoding_GG/HuffmanCoding.srcs/sources_1/new/data_in.txt",data_ram,0,255);
    #190
    start <= 1;
    #20
    start_en <= 1;
    start <= 0;
   
    end

    always@(posedge clk)
    begin
      if(start_en == 1)
        begin
        if(count == 255)
          begin
          data_in <= data_ram[point];
          count <= count;
//          point <= 0;
//          count <= 0;
//          data_in <= 0;    //此后不再输出
          end
        else
          begin
          data_in <= data_ram[point];
          count <= count + 1;
          point <= point + 1;
          end
        end
      else
        begin
        data_in <= 4'b0000;
        count <= count;
        point <= point;
        end
            
    end

   HuffmanCoding h1(
       .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .start(start),
        .code_0(code_0),
        .code_1(code_1),
        .code_2(code_2),
       .code_3(code_3),
        .code_4(code_4),
        .code_5(code_5),
        .code_6(code_6),
        .code_7(code_7),
        .code_8(code_8),
        .code_9(code_9),
        
//        .new_root_index(new_root_index),
        .min1(min1),
        .min2(min2),
        .encoding_finish(encoding_finish),
        .huffman_out_finish(huffman_out_finish),
//        .data_out(data_out),
   
//        .data_num_count_w0(data_num_count_w0),
//        .data_num_count_w1(data_num_count_w1),
//        .data_num_count_w2(data_num_count_w2),
//        .data_num_count_w3(data_num_count_w3),
//        .data_num_count_w4(data_num_count_w4),
//        .data_num_count_w5(data_num_count_w5),
//        .data_num_count_w6(data_num_count_w6),
//        .data_num_count_w7(data_num_count_w7),
//        .data_num_count_w8(data_num_count_w8),
//        .data_num_count_w9(data_num_count_w9),
        .data_count_finish(data_count_finish),

//        .data_point(data_point),
        .output_data(output_data),   
        .output_start(output_start),  
        .output_done(output_done),   
        .output_gap(output_gap),     //间隔区分不同数据种类
        
        .code_en(code_en),
        .data_select(data_select)   //用这个来选择数据用哪个
        );

endmodule
