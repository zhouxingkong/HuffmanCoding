`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/05 09:53:40
// Design Name: 
// Module Name: encoding
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


module encoding(
    input clk,
    input rst_n,
    input data_count_finish,
    input [4:0]min1,
    input [4:0]min2,
    
    output [4:0]new_root_index,   //标志树中新生成根的位置    
    
    output encoding_finish,
    output reg [8:0]code_mask_0 = 0,    //数据编码长度
    output reg [8:0]code_mask_1 = 0,
    output reg [8:0]code_mask_2 = 0,
    output reg [8:0]code_mask_3 = 0,
    output reg [8:0]code_mask_4 = 0,
    output reg [8:0]code_mask_5 = 0,
    output reg [8:0]code_mask_6 = 0,
    output reg [8:0]code_mask_7 = 0,
    output reg [8:0]code_mask_8 = 0,
    output reg [8:0]code_mask_9 = 0,
    output reg [8:0]code_0 = 0,           //数据编码 
    output reg [8:0]code_1 = 0,   
    output reg [8:0]code_2 = 0,    
    output reg [8:0]code_3 = 0,    
    output reg [8:0]code_4 = 0,    
    output reg [8:0]code_5 = 0,     
    output reg [8:0]code_6 = 0,
    output reg [8:0]code_7 = 0,     
    output reg [8:0]code_8 = 0,   
    output reg [8:0]code_9 = 0    
    
    );
    
    reg [4:0] new_root_index_r = 5'd10;   //标志树中新生成根的位置    
    reg [3:0] code_count = 4'b0000;
    reg encoding_finish_r = 1'b0;    //编码完成标志
    wire [9:0] add0_mask; //加0掩码
    wire [9:0] add1_mask; //加1掩码
    reg [9:0] tree [18:0];   //树矩阵

    assign new_root_index = new_root_index_r;
    assign encoding_finish = encoding_finish_r;
    
    assign add0_mask=tree[min1];
    assign add1_mask=tree[min2];
    
    always @(posedge clk)   
    begin
        if(rst_n == 1'b0) 
          begin  //初始化时执行一次
              code_count <= 0;         //编码计数清零
              encoding_finish_r <= 0;    //编码完成标志清零
              new_root_index_r = 5'd10;  //初始化标志树中新生成根的位置
    
              tree[0]<=10'b00000_00001;
              tree[1]<=10'b00000_00010;
              tree[2]<=10'b00000_00100;
              tree[3]<=10'b00000_01000;
              tree[4]<=10'b00000_10000;
              tree[5]<=10'b00001_00000;
              tree[6]<=10'b00010_00000;
              tree[7]<=10'b00100_00000;
              tree[8]<=10'b01000_00000;
              tree[9]<=10'b10000_00000;
              //i=10~18为枝节
              tree[10]<=10'b00000_00000;
              tree[11]<=10'b00000_00000;
              tree[12]<=10'b00000_00000;
              tree[13]<=10'b00000_00000;
              tree[14]<=10'b00000_00000;
              tree[15]<=10'b00000_00000;
              tree[16]<=10'b00000_00000;
              tree[17]<=10'b00000_00000;
              tree[18]<=10'b00000_00000;
          end
        else
          begin

           if(data_count_finish==1'b1 && code_count < 8)  //经过仿真测试这里边界至少是7开始才不会输出错误
              begin    //编码过程正在运行
                  code_count <= code_count + 1;
                  tree[new_root_index_r]<=tree[min1] | tree[min2]; //构建新节点，按位操作，这才叫王道！！
                  new_root_index_r <= new_root_index_r + 1'b1;
              end  
            else if(data_count_finish==1'b1 && code_count >= 8 && code_count < 9)  
              begin
                  tree[new_root_index_r]<=tree[min1] | tree[min2]; //构建新节点，按位操作，这才叫王道！！
                  new_root_index_r <= new_root_index_r + 1'b1;
                  code_count <= code_count + 1;
                  encoding_finish_r <= 1;         //为了让输出“卡点不浪费时钟（寄存器沿触发造成的延迟）”我们提前拉高完成时钟，实际上并没有完成
              end  
            else if(data_count_finish==1'b1 && code_count == 9) 
              begin
                  encoding_finish_r <= 1;
              end     
            else
              begin
                    encoding_finish_r <= 0;
              end  
          end
    end

    //下面的程序用来更新最终的编码
    
    
    always @(posedge clk)   //更新0的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9)   //经过仿真测试，编码周期等待时钟都是9个，下同
          begin                                                              
            if(add0_mask[0] == 1'b1) 
              begin
                code_0[8:0] <= {1'b0,code_0[8:1]};
                //code_mask_0 <= code_mask_0 + 1;
                code_mask_0<={1'b1,code_mask_0[8:1]};
              end
            else if(add1_mask[0] == 1'b1)     //少一个else不知道 有没有问题，到时候仿真测试一下！！！！！！！！！！！下同
              begin
                code_0 <= {1'b1,code_0[8:1]};
                //code_mask_0 <= code_mask_0 + 1;
                code_mask_0<={1'b1,code_mask_0[8:1]};
              end
          end
    end
    
    always @(posedge clk) //更新1的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[1] == 1'b1) 
              begin
                //code_mask_1 <= code_mask_1 + 1;
                code_1 <= {1'b0,code_1[8:1]};
                code_mask_1<={1'b1,code_mask_1[8:1]};
              end
            else if(add1_mask[1] == 1'b1) 
              begin
                //code_mask_1 <= code_mask_1 + 1;
                code_1 <= {1'b1,code_1[8:1]};
                code_mask_1<={1'b1,code_mask_1[8:1]};
              end
          end
    end
    
    always @(posedge clk) //更新2的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[2] == 1'b1) 
              begin
                //code_mask_2 <= code_mask_2 + 1;
                code_2 <= {1'b0,code_2[8:1]};
                code_mask_2<={1'b1,code_mask_2[8:1]};
              end
            else if(add1_mask[2] == 1'b1)  
              begin
                //code_mask_2 <= code_mask_2 + 1;
                code_2 <= {1'b1,code_2[8:1]};
                code_mask_2<={1'b1,code_mask_2[8:1]};
              end
          end
    end
    
    always @(posedge clk) //更新3的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9)
          begin
            if(add0_mask[3] == 1'b1) 
              begin
                //code_mask_3 <= code_mask_3 + 1;
                code_3 <= {1'b0,code_3[8:1]};
                code_mask_3<={1'b1,code_mask_3[8:1]};
              end
            else if(add1_mask[3] == 1'b1)
              begin
                //code_mask_3 <= code_mask_3 + 1;
                code_3 <= {1'b1,code_3[8:1]};
                code_mask_3<={1'b1,code_mask_3[8:1]};
              end
          end
    end
    
    always @(posedge clk) //更新4的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9)
          begin
            if(add0_mask[4] == 1'b1) 
              begin
                //code_mask_4 <= code_mask_4 + 1;
                code_4 <= {1'b0,code_4[8:1]};
                code_mask_4<={1'b1,code_mask_4[8:1]};
              end
            else if(add1_mask[4] == 1'b1)
              begin
                //code_mask_4 <= code_mask_4 + 1;
                code_4 <= {1'b1,code_4[8:1]};
                code_mask_4<={1'b1,code_mask_4[8:1]};
              end
          end
    end
    
    always @(posedge clk) //更新5的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[5] == 1'b1) 
              begin
                //code_mask_5 <= code_mask_5 + 1;
                code_5 <= {1'b0,code_5[8:1]};
                code_mask_5<={1'b1,code_mask_5[8:1]};
              end
            else if(add1_mask[5] == 1'b1) 
              begin
                //code_mask_5 <= code_mask_5 + 1;
                code_5 <= {1'b1,code_5[8:1]};
                code_mask_5<={1'b1,code_mask_5[8:1]};
              end
          end
    end
    
    always @(posedge clk) //更新6的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[6] == 1'b1)
              begin
                //code_mask_6 <= code_mask_6 + 1;
                code_6 <= {1'b0,code_6[8:1]};
                code_mask_6<={1'b1,code_mask_6[8:1]};
              end
            else if(add1_mask[6] == 1'b1) 
              begin
                //code_mask_6 <= code_mask_6 + 1;
                code_6 <= {1'b1,code_6[8:1]};
                code_mask_6<={1'b1,code_mask_6[8:1]};
              end
          end
    end
    
    always @(posedge clk) //更新7的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[7] == 1'b1) 
              begin
                //code_mask_7 <= code_mask_7 + 1;
                code_7 <= {1'b0,code_7[8:1]};
                code_mask_7<={1'b1,code_mask_7[8:1]};
              end
            else if(add1_mask[7] == 1'b1)
              begin
                //code_mask_7 <= code_mask_7 + 1;
                code_7 <= {1'b1,code_7[8:1]};
                code_mask_7<={1'b1,code_mask_7[8:1]};
              end
          end
    end
    
    always @(posedge clk) //更新8的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[8] == 1'b1)
              begin
                //code_mask_8 <= code_mask_8 + 1;
                code_8 <= {1'b0,code_8[8:1]};
                code_mask_8<={1'b1,code_mask_8[8:1]};
              end
            else if(add1_mask[8] == 1'b1) 
              begin
                //code_mask_8 <= code_mask_8 + 1;
                code_8 <= {1'b1,code_8[8:1]};
                code_mask_8<={1'b1,code_mask_8[8:1]};
              end
          end
    end
    
    always @(posedge clk) //更新9的编码
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[9] == 1'b1) 
              begin
                //code_mask_9 <= code_mask_9 + 1;
                code_9 <= {1'b0,code_9[8:1]};
                code_mask_9<={1'b1,code_mask_9[8:1]};
              end
            else if(add1_mask[9] == 1'b1) 
              begin
                //code_mask_9 <= code_mask_9 + 1;
                code_9 <= {1'b1,code_9[8:1]};
                code_mask_9<={1'b1,code_mask_9[8:1]};
              end
          end
    end
endmodule
