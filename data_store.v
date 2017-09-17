`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/05 09:54:54
// Design Name: 
// Module Name: data_store
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

//本模块用来存储输入数据，并对输入数据进行频度统计并输出初始频度
module data_store(
    input clk,    //输入数据时钟
    input rst_n,  //复位信号
    input start,  //开始输入的标志信号
    input [3:0]data_in, //输入数据
    input data_out_start,  //开始输出存储的数据的标志
    
    input [8:0]data_point,
     
    output [3:0]data_out,  //输出存储的数据
    
    output reg data_in_start_en = 0,         //数据输入开始标志(此标志持续拉高)
    output reg data_count_finish = 0,        //统计完毕输出使能
    output [8:0]data_num_count_w9,   //数据9的频度 下同
    output [8:0]data_num_count_w8,
    output [8:0]data_num_count_w7,
    output [8:0]data_num_count_w6,
    output [8:0]data_num_count_w5,
    output [8:0]data_num_count_w4,
    output [8:0]data_num_count_w3,
    output [8:0]data_num_count_w2,
    output [8:0]data_num_count_w1,
    output [8:0]data_num_count_w0

    );
    
    reg [3:0]data_in_r[255:0];      //考虑一下用RAM的话是不是会节省资源，但是访问可能会有限制（RAM一次只能访问一个数据）
    reg [8:0]data_num_count[9:0];  //用来记录9-0每个数字的频度（data_num_count[9]表示9的频度，data_num_count[0]表示0的频度)
    reg [8:0]data_in_count = 9'b0000_00000;    //计数256个 
   
    
    assign data_num_count_w9 = (data_in==4'd9)? (data_num_count[9]+1'b1):data_num_count[9];
    assign data_num_count_w8 = (data_in==4'd8)? (data_num_count[8]+1'b1):data_num_count[8];
    assign data_num_count_w7 = (data_in==4'd7)? (data_num_count[7]+1'b1):data_num_count[7];
    assign data_num_count_w6 = (data_in==4'd6)? (data_num_count[6]+1'b1):data_num_count[6];
    assign data_num_count_w5 = (data_in==4'd5)? (data_num_count[5]+1'b1):data_num_count[5];
    assign data_num_count_w4 = (data_in==4'd4)? (data_num_count[4]+1'b1):data_num_count[4];
    assign data_num_count_w3 = (data_in==4'd3)? (data_num_count[3]+1'b1):data_num_count[3];
    assign data_num_count_w2 = (data_in==4'd2)? (data_num_count[2]+1'b1):data_num_count[2];
    assign data_num_count_w1 = (data_in==4'd1)? (data_num_count[1]+1'b1):data_num_count[1];
    assign data_num_count_w0 = (data_in==4'd0)? (data_num_count[0]+1'b1):data_num_count[0];
   
    assign data_out = data_in_r[data_point];
    
    always@(posedge clk)
    begin
    
      if(start == 1 && rst_n == 1) data_in_start_en <= 1;    //start上升沿触发data_in_start_en信号拉高，作为数据输入开始标
      else data_in_start_en <= data_in_start_en;  //这样写保证start信号拉低之后data_in_start_en信号仍为高电平状态
        
      if(rst_n == 0)
        begin
        data_in_count <= 0;       //复位之后计数器清零
        data_in_start_en <= 0;     //复位之后数据输入开始标志清零
        data_count_finish <= 0;  // 复位统计完毕的输出标志
        
        data_num_count[9] <= 0;    //频度全部初始化为0
        data_num_count[8] <= 0;
        data_num_count[7] <= 0;
        data_num_count[6] <= 0;
        data_num_count[5] <= 0;
        data_num_count[4] <= 0;
        data_num_count[3] <= 0;
        data_num_count[2] <= 0;
        data_num_count[1] <= 0;
        data_num_count[0] <= 0;
        end
      else
        begin                                               //仿真结果说明，应该选256 
        if(data_in_start_en == 1 && data_in_count <= 256)   //这样写是为了避免漏掉第一个数据，到时候仿真看一下究竟会不会漏掉
          begin
          
              data_count_finish <= 0;  //没有统计完毕之前输出0  
              data_in_count <= data_in_count + 1;      //记录输入数据个数
              
              if(data_in_count > 0)   //为了防止提前开始一个时钟存数据
              begin
                data_in_r[data_in_count - 1] <= data_in;     //存输入数据  注意这里下标是[data_in_count - 1]
                case(data_in)
                    4'b0001: begin data_num_count[1] <= data_num_count[1] + 1; end
                    4'b0010: begin data_num_count[2] <= data_num_count[2] + 1; end
                    4'b0011: begin data_num_count[3] <= data_num_count[3] + 1; end
                    4'b0100: begin data_num_count[4] <= data_num_count[4] + 1; end
                    4'b0101: begin data_num_count[5] <= data_num_count[5] + 1; end
                    4'b0110: begin data_num_count[6] <= data_num_count[6] + 1; end
                    4'b0111: begin data_num_count[7] <= data_num_count[7] + 1; end
                    4'b1000: begin data_num_count[8] <= data_num_count[8] + 1; end
                    4'b1001: begin data_num_count[9] <= data_num_count[9] + 1; end
                    default: begin data_num_count[0] <= data_num_count[0] + 1; end  //这么写为了防止生成锁存器,不过感觉写这一句不是很合适
                endcase
                if(data_in_count == 256) data_count_finish <= 1; //提前一个周期拉高，为了预取数据
              end
            
          end
        else
        begin
            data_count_finish <= data_count_finish;
        end
                    
        end
        
    end
    
endmodule
