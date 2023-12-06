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

//  From: Note Dealer ---------------//
    input [9:0] Pin_Note,       //3.���ǵİ������� NOTE 7+3,Pin_Note[0]��LSB
                                    //  UART_Note, ����UART������,��ͨ��UART���룬���������Թ� UART'S NOTE
 // From: Buzzer -------------------//
    output wire speaker,           //B.Buzzer output signal��one_hot_Note,  one-hot-Note,ȥ����buzzer  
    output sel,
                              
// From: WASDY --------------------//׼������
//    input [4:0] WASDE,           //4.���ǵ�5���������������˳��
//    output [4:0] WASDE_Signal,   //C.������ӳ�� output:ȥ����������
    
// From: UART----------------------//׼������
//    input uart_intoFPGA,         //5.��������
//    output uart_outFPGA,         //D.�ߵ�����
    
//From: Display-------------------//
    
//    output [7:0] Tub1,
//    output [7:0] Tub2,  //E.����ܵ����PRETEUS ׼������
    
    output [6:0] led_note,
    output [2:0] led_HighLow            //F.LED
    );

//#------------------- STATE;ENABLE -------------------#enable ���ܻ�û������
    reg [1:0] current_state;            //state 
    reg [6:0] current_ENABLE;           //ENABLE
    
////#------------------- UART ---------------------------#//
//    reg uart_message;
//    reg [9:0] UARTNOTE;
    
//#------------------- ������� -----------------------#//
    reg [1:0] Proteus_state;
    reg [47:0] DigitalMoss;          //E.����ܵ����PRETEUS ׼������
    
//#------------------------ LED -----------------------#//
    reg [1:0] LEDStatus;   
    
////#------------------- MEMORY -----------------------#//
//    reg MEMORYNOTE;
    
//#--------------------- NOTE -------------------------#//
    wire [9:0] NOTE;   //done
    reg [9:0] PINNOTE; //done
    reg [2:0] NoteStatus;  //notyet
    
////#-------------------- WASD ------------------------#//    
//    reg [4:0] wasd_out;
    
    //***********NOTE***************//
    NoteDealer ND(
     //INPUT
      .clk(clk),                      //CLOCK]            
      .Pin_Note(PINNOTE),             //���ǵİ������� 7+3
//    .UART_Note(UARTNOTE),           //����UART��������׼������

            
    .one_hot_Note(NOTE)               // one-hot-Note OUTPUT
//    .Memory_Note(MEMORYNOTE)׼������ OUTPUT
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
    .BUZZERBusline(out_led),
//    .LearnNote(), //ready for storage in study mode
    .LEDStatus(LEDStatus),//whoControl
 
    .lednote(led_note),//output
    .HighLow(led_HighLow)//output
    );
    
    //***********�����**************//
    proteus Pr(
    .DigitalMoss(DigitalMoss)
    //io
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
   
   
//    ����ʽ״̬����������    SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS

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
              LEDStatus <= `DISABLE;
//            SD_ENABLE  <= `DISABLE;
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
                begin
                    PINNOTE <=  Pin_Note;
                    LEDStatus <= `LIGHTNDPLAY;
                 end
                 
                `PLAY_MODE_ENABLE:
                begin
                    PINNOTE <= `DISABLE;
                    LEDStatus <= `PLAYMODELIGHT;
                end
                
                `UART_MODE_ENABLE:
                begin
                    PINNOTE <= `DISABLE;
                    LEDStatus <= `LIGHTNDPLAY;
                end
                
                `LEARN_MODE_ENABLE:
                begin
                    PINNOTE <= Pin_Note;
                    LEDStatus <= `LIGHTBEFOREPLAY;
                end
               
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
     
     //-------------------------------------------------------------------------------------&*&*(
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
