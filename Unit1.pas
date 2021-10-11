//////////////////////////////////////////////////////
//                                                  //
//  Автор: Танасійчук Андрій Мирославович           //
//                                                  //
//  Україна                                         //
//                                                  //
//  м.Івано-Франківськ                              //
//                                                  //
//  Andriy-TM@yandex.ru                             //
//                                                  //
//  Ресурс зкачано з :  http://www.delphisources.ru //
//                                                  //
//  2006 рік                                        //
//                                                  //
//////////////////////////////////////////////////////

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms,
  ExtCtrls, DXClass, DXDraws, GameMenu,  Tetris_E, AppEvnts,
  StdCtrls, jpeg, Controls, inifiles, Dialogs;

type
  TTetris = class(TDXForm)
    DXDraw1: TDXDraw;
    DXTimer1: TDXTimer;
    Timer1: TTimer;
    DXImageList1: TDXImageList;
    ApplicationEvents1: TApplicationEvents;
    Timer2: TTimer;
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXDraw1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DXDraw1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
   Procedure GameEvent(Sender: TObject);
   Procedure SetVisibleBtn(First,Last:TAmount;Visible:Boolean;What:TWhat=G_Btn);
   Procedure OnGMenuVisible(Sender: TObject);
   Procedure NewGame;
   Procedure Parametrs;
   Procedure BackFromOption;
   Procedure SaveOption;
   Procedure TextOutInOption;
   Procedure GameOver;
   Procedure DrawRecordTable(X,Y:Integer);
   Procedure DrawDialog;
   Procedure DrawAbout;

   Procedure ReadOFromF;
   Procedure WriteOToF;

   Procedure ReadWriteRecords(Write:Boolean);
   Procedure StandartRecords;
  end;

type
  TPoints=record
    Nick    : String[10];
    Level   : Byte;
    Points  : Word;
    DelLines: Word;
   end;
  TGamePoints=array[0..4]of TPoints;

var
  Form1: TTetris;
  GMenu:TGameMenu;
  MapWidth:Byte=10;
  MapHeight:Byte=20;
  ItemWidth:Byte=24;
  ItemHeight:Byte=24;
  Max:Byte=0;
  Min:Byte=20;
  MapX:Integer;
  MapY:Integer;
  KeyLeft:Byte=37;
  KeyRight:Byte=39;
  KeyBottom:Byte=40;
  KeyRote:Byte=38;
  LastKey:Byte;
  Speed:Word=200;
  Points:Word=0;
  CountDLines:Word;
  IsGameOver:Boolean=False;
  Pause:Boolean=False;
  IsGameStarted:Boolean=False;
  Level:Byte=1;
  Option:Boolean=False;
  DeletLine:boolean=False;
  BackGraund:Boolean=False;
  AnimDel:Boolean=False;
  ShowRecords:Boolean;
  IsNewRecord:Boolean;
  WhatRecordsShow:Boolean=False;
  Space:Boolean;
  ShowAbout:Boolean=False;

  OFile:TIniFile;
  Classic:Boolean;
  IndexNewR:0..4;
  Current, Records_C, Records_T:TGamePoints;
implementation

{$R *.dfm}
procedure TTetris.GameEvent(Sender: TObject);
begin
 If Sender=GMenu.GameBtns[1] then
  begin
   Pause:=False;GMenu.Visible:=False;
  end;

 if (Sender=GMenu.GameBtns[2])then
     begin
      If GMenu.GameBtns[2].Caption='Новая игра' then
       begin
          NewGame; IsGameStarted:=True;
          GMenu.Visible:=False;
       end else
        begin
          IsGameOver:=True;
          GameOver;
          GMenu.Visible:=True;
        end;
     end;

 if (Sender=GMenu.GameBtns[3])then
     begin
      ShowRecords:=True;
      WhatRecordsShow:=False;
      Current:=Records_C;
      SetVisibleBtn( 1, 8,False);
      SetVisibleBtn( 8, 8,True);
      SetVisibleBtn(10,10,True);
     end;

 if Sender=GMenu.GameBtns[4] then
    Parametrs;

 if Sender=GMenu.GameBtns[5] then
    begin
     ShowAbout:=True;
     SetVisibleBtn( 1, 8,False);
     SetVisibleBtn( 8, 8,True);
    end;


 if Sender=GMenu.GameBtns[6] then
    Form1.Close;

 if Sender=GMenu.GameBtns[7] then
    SaveOption;

 if (Sender=GMenu.GameBtns[8])then
    BackFromOption;

 if (Sender=GMenu.GameBtns[9])then
  begin
   if GMenu.GameEdits[1].Text='' then Exit;
   Current[IndexNewR].Nick:=GMenu.GameEdits[1].Text;
   If Classic then Records_C:=Current else
    Records_T:=Current;
   Gmenu.GameEdits[1].Visible:=False;
   SetVisibleBtn(9,9,False);
   IsNewRecord:=False;
   GMenu.Visible:=True;
   BackFromOption;
  end;

 if (Sender=GMenu.GameBtns[10])then
    begin
     If Not WhatRecordsShow then
      Current:=Records_T else
      Current:=Records_C;
      WhatRecordsShow:=Not WhatRecordsShow;
    end;
end;

Procedure TTetris.OnGMenuVisible(Sender: TObject);
begin
if (IsNewRecord) then
 begin
  SetVisibleBtn(1,8,False);
  SetVisibleBtn(9,9,True);
  exit;
 end;

 If (Pause)and(IsGameStarted)and(Not IsGameOver) Then
  begin
   GMenu.GameBtns[1].Visible:=True;
   GMenu.GameBtns[2].Caption:='Закончить игру';
   GMenu.SetBtnsInRect
   (Rect(0,0,Form1.DXDraw1.Width,Form1.DXDraw1.Height),200,50,1,6);
  end else
  begin
   GMenu.GameBtns[1].Visible:=False;
   GMenu.GameBtns[2].Caption:='Новая игра';
   GMenu.SetBtnsInRect
   (Rect(0,0,Form1.DXDraw1.Width,Form1.DXDraw1.Height),200,50,2,6);
  end;
end;

Procedure TTetris.SetVisibleBtn(First,Last:TAmount;Visible:Boolean;What:TWhat=G_Btn);
var i:Integer;
begin
case What of
 G_Btn: For i:=First to Last do
         GMenu.GameBtns[i].Visible:=Visible;
 G_Scroll: For i:=First to Last do
         GMenu.GameScrolls[i].Visible:=Visible;
 G_Edit: For i:=First to Last do
         GMenu.GameEdits[i].Visible:=Visible;
 G_KeyEdit: For i:=First to Last do
         GMenu.GameEditKeys[i].Visible:=Visible;
 G_CheckBox: For i:=First to Last do
         GMenu.GameCheckBox[i].Visible:=Visible;
 end;
end;

Procedure TTetris.NewGame;
begin
 Form1.Timer2.Enabled:=False;
 MapClear;
 IsGameOver:=False;
 Pause:=False;
 RandomFigure(Figure);
 RandomFigure(NewFigure);
 Figure.X:=Trunc(MapWidth/2);
 Figure.Y:=0;
 Speed:=400;
 Form1.Timer1.Interval:=Speed;
 Points:=0; CountDLines:=0;  Level:=1;
 NextLevel:=5;
end;

Procedure TTetris.Parametrs;
begin
 Option:=True;
 SetVisibleBtn(1,6,False);
 SetVisibleBtn(7,8,True);
  GMenu.GameEditKeys[1].Key:=KeyLeft;
  GMenu.GameEditKeys[2].Key:=KeyRight;
  GMenu.GameEditKeys[3].Key:=KeyRote;
  GMenu.GameEditKeys[4].Key:=KeyBottom;
  GMenu.GameCheckBox[1].Checked:=doFullScreen in Form1.DXDraw1.Options;
  GMenu.GameCheckBox[2].Checked:=BackGraund;
  GMenu.GameCheckBox[3].Checked:=AnimDel;
  GMenu.GameCheckBox[4].Checked:=Space;
  GMenu.GameCheckBox[5].Checked:=Classic;
  GMenu.GameScrolls[1].Position:=ItemWidth-14;
  GMenu.GameScrolls[1].Position:=ItemHeight-14;

 SetVisibleBtn( 1,4,True,G_KeyEdit);
 SetVisibleBtn( 1,1,True,G_Scroll);
 SetVisibleBtn( 1,4,True,G_CheckBox);
 If (IsGameOver)then
  GMenu.GameCheckBox[5].Visible:=True;
end;

Procedure TTetris.SaveOption;
begin
BackFromOption;
KeyLeft:= GMenu.GameEditKeys[1].Key;
KeyRight:= GMenu.GameEditKeys[2].Key;
KeyRote:= GMenu.GameEditKeys[3].Key;
KeyBottom:= GMenu.GameEditKeys[4].Key;

If (GMenu.GameCheckBox[1].Checked)then
begin
 If   (Not (DoFullScreen in Form1.DXDraw1.Options)) then
  begin
    Form1.BorderStyle:=bsNone;
    Form1.DXDraw1.Options:= Form1.DXDraw1.Options+[doFullScreen];
    Form1.DXDraw1.Initialize;
  end;
end else
 If  (DoFullScreen in Form1.DXDraw1.Options) then
  begin
    Form1.BorderStyle:=bsSingle;
    Form1.Position:=poScreenCenter;
    Form1.DXDraw1.Options:= Form1.DXDraw1.Options-[doFullScreen];
    Form1.DXDraw1.Initialize;
  end;


BackGraund:=GMenu.GameCheckBox[2].Checked;
AnimDel:=GMenu.GameCheckBox[3].Checked;
Space:=GMenu.GameCheckBox[4].Checked;

If not GMenu.GameCheckBox[5].Checked then
 begin
  MapWidth:=13;
  Classic:=False;
 end else
 begin
  MapWidth:=10;
  Classic:=True;
 end;
 
ItemWidth:=GMenu.GameScrolls[1].Position+14;
ItemHeight:=GMenu.GameScrolls[1].Position+14;

MapX:=200+(240-MapWidth*ItemWidth)div 2;
MapY:=Trunc((Form1.DXDraw1.Height-ItemHeight*MapHeight)/2);
end;

Procedure TTetris.BackFromOption;
begin
 Option:=False; ShowRecords:=False; ShowAbout:=False;
 If (Pause)and(IsGameStarted)and(Not IsGameOver) then SetVisibleBtn(1,6,True) else
      SetVisibleBtn(2,6,True);
 SetVisibleBtn( 7,8,False);
 SetVisibleBtn(10,10,False); 
 SetVisibleBtn( 1,4,False,G_KeyEdit);
 SetVisibleBtn( 1,5,False,G_CheckBox);
 SetVisibleBtn( 1,1,False,G_Scroll);
end;
//===================================================
Procedure TTetris.ReadOFromF;
var Path:String;
B:Byte;
begin
GetDir(0,Path);
Path:=Path+'\Config.ini';
OFile:=TIniFile.Create(Path);

KeyLeft:= OFile.ReadInteger('KeyBoard','Left',37);
KeyRight:= OFile.ReadInteger('KeyBoard','Right',39);
KeyRote:= OFile.ReadInteger('KeyBoard','Up',38);
KeyBottom:= OFile.ReadInteger('KeyBoard','Down',40);

if OFile.ReadBool('Configs','FullScreen',False) then
 begin
  Form1.BorderStyle:=bsNone;
  Form1.DXDraw1.Options:=Form1.DXDraw1.Options+[doFullScreen];
 end;

BackGraund:=OFile.ReadBool('Configs','BackGround',False);
AnimDel:=OFile.ReadBool('Configs','AnimRows',False);
Space:=OFile.ReadBool('Configs','PlaceBetweenRectangles',False);
Classic:=OFile.ReadBool('Configs','ClassicTetris',True);
if Not Classic then
 MapWidth:=13;
b:= OFile.ReadInteger('Configs','RectangleSize',24);
If (B>24)or(B<6)then B:=24;
ItemWidth:=b;
ItemHeight:=b; 

OFile.Free;
end;

Procedure TTetris.WriteOToF;
var Path:String;
begin
GetDir(0,Path);
Path:=Path+'\Config.ini';
Try
 OFile:=TIniFile.Create( Path);
 OFile.WriteInteger('KeyBoard','Left',KeyLeft);
 OFile.WriteInteger('KeyBoard','Right',KeyRight);
 OFile.WriteInteger('KeyBoard','Up',KeyRote);
 OFile.WriteInteger('KeyBoard','Down',KeyBottom);

 OFile.WriteBool('Configs','FullScreen',doFullScreen in Form1.DXDraw1.Options);
 OFile.WriteBool('Configs','BackGround',BackGraund);
 OFile.WriteBool('Configs','AnimRows',AnimDel);
 OFile.WriteBool('Configs','PlaceBetweenRectangles',Space);
 OFile.WriteBool('Configs','ClassicTetris',Classic);

 OFile.WriteInteger('Configs','RectangleSize',ItemWidth);
OFile.Free;
 except
  exit;
 end;
end;

procedure TTetris.FormCreate(Sender: TObject);
begin
 DeleteMenu(GetSystemMenu(Self.Handle, false), SC_Size, MF_BYCOMMAND);
 DeleteMenu(GetSystemMenu(Self.Handle, false), SC_Maximize, MF_BYCOMMAND);
 DeleteMenu( GetSystemMenu(Self.Handle, false),0, MF_BYPOSITION);
 DeleteMenu( GetSystemMenu(Self.Handle, false),1, MF_BYPOSITION);

 IsGameOver:=True;
 Pause:=True;
 Classic:=True;

 ReadOFromF;

 MapX:=Trunc((Form1.DXDraw1.Width-ItemWidth*MapWidth)/2);
 MapY:=Trunc((Form1.DXDraw1.Height-ItemHeight*MapHeight)/2);
//Menu-------------------------------------------------------
 GMenu:=TGameMenu.Create;
 GMenu.Visible:=True;
 GameMenu.DXDraw:=@Form1.DXDraw1;
 GMenu.EVent:= GameEvent;
 GMenu.OnVisible:= OnGMenuVisible;
 GMenu.Image:=Form1.DXImageList1.Items.Find('Buttons');
{Buttons}
  {Btn-01} GMenu.Add(G_Btn, 'Продолжить');
  {Btn-02} GMenu.Add(G_Btn, 'Новая игра');
  {Btn-03} GMenu.Add(G_Btn, 'Таблица рекордов');
  {Btn-04} GMenu.Add(G_Btn, 'Настройки');
  {Btn-05} GMenu.Add(G_Btn, 'Автор');
  {Btn-06} GMenu.Add(G_Btn, 'Выход');
  {Btn-07} GMenu.Add(G_Btn, 'Сохранить настройки', Param(50,420,210,50));
  {Btn-08} GMenu.Add(G_Btn, 'Назад', Param(400,420,200,50));
  {Btn-09} GMenu.Add(G_Btn, 'OК', Param(255,300,145,35));
  {Btn-10} GMenu.Add(G_Btn, 'Класический\Специальный', Param(40,420,240,50));

  SetVisibleBtn(7,10,False);
  GMenu.GameBtns[1].Visible:=False;
  GMenu.SetBtnsInRect(Rect(0,0,Form1.DXDraw1.Width,Form1.DXDraw1.Height),200,50,2,6);
{EditKeys}
    GMenu.Add(G_KeyEdit,'',Param(150,40,100,38));
    GMenu.GameEditKeys[1].Image:=Form1.DXImageList1.Items[5];
    GMenu.Add(G_KeyEdit,'',Param(150,85,100,38));
    GMenu.GameEditKeys[2].Image:=Form1.DXImageList1.Items[5];
    GMenu.Add(G_KeyEdit,'',Param(150,130,100,38));
    GMenu.GameEditKeys[3].Image:=Form1.DXImageList1.Items[5];
    GMenu.Add(G_KeyEdit,'',Param(150,175,100,38));
    GMenu.GameEditKeys[4].Image:=Form1.DXImageList1.Items[5];
    SetVisibleBtn( 1,4,False,G_KeyEdit);
{ChackBox}
    GMenu.Add(G_CheckBox,'Во весь экран',Param(350,35,195,25));
    GMenu.Add(G_CheckBox,'Фоновый рисунок',Param(350,70,210,25));
    GMenu.Add(G_CheckBox,'Анимация фигур',Param(350,105,180,25));
    GMenu.Add(G_CheckBox,'Пропуски',Param(350,140,120,25));
    GMenu.Add(G_CheckBox,'Классческий тетрис',Param(350,175,200,25));

    GMenu.GameCheckBox[1].Image:=Form1.DXImageList1.Items[3];
    GMenu.GameCheckBox[1].Visible:=False;
    GMenu.GameCheckBox[2].Image:=Form1.DXImageList1.Items[3];
    GMenu.GameCheckBox[2].Visible:=False;
    GMenu.GameCheckBox[3].Image:=Form1.DXImageList1.Items[3];
    GMenu.GameCheckBox[3].Visible:=False;

    GMenu.GameCheckBox[4].Image:=Form1.DXImageList1.Items[3];
    GMenu.GameCheckBox[4].Visible:=False;
    GMenu.GameCheckBox[5].Image:=Form1.DXImageList1.Items[3];
    GMenu.GameCheckBox[5].Visible:=False;

{Scrolls}
    GMenu.Add(G_Scroll,'',Param(320,302,250,20));
    GMenu.GameScrolls[1].Image:=Form1.DXImageList1.Items[4];
    GMenu.GameScrolls[1].CenterDraw:=3;
    GMenu.GameScrolls[1].Visible:=False;
{Edits}
    GMenu.Add(G_Edit,'',Param(230,210,200,50));
    Gmenu.GameEdits[1].Image:=Form1.DXImageList1.Items[5];
    Gmenu.GameEdits[1].Visible:=False;
    Gmenu.GameEdits[1].Max:=10;
    Gmenu.GameEdits[1].TextSize:=19;
//-----------------------------------------------------------
    ReadWriteRecords(False);
end;

procedure TTetris.DXTimer1Timer(Sender: TObject; LagCount: Integer);
var W:Integer;
begin
If Not Form1.DXDraw1.CanDraw then Exit;
 Form1.DXDraw1.Surface.Fill(5465445);

 If ((GMenu.Visible)and(not IsNewRecord)) then
 Form1.DXImageList1.Items.Find('Back').StretchDraw(
  Form1.DXDraw1.Surface,Rect(0,0,640,480),0);

 if (Not GMenu.Visible)or((GMenu.Visible)and(IsNewRecord)) then
  begin
   If BackGraund then
   { Form1.DXImageList1.Items.Find('Back').StretchDraw(
     Form1.DXDraw1.Surface,Rect(MapX,MapY,MapX+MapWidth*ItemWidth,Mapy+MapHeight*ItemHeight),1);
    }
    Form1.DXImageList1.Items.Find('Back').StretchDraw(
     Form1.DXDraw1.Surface,Rect(0,0,640,480),1);
 If Not DeletLine then
    Tetris_E.DrawFigure(Figure,Figure.X,Figure.Y,True,ItemWidth,ItemHeight);
    Tetris_E.DrawFigure(NewFigure,500,50);
    Tetris_E.DrawMap;

    DXDraw1.Surface.Canvas.Pen.Color:=clWhite;
    DXDraw1.Surface.Canvas.Rectangle(MapX,MapY,MapX+MapWidth*ItemWidth,Mapy+MapHeight*ItemHeight);
    DXDraw1.Surface.Canvas.Rectangle(0,0,MapX+1,480);
    DXDraw1.Surface.Canvas.Rectangle(MapX+(MapWidth*ItemWidth)-1,0,640,480);
 With DXDraw1.Surface.Canvas do
  begin
    Pen.Color:=clWhite;
    Font.Color:=clWhite;
    Brush.Style:=bsClear;
    Font.Size:=24;
    W:=TextWidth('Очки:');
    TextOut((MapX-W)div 2,50,'Очки:');
    W:=TextWidth(IntToStr(Points));
    TextOut((MapX-W)div 2,80,IntToStr(Points));
    W:=TextWidth('Уровень:');
    TextOut((MapX-W)div 2,150,'Уровень:');
    W:=TextWidth(IntToStr(Level));
    TextOut((MapX-W)div 2,180,IntToStr(Level));
    W:=TextWidth('Линий:');
    TextOut((MapX-W)div 2,250,'Линий:');
    W:=TextWidth(IntToStr(CountDLines));
    TextOut((MapX-W)div 2,280,IntToStr(CountDLines));
    W:=TextWidth('Наступний:');
    TextOut((MapX-W)div 2,350,'Наступний:');
    W:=TextWidth(IntToStr(NextLevel-CountDLines));
    TextOut((MapX-W)div 2,385,IntToStr(NextLevel-CountDLines));
    Release;
  end;
 end;
 If IsNewRecord then DrawDialog; 
 If ShowRecords then DrawRecordTable(15,55);
 If ShowAbout then DrawAbout;
 If Option then TextOutInOption;
 GMenu.DoDraw;
 Form1.DXDraw1.Flip;

end;

procedure TTetris.DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GMenu.MouseDown(X,Y);
end;

procedure TTetris.DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  GMenu.MouseMove(X,Y);
end;

procedure TTetris.DXDraw1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GMenu.MouseUp(X,Y);
end;

procedure TTetris.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
If Msg.message=WM_KeyDown then
   GMenu.KeyDown(Msg.wParam);

If Msg.message=WM_KeyDown then
 If Msg.wParam=27 then
  If GMenu.Visible then Form1.Close else
   begin
    If (Not Pause)and(Not IsGameOver)then Pause:=True;
    GMenu.Visible:=True;
    Timer2.Enabled:=False;
   end;
If (IsGameOver)or(Pause) then Exit;
If Msg.message=WM_KeyDown then
Begin
 If Msg.wParam=KeyLeft then
  begin
   LastKey:=KeyLeft;
    If Msg.lParam<10900000000  then
      Form1.Timer2.OnTimer(Form1);
   Form1.Timer2.Interval:=200;
   Form1.Timer2.Enabled:=True;
  end;

 If Msg.wParam=KeyRight then
  begin
   LastKey:=KeyRight;
  If Msg.lParam<10900000000  then
      Form1.Timer2.OnTimer(Form1);
   Form1.Timer2.Interval:=200;
   Form1.Timer2.Enabled:=True;
  end;

 If Msg.wParam=KeyRote then
    Rote(Figure.St);

 If Msg.wParam=KeyBottom then
    Form1.Timer1.Interval:=40;

end;

If Msg.message=WM_KeyUp then
 begin
   If (Msg.wParam=KeyLeft) or (Msg.wParam=KeyRight) then
     Form1.Timer2.Enabled:=False;

   If Msg.wParam=KeyBottom then
     Form1.Timer1.Interval:=Speed;
 end;
end;



procedure TTetris.Timer2Timer(Sender: TObject);
begin

 If (CanMove(dLeft))and(LastKey=KeyLeft) then
  begin
   Form1.Timer2.Interval:=50;
   Figure.X:=Figure.X-1;
  end;

 If (CanMove(dRight))and(LastKey=KeyRight) then
  begin
   Form1.Timer2.Interval:=50;
   Figure.X:=Figure.X+1;
  end;

end;

procedure TTetris.Timer1Timer(Sender: TObject);
begin
If Not Form1.Showing then exit;
If (GMenu.Visible)or(Not IsGameStarted) then Exit;

 if (CanMove) then
  begin
   Figure.Y:=Figure.y+1;
  end else
    begin
      If IsGameOver then exit;
      LiveFigureOnMap(Figure.X, Figure.Y);
      Max:=Figure.Y;
      if Figure.Y<Min then Min:=Figure.Y;
       DeleteLines;
       Figure:=NewFigure;
       RandomFigure(NewFigure);
       Figure.X:=5;Figure.Y:=0;
      If Not CanBe(Figure.St) then GameOver;
    end;
end;

procedure TTetris.TextOutInOption;
begin
Form1.DXDraw1.Surface.Canvas.Pen.Color:=ClLime;
 Form1.DXDraw1.Surface.Canvas.Brush.Style:=bsSolid;
 Form1.DXDraw1.Surface.Canvas.Brush.Color:=clGreen;
  Form1.DXDraw1.Surface.Canvas.RoundRect( 20,25,305,225,35,35);
  Form1.DXDraw1.Surface.Canvas.RoundRect(325,25,615,225,35,35);
  Form1.DXDraw1.Surface.Canvas.RoundRect(20,250,615,380,35,35);
 Form1.DXDraw1.Surface.Canvas.Brush.Style:=bsClear;

  Form1.DXDraw1.Surface.Canvas.Font.Size:=15;
  Form1.DXDraw1.Surface.Canvas.TextOut(45,45,'Влево');
  Form1.DXDraw1.Surface.Canvas.TextOut(45,90,'Вправо');
  Form1.DXDraw1.Surface.Canvas.TextOut(45,135,'Поворот');
  Form1.DXDraw1.Surface.Canvas.TextOut(45,180,'Вниз');

  Form1.DXDraw1.Surface.Canvas.TextOut(150,298,'Розмер квадрата');
  Form1.DXDraw1.Surface.Canvas.Release;
end;

procedure TTetris.GameOver;
var i,j:Byte;
begin
i:=0;
  IsGameOver:=True;
  If Classic then Current:=Records_C else
    Current:=Records_T;

  While i<=4 do
   begin
    If Current[i].Points<Points then
     begin
      IndexNewR:=I;
      IsNewRecord:=True;
      GMenu.GameBtns[9].Visible:=True;
      Gmenu.GameEdits[1].Visible:=True;
      GMenu.Visible:=True;
      For j:=4 Downto i+1 do
       begin
        Current[j].Points:=Current[j-1].Points;
        Current[j].Level:=Current[j-1].Level;
        Current[j].DelLines:=Current[j-1].DelLines;
        Current[j].Nick:=Current[j-1].Nick;
       end;
        Current[i].Points:=Points;
        Current[i].Level:=Level;
        Current[i].DelLines:=CountDLines;
        i:=5;
     end;
    Inc(i);
   end;

end;

procedure TTetris.DrawRecordTable(X,Y:Integer);
var i,j,SX,W:Byte;
S:String[10] ;
begin
SX:=Y;W:=250;
  DXDraw1.Surface.Canvas.Font.Size:=23;
  If Not WhatRecordsShow then
   DXDraw1.Surface.Canvas.TextOut(X+175,Y-45,'Классический тетрис') else
   DXDraw1.Surface.Canvas.TextOut(X+175,Y-45,'Специальний тетрис');
  DXDraw1.Surface.Canvas.Brush.Color:=clGreen;
  DXDraw1.Surface.Canvas.Font.Size:=19;
  DXDraw1.Surface.Canvas.Font.Color:=clWhite;
  DXDraw1.Surface.Canvas.Pen.Color:=clLime;
 For j:=0 to 3 do
  begin
   For i:=0 to 5 do
     begin

        case j of
         0: if i<>0 then S:=Current[i-1].Nick else S:='Имена';
         1: if i<>0 then S:=IntToStr(Current[i-1].Level) else S:='Урвень';
         2: if i<>0 then S:=IntToStr(Current[i-1].Points) else S:='Очки';
         3: if i<>0 then S:=IntToStr(Current[i-1].DelLines) else S:='Линий';
        end;

      DXDraw1.Surface.Canvas.RoundRect(x,y,x+W-15,y+35,5,5);
      DXDraw1.Surface.Canvas.TextOut(X+2+5,Y+3,S);
      Y:=Y+60-1;
     end;
   X:=X+W-1;
   Y:=SX;
   W:=120;
  end;

  DXDraw1.Surface.Canvas.Release;
  DXDraw1.Surface.Canvas.Brush.Style:=bsClear;
end;

procedure TTetris.DrawDialog;
begin
Form1.DXDraw1.Surface.Canvas.Brush.Color:=ClGreen;
Form1.DXDraw1.Surface.Canvas.Brush.Style:=bsSolid;
Form1.DXDraw1.Surface.Canvas.Pen.Color:=clLime;
Form1.DXDraw1.Surface.Canvas.RoundRect(115,90,535,365,35,35);
 with  Form1.DXDraw1.Surface.Canvas do
  begin
    Font.Size:=19;
    Font.Color:=clWhite;

    TextOut(235,110,'Новый рекорд!!!');
    TextOut(255,165,'Введите имя');

    Brush.Style:=bsClear;
    Release;
  end;
end;

procedure TTetris.DXDraw1KeyPress(Sender: TObject; var Key: Char);
begin
GMenu.KeyPress(Key);
end;

procedure TTetris.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteOToF;
  ReadWriteRecords(True);
end;

procedure TTetris.ReadWriteRecords(Write:Boolean);
var FileHandle:Integer;
begin
// Read Records===========================================
If Not Write then
 begin
  StandartRecords;
  Current:=Records_C;
  if Not FileExists('Tetris.dat') then
     exit;
  if(FileIsReadOnly('Tetris.dat')) then
   begin
    Dialogs.MessageDlg('Файл Tetris.dat захищений від запису'+#13+ 'Рекорди зберігатися не будуть',
      mtWarning,[mbOK],0);
      exit;
   end;
   FileHandle:=FileOpen('Tetris.dat',fmOpenRead);
   FileRead( FileHandle,Records_C,SizeOf(Records_C));
   FileRead( FileHandle,Records_T,SizeOf(Records_T));
   FileRead( FileHandle,IsGameOver,SizeOf(IsGameOver));
    If Not IsGameOver then
     begin
      IsGameStarted:=True;Pause:=True;
      GMenu.Visible:=True;
      FileRead(FileHandle,Map,SizeOf(Map));
      FileRead(FileHandle,Figure,SizeOf(TFigure));
      FileRead(FileHandle,NewFigure,SizeOf(TFigure));
      FileRead(FileHandle,Points,SizeOf(Points));
      FileRead(FileHandle,Level,SizeOf(Level));
      FileRead(FileHandle,NextLevel,SizeOf(NextLevel));
      FileRead(FileHandle,CountDLines,SizeOf(CountDLines));
      FileRead(FileHandle,Speed,SizeOf(Speed));
      Form1.Timer1.Interval:=Speed;
     end;
   FileClose(FileHandle);
 end;
//End Read records =======================================

//Write Records===========================================
 If FileExists('Tetris.dat') then
  If(FileIsReadOnly('Tetris.dat')) then
   begin
    Dialogs.MessageDlg('Файл Tetris.dat захищений від запису'+#13+ 'Рекорди не збереженні!!!',
      mtWarning,[mbOK],0);
      exit;
   end;
  FileHandle:=FileCreate('Tetris.dat');
  FileWrite(FileHandle,Records_C,SizeOf(Records_C));
  FileWrite(FileHandle,Records_T,SizeOf(Records_T));
  FileWrite(FileHandle,IsGameOver,SizeOf(IsGameOver));
  If Not IsGameOver then
   begin
    FileWrite(FileHandle,Map,SizeOf(Map));
    FileWrite(FileHandle,Figure,SizeOf(TFigure));
    FileWrite(FileHandle,NewFigure,SizeOf(TFigure));
    FileWrite(FileHandle,Points,SizeOf(Points));
    FileWrite(FileHandle,Level,SizeOf(Level));
    FileWrite(FileHandle,NextLevel,SizeOf(NextLevel));
    FileWrite(FileHandle,CountDLines,SizeOf(CountDLines));
    FileWrite(FileHandle,Speed,SizeOf(Speed));
   end;
  FileClose(FileHandle);
//End Write Records=======================================
end;

procedure TTetris.StandartRecords;
var i:Integer;
begin
 For i:=0 to 4 do
  begin
   Records_C[i].Nick:='Гравець'+IntTOStr(I+1);
   Records_C[i].Level:=5-i+4;
   Records_C[i].Points:=(150-I*15)*3;
   Records_C[i].DelLines:=(20-3*i)*3;

   Records_T[i].Nick:='Гравець'+IntTOStr(I+1);
   Records_T[i].Level:=5-i+4;
   Records_T[i].Points:=(200-25*i)*3;
   Records_T[i].DelLines:=(20-3*i)*3;
  end;
end;

procedure TTetris.DrawAbout;
begin
  DXDraw1.Surface.Canvas.TextOut(100,50,'Tetris 1.0');
  DXDraw1.Surface.Canvas.TextOut(100,90,'Автор:');
  DXDraw1.Surface.Canvas.TextOut(100,130,'Танасійчук Андрій Мирославович');
  DXDraw1.Surface.Canvas.TextOut(100,170,'Україна');
  DXDraw1.Surface.Canvas.TextOut(100,210,'e-mail: Andriy-TM@yandex.ru');
  DXDraw1.Surface.Canvas.TextOut(100,250,'Ресурс розмыщений на сайты: http://www.delphisources.ru');
  DXDraw1.Surface.Canvas.TextOut(100,290,'м.Івано-Франківськ');
  DXDraw1.Surface.Canvas.TextOut(100,330,'2006р.');
  DXDraw1.Surface.Canvas.Release;
end;

procedure TTetris.ApplicationEvents1Minimize(Sender: TObject);
begin
   If (Not Pause)and(Not IsGameOver)then Pause:=True;
   GMenu.Visible:=True;
   Timer2.Enabled:=False;
end;

end.