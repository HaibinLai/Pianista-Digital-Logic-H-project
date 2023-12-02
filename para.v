`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ������
// 
// Create Date: 2023/12/01 23:49:38
// Design Name: ����
// Module Name: para
// Project Name: �����߼�
// Target Devices: FPGA
// Tool Versions: 
// Description: �������峣���ġ����ļ���

//����//`define+name+���� ��
//��������`define ����STATE_INIT����   3'd0
//��������`define ����STATE_IDLE�� �� 3'd1
//��������`define ����STATE_WRIT���� 3'd2
//��������`define ����STATE_READ����3'd3
//��������`define ����STATE_WORK      3'd4
//��������`define ����STATE_RETU����3'd5

//����Ҫ���ò������ļ�init.v��ʹ��`include "para.v"��
//��������`include "para.v"
//ʵ��ʹ�ã�
//    assign BuzzerSpeaker = `BAUD_RATE;
//ע��Ҫ�ӡ�`��
//////////////////////////////////////////////////////////////////////////////////

`define BAUD_RATE 9600
`define WIDTH 32
`define CLK_PERIOD 10
`define FREE_MODE 2'b00
`define UART_MODE 2'b11
`define LEARN_MODE 2'b01
`define PLAY_MODE 2'b10

//BUZZER LED UART SHUMA        PIN
`define FREE_MODE_ENABLE    6'b111101

//BUZZER LED UART SHUMA WASDY PIN
`define LEARN_MODE_ENABLE   6'b111111

//BUZZER LED UART? SHUMA WASDY 
`define PLAY_MODE_ENABLE    6'b111110

//BUZZER LED UART SHUMA 
`define UART_MODE_ENABLE    6'b111100
`define DISABLE 1'b0