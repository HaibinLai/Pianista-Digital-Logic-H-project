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
    input rst,                      //A.reset button, low for active

// ------------------ From: Note Dealer ---------------//
    input [9:0] Pin_Note,       //3.���ǵİ������� NOTE 7+3,Pin_Note[0]��LSB
                                //  UART_Note, ����UART������,��ͨ��UART���룬���������Թ� UART'S NOTE
 // -------------------From: Buzzer -------------------//
    output wire speaker,       //B.Buzzer output signal��one_hot_Note,  one-hot-Note,ȥ����buzzer  
    output sel,
                              
// ------------------ From: WASDY --------------------//׼������
//    input [4:0] WASDE,          //4.���ǵ�5���������������˳��
//    output [4:0] WASDE_Signal,  //C.������ӳ�� output:ȥ����������
    
// -------------------From: UART----------------------//׼������
//    input uart_intoFPGA,        //5.��������
//    output uart_outFPGA,        //D.�ߵ�����
    
//--------------------From: Display-------------------//
//    output [47:0] DigitalMoss,  //E.����ܵ����PRETEUS ׼������
    
    output [6:0] led_note,
    output [2:0] led_HighLow            //F.LED
    );

////#------------------- STATE;ENABLE -------------------#enable ���ܻ�û������
    reg [1:0] current_state;            //state 
    reg [6:0] current_ENABLE;           //ENABLE
//    reg SD_ENABLE;                      
//    reg WASDY_ENABLE;
//    reg BUZZER_ENABLE;
//    reg LED_ENABLE;
//    reg UART_ENABLE;
//    reg PROTEUS_ENABLE;
//    reg MEMORY_ENABLE;
    
////#------------------- UART ---------------------------#//
//    reg uart_message;
//    reg [9:0] UARTNOTE;
    
////#------------------- ������� -----------------------#//
//    reg [1:0] Proteus_state;
    
////#------------------- MEMORY -------------------------#//
//    reg MEMORYNOTE;
    
//#--------------------- NOTE -------------------------#//
    wire [9:0] NOTE;
    reg [9:0] PINNOTE;
    
////#--------------------- WASD -------------------------#//    
//    reg [4:0] wasd_out;
    
    //***********NOTE***************//
    NoteDealer ND(
     //INPUT
    .clk(clk),                      //CLOCK]
//    .Pin_Note(Pin_Note),            //���ǵİ������� 7+2
      .Pin_Note(PINNOTE),
//    .SD_ENABLE(SD_ENABLE),          //SWITCH ENABLE
//    .UART_ENABLE(UART_ENABLE),      //UART   ENABLE
//    .Memory_ENABLE(MEMORY_ENABLE),  //MEMORY ENABLE

//    .UART_Note(UARTNOTE),           //����UART��������׼������
            //OUTPUT
    .one_hot_Note(NOTE)            // one-hot-Note    
//    .Memory_Note(MEMORYNOTE)׼������
    );
    
//    //***********WASD***************// ׼������
//    WASDY WASDY(
//    .clk(clk),
//    .WASDE(WASDE),
//    .WASDE_Signal(wasd_out)
//    );
    
    //***********BUZZER*************//
    wire[9:0] out_led;    
    Buzzer Buzzer(
    .clk(clk),                       // Clock signal
    .low({NOTE[6],NOTE[5],NOTE[4],NOTE[3],NOTE[2],NOTE[1],NOTE[0]}),
    .pitch({NOTE[9],NOTE[8],NOTE[7]}),
    
    .speaker(speaker),       
    .sel(sel)        ,                //������
    .markLED(out_led)
    );

    //***********LED****************//
    Led Led(
    .Busline(out_led),
    .lednote(led_note),
    .HighLow(led_HighLow)
    );
    
//    //***********UL*****************//׼������
//    uart_loop UL(
//    .i_clk_sys(clk),
//    .i_uart_rx(uart_intoFPGA),
//    .uart_rx(uart_message),
//    .i_rst_n(UART_ENABLE),
//    .o_uart_tx(uart_outFPGA),
//     .UART_ENABLE(UART_ENABLE)
//    );
    
//    //***********MEMORY*************//׼������
//    Memory Me(
//       .clk(clk)
//   );
   
   
//    ����ʽ״̬����������    

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
            
        default:// just in case
            current_ENABLE = `FREE_MODE_ENABLE;
       endcase 
    end
    
//      �׶�����Execute �׶Σ���ʱ�������ش���
    always @(posedge clk or negedge rst) begin
            if(!rst) begin
              PINNOTE <=  `DISABLE;
//            SD_ENABLE    = `DISABLE;
//            WASDY_ENABLE = `DISABLE;
//            BUZZER_ENABLE= `DISABLE;
//            LED_ENABLE   = `DISABLE;
//            UART_ENABLE  = `DISABLE;
//            PROTEUS_ENABLE=`DISABLE; 
//            MEMORY_ENABLE= `DISABLE; 
            end 
            
            else begin
            case(current_ENABLE)
                `FREE_MODE_ENABLE:
                    PINNOTE <=  Pin_Note;
            endcase
//            SD_ENABLE    = current_ENABLE[5];
//            WASDY_ENABLE = current_ENABLE[4];
//            BUZZER_ENABLE= current_ENABLE[0];
//            LED_ENABLE   = current_ENABLE[1];
//            UART_ENABLE  = current_ENABLE[2];
//            PROTEUS_ENABLE=current_ENABLE[3];
//            MEMORY_ENABLE= current_ENABLE[6];            
            end
     end
     
     // ����
     //-----------Ц����������������֪�Լ�������-----------//
     //*                    _ooOoo_                       *//
     //*                   o8888888o                      *//
     //*                   88" . "88                      *//
     //*                   (| -_- |)                      *//
     //*                    O\ = /O                       *//
     //*                ____/`---'\____                   *//
     //*              .   ' \\| |// `.                    *//
     //*               / \\||| : |||// \                  *//
     //*             / _||||| -:- |||||- \                *//
     //*               | | \\\ - /// | |                  *//
     //*             | \_| ''\---/'' | |                  *//
     //*              \ .-\__ `-` ___/-. /                *//
     //*           ___`. .' /--.--\ `. . __               *//
     //*        ."" '< `.___\_<|>_/___.' >'"".            *//
     //*       | | : `- \`.;`\ _ /`;.`/ - ` : | |         *//
     //*         \ \ `-. \_ __\ /__ _/ .-` / /            *//
     //* ======`-.____`-.___\_____/___.-`____.-'======    *//
     //*                    `=---='                       *//
     //----------------------------------------------------//
     
endmodule
