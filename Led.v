`timescale 1ns / 1ps

///////////////////////////////
// Led module
//author Haibin Lai
//date 11/19

//input: 
//input [9:0] Busline ����

//output:
//[6:0]lednote: ��Ӧ7��led ��
//[2:0]HighLow: ��Ӧ��8��8

////////////////////////////////


module Led(
    input [9:0] Busline,
    output [6:0] lednote,
    output [2:0] HighLow
    );

    assign lednote = {Busline[9],Busline[8],Busline[7],Busline[6],Busline[5],Busline[4],Busline[3]};
    assign HighLow = {Busline[2],Busline[1],Busline[0]};

endmodule
