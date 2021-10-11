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
unit Tetris_E;

interface
const
 MapWidthCounts=13;
 MapHeightCounts=20;
Type
 MasFigure=Array[0..3,0..3]of 0..1;
 State=(stNormal, stRight, stBottom, stLeft);
 MasStates=Array[State]of MasFigure;
 PMasStates=^MasStates;
 TMapItem=Record
   Include:Boolean;
   Pic:Byte;
  end;
 TFigure=record
   X,Y:Byte;
   Pic:Byte;
   Mas:PMasStates;
   St:State;
  end;

type
TDirection=(dLeft,dRight,dDown);

Const
fgStick: MasStates=
  {Normal} ( ((1,0,0,0), (1,0,0,0), (1,0,0,0), (1,0,0,0)),
  {Right }   ((1,1,1,1), (0,0,0,0), (0,0,0,0), (0,0,0,0)),
  {Bottom}   ((1,0,0,0), (1,0,0,0), (1,0,0,0), (1,0,0,0)),
  {Left  }   ((1,1,1,1), (0,0,0,0), (0,0,0,0), (0,0,0,0)) );
fgChair_R: MasStates=
           ( ((1,0,0,0), (1,1,0,0), (0,1,0,0), (0,0,0,0)),
             ((0,1,1,0), (1,1,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,0,0,0), (1,1,0,0), (0,1,0,0), (0,0,0,0)),
             ((0,1,1,0), (1,1,0,0), (0,0,0,0), (0,0,0,0)) );
fgChair_L: MasStates=
           ( ((0,1,0,0), (1,1,0,0), (1,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (0,1,1,0), (0,0,0,0), (0,0,0,0)),
             ((0,1,0,0), (1,1,0,0), (1,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (0,1,1,0), (0,0,0,0), (0,0,0,0)) );
fgL_L: MasStates=
           ( ((1,0,0,0), (1,0,0,0), (1,1,0,0), (0,0,0,0)),
             ((1,1,1,0), (1,0,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (0,1,0,0), (0,1,0,0), (0,0,0,0)),
             ((0,0,1,0), (1,1,1,0), (0,0,0,0), (0,0,0,0)) );
fgL_R: MasStates=
           ( ((0,1,0,0), (0,1,0,0), (1,1,0,0), (0,0,0,0)),
             ((1,0,0,0), (1,1,1,0), (0,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (1,0,0,0), (1,0,0,0), (0,0,0,0)),
             ((1,1,1,0), (0,0,1,0), (0,0,0,0), (0,0,0,0)) );
fgH: MasStates=
           ( ((0,1,0,0), (1,1,1,0), (0,0,0,0), (0,0,0,0)),
             ((1,0,0,0), (1,1,0,0), (1,0,0,0), (0,0,0,0)),
             ((1,1,1,0), (0,1,0,0), (0,0,0,0), (0,0,0,0)),
             ((0,1,0,0), (1,1,0,0), (0,1,0,0), (0,0,0,0)) );
fgSquare: MasStates=
           ( ((1,1,0,0), (1,1,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (1,1,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (1,1,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (1,1,0,0), (0,0,0,0), (0,0,0,0)) );

fgX: MasStates=
           ( ((0,1,0,0), (1,1,1,0), (0,1,0,0), (0,0,0,0)),
             ((0,1,0,0), (1,1,1,0), (0,1,0,0), (0,0,0,0)),
             ((0,1,0,0), (1,1,1,0), (0,1,0,0), (0,0,0,0)),
             ((0,1,0,0), (1,1,1,0), (0,1,0,0), (0,0,0,0)) );

fgT: MasStates=
           ( ((1,1,1,0), (0,1,0,0), (0,1,0,0), (0,0,0,0)),
             ((0,0,1,0), (1,1,1,0), (0,0,1,0), (0,0,0,0)),
             ((0,1,0,0), (0,1,0,0), (1,1,1,0), (0,0,0,0)),
             ((1,0,0,0), (1,1,1,0), (1,0,0,0), (0,0,0,0)) );

fgZ_L: MasStates=
           ( ((1,0,0,0), (1,1,1,0), (0,0,1,0), (0,0,0,0)),
             ((0,1,1,0), (0,1,0,0), (1,1,0,0), (0,0,0,0)),
             ((1,0,0,0), (1,1,1,0), (0,0,1,0), (0,0,0,0)),
             ((0,1,1,0), (0,1,0,0), (1,1,0,0), (0,0,0,0)) );
fgZ_R: MasStates=
           ( ((0,0,1,0), (1,1,1,0), (1,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (0,1,0,0), (0,1,1,0), (0,0,0,0)),
             ((0,0,1,0), (1,1,1,0), (1,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (0,1,0,0), (0,1,1,0), (0,0,0,0)) );
fgU: MasStates=
           ( ((1,0,1,0), (1,1,1,0), (0,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (1,0,0,0), (1,1,0,0), (0,0,0,0)),
             ((1,1,1,0), (1,0,1,0), (0,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (0,1,0,0), (1,1,0,0), (0,0,0,0)) );
fgG_S: MasStates=
           ( ((1,1,0,0), (1,0,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (0,1,0,0), (0,0,0,0), (0,0,0,0)),
             ((0,1,0,0), (1,1,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,0,0,0), (1,1,0,0), (0,0,0,0), (0,0,0,0)) );

fgG_B: MasStates=
           ( ((1,1,1,0), (1,0,0,0), (1,0,0,0), (0,0,0,0)),
             ((1,1,1,0), (0,0,1,0), (0,0,1,0), (0,0,0,0)),
             ((0,0,1,0), (0,0,1,0), (1,1,1,0), (0,0,0,0)),
             ((1,0,0,0), (1,0,0,0), (1,1,1,0), (0,0,0,0)) );

fgStick_S: MasStates=
           ( ((1,1,0,0), (0,0,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,0,0,0), (1,0,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,1,0,0), (0,0,0,0), (0,0,0,0), (0,0,0,0)),
             ((1,0,0,0), (1,0,0,0), (0,0,0,0), (0,0,0,0)) );
Var
  Map:Array[0..MapWidthCounts,0..MapHeightCounts]of TMapItem;
  Figure:TFigure;
  NewFigure:TFigure;
  NextLevel:Word=5;
  Count:Byte;

  procedure DeleteLines;
  Procedure LiveFigureOnMap(X,Y:Byte);
  Procedure RandomFigure(Var Figure:TFigure);
  Procedure DrawMap;
  Procedure MapClear;  
  Procedure Rote(Var st:State);
  Procedure DrawFigure(Figure:TFigure;X,Y:Integer;ByIndex:Boolean=False;Const UseW:Byte=24;Const UseH:Byte=24);
  Function  CanMove(Direction:TDirection=dDown):Boolean;
  Function  CanBe(s:State):Boolean;
implementation
Uses Unit1, Classes, SysUtils;

Function CheckForLine(Index:Byte):Boolean;
var i:Integer;
begin
 result:=True;
  For i:=0 to MapWidth-1 do
   If Map[i,Index].Include=false then
    result:=false;
end;

Procedure DeleteLine(Index:Byte);
var i:Integer;
begin
If AnimDel then
 begin
 For i:=0 to MapWidth-1 do
  Map[I,Index].Pic:=Form1.DXImageList1.Tag;
  For i:=0 to MapWidth-1 do
   begin
   Deletline:=True;
    Map[I,Index].Pic:=Form1.DXImageList1.Tag;
    Form1.DXTimer1.OnTimer(Form1,0);
    Sleep(20);
    Map[I,Index].Include:=False;
   DeletLine:=False;
   end
 end
else
  For i:=0 to MapWidth-1 do
    Map[I,Index].Include:=False;

  Min:=Min+1;
end;


Procedure LineBeLine(Index:Byte);
var i,j:Integer;
begin
 For i:=Index DownTo Min-1 do
  For j:=0 to MapWidth-1 do
   begin
    Map[J,i].Include:=Map[J,I-1].Include;
    Map[J,i].Pic:=Map[J,I-1].Pic;
   end;
end;

procedure DeleteLines;
var i, Count:Byte;
begin
Count:=0;
 For I:=Max to Max+3 do
  if CheckForLine(I) then
  begin
   DeleteLine(I);
   LineBeLine(I);
   Inc(Count);
   Inc(CountDLines);
   If CountDLines = NextLevel then
    begin
     NextLevel:=NextLevel+Level+5;
     Inc(Level);
     Speed:= Speed-25;
     Form1.Timer1.Interval:= Speed;
    end;
  end;
if Count>1 then
 Points:=Points+MapWidth*Count+Count*4+Level
 else
  If Count=1 then
   Points:=Points+MapWidth+Level;

end;

Function BoolToByte(B:Boolean):Byte;
begin
 if B then result:=1 else result:=0;
end;

Function CanBe(s:State):Boolean;
var I,J:Integer;
begin
result:=True;
 For i:=0 to 3 do
  for j:=0 to 3 do
   if Figure.Mas^[s,i,j]=1 then
    if (Figure.Mas^[s,i,j]=BoolToByte(Map[Figure.X+J,Figure.Y+i].Include))or
      (Figure.X+J=MapWidth)or(Figure.Y+I=MapHeight) then
    result:=False;
end;

Function CanMove(Direction:TDirection=dDown):Boolean;
var i,j:Integer;
begin
Result:=True;
 Count:=0;
   For i:=0 to 3 do
    For j:=0 to 3 do
     if Figure.Mas^[Figure.St,i,j]=1 then
      begin
       case Direction of
        dLeft :
         if  (Map[Figure.X+J-1,Figure.Y+I].Include=true)or(Figure.X+J=0) then
          Result:=False;
        dRight:
         if  (Map[Figure.X+J+1,Figure.Y+I].Include=true)or(Figure.X+J+1=MapWidth) then
          Result:=False;
        dDown :
         if  (Map[Figure.X+J,Figure.Y+i+1].Include=true)or(Figure.Y+i+1=MapHeight) then
          Result:=False;
       end;
       Inc(Count);
     If Classic then If Count=4 then Exit;
      end;
end;

Procedure LiveFigureOnMap(X,Y:Byte);
var i,j:Integer;
begin
 Count:=0;
   For i:=0 to 3 do
    For j:=0 to 3 do
     if Figure.Mas^[Figure.St,i,j]=1 then
      begin
       Map[X+J,Y+I].Include:=True;
       Map[X+J,Y+I].Pic:=Figure.Pic;
       Inc(Count);
      If Classic then If Count=4 then Exit;
      end;
end;

Procedure DrawFigure(Figure:TFigure;X,Y:Integer;ByIndex:Boolean=False;Const UseW:Byte=24;Const UseH:Byte=24);
var i,j:Integer;
begin
If ByIndex then begin
              X:=MapX+X*ItemWidth; Y:=MapY+Y*ItemHeight;
              end;
Count:=0;
 For i:=0 to 3 do
  For j:=0 to 3 do
    if Figure.Mas^[Figure.St,i,j]=1 then
     begin
     Form1.DXImageList1.Items.Find('TetrisItems').StretchDraw(
      Form1.DXDraw1.Surface,
      Rect(X+(J*UseW),Y+(I*UseH),
      X+(J*UseW)+UseW,Y+(I*UseH)+UseH),Figure.Pic);
      Inc(Count);

     If Classic then If Count=4 then Exit;
     end;
end;



Procedure MapClear;
var i,j:Integer;
begin
 for i:=0 to MapWidthCounts do
  for j:=0 to MapHeightCounts do
   Map[i,j].Include:=False;
end;

Procedure DrawMap;
var i,j:Integer;
S:0..5;
begin
If Space then S:=5 else S:=0;
for i:=0 to MapWidth-1 do
 for j:=0 to MapHeight-1 do
  begin
   if Map[i,j].Include then
     Form1.DXImageList1.Items.Find('TetrisItems').StretchDraw(
      Form1.DXDraw1.Surface,
      Rect(MapX+I*ItemWidth,MapY+J*ItemHeight,
 MapX+I*ItemWidth+ItemWidth-S,MapY+J*ItemHeight+ItemHeight-S),
       Map[i,j].Pic);

  end;
end;

Procedure RandomFigure(Var Figure:TFigure);
var K:Byte;
begin
Randomize;
if Classic then k:=7
   else k:=15;
Randomize;   
 case Random(k) of
   0:Figure.Mas:=@fgStick;
   1:Figure.Mas:=@fgChair_L;
   2:Figure.Mas:=@fgChair_R;
   3:Figure.Mas:=@fgL_L;
   4:Figure.Mas:=@fgL_R;
   5:Figure.Mas:=@fgH;
   6:Figure.Mas:=@fgSquare;
   7:Figure.Mas:=@fgX;
   8:Figure.Mas:=@fgT;
   9:Figure.Mas:=@fgZ_L;
  10:Figure.Mas:=@fgZ_R;
  11:Figure.Mas:=@fgU;
  12:Figure.Mas:=@fgG_S;
  13:Figure.Mas:=@fgG_B;
  14:Figure.Mas:=@fgStick_S;
 end;
 case Random(4) of
  0:Figure.St:=stNormal;
  1:Figure.St:=stRight;
  2:Figure.St:=stLeft;
  3:Figure.St:=stBottom;
 end;
Figure.Pic:=Random(Form1.DXImageList1.Tag);
end;

Procedure Rote(Var st:State);
begin
  case St of
   stNormal:
    begin
    if CanBe(stRight) then
     St:=stRight;
    end;
   stRight:
    begin
    if CanBe(stBottom) then
     St:=stBottom;
    end;
   stBottom:
    begin
    if CanBe(stLeft) then
     St:=stLeft;
    end;
   stLeft:
    begin
    if CanBe(stNormal) then
     St:=stNormal;
    end;
 end;
end;

Procedure DrawFig(Const Figure:TFigure);
begin

end;



end.
