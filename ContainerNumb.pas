unit ContainerNumb;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls,Vcl.Graphics,Vcl.StdCtrls, Vcl.Mask,Vcl.Forms,
  Windows, Messages, Variants, Vcl.Dialogs, Vcl.XPMan, Math;

type
  TImageCr = class(TImage)
  private
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  end;
  
  TContainerNumb = class(TPanel)
  private
    { Private declarations }
    FPanel,FPanel2: TPanel;
    FImage: TImageCr;
    FMaskEdit: TMaskEdit;
    FLeftSideNumber : string;

    procedure PanelClick(Sender:TObject);
    procedure ImageClick(Sender:TObject);
    procedure WMSize(var Message:Tmessage); message WM_SIZE;
    procedure MaskEditKeyPress(Sender: TObject; var Key: Char);
    procedure MaskEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    { Protected declarations }
    MEFormat : Word;
  public
    { Public declarations }

    constructor Create(AOwner: TComponent); override;
    property OnClick;

  published

    { Published declarations }
  end;

Const
  FullMask = '>LLLL0000000;1;_';
  ShortMask = '0000000;1;_';
  Hint1 = 'Только цифры';
  Hint2 = 'Буквы и цифры';
  Hint3 = 'Сокращенный формат';
  Hint4 = 'Полный формат';

var  Glif : array [1..4] of TImage;
     FirstCheck,CheckNumb : boolean;


procedure Register;
function CheckControlNumb(STrForCheck:string):integer;
function CheckAlpha(AlphaCh:Char; Position:word):integer;

implementation
{$R CNres.res}

procedure Register;
begin
  RegisterComponents('Samples', [TContainerNumb]);
end;

constructor TContainerNumb.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
    Width:= 221;
    Height:= 33;
    TabOrder:= 0;
    BorderWidth := 1;
    BevelWidth := 1;
    BevelInner := bvLowered;
    Color := clBtnHighlight;
    MEFormat:=0;

    FPanel:=TPanel.Create(self);
    FPanel.Parent:=Self;
    FPanel.Top:=1;
    FPanel.Left:=0;
    FPanel.Height:=32;
    FPanel.Width:=32;
    FPanel.Caption:='123';
    FPanel.BevelInner := bvLowered;
    FPanel.Align:= alNone;
    FPanel.Color := cl3DLight;
    FPanel.TabOrder:= 0;
    FPanel.OnClick:= PanelClick;
    FPanel.Hint:=Hint1;

    FMaskEdit:=TMaskEdit.Create(self);
    FMaskEdit.Parent:=Self;
    FMaskEdit.Top:=4;
    FMaskEdit.Left:=42;
    FMaskEdit.Height:=28;
    FMaskEdit.Width:=144;
    FMaskEdit.Anchors:= [akTop];
    FMaskEdit.AutoSize:= False;
    FMaskEdit.AutoSize := False;
    FMaskEdit.BevelEdges := [];
    FMaskEdit.BevelInner := bvNone;
    FMaskEdit.BevelOuter := bvNone;
    FMaskEdit.BorderStyle := bsNone;
    FMaskEdit.BorderStyle := bsNone;
    FMaskEdit.Font.Charset:= DEFAULT_CHARSET;
    FMaskEdit.Font.Color:= clWindowText;
    FMaskEdit.Font.Height:= -20;
    FMaskEdit.Font.Name:= 'Tahoma';
    FMaskEdit.Font.Style:= [];
    FMaskEdit.ParentFont:= False;
    FMaskEdit.TabOrder:= 1;
    FMaskEdit.EditMask:= FullMask;
    FMaskEdit.MaxLength := 12;
    FMaskEdit.OnKeyPress := MaskEditKeyPress;
    FMaskEdit.OnKeyUp := MaskEditKeyUp;
    FmaskEdit.Hint := Hint3;

    FPanel2:=TPanel.Create(Self);
    FPanel2.Parent:=Self;
    FPanel2.Top:=1;
    FPanel2.Left:=189;
    FPanel2.Height:=32;
    FPanel2.Width:=32;
    FPanel2.BevelInner := bvLowered;
    FPanel2.Align:= alNone;
    FPanel2.Color := cl3DLight;

    Glif[1]:=TImage.Create(Self);
    Glif[1].Picture.Bitmap.Handle:= LoadBitmap(hInstance, 'emptybmp');
    Glif[2]:=TImage.Create(Self);
    Glif[2].Picture.Bitmap.Handle:= LoadBitmap(hInstance, 'deletebmp');
    Glif[3]:=TImage.Create(Self);
    Glif[3].Picture.Bitmap.Handle:= LoadBitmap(hInstance, 'okbmp');
    Glif[4]:=TImage.Create(Self);
    Glif[4].Picture.Bitmap.Handle:= LoadBitmap(hInstance, 'wrongbmp');

    FImage:=TImageCr.Create(Self);
    FImage.Parent :=FPanel2;
    FImage.Top    :=2;
    FImage.Left   :=2;
    FImage.Height :=28;
    FImage.Width  :=28;
    FImage.Picture.Bitmap := Glif[1].Picture.Bitmap;
    FImage.Center         := True;
    FImage.Align          := alClient;
    FImage.OnClick        := ImageClick;

    FirstCheck            :=False;
    CheckNumb             :=False;

end;


procedure TContainerNumb.WMSize(var Message:TMessage);
begin
  inherited;
  if Width<>221  then Width:=221;
  if Height<>33 then Height:=33;

end;

procedure TImagecr.CMMouseEnter(var Message: TMessage);
begin
  Picture.Bitmap := Glif[2].Picture.Bitmap;

end;

procedure TImagecr.CMMouseLeave(var Message: TMessage);
begin
  if FirstCheck then
   if CheckNumb then
    Picture.Bitmap := Glif[3].Picture.Bitmap       // Number is Ok
    else Picture.Bitmap := Glif[4].Picture.Bitmap  // Wrong Number
  else
  Picture.Bitmap := Glif[1].Picture.Bitmap;        // Empty
end;

procedure TContainerNumb.ImageClick ;
begin
  FMaskEdit.Text        := '';
  FirstCheck            := False;
  CheckNumb             := False;


end;

procedure TContainerNumb.MaskEditKeyPress(Sender: TObject; var Key: Char);
begin
  case MEFormat of
  0:  begin
        if  (Key in ['a'..'z']) then Key := AnsiUpperCase(Key)[1];

        if not (Key in [#8, '0'..'9', 'A'..'Z']) then
        begin
           Key := #0;
        end;

      end;

  1:  begin

      end;

  end;
end;

procedure TContainerNumb.MaskEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case MEFormat of
  0:  begin
        if Pos(' ',FMaskEdit.Text)=0 then
         if CheckControlNumb(FMaskEdit.Text)=1 then
         begin
           FImage.Picture.Bitmap := Glif[3].Picture.Bitmap;     // Number is Ok
           CheckNumb:=True;
           FirstCheck:=True;
         end
         else
         begin
           FImage.Picture.Bitmap := Glif[4].Picture.Bitmap;    // Wrong number
           CheckNumb:=False;
           FirstCheck:=True;
         end;

      end;

  1:  begin

      end;

  end;
end;

procedure TContainerNumb.PanelClick(Sender:TObject);
begin
  if FMaskEdit.EditMask = FullMask
  then begin
         FLeftSideNumber        := FMaskEdit.Text;
         FMaskEdit.Text         := '';
         FMaskEdit.EditMask     := ShortMask;
         FMaskEdit.Text         := Copy(FLeftSideNumber,5,7);
         FPanel.Hint            := Hint2;
         FMaskEdit.Left         := 67;
         MEFormat               := 1;
         FImage.Picture.Bitmap  := Glif[1].Picture.Bitmap;       // Empty
         FirstCheck             := False;
       end

  else  begin
         FMaskEdit.EditMask       := FullMask;
         FMaskEdit.Text           := FLeftSideNumber;
         FPanel.Hint              := Hint1;
         FMaskEdit.Left           := 42;
         MEFormat                 := 0;
         if Pos(' ',FMaskEdit.Text)= 0 then
          if CheckControlNumb(FMaskEdit.Text)= 1 then
          begin
            FImage.Picture.Bitmap := Glif[3].Picture.Bitmap;     // Number is Ok
            CheckNumb             := True;
            FirstCheck            := True;
          end
          else
          begin
            FImage.Picture.Bitmap := Glif[4].Picture.Bitmap;    // Wrong number
            CheckNumb             := False;
            FirstCheck            := True;
          end;


       end




end;

function CheckControlNumb(STrForCheck:string):integer;
var i,Summ:integer;
    Res,Remind:word;
begin
  // Начальные присвоения
  result:=idCancel;
  Summ:=0;

  // Проверка строки для разбора
  if length(STrForCheck)<11 then exit;

  // Разбор буквенного кода
  for i:=1 to 4 do
  Summ:= Summ+CheckAlpha(STrForCheck[i],i);

  // Разбор цифрового кода
  for i:=5 to 10 do
  Summ:= Summ+Round(StrToInt(STrForCheck[i])*Power(2,(i-1)));
  DivMod(Summ,11,Res,Remind);
  if Remind = 10 then Remind :=0;
  if Remind = StrToInt(STrForCheck[11]) then result:= idOk;

end;

function CheckAlpha(AlphaCh:Char; Position:word):integer;
const
  ALPHA = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  NUMBR = '1012131415161718192021232425262728293031323435363738';
  var i:word;

begin
  i:=Pos(AlphaCh,ALPHA)-1;
  result := Round(StrToInt(Copy(NUMBR,i*2+1,2))*Power(2,(Position-1)));

end;

end.
