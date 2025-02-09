program IntelligenceLab;

uses
  System.StartUpCopy,
  FMX.Forms,
  MachineLearningWithDelphiApp in 'MachineLearningWithDelphiApp.pas' {Form1},
  DataModelingConection in 'DataModelingConection.pas' {DtmConection: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDtmConection, DtmConection);
  Application.Run;
end.
