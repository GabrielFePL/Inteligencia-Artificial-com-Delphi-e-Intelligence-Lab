unit DataModelingConection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDataModule1 = class(TDataModule)
    cnnConection: TFDConnection;
    driver: TFDPhysMySQLDriverLink;
    queryPreProcessedData: TFDQuery;
    queryPreProcessedDataGender: TStringField;
    queryPreProcessedDataAge: TStringField;
    queryPreProcessedDataMarital_Status: TStringField;
    queryPreProcessedDataDependents: TStringField;
    queryPreProcessedDataIncome: TStringField;
    queryPreProcessedDataResidence_Type: TStringField;
    queryPreProcessedDataVehicle: TStringField;
    queryPreProcessedDataClient_Profile: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
