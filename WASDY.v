`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Haibin Lai
// 
// Create Date: 2023/12/01 21:45:28
// Design Name: �������ǵ�WASDY�����Ӷ��л�����
// Module Name: WASDY
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


module WASDY(
    input [4:0] WASDE, //���ǵ�5���������������˳��
    input clk,
    output [4:0] WASDE_Signal //������ӳ��
    );
    //code 
    
     memory Me(
        .clk(clk)
    );
    
endmodule
