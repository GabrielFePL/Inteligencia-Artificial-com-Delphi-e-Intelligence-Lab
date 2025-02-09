unit ConexaoDtm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TdtmConexao = class(TDataModule)
    cnnConexao: TFDConnection;
    driver: TFDPhysMySQLDriverLink;
    qryPessoas: TFDQuery;
    qryPessoasgenero: TStringField;
    qryPessoasidade: TStringField;
    qryPessoasestado_civil: TStringField;
    qryPessoasdependentes: TStringField;
    qryPessoassalario: TStringField;
    qryPessoasresidencia: TStringField;
    qryPessoasveiculo: TStringField;
    qryPessoasperfil: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmConexao: TdtmConexao;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
