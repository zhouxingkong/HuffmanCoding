`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/05 17:17:40
// Design Name: 
// Module Name: data_out
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

module data_out(
    input clk,
    input rst_n,
    input encoding_finish,   //编码完成标志
    input [3:0]data_in,   //输入待编码数据
    
    input  [8:0]code_mask_0,    //数据编码长度
    input  [8:0]code_mask_1,
    input  [8:0]code_mask_2,
    input  [8:0]code_mask_3,
    input  [8:0]code_mask_4,
    input  [8:0]code_mask_5,
    input  [8:0]code_mask_6,
    input  [8:0]code_mask_7,
    input  [8:0]code_mask_8,
    input  [8:0]code_mask_9,
    input  [8:0]code_0,           //数据编码 
    input  [8:0]code_1,   
    input  [8:0]code_2,    
    input  [8:0]code_3,    
    input  [8:0]code_4,    
    input  [8:0]code_5,     
    input  [8:0]code_6,      
    input  [8:0]code_7,     
    input  [8:0]code_8,   
    input  [8:0]code_9,    
    
    output reg huffman_out_finish = 0,
    output reg[8:0] data_point = 9'b000000000,  //存储器索引指针
    output output_data,   //输出数据
    output reg output_gap,    //间隔区分不同数据种类
    output output_done,   //输出完成标志
    output output_start,   //输出开始标志
    
    output code_en,  //编码输出使能位
    output [3:0] data_select   //用这个来选择数据用哪个
    );
    
    reg [3:0]huffman_state = 4'b0000;   //存储输出的数（0~9）
    
    reg [8:0] out_code_buff=9'd0;    //编码缓冲区
    reg [8:0] out_mask_buff=9'd0;    //掩码缓冲区
    reg [8:0] code_select=9'd0;
    reg [8:0] mask_select=9'd0;
    
    reg output_started=0;
    reg output_finished=0;
    assign output_start = encoding_finish && (~output_started);
    assign output_done = (data_point == 257)? 1'b1 : 1'b0;  //注意！！！！！！！！！！！！！很多瞬间拉高的标志信号都可以这么写
    assign output_data = out_code_buff[8];  //输出信号为编码缓冲区的最高位
    assign code_en = out_mask_buff[7];      //取高2位
    assign data_select = (huffman_out_finish == 1'b1)? data_in : huffman_state;     //选择输出0~9还是0~255
    
always@ (data_select or encoding_finish or clk)    //这个敏感电平到时候还要改
begin
    case(data_select)
        4'd0: mask_select<=code_mask_0;
        4'd1: mask_select<=code_mask_1;
        4'd2: mask_select<=code_mask_2;
        4'd3: mask_select<=code_mask_3;
        4'd4: mask_select<=code_mask_4;
        4'd5: mask_select<=code_mask_5;
        4'd6: mask_select<=code_mask_6;
        4'd7: mask_select<=code_mask_7;
        4'd8: mask_select<=code_mask_8;
        default : mask_select<=code_mask_9;
    endcase
end

always@ (data_select or encoding_finish or clk)    //这个敏感电平到时候还要改
begin
    case(data_select)
        4'd0: code_select<=code_0;
        4'd1: code_select<=code_1;
        4'd2: code_select<=code_2;
        4'd3: code_select<=code_3;
        4'd4: code_select<=code_4;
        4'd5: code_select<=code_5;
        4'd6: code_select<=code_6;
        4'd7: code_select<=code_7;
        4'd8: code_select<=code_8;
        default : code_select<=code_9;
    endcase
end

always@ (posedge clk)
begin
    if(rst_n == 0)
    begin
        huffman_state <= 0;
        output_gap <= 0;
        //output_start <= 0;
        huffman_out_finish <= 0;
        data_point <= 0;
        
        out_code_buff<=0;
        out_mask_buff<=0;
        output_started<=0;
        output_finished<=0;
    end
    else if(encoding_finish == 1 && huffman_out_finish ==0)   //编码已经结束，输出0~9编码
    begin
        if(code_en==1'b1)
        begin
            out_code_buff <= {out_code_buff[7:0],1'b0};
            out_mask_buff <= {out_mask_buff[7:0],1'b0};
            output_gap<=1'b0;
            output_started<=1'b1;
        end
        else
        begin
            out_code_buff <= code_select;
            out_mask_buff <= mask_select;
            output_gap <= 1'b1;
            
            if(output_started==0) begin
                output_started<=1'b1;
                //output_start<=1'b0;
            end
            
            if(huffman_state>=4'd9) huffman_out_finish <= 1'b1;
            else huffman_state <= huffman_state+1'b1;
            
        end
    end
    else if(huffman_out_finish == 1 && output_finished==0)  //输出0~9编码结束，开始输出0~255
    begin
        if(code_en==1'b1)   //在这里要输出上一个环节9的编码
        begin
            out_code_buff <= {out_code_buff[7:0],1'b0};
            out_mask_buff <= {out_mask_buff[7:0],1'b0};
            //output_gap<=1'b1;
        end
        else
        begin
            out_code_buff <= code_select;
            out_mask_buff <= mask_select;
            //output_gap<=1'b1;
            if(data_point>=9'd256) begin
                output_finished <= 1'b1;
                data_point<=9'd257; //这时候output_done拉高
            end
            else data_point <= data_point+1'b1;
            
        end
        
        if(data_point>0)
        begin
            output_gap<=1'b1;
        end
        else if(data_point==0&&code_en!=1'b1)
        begin
            output_gap<=1'b1;
        end
        else
        begin
            output_gap<=1'b0;
        end
    end
    else data_point<=9'd0;
end
  
endmodule