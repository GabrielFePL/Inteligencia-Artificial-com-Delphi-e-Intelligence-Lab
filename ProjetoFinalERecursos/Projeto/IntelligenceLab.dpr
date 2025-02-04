program IntelligenceLab;

uses
  System.StartUpCopy,
  FMX.Forms,
  PrincipalFrm in 'PrincipalFrm.pas' {frmPrincipal},
  ConexaoDtm in 'ConexaoDtm.pas' {dtmConexao: TDataModule},
  TesteAlgoritmosFrm in 'TesteAlgoritmosFrm.pas' {frmTestesAlgoritmos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmTestesAlgoritmos, frmTestesAlgoritmos);
  Application.CreateForm(TdtmConexao, dtmConexao);
  Application.Run;
end.
