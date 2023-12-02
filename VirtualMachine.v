`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
//haibin Lai
//
// VM, centural of the programme
// VM����������״̬��Ȼ��״̬��������Controller
//input: all of the signal,pins,...
//function:all the little led...etc
//output:led,shuweiguan,
//////////////////////////////////////////////////////////////////////////////////

`include "para.v"

//����
    //һ��������
    //���� INPUT��
    //1.PINS_NOTE 2.PINS_STATE 3.WASDE 4.RESET 5.UART
    //��� OUTPUT��
    //A.RESET  B.BUZZER  C.WASDE  D.UART_OUT  E.PRETEUS  F.LED
module VirtualMachine(

input clk,                      //1.���ǵ�ʱ��CLOCK
input [1:0] next_state,         //2.��״̬STATE
input rst,                      //A.reset button

// From: Note Dealer
    input [8:0] Pin_Note,       //3.���ǵİ������� NOTE 7+2,Pin_Note[0]��LSB
                                //  UART_Note, ����UART������,��ͨ��UART���룬���������Թ� UART'S NOTE
    output wire speaker,       //B.Buzzer output signal��one_hot_Note,  one-hot-Note,ȥ����buzzer                                
// From: WASDY
    input [4:0] WASDE,          //4.���ǵ�5���������������˳��
    output [4:0] WASDE_Signal,  //C.������ӳ�� output:ȥ����������
// From: UART
    input uart_intoFPGA,        //5.��������
    output uart_outFPGA,        //D.�ߵ�����
    
//Display
    output [47:0] DigitalMoss,  //E.����ܵ����PRETEUS
    output [7:0] Led_note            //F.LED
    );
//    assign BuzzerSpeaker = `BAUD_RATE;

    reg [1:0] current_state; //state 
    reg [5:0] current_ENABLE; //ENABLE
    reg SD_ENABLE;
    reg WASDY_ENABLE;
    reg BUZZER_ENABLE;
    reg LED_ENABLE;
    reg UART_ENABLE;
    reg PROTEUS_ENABLE;
    
    reg uart_message;


    NoteDealer ND(
    .clk(clk)
    );
    WASDY WASDY(
    .clk(clk)
    );
    Buzzer Buzzer(
    .clk(clk)
    );
    Led Led(
    .clk(clk)
    );
    uart_loop UL(
    .clk(clk),
    .uart_in(uart_intoFPGA),
    .uart_rx(uart_message),
    .rst(current_ENABLE[2]),
    .uart_out(uart_outFPGA)

    );
    

//    VM��������
//    �׶�һ��Fetch �׶Σ���ʱ�������ش���
    always @(posedge clk or negedge rst) begin
// �� Fetch �׶Σ�ֻ����״̬�Ķ�ȡ��ͬ������
        if(!rst) begin
            current_state <= `FREE_MODE;
        end
        else begin
            current_state <= next_state;
        end
    end


//    �׶ζ���Decode �׶Σ���ʱ�Ӻ㶨ʱ����
always @* begin
       case (current_state)
       //����ģʽ
       `FREE_MODE:
            current_ENABLE = `FREE_MODE_ENABLE;
            
       //����ģʽ    
       `PLAY_MODE:
            current_ENABLE = `PLAY_MODE_ENABLE;
       
       //UART����ͨ��webģʽ   
       `UART_MODE:
            current_ENABLE = `UART_MODE_ENABLE;
           
       //ѧϰģʽ
       `LEARN_MODE:
            current_ENABLE = `LEARN_MODE_ENABLE;
            
            
        default:
            current_ENABLE = `FREE_MODE_ENABLE;
       endcase 
    end
    
//      �׶�����Execute �׶Σ���ʱ�������ش���
    always @(posedge clk or negedge rst) begin

            if(!rst) begin
            SD_ENABLE    = `DISABLE;
            WASDY_ENABLE = `DISABLE;
            BUZZER_ENABLE= `DISABLE;
            LED_ENABLE   = `DISABLE;
            UART_ENABLE  = `DISABLE;
            PROTEUS_ENABLE=`DISABLE;
            end 
            else begin
            SD_ENABLE    = current_ENABLE[5];
            WASDY_ENABLE = current_ENABLE[4];
            BUZZER_ENABLE= current_ENABLE[0];
            LED_ENABLE   = current_ENABLE[1];
            UART_ENABLE  = current_ENABLE[2];
            PROTEUS_ENABLE=current_ENABLE[3];            
            end
     end
endmodule
