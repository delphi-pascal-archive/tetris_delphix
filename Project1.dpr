//////////////////////////////////////////////////////
//                                                  //
//  �����: ��������� ����� ������������           //
//                                                  //
//  ������                                         //
//                                                  //
//  �.�����-���������                              //
//                                                  //
//  Andriy-TM@yandex.ru                             //
//                                                  //
//  ������ ������� � :  http://www.delphisources.ru //
//                                                  //
//  2006 ��                                        //
//                                                  //
//////////////////////////////////////////////////////
program Project1;

{%File 'ModelSupport\Tetris_E\Tetris_E.txvpck'}
{%File 'ModelSupport\Unit1\Unit1.txvpck'}
{%File 'ModelSupport\default.txvpck'}

uses
  Forms,
  Unit1 in 'Unit1.pas' {Tetris},
  Tetris_E in 'Tetris_E.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTetris, Form1);
  Application.Run;
end.
