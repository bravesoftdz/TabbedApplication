program TabbedApplication;



uses
  System.StartUpCopy,
  FMX.Forms,
  TabbedTemplate in 'TabbedTemplate.pas' {TabbedForm}
  {$IFDEF IOS}
,
  Macapi.Dispatch in '..\Macapi.Dispatch.pas' {$ENDIF};
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTabbedForm, TabbedForm);
  Application.Run;
end.
