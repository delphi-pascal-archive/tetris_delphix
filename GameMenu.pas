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

{
******************************************************
**   Модуль реалізації меню в ігрі.			    **
**   Тут знаходяться такі частини меню як:	    **
**   Buttons, CheckButtons та SrollBar.		    **	
******************************************************
}

unit GameMenu;

interface

Uses Windows, DXDraws, Classes, Graphics;

Type
TAmount=0..10;
TWhat=(G_Scroll, G_Btn, G_Edit, G_KeyEdit, G_CheckBox);
TArrayPointer=Array[0..9] of Pointer;

TParam=record
  Left:Integer;
  Top:integer;
  Width:Integer;
  Height:Integer;
 end;

TBtn=Class
  private
   FBoundsRect:TRect;
   FVisible:Boolean;
   FParam:TParam;
  public
   Constructor Create;Virtual;
   Destructor Destroy;Override;

   Procedure SetParam(Left, Top, Width, Height:Integer);Overload;Virtual;
   Procedure SetParam(Param: TParam);Overload;Virtual;

   Procedure DoDraw;Virtual;

   Property BoundsRect:TRect read FBoundsRect;
   Property Param:TParam read FParam;
   Property Visible:Boolean read FVisible write FVisible;
 end;

 TImageBtn=Class(TBtn)
   Private
    FImage:TPictureCollectionItem;
    FCaption:String;
    FTextSize:Integer;
    FTransporent:Boolean;
    Select:Boolean;
    Light:Boolean;
   Protected
    Function GetDrawIndex:Byte;
   Public
    OnClick:TNotifyEvent;

    Constructor Create;Override;
    Procedure DoDraw;Override;

    Procedure MouseMove(X,Y:Integer);
    Procedure MouseDown(X,Y:Integer);
    Procedure MouseUp(X,Y:Integer);

    Property Transporent:Boolean read FTransporent write FTransporent;
    Property Image:TPictureCollectionItem read FImage write FImage;
    Property Caption:String read FCaption write FCaption;
    Property TextSize:Integer read FTextSize write FTextSize;
  end;

 TGameScroll=class(TBtn)
  private
   FImage:TPictureCollectionItem;
   FVertical:Boolean;
   FMax:Integer;
   FPosition:Integer;
   FChange:TNotifyEvent;

   TopRect:TRect;
   ButtomRect:TRect;
   CenterRect:TRect;

   TopDraw:0..2;
   BottomDraw:0..2;
   Procedure SetRect;
   Procedure SetVertical(const Value: Boolean);
   procedure SetPosition(const Value: Integer);
    procedure SetMax(const Value: integer);
  Public
   CenterDraw:0..3;
   Constructor Create;Override;
   Procedure DoDraw;Override;
   Procedure MouseMove(X,Y:Integer);
   Procedure MouseDown(X,Y:Integer);
   Procedure SetParam(Left,Top,Width,Height:Integer);Override;

   Property OnChange:TNotifyEvent Read FChange write FChange;

   Property Image:TPictureCollectionItem read FImage write FImage;
   Property Vertical:Boolean read FVertical write SetVertical;
   Property Max:integer read FMax write SetMax;
   Property Position: integer read FPosition write SetPosition;
 end;

Type
 TGameCheckBox=class(TBtn)
  Private
   FImage:TPictureCollectionItem;
   FChecked:Boolean;
   FCaption:String;
   FCheckRect:TRect;
   FChoose:Boolean;
   DrawIndex:0..2;
   Procedure SetCheck(Const Value: Boolean);
  public
   OnCheck:TNotifyEvent;
   Constructor Create;Override;
   Procedure DoDraw;Override;
   Procedure MouseMove(X,Y:Integer);
   Procedure MouseUp(X,Y:Integer);
   Procedure SetParam(Left,Top,Width,Height:Integer);Override;

   Property Image:TPictureCollectionItem read FImage write FImage;
   Property Checked:Boolean read FChecked write SetCheck;
   Property Caption:string read FCaption write FCaption;
 end;

Type
TGameEdit=class(TBtn)
   Private
    FText:String;
    FMax:Byte;
    FImage:TPictureCollectionItem;
    FTextSize:Integer;
    Light:Boolean;
    Select:Boolean;
    procedure SetText(const Value: String);
   Protected
    Function GetDrawIndex:Byte;
   Public
    OnChange:TNotifyEvent;
    Constructor Create;Override;
    Procedure DoDraw;Override;

    Procedure MouseMove(X,Y:Integer);
    Procedure MouseDown(X,Y:Integer);
    Procedure KeyPress(Var Key:Char);

    Property Image:TPictureCollectionItem read FImage write FImage;
    Property Text:String read FText write SetText;
    Property Max:Byte read FMax write FMax;
    Property TextSize:Integer read FTextSize write FTextSize;
  end;

TGameKeyEdit=class(TBtn)
   Private
    FText:String;
    FImage:TPictureCollectionItem;
    FTextSize:Integer;
    Light:Boolean;
    Select:Boolean;
    FKey:Word;
    procedure SetKey(const Value: Word);
    Procedure ChooseKey(Key: Word);
   Protected
    Function GetDrawIndex:Byte;
   Public
    OnKeyEdit:TNotifyEvent;
    Constructor Create;Override;
    Procedure DoDraw;Override;

    Procedure MouseMove(X,Y:Integer);
    Procedure MouseDown(X,Y:Integer);
    Procedure KeyDown(Key: Word);

    Property Image:TPictureCollectionItem read FImage write FImage;
    Property TextSize:Integer read FTextSize write FTextSize;
    Property Key: Word read FKey write SetKey;
  end;

TGameMenu=Class(TObject)
  Private
   BtnList:TArrayPointer;
   CheckList:TArrayPointer;
   EditList:TArrayPointer;
   KeyEditList:TArrayPointer;
   ScrollList:TArrayPointer;

   FImage:TPictureCollectionItem;
   FEvent:TNotifyEvent;

   BtnCount:TAmount;
   CheckCount:TAmount;
   EditCount:TAmount;
   KeyEditCount:TAmount;
   ScrollCount:TAmount;

   FOnVisible:TNotifyEvent;
    FVisible: Boolean;
    function GetBtn(index: TAmount): TImageBtn;
    function GetCheckBox(index: TAmount): TGameCheckBox;
    function GetEdit(index: TAmount): TGameEdit;
    function GetEditKey(index: TAmount): TGameKeyEdit;
    function GetScrolls(index: TAmount): TGameScroll;

    Function Insert(P: Pointer;Var PArray: TArrayPointer;Var Count: TAmount):Boolean;
    procedure SetVisible(const Value: Boolean);
  Public
   Constructor Create;
   Destructor Destroy;Override;

   Function Add(What: TWhat;Caption:String):Boolean;Overload;
   Function Add(What: TWhat;Caption:String;Param: TParam):Boolean;Overload;

   Procedure MouseDown(X, Y:Integer);
   Procedure MouseMove(X, Y:Integer);
   Procedure MouseUp(X, Y:Integer);
   Procedure KeyDown(Key: Word);
   Procedure KeyPress(Var Key:Char);
   Procedure DoDraw;

   procedure SetBtnsInRect(Rect: TRect;BtnWidth,BtnHeight:Integer;First,Last:TAmount);
   procedure SetAllBtnsInRect(Rect: TRect;BtnWidth,BtnHeight:Integer);

   Property Image:TPictureCollectionItem read FImage write FImage;
   Property EVent:TNotifyEvent read FEvent write FEvent;
   Property OnVisible:TNotifyEvent read FOnVisible write FOnVisible;
   Property Visible:Boolean read FVisible write SetVisible;

   Property GameBtns[index: TAmount]:TImageBtn read GetBtn;
   Property GameCheckBox[index: TAmount]:TGameCheckBox read GetCheckBox;
   Property GameEdits[index: TAmount]:TGameEdit read GetEdit;
   Property GameEditKeys[index: TAmount]:TGameKeyEdit read GetEditKey;
   Property GameScrolls[index: TAmount]:TGameScroll read GetScrolls;
 end;

Function PointInRect(X,Y:Integer;Rect:TRect):Boolean;
Function Param(Left, Top, Width, Height:Integer):TParam;

var
  DXDraw:^TDXDraw;

implementation
{Functions & Procedures}
Function PointInRect(X,Y:Integer;Rect:TRect):Boolean;
begin
 Result:=False;
  If (X>Rect.Left)and(X<Rect.Right)and
     (Y>Rect.Top)and(Y<Rect.Bottom)Then
      result:=True;
end;

Function Param(Left, Top, Width, Height:Integer):TParam;
begin
 Result.Left:=Left;
 Result.Top:=Top;
 Result.Width:=Width;
 Result.Height:=Height;
end;
{ Btn }

constructor TBtn.Create;
begin
 Inherited Create;
  FVisible:=True;
  Self.SetParam(0,0,200,20);
end;

destructor TBtn.Destroy;
begin
  inherited Destroy;
end;

procedure TBtn.DoDraw;
begin
end;

procedure TBtn.SetParam(Left, Top, Width, Height: Integer);
begin
  FParam.Left:=Left; FParam.Top:=Top;
  FParam.Width:=Width; FParam.Height:=Height;
  FBoundsRect:=Rect(Left, Top, Left+Width, Top+Height);
end;

procedure TBtn.SetParam(Param: TParam);
begin
 SetParam(Param.Left, Param.Top, Param.Width, Param.Height);
end;


{ TImageBtn }

constructor TImageBtn.Create;
begin
  inherited Create;
   FCaption:='GameButton';
   FTransporent:=False;
   FTextSize:=16;
end;

procedure TImageBtn.DoDraw;
var TextX, TextY, I:Integer;
begin
inherited DoDraw;
 If not FVisible then Exit;
  DXDraw^.Surface.Canvas.Brush.Style:=bsClear;
  DXDraw^.Surface.Canvas.Font.Size:=FTextSize;
  DXDraw^.Surface.Canvas.Font.Color:=clWhite;
  I:=GetDrawIndex;

  DXDraw^.Surface.StretchDraw( FBoundsRect,FImage.PatternRects[I],
   FImage.PatternSurfaces[I],FTransporent);

  TextX:=Trunc(BoundsRect.Left+(Param.Width - DXDraw^.Surface.Canvas.TextWidth(FCaption))/2);
  TextY:=Trunc(BoundsRect.Top+(Param.Height - DXDraw^.Surface.Canvas.TextHeight(FCaption))/2);

  DXDraw^.Surface.Canvas.TextRect(FBoundsRect,TextX,TextY,FCaption);
  DXDraw^.Surface.Canvas.Release;
end;

function TImageBtn.GetDrawIndex: Byte;
begin
 Result:=0;
  If Light then Result:=1;
  If Select then Result:=2;
end;

procedure TImageBtn.MouseDown(X, Y: Integer);
begin
If Not FVisible then Exit;
 If PointInRect(X, Y, FBoundsRect) then
  Select:=True else Select:=False;
end;

procedure TImageBtn.MouseMove(X, Y: Integer);
begin
If Not FVisible then Exit;
 If PointInRect(X, Y, FBoundsRect) then
  Light:=True else Light:=False;
end;

procedure TImageBtn.MouseUp(X, Y: Integer);
begin
If Not FVisible then Exit;
 If (Select)then
  begin
   Select:=False;
    if (PointInRect(X, Y, FBoundsRect))then
     if Assigned(OnClick)then OnClick(Self);
  end;
end;

{ TGameSroll }

constructor TGameScroll.Create;
begin
  inherited Create;
   FMax:=10;
   FVertical:=False;
end;

procedure TGameScroll.DoDraw;
begin
  inherited;
   If Not Visible then Exit;
    FImage.StretchDraw(DXDraw^.Surface,TopRect,TopDraw);
    FImage.StretchDraw(DXDraw^.Surface,ButtomRect,BottomDraw);
    FImage.StretchDraw(DXDraw^.Surface,CenterRect,CenterDraw);
end;

procedure TGameScroll.MouseDown(X, Y: Integer);
begin
if Not Visible then Exit;
If PointInRect(X,Y,ButtomRect) then
 begin
  if FPosition<FMax then
   begin
    Position:=Position+1;
    If Assigned(OnChange) then FChange(Self);
   end;
  SetRect;
  BottomDraw:=2; exit;
 end;

If PointInRect(X,Y,TopRect) then
 begin
  if FPosition>0 then
   begin
    Position:=Position-1;
    If Assigned(OnChange) then FChange(Self);
   end;
  SetRect;
  TopDraw:=2;
 end;

end;

procedure TGameScroll.MouseMove(X, Y: Integer);
begin
if Not Visible then Exit;
 If PointInRect(X,Y,ButtomRect) then
  begin
   BottomDraw:=1; exit;
  end;

 If PointInRect(X,Y,TopRect) then
  begin
   TopDraw:=1; exit;
  end;

 If TopDraw<>0 then TopDraw:=0;
 If BottomDraw<>0 then BottomDraw:=0;
end;

procedure TGameScroll.SetMax(const Value: integer);
begin
  Position:=0;
  FMax := Value;
  SetParam(FParam.Left, FParam.Top, FParam.Width, FParam.Height);
end;

procedure TGameScroll.SetParam(Left, Top, Width, Height: Integer);
begin
 If (Not FVertical) then Width:=Round((Width-40)/(1 + Max))*(1+Max)+40
   else Height:=Round((Height-40)/(1 + Max))*(1+Max)+40;
  inherited;
   SetRect;
end;

procedure TGameScroll.SetPosition(const Value: Integer);
begin
 If Value>Max then
  FPosition:=FMax else
 If Value<0 then
  FPosition:=0  else
  FPosition:=Value;
  SetRect;
end;

procedure TGameScroll.SetRect;
var W:Integer;
begin
If (Not Vertical) then
 begin
  W:=Round((Param.Width-40)/(1 + Max));

  TopRect:= Rect(FParam.Left,FParam.Top,FParam.Left+20,FParam.Top+FParam.Height);
  ButtomRect:= Rect(FBoundsRect.Right-20,FBoundsRect.Bottom-Param.Height,FBoundsRect.Right,FBoundsRect.Bottom);
  CenterRect:= Rect(FParam.Left+20+W*FPosition,FParam.Top,FParam.Left+20+W+W*FPosition,FParam.Top+FParam.Height);
 end else
 begin
  W:=Round((Param.Height-40)/(1 + Max));

  TopRect:= Rect(FParam.Left,FParam.Top,FParam.Left+FParam.Width,FParam.Top+20);
  ButtomRect:= Rect(FBoundsRect.Right-FParam.Width,FBoundsRect.Bottom-20,FBoundsRect.Right,FBoundsRect.Bottom);
  CenterRect:= Rect(FParam.Left,FParam.Top+20+W*FPosition,FParam.Left+FParam.Width,FParam.Top+20+W+W*FPosition);
 end;
end;

procedure TGameScroll.SetVertical(const Value: Boolean);
begin
 FVertical:=Value;
 SetParam(FParam.Left, FParam.Top, FParam.Width, FParam.Height);
end;

{ TGameCheckBox }

constructor TGameCheckBox.Create;
begin
  inherited;
  FCaption:='CheckButton';
  FChecked:=False;
end;

procedure TGameCheckBox.DoDraw;
var TextY:Integer;
begin
  inherited;
 If Not FVisible Then exit;

FImage.StretchDraw( DXDRaw^.Surface,FCheckRect,DrawIndex);
TextY:= Round(ABS(FParam.Height-DXDraw^.Surface.Canvas.TextHeight(FCaption))/2);
 DXDraw^.Surface.Canvas.TextRect(FBoundsRect,
  FCheckRect.Right,FParam.Top+TextY,FCaption);

 if FChoose then
  with DXDraw^.Surface.Canvas do
   begin
    Pen.Color:=clLime;
    Rectangle(FBoundsRect);
   end;
  DXDraw^.Surface.Canvas.Release;

end;

procedure TGameCheckBox.MouseMove(X, Y: Integer);
begin
If Not FVisible then exit;
 if PointInRect(X,Y,FBoundsRect) then
   FChoose:=true else FChoose:=False;
end;

procedure TGameCheckBox.MouseUp(X, Y: Integer);
begin
If Not FVisible then exit;
 If (PointInRect(X,Y,FBoundsRect)) then
  begin
   FChecked:=not FChecked;
   If Assigned(OnCheck)then OnCheck(Self);
   if FChecked then DrawIndex:=1 else DrawIndex:=0;
  end;
end;

procedure TGameCheckBox.SetCheck(const Value: Boolean);
begin
  FChecked:=Value;
  if FChecked then DrawIndex:=1 else DrawIndex:=0;
end;

procedure TGameCheckBox.SetParam(Left, Top, Width, Height: Integer);
begin
  inherited;
  FCheckRect:=Rect( FParam.Left,FParam.Top,FParam.Left+Fparam.Height,FParam.Top+FParam.Height);
end;

{ TGameEdit }

constructor TGameEdit.Create;
begin
  inherited;
   FMax:=255;
   Select:=False;
   FTextSize:=14;
end;

procedure TGameEdit.DoDraw;
var TextX,TextY,I:Integer;
begin
  inherited;
 If Not FVisible Then Exit;
  DXDraw^.Surface.Canvas.Brush.Style:=bsClear;
  DXDraw^.Surface.Canvas.Font.Size:=FTextSize;
  DXDraw^.Surface.Canvas.Font.Color:=clWhite;
  I:=GetDrawIndex;

  DXDraw^.Surface.StretchDraw( FBoundsRect,FImage.PatternRects[I],
   FImage.PatternSurfaces[I],False);

  TextX:=Trunc(BoundsRect.Left+(Param.Width - DXDraw^.Surface.Canvas.TextWidth(FText))/2);
  TextY:=Trunc(BoundsRect.Top+(Param.Height - DXDraw^.Surface.Canvas.TextHeight(FText))/2);

  DXDraw^.Surface.Canvas.TextRect(FBoundsRect,TextX,TextY,FText);
  DXDraw^.Surface.Canvas.Release;
end;

function TGameEdit.GetDrawIndex: Byte;
begin
  Result:=0;
   If Light then Result:=1;
   If Select then Result:=2;
end;

procedure TGameEdit.KeyPress(var Key: Char);
begin
 If (Not FVisible)or(Not Select) then Exit;
 {Enter - 13; BackSpace - 8}
  If (Key=Chr(8))or (Key=Chr(13)) then
   begin
    If Key=Chr(8) then
     begin
      Delete(FText,Length(FText),1);
      If Assigned(OnChange) then OnChange(Self);
     end
     else Select:=False;
     Exit;
   end;
  If (Length(FText)<FMax)
   then
    begin
     FText:=FText + Key;
     If Assigned(OnChange) then OnChange(Self);
    end;
end;

procedure TGameEdit.MouseDown(X, Y: Integer);
begin
  If Not FVisible Then Exit;
   If PointInRect(X, Y, FBoundsRect) then
    begin
     Select:=Not Select;
     If (Select)and(DXDraw^.Focused=False) then
     DXDraw^.SetFocus;
    end else Select:=False;
end;

procedure TGameEdit.MouseMove(X, Y: Integer);
begin
 If Not FVisible Then Exit;
  If PointInRect(X, Y, FBoundsRect) then
    Light:=True else Light:=False;
end;

procedure TGameEdit.SetText(const Value: String);
begin
 If Length(Value)<=FMax then FText := Value;
end;

{ TGameKeyEdit }

procedure TGameKeyEdit.ChooseKey(Key: Word);
begin
 If (Key in [65..90])or(Key in [48..57]) then
   begin
    FText:=Chr(Key);
    FKey:=Key;
   end else
  If (Key in [96..105]) then
   begin
    FText:='Num '+Chr(Key-48);
    FKey:=Key;
   end else
 If (Key in [37..40]) then
   begin
    if Key=37 then FText:='Left';
    if key=38 then FText:='Up';
    if key=39 then FText:='Right';
    if key=40 then FText:='Down';
    FKey:=Key;
   end else
 If Key=32 then
   begin
     FText:='Space';
     FKey:=Key
   end else
   Begin
    if key=13 then Select:=False else
    begin
     FKey:=0;
     FText:='none';
    end;
   end;
end;

constructor TGameKeyEdit.Create;
begin
  inherited Create;
   FText:='none';
   FTextSize:=14;
   FKey:=0;
end;

procedure TGameKeyEdit.DoDraw;
var TextX,TextY,I:Integer;
begin
  inherited;
 If Not FVisible Then Exit;
  DXDraw^.Surface.Canvas.Brush.Style:=bsClear;
  //DXDraw^.Surface.Canvas.Font.Size:=FTextSize;
  DXDraw^.Surface.Canvas.Font.Color:=clWhite;
  I:=GetDrawIndex;

  DXDraw^.Surface.StretchDraw( FBoundsRect,FImage.PatternRects[I],
   FImage.PatternSurfaces[I],False);

  TextX:=Trunc(BoundsRect.Left+(Param.Width - DXDraw^.Surface.Canvas.TextWidth(FText))/2);
  TextY:=Trunc(BoundsRect.Top+(Param.Height - DXDraw^.Surface.Canvas.TextHeight(FText))/2);

  DXDraw^.Surface.Canvas.TextRect(FBoundsRect,TextX,TextY,FText);
  DXDraw^.Surface.Canvas.Release;
end;

function TGameKeyEdit.GetDrawIndex: Byte;
begin
  Result:=0;
   If Light then Result:=1;
   If Select then Result:=2;
end;

procedure TGameKeyEdit.KeyDown(Key: Word);
begin
 If (Not FVisible)or(Not Select) Then Exit;
  ChooseKey(Key);
end;

procedure TGameKeyEdit.MouseDown(X, Y: Integer);
begin
  If Not FVisible Then Exit;
   If PointInRect(X, Y, FBoundsRect) then
    begin
     Select:=Not Select;
     If (Select)and(DXDraw^.Focused=False) then
     DXDraw^.SetFocus;
    end else Select:=False;
end;

procedure TGameKeyEdit.MouseMove(X, Y: Integer);
begin
 If Not FVisible Then Exit;
  If PointInRect(X, Y, FBoundsRect) then
    Light:=True else Light:=False;
end;

procedure TGameKeyEdit.SetKey(const Value: Word);
begin
  FKey := Value;
  ChooseKey(Value);
end;

{ TGameMenu }

Function TGameMenu.Insert(P: Pointer;Var PArray: TArrayPointer;Var Count: TAmount):Boolean;
begin
Result:=False;
If Count=10 then Exit;
 Inc(Count); PArray[Count-1]:=P;
 Result:=True;
end;

Function TGameMenu.Add(What: TWhat;Caption:String):Boolean;
begin
Result:=False;
If (What=G_Btn)and(BtnCount<10) then
  begin
   Result:=Insert(TImageBtn.Create,BtnList,BtnCount);
   TImageBtn(BtnList[BtnCount-1]).OnClick:=FEvent;
   TImageBtn(BtnList[BtnCount-1]).Image:=FImage;
   TImageBtn(BtnList[BtnCount-1]).Caption:=Caption;
  end else
If (What=G_CheckBox)and(CheckCount<10) then
  begin
   Result:=Insert(TGameCheckBox.Create,CheckList,CheckCount);
   TGameCheckBox(CheckList[CheckCount-1]).OnCheck:=FEvent;
   TGameCheckBox(CheckList[CheckCount-1]).Caption:=Caption;
  end else
If (What=G_Edit)and(EditCount<10) then
  begin
   Result:=Insert(TGameEdit.Create,EditList,EditCount);
   TGameEdit(EditList[EditCount-1]).OnChange:=FEvent;
  end else
If (What=G_Scroll)and(ScrollCount<10) then
  begin
   Result:=Insert(TGameScroll.Create,ScrollList,ScrollCount);
   TGameScroll(ScrollList[ScrollCount-1]).OnChange:=FEvent;
  end else
If (What=G_KeyEdit)and(KeyEditCount<10) then
  begin
   Result:=Insert(TGameKeyEdit.Create,KeyEditList,KeyEditCount);
   TGameKeyEdit(KeyEditList[KeyEditCount-1]).OnKeyEdit:=FEvent;
  end;
end;

Function TGameMenu.Add(What: TWhat;Caption:String;Param: TParam):Boolean;
begin
 Result:=False;
 if Not Add(What,Caption) then Exit;
   Case What of
   G_Btn     : TImageBtn(BtnList[BtnCount-1]).SetParam(Param);
   G_CheckBox: TGameCheckBox(CheckList[CheckCount-1]).SetParam(Param);
   G_Edit    : TGameEdit(EditList[EditCount-1]).SetParam(Param);
   G_Scroll  : TGameScroll(ScrollList[ScrollCount-1]).SetParam(Param);
   G_KeyEdit : TGameKeyEdit(KeyEditList[KeyEditCount-1]).SetParam(Param);
   end;
  Result:=True;
end;

constructor TGameMenu.Create;
begin
 Inherited Create;
  BtnCount:=0; CheckCount:=0; ScrollCount:=0;
  EditCount:=0; KeyEditCount:=0;
  FVisible:=True;
end;

destructor TGameMenu.Destroy;
begin

  inherited;
end;

function TGameMenu.GetBtn(index: TAmount): TImageBtn;
begin
 Result:=TImageBtn(BtnList[Index-1]);
end;

function TGameMenu.GetCheckBox(index: TAmount): TGameCheckBox;
begin
 Result:=TGameCheckBox(CheckList[Index-1]);
end;

function TGameMenu.GetEdit(index: TAmount): TGameEdit;
begin
 Result:=TGameEdit(EditList[Index-1]);
end;

function TGameMenu.GetEditKey(index: TAmount): TGameKeyEdit;
begin
 Result:=TGameKeyEdit(KeyEditList[Index-1]);
end;

function TGameMenu.GetScrolls(index: TAmount): TGameScroll;
begin
 Result:=TGameScroll(ScrollList[Index-1]);
end;

procedure TGameMenu.DoDraw;
var i:Integer;
begin
If Not FVisible then Exit;
 For i:=0 to BtnCount-1 do
  TImageBtn(BtnList[i]).DoDraw;
 For i:=0 to ScrollCount-1 do
  TGameScroll(ScrollList[i]).DoDraw;
 For i:=0 to KeyEditCount-1 do
  TGameKeyEdit(KeyEditList[i]).DoDraw;
 For i:=0 to EditCount-1 do
  TGameEdit(EditList[i]).DoDraw;
 For i:=0 to CheckCount-1 do
  TGameCheckBox(CheckList[i]).DoDraw;
end;

procedure TGameMenu.KeyDown(Key: Word);
var i:Integer;
begin
If Not FVisible then Exit;
If KeyEditCount=0 then Exit;
 For i:=0 to KeyEditCount-1 do
  TGameKeyEdit(KeyEditList[i]).KeyDown(Key);
end;

procedure TGameMenu.KeyPress(var Key: Char);
var i:Integer;
begin
If Not FVisible then Exit;
If EditCount=0 then Exit;
  For i:=0 to EditCount-1 do
   TGameEdit(EditList[i]).KeyPress(Key);
end;

procedure TGameMenu.MouseDown(X, Y: Integer);
var i:Integer;
begin
If Not FVisible then Exit;
 For i:=0 to BtnCount-1 do
  TImageBtn(BtnList[i]).MouseDown(X,Y);
 For i:=0 to ScrollCount-1 do
  TGameScroll(ScrollList[i]).MouseDown(X,Y);
 For i:=0 to KeyEditCount-1 do
  TGameKeyEdit(KeyEditList[i]).MouseDown(X,Y);
 For i:=0 to EditCount-1 do
  TGameEdit(EditList[i]).MouseDown(X,Y);
end;

procedure TGameMenu.MouseMove(X, Y: Integer);
var i:Integer;
begin
If Not FVisible then Exit;
 For i:=0 to BtnCount-1 do
  TImageBtn(BtnList[i]).MouseMove(X,Y);
 For i:=0 to CheckCount-1 do
  TGameCheckBox(CheckList[i]).MouseMove(X,Y);
 For i:=0 to ScrollCount-1 do
  TGameScroll(ScrollList[i]).MouseMove(X,Y);
 For i:=0 to KeyEditCount-1 do
  TGameKeyEdit(KeyEditList[i]).MouseMove(X,Y);
 For i:=0 to EditCount-1 do
  TGameEdit(EditList[i]).MouseMove(X,Y);
end;

procedure TGameMenu.MouseUp(X, Y: Integer);
var i:Integer;
begin
If Not FVisible then Exit;
 For i:=0 to BtnCount-1 do
  TImageBtn(BtnList[i]).MouseUp(X,Y);
 For i:=0 to CheckCount-1 do
  TGameCheckBox(CheckList[i]).MouseUp(X,Y);
end;

procedure TGameMenu.SetBtnsInRect(Rect: TRect;BtnWidth,BtnHeight:Integer;First,Last:TAmount);
Var I, X, Y, Between:Integer;
begin
 If (BtnCount=0)or(Last<First)or((First=0)or(Last=0)) then Exit;
 X:=Trunc((Rect.Left+Rect.Right-BtnWidth)/2);
 Between:=Trunc((Rect.Top+Rect.Bottom-((Last-First+1)*BtnHeight))/((Last-First+1)+1));
 Y:=Between;
  For i:=First-1 to Last-1 do
  begin
   TImageBtn(BtnList[i]).SetParam(Rect.Left+X,Rect.Top+Y,BtnWidth,BtnHeight);
   If I<>Last-1 then Y:=(Y+BtnHeight)+Between;
  end;
end;

procedure TGameMenu.SetAllBtnsInRect(Rect: TRect; BtnWidth,
  BtnHeight: Integer);
begin
  SetBtnsInRect(Rect,BtnWidth,BtnHeight,1,BtnCount);
end;

procedure TGameMenu.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
   If Assigned(OnVisible)then FOnVisible(Self);
end;

end.
