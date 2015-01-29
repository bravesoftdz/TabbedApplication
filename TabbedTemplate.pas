unit TabbedTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Gestures, FMX.Layouts, FMX.ListBox, IdHTTP, FMX.Media;

type
  TTabbedForm = class(TForm)
    HeaderToolBar: TToolBar;
    ToolBarLabel: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    GestureManager1: TGestureManager;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Button1: TButton;
    ListBox3: TListBox;
    MediaPlayer1: TMediaPlayer;
    Button2: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure HeaderToolBarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox2ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TabbedForm: TTabbedForm;
  a1,a2,a3,a4:array of String;
  n,m:integer;
  category,seriya,videofile:String;
implementation

{$R *.fmx}
function utf16decode(const encode:string):string;
var
presult,psource:PChar;
s:string;
buf,code:Integer;
begin
try
SetLength(result, length(encode));
presult:=pchar(result);
psource:=pchar(encode);

while psource^<>#0 do
begin
if (psource^='\') then
begin
  inc(psource);
  if psource^='u' then
  begin
    psource^:='x';
    SetString(s,psource,5);
    Val(s,buf,code);
    if buf>=$100 then
    begin
      s:=WideChar(buf);
      presult^:=s[1];
    end
    else
      presult^:=chr(buf);
    Inc(psource,5);
  end
  else
    presult^:='\';
end
else
begin
  presult^:=psource^;
  Inc(psource);
end;

Inc(presult);
end;
SetLength(result, presult - pchar(Result));
except
result:='error';
end;
end;







procedure TTabbedForm.HeaderToolBarClick(Sender: TObject);
begin

end;

{*********** INITIALIZING END ***********}

procedure getcategory(s:String);
var
  ss:String;
  i,r1,l1,r2,l2:integer;
begin
  ss:=s;
  while pos('"name":',ss)>0 do delete(ss,pos('"name":',ss),7);
  while pos('"id":',ss)>0 do delete(ss,pos('"id":',ss),5);
  n:=0;
  i:=n-1;
  while pos('"',ss)>0 do begin
   r1:=pos('"',ss);
   delete(ss,r1,1);
   l1:=pos('"',ss);
   delete(ss,l1,1);
   r2:=pos('"',ss);
   delete(ss,r2,1);
   l2:=pos('"',ss);
   delete(ss,l2,1);
   n:=n+1;
   i:=i+1;
   setlength(a1,n);
   setlength(a2,n);
   a1[i]:=copy(ss,r1,l1-r1);
   a2[i]:=copy(ss,r2,l2-r2);
  end;
end;

procedure connect_index2;
var
  idhttp: TidHttp;
 // JSON:  TJsonValue;
  Getfile: String;
//  Obj: TJSONObject;
 // Pair: TJSONPair;
begin
  idhttp :=Tidhttp.Create;
  try
  Getfile:=(idhttp.Get('http://iplay.kaztrk.kz/connect/index2.php?row=name,id&table=dle_category'));
//    Getfile:=(idhttp.Get('http://iplay.kaztrk.kz/connect/index.php?row=id&table=dle_post&t=category&y=8'));
   // Getfile:=(idhttp.Get('http://iplay.kaztrk.kz/connect/index.php?row=xfields&table=dle_post&t=id&y=29'));
//    Obj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(GetFile), 0) as TJSONObject;
  {  Invent := Obj.Get('id').JsonValue;
    size := TJSONArray(Invent).size;
    for i := 0 to size - 1 do
    begin
      Inv := TJSONArray(Invent).Get(i);
      Pair := TJSONPair(Inv);
      Memo1.Lines.Add(Format('id #%s', [Pair.JsonString.Value]));
    end;}
//  label1.Text:=getmp4(getfile);
   getcategory(getfile);
//   label1.Text:='YEAP!!!';
//   label1.Text:=a1[1];
  finally
 // Obj.Free;
  idhttp.Free;
  end;
end;

procedure writetolist1;
var
  j: Integer;
  Buffer: String;
  ListBoxItem : TListBoxItem;
  ListBoxGroupHeader : TListBoxGroupHeader;
begin
  TabbedForm.ListBox1.Clear;
  TabbedForm.ListBox1.BeginUpdate;
  ListBoxGroupHeader := TListBoxGroupHeader.Create(TabbedForm.ListBox1);
  ListBoxGroupHeader.Text := 'Категории';
  TabbedForm.ListBox1.AddObject(ListBoxGroupHeader);

  for j:=0 to n-1 do
  begin
    // Add header ('A' to 'Z') to the List

    // Add items ('a', 'aa', 'aaa', 'b', 'bb', 'bbb', 'c', ...) to the list
      // StringOfChar returns a string with a specified number of repeating characters.
      Buffer := a1[j];
      // Simply add item
      // ListBox1.Items.Add(Buffer);

      // or, you can add items by creating an instance of TListBoxItem by yourself
      ListBoxItem := TListBoxItem.Create(TabbedForm.ListBox1);
      ListBoxItem.Text :=Buffer;// utf16decode(Buffer);
      // (aNone=0, aMore=1, aDetail=2, aCheckmark=3)
      ListBoxItem.ItemData.Accessory := TListBoxItemData.TAccessory(1);
      TabbedForm.ListBox1.AddObject(ListBoxItem);
   end;
  TabbedForm.ListBox1.EndUpdate;
end;


procedure tab1show;
begin
    connect_index2;
    writetolist1;
end;


{***********************   TAB2   *******************************}

procedure gettitle(s:string);
var
  ss:String;
  i,r1,l1,r2,l2:integer;
begin
  ss:=s;
  while pos('"title":',ss)>0 do delete(ss,pos('"title":',ss),8);
  while pos('"id":',ss)>0 do delete(ss,pos('"id":',ss),5);
  while pos('\\\"',ss)>0 do delete(ss,pos('\\\"',ss),4);
  m:=0;
  i:=m-1;
  while pos('"',ss)>0 do begin
   r1:=pos('"',ss);
   delete(ss,r1,1);
   l1:=pos('"',ss);
   delete(ss,l1,1);
   r2:=pos('"',ss);
   delete(ss,r2,1);
   l2:=pos('"',ss);
   delete(ss,l2,1);
   m:=m+1;
   i:=i+1;
   setlength(a3,m);
   setlength(a4,m);
   a3[i]:=copy(ss,r1,l1-r1);
   a4[i]:=copy(ss,r2,l2-r2);
  end;
end;

procedure showtitle;
var
  j: Integer;
  Buffer: String;
  ListBoxItem : TListBoxItem;
  ListBoxGroupHeader : TListBoxGroupHeader;
begin
  TabbedForm.ListBox2.BeginUpdate;
  ListBoxGroupHeader := TListBoxGroupHeader.Create(TabbedForm.ListBox2);
  ListBoxGroupHeader.Text := 'Серии';
   TabbedForm.ListBox2.AddObject(ListBoxGroupHeader);

  for j:=0 to m-1 do
  begin
    // Add header ('A' to 'Z') to the List

    // Add items ('a', 'aa', 'aaa', 'b', 'bb', 'bbb', 'c', ...) to the list
      // StringOfChar returns a string with a specified number of repeating characters.
      Buffer := a3[j];
      // Simply add item
      // ListBox1.Items.Add(Buffer);

      // or, you can add items by creating an instance of TListBoxItem by yourself
      ListBoxItem := TListBoxItem.Create(TabbedForm.ListBox2);
      ListBoxItem.Text := Buffer;//utf16decode(Buffer);
      // (aNone=0, aMore=1, aDetail=2, aCheckmark=3)
      ListBoxItem.ItemData.Accessory := TListBoxItemData.TAccessory(1);
       TabbedForm.ListBox2.AddObject(ListBoxItem);
   end;
   TabbedForm.ListBox2.EndUpdate;
end;



procedure connect_index_title;
var
  idhttp: TidHttp;
  Getfile:String;
begin
idhttp :=Tidhttp.Create;
try
  TabbedForm.ListBox2.Clear;
  Getfile:=(idhttp.Get('http://iplay.kaztrk.kz/connect/index.php?row=title,id&table=dle_post&t=category&y=' + category));
  gettitle(Getfile);
finally
  idhttp.Free;
end;

end;

procedure getmp4(s:string);
var
  ss:String;
  i,r1,l1,r2,l2:integer;
begin
  ss:=s;
  l1:=pos('|video|',ss);
  r1:=pos('.mp4',ss);
  videofile:=copy(ss,l1+7,r1-l1-3);
end;


Procedure getxfields;
var
  idhttp: TidHttp;
  Getfile:String;
begin
idhttp :=Tidhttp.Create;
try
  TabbedForm.ListBox2.Clear;
  Getfile:=(idhttp.Get('http://iplay.kaztrk.kz/connect/index.php?row=xfields&table=dle_post&t=id&y=' + seriya));
  getmp4(Getfile);
finally
  idhttp.Free;
end;

end;


Procedure tab3show;
begin
   getxfields;
  tabbedform.Label1.Text:= videofile;
//   playvideo;
end;



procedure tab2show;
begin
    connect_index_title;
    TabbedForm.ListBox2.Clear;
    showtitle;
end;



procedure TTabbedForm.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  category:=  a2[item.Index-1];
  TabControl1.ActiveTab := TabItem2;
  button1.Visible:=true;
  tab2show;
end;




procedure TTabbedForm.ListBox2ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  seriya:=  a4[item.Index-1];
  TabControl1.ActiveTab := TabItem3;
  button1.Visible:=false;
  button2.Visible:=true;
  tab3show;
end;

procedure TTabbedForm.Button1Click(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem1;
  button1.Visible:=false;
  tab1show;
end;

procedure TTabbedForm.Button2Click(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem2;
  button2.Visible:=false;
  button1.Visible:=true;
  tab2show;
end;

procedure TTabbedForm.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl1.ActiveTab := TabItem1;
  button1.Visible:=false;
  tab1show;
end;

procedure TTabbedForm.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
{$IFDEF ANDROID}
  case EventInfo.GestureID of
    sgiLeft:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount-1] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex+1];
      Handled := True;
    end;

    sgiRight:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex-1];
      Handled := True;
    end;
  end;
{$ENDIF}
end;


end.
