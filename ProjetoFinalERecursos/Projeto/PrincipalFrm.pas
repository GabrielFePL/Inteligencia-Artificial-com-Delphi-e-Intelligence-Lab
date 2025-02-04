unit PrincipalFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Mitov.Types, ILTrainingData, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ListBox, LPComponent, ILBasicClassifier, ILNaiveBayes, ILKNearestNeighbor,
  ILNeuralNetwork, FMX.ScrollBox, FMX.Memo, ILRadialBasisFunctionNetwork;

type
  TfrmPrincipal = class(TForm)
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    cmbGenero: TComboBox;
    cmbIdade: TComboBox;
    cmbEstadoCivil: TComboBox;
    cmbDependentes: TComboBox;
    cmbRenda: TComboBox;
    cmbResidencia: TComboBox;
    cmbVeiculo: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblPerfil: TLabel;
    btnTreinar: TButton;
    btnPrever: TButton;
    naivebayes: TILNaiveBayes;
    lblPefilKNN: TLabel;
    knn: TILKNearestNeighbor;
    lblBackpropagation: TLabel;
    redeneural: TILNeuralNetwork;
    backpropagation: TILNeuralNetworkBackpropTrain;
    rprop: TILNeuralNetworkRPropTrain;
    rederprop: TILNeuralNetwork;
    lblRprop: TLabel;
    lblBom: TLabel;
    lblMedio: TLabel;
    lblRuim: TLabel;
    procedure btnTreinarClick(Sender: TObject);
    procedure btnPreverClick(Sender: TObject);
    procedure naivebayesResult(ASender: TObject; AFeatures: ISLRealBuffer;
      AResult: TILNaiveBayesResult);
    procedure knnResult(ASender: TObject; AFeatures: ISLRealBuffer;
      AResult: TILKNearestNeighborResult);
    procedure redeneuralResult(ASender: TObject; AFeatures: ISLRealBuffer;
      AResult: TILClassifierResult);
    procedure rederpropResult(ASender: TObject; AFeatures: ISLRealBuffer;
      AResult: TILClassifierResult);
  private
    FBom, FMedio, FRuim: Integer;
    procedure GravaDados(APrevisores: ISLRealMatrixBuffer; AClasse: ISLRealBuffer);
    procedure TreinarRedeNeural;
  public
    function GetGeneroNumerico(AGenero: string): Real;
    function GetIdadeNumerico(AIdade: string): Real;
    function GetEstadoCivilNumerico(AEstadoCivil: string): Real;
    function GetDependentesNumerico(ADependentes: string): Real;
    function GetRendaNumerico(ARenda: string): Real;
    function GetResidenciaNumerico(AResidencia: string): Real;
    function GetVeiculoNumerico(AVeiculo: string): Real;
    function GetPerfilNumerico(APerfil: string): Real;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses ConexaoDtm, FireDAC.Comp.Client, ILStreamTypes;

{ TForm2 }


procedure TfrmPrincipal.btnPreverClick(Sender: TObject);
var
  ANovo: ISLRealBuffer;
begin
  FBom := 0;
  FMedio := 0;
  FRuim := 0;

  ANovo := TSLRealBuffer.CreateSize(7);

  ANovo[0] := GetGeneroNumerico(cmbGenero.Selected.Text);
  ANovo[1] := GetIdadeNumerico(cmbIdade.Selected.Text);
  ANovo[2] := GetEstadoCivilNumerico(cmbEstadoCivil.Selected.Text);
  ANovo[3] := GetDependentesNumerico(cmbDependentes.Selected.Text);
  ANovo[4] := GetRendaNumerico(cmbRenda.Selected.Text);
  ANovo[5] := GetResidenciaNumerico(cmbResidencia.Selected.Text);
  ANovo[6] := GetVeiculoNumerico(cmbVeiculo.Selected.Text);

  naivebayes.Predict(ANovo);
  knn.Predict(ANovo);
  redeneural.Predict(ANovo);
  rederprop.Predict(ANovo);

  lblBom.Text := 'Bom: ' + IntToStr(FBom);
  lblMedio.Text := 'Médio: ' + IntToStr(FMedio);
  lblRuim.Text := 'Ruim: ' + IntToStr(FRuim);
end;

procedure TfrmPrincipal.btnTreinarClick(Sender: TObject);
var
  ADadosTreinamento: ISLRealMatrixBuffer;
  AClasse: ISLRealBuffer;
  ALinhas: Integer;
begin
  ADadosTreinamento := TSLRealMatrixBuffer.CreateSize(1000, 7);
  AClasse := TSLRealBuffer.CreateSize(1000);
  ALinhas := 0;

  with TFDQuery.Create(Self) do
  try
    Connection := dtmConexao.cnnConexao;

    Open('select * from pessoas_classificacao where perfil = ''Bom''');
    while not Eof do
    begin
      ADadosTreinamento[ALinhas, 0] := GetGeneroNumerico(FieldByName('genero').AsString);
      ADadosTreinamento[ALinhas, 1] := GetIdadeNumerico(FieldByName('idade').AsString);
      ADadosTreinamento[ALinhas, 2] := GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      ADadosTreinamento[ALinhas, 3] := GetDependentesNumerico(FieldByName('dependentes').AsString);
      ADadosTreinamento[ALinhas, 4] := GetRendaNumerico(FieldByName('salario').AsString);
      ADadosTreinamento[ALinhas, 5] := GetResidenciaNumerico(FieldByName('residencia').AsString);
      ADadosTreinamento[ALinhas, 6] := GetVeiculoNumerico(FieldByName('veiculo').AsString);
      AClasse[ALinhas] := GetPerfilNumerico(FieldByName('perfil').AsString);

      Inc(ALinhas);
      Next;
    end;

    Close;
    Open('select * from pessoas_classificacao where perfil = ''Médio''');
    while not Eof do
    begin
      ADadosTreinamento[ALinhas, 0] := GetGeneroNumerico(FieldByName('genero').AsString);
      ADadosTreinamento[ALinhas, 1] := GetIdadeNumerico(FieldByName('idade').AsString);
      ADadosTreinamento[ALinhas, 2] := GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      ADadosTreinamento[ALinhas, 3] := GetDependentesNumerico(FieldByName('dependentes').AsString);
      ADadosTreinamento[ALinhas, 4] := GetRendaNumerico(FieldByName('salario').AsString);
      ADadosTreinamento[ALinhas, 5] := GetResidenciaNumerico(FieldByName('residencia').AsString);
      ADadosTreinamento[ALinhas, 6] := GetVeiculoNumerico(FieldByName('veiculo').AsString);
      AClasse[ALinhas] := GetPerfilNumerico(FieldByName('perfil').AsString);

      Inc(ALinhas);
      Next;
    end;

    Close;
    Open('select * from pessoas_classificacao where perfil = ''Ruim''');
    while not Eof do
    begin
      ADadosTreinamento[ALinhas, 0] := GetGeneroNumerico(FieldByName('genero').AsString);
      ADadosTreinamento[ALinhas, 1] := GetIdadeNumerico(FieldByName('idade').AsString);
      ADadosTreinamento[ALinhas, 2] := GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      ADadosTreinamento[ALinhas, 3] := GetDependentesNumerico(FieldByName('dependentes').AsString);
      ADadosTreinamento[ALinhas, 4] := GetRendaNumerico(FieldByName('salario').AsString);
      ADadosTreinamento[ALinhas, 5] := GetResidenciaNumerico(FieldByName('residencia').AsString);
      ADadosTreinamento[ALinhas, 6] := GetVeiculoNumerico(FieldByName('veiculo').AsString);
      AClasse[ALinhas] := GetPerfilNumerico(FieldByName('perfil').AsString);

      Inc(ALinhas);
      Next;
    end;

    naivebayes.Train(ADadosTreinamento, AClasse, False);
    knn.Train(ADadosTreinamento, AClasse, False);
    TreinarRedeNeural;

    //GravaDados(ADadosTreinamento, AClasse);
  finally
    Free;
  end;
end;


function TfrmPrincipal.GetDependentesNumerico(ADependentes: string): Real;
begin
  if ADependentes = '0-2' then
    Result := 0.00
  else if ADependentes = '3-5' then
    Result := 0.50
  else
    Result := 1.00;
end;

function TfrmPrincipal.GetEstadoCivilNumerico(AEstadoCivil: string): Real;
begin
  if AEstadoCivil = 'Casado' then
    Result := 0.00
  else if AEstadoCivil = 'Solteiro' then
    Result := 0.30
  else if AEstadoCivil = 'Divorciado' then
    Result := 0.60
  else
    Result := 1.00;
end;

function TfrmPrincipal.GetGeneroNumerico(AGenero: string): Real;
begin
  if AGenero = 'M' then
    Result := 0.00
  else
    Result := 1.00;
end;

function TfrmPrincipal.GetIdadeNumerico(AIdade: string): Real;
begin
  if AIdade = '<20' then
    Result := 0.00
  else if AIdade = '20-39' then
    Result := 0.50
  else
    Result := 1.00;
end;

function TfrmPrincipal.GetPerfilNumerico(APerfil: string): Real;
begin
  if APerfil = 'Bom' then
    Result := 0.0
  else if APerfil = 'Médio' then
    Result := 0.50
  else
    Result := 1.00;
end;

function TfrmPrincipal.GetRendaNumerico(ARenda: string): Real;
begin
  if ARenda = '700-8000' then
    Result := 0.00
  else if ARenda = '8001-15000' then
    Result := 0.50
  else
    Result := 1.00;
end;

function TfrmPrincipal.GetResidenciaNumerico(AResidencia: string): Real;
begin
  if AResidencia = 'Própria' then
    Result := 0.00
  else if AResidencia = 'Alugada' then
    Result := 0.50
  else
    Result := 1.00;
end;

function TfrmPrincipal.GetVeiculoNumerico(AVeiculo: string): Real;
begin
  if AVeiculo = 'Sim' then
    Result := 0.00
  else
    Result := 1.00;
end;


procedure TfrmPrincipal.GravaDados(APrevisores: ISLRealMatrixBuffer; AClasse: ISLRealBuffer);
var
  I: Integer;
  AResultado: TStringList;
begin
  AResultado := TStringList.Create;
  for I := 0 to 999 do
    AResultado.Add(FloatToStr(APrevisores[I][0]) + ';' +
                   FloatToStr(APrevisores[I][1]) + ';' +
                   FloatToStr(APrevisores[I][2]) + ';' +
                   FloatToStr(APrevisores[I][3]) + ';' +
                   FloatToStr(APrevisores[I][4]) + ';' +
                   FloatToStr(APrevisores[I][5]) + ';' +
                   FloatToStr(APrevisores[I][6]) + ';' +
                   FloatToStr(AClasse[I]));
  AResultado.SaveToFile('c:\base.txt');
end;

procedure TfrmPrincipal.knnResult(ASender: TObject; AFeatures: ISLRealBuffer;
  AResult: TILKNearestNeighborResult);
begin
  if AResult.ResultClass = 0 then
  begin
    lblPefilKNN.Text := 'KNN: Bom';
    Inc(FBom);
  end
  else if AResult.ResultClass = 0.5 then
  begin
    lblPefilKNN.Text := 'KNN: Médio';
    Inc(FMedio);
  end
  else
  begin
    lblPefilKNN.Text := 'KNN: Ruim';
    Inc(FRuim);
  end;
end;

procedure TfrmPrincipal.naivebayesResult(ASender: TObject; AFeatures: ISLRealBuffer;
  AResult: TILNaiveBayesResult);
begin
  if AResult.ResultClass = 0 then
  begin
    lblPerfil.Text := 'Naive: Bom';
    Inc(FBom);
  end
  else if AResult.ResultClass = 0.5 then
  begin
    lblPerfil.Text := 'Naive: Médio';
    Inc(FMedio);
  end
  else
  begin
    lblPerfil.Text := 'Naive: Ruim';
    Inc(FRuim);
  end;

end;


procedure TfrmPrincipal.redeneuralResult(ASender: TObject;
  AFeatures: ISLRealBuffer; AResult: TILClassifierResult);
begin
  if Round(AResult.Results[0]) = 1 then
  begin
    lblBackpropagation.Text := 'Back: Bom';
    Inc(FBom);
  end
  else if Round(AResult.Results[0]) = 2 then
  begin
    lblBackpropagation.Text := 'Back: Médio';
    Inc(FMedio);
  end
  else
  begin
    lblBackpropagation.Text := 'Back: Ruim';
    Inc(FRuim);
  end;
end;

procedure TfrmPrincipal.rederpropResult(ASender: TObject;
  AFeatures: ISLRealBuffer; AResult: TILClassifierResult);
begin
  if Round(AResult.Results[0]) = 1 then
  begin
    lblRprop.Text := 'RProp: Bom';
    Inc(FBom);
  end
  else if Round(AResult.Results[0]) = 2 then
  begin
    lblRprop.Text := 'RProp: Médio';
    Inc(FMedio);
  end
  else
  begin
    lblRprop.Text := 'RProp: Ruim';
    Inc(FRuim);
  end;
end;

procedure TfrmPrincipal.TreinarRedeNeural;
var
  ADadosTreinamentoRedeNeural: IILTrainingDataArray;
  APrevisores: ISLRealBuffer;
  ARegistro: IILTrainingDataItem;
begin
  ADadosTreinamentoRedeNeural := TILTrainingDataArray.Create;

  with TFDQuery.Create(Self) do
  try
    Connection := dtmConexao.cnnConexao;
    Open('select * from pessoas_classificacao where perfil = ''Bom''');
    while not Eof do
    begin
      APrevisores := TSLRealBuffer.CreateSize(7);
      APrevisores[0] := GetGeneroNumerico(FieldByName('genero').AsString);
      APrevisores[1] := GetIdadeNumerico(FieldByName('idade').AsString);
      APrevisores[2] := GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      APrevisores[3] := GetDependentesNumerico(FieldByName('dependentes').AsString);
      APrevisores[4] := GetRendaNumerico(FieldByName('salario').AsString);
      APrevisores[5] := GetResidenciaNumerico(FieldByName('residencia').AsString);
      APrevisores[6] := GetVeiculoNumerico(FieldByName('veiculo').AsString);
      ARegistro := TILTrainingDataItem.CreateData(APrevisores, 1);
      ADadosTreinamentoRedeNeural.Add(ARegistro);

      Next;
    end;

    Close;
    Open('select * from pessoas_classificacao where perfil = ''Médio''');
    while not Eof do
    begin
      APrevisores := TSLRealBuffer.CreateSize(7);
      APrevisores[0] := GetGeneroNumerico(FieldByName('genero').AsString);
      APrevisores[1] := GetIdadeNumerico(FieldByName('idade').AsString);
      APrevisores[2] := GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      APrevisores[3] := GetDependentesNumerico(FieldByName('dependentes').AsString);
      APrevisores[4] := GetRendaNumerico(FieldByName('salario').AsString);
      APrevisores[5] := GetResidenciaNumerico(FieldByName('residencia').AsString);
      APrevisores[6] := GetVeiculoNumerico(FieldByName('veiculo').AsString);
      ARegistro := TILTrainingDataItem.CreateData(APrevisores, 2);
      ADadosTreinamentoRedeNeural.Add(ARegistro);

      Next;
    end;

    Close;
    Open('select * from pessoas_classificacao where perfil = ''Ruim''');
    while not Eof do
    begin
      APrevisores := TSLRealBuffer.CreateSize(7);
      APrevisores[0] := GetGeneroNumerico(FieldByName('genero').AsString);
      APrevisores[1] := GetIdadeNumerico(FieldByName('idade').AsString);
      APrevisores[2] := GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      APrevisores[3] := GetDependentesNumerico(FieldByName('dependentes').AsString);
      APrevisores[4] := GetRendaNumerico(FieldByName('salario').AsString);
      APrevisores[5] := GetResidenciaNumerico(FieldByName('residencia').AsString);
      APrevisores[6] := GetVeiculoNumerico(FieldByName('veiculo').AsString);
      ARegistro := TILTrainingDataItem.CreateData(APrevisores, 3);
      ADadosTreinamentoRedeNeural.Add(ARegistro);

      Next;
    end;

    backpropagation.Train(ADadosTreinamentoRedeNeural);
    rprop.Train(ADadosTreinamentoRedeNeural);

  finally
    Free;
  end;

end;

end.
