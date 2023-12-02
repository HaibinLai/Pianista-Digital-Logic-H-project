`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Haibin Lai
// 
// Create Date: 2023/11/29 23:50:05
// Design Name: �������ǵ�����
// Module Name: NoteDealer

// Target Devices: 
// Tool Versions: 1.0.1
// Description: ��ΰ�8λ��noteת����21λ��one hot
// 
// Additional Comments:noop
// 
//////////////////////////////////////////////////////////////////////////////////


module NoteDealer(
    input [8:0] Pin_Note, //���ǵİ�������
    input [8:0] UART_Note, //����UART������
    output [20:0] one_hot_Note // one-hot-Note
    );
    
    SwitchDealer SD();
    UARTDealer   UD();
endmodule
