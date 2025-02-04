unit TesteAlgoritmosFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Mitov.Types, LPComponent,
  ILBasicClassifier, ILNaiveBayes, FMX.ScrollBox, FMX.Memo, ILKNearestNeighbor,
  FMX.Edit, ILNeuralNetwork;

type
  TfrmTestesAlgoritmos = class(TForm)
    btnTransferirDados: TButton;
    qryInsercao: TFDQuery;
    btnTreinarTestar: TButton;
    naivebayes: TILNaiveBayes;
    mmNaiveBayes: TMemo;
    mmKNN: TMemo;
    knn: TILKNearestNeighbor;
    edtK: TEdit;
    Label1: TLabel;
    mmBackPropagation: TMemo;
    backpropagation: TILNeuralNetworkBackpropTrain;
    redebackpropagation: TILNeuralNetwork;
    mmRprop: TMemo;
    rprop: TILNeuralNetworkRPropTrain;
    rederprop: TILNeuralNetwork;
    procedure btnTransferirDadosClick(Sender: TObject);
    procedure btnTreinarTestarClick(Sender: TObject);
    procedure naivebayesResult(ASender: TObject; AFeatures: ISLRealBuffer;
      AResult: TILNaiveBayesResult);
    procedure knnResult(ASender: TObject; AFeatures: ISLRealBuffer;
      AResult: TILKNearestNeighborResult);
    procedure redebackpropagationResult(ASender: TObject;
      AFeatures: ISLRealBuffer; AResult: TILClassifierResult);
    procedure rederpropResult(ASender: TObject; AFeatures: ISLRealBuffer;
      AResult: TILClassifierResult);
  private
    FClasseEsperada: Real;
    // Naive Bayes
    FNBomBom, FNBomMedio, FNBomRuim: Integer;
    FNMedioBom, FNMedioMedio, FNMedioRuim: Integer;
    FNRuimBom, FNRuimMedio, FNRuimRuim: Integer;
    // KNN
    FKBomBom, FKBomMedio, FKBomRuim: Integer;
    FKMedioBom, FKMedioMedio, FKMedioRuim: Integer;
    FKRuimBom, FKRuimMedio, FKRuimRuim: Integer;
    // Backpropagation
    FRBBomBom, FRBBomMedio, FRBBomRuim: Integer;
    FRBMedioBom, FRBMedioMedio, FRBMedioRuim: Integer;
    FRBRuimBom, FRBRuimMedio, FRBRuimRuim: Integer;
    // Rprop
    FRPBomBom, FRPBomMedio, FRPBomRuim: Integer;
    FRPMedioBom, FRPMedioMedio, FRPMedioRuim: Integer;
    FRPRuimBom, FRPRuimMedio, FRPRuimRuim: Integer;
    procedure TreinarTestarRedeNeural;
  public
    { Public declarations }
  end;

var
  frmTestesAlgoritmos: TfrmTestesAlgoritmos;

implementation

{$R *.fmx}

uses ConexaoDtm, PrincipalFrm, ILStreamTypes;

procedure TfrmTestesAlgoritmos.btnTransferirDadosClick(Sender: TObject);
var
  AContador: Integer;
begin
  AContador := 1;

  with TFDQuery.Create(Self) do
  try
    Connection := dtmConexao.cnnConexao;

    Open('select * from pessoas_classificacao where perfil = ''Bom''');
    while not Eof do
    begin
      if AContador <= 266 then
        qryInsercao.SQL.Text := 'insert into pessoas_treinamento (genero, idade, estado_civil, dependentes, salario, residencia, veiculo, perfil) values (:genero, :idade, :estado_civil, :dependentes, :salario, :residencia, :veiculo, :perfil)'
      else
        qryInsercao.SQL.Text := 'insert into pessoas_teste (genero, idade, estado_civil, dependentes, salario, residencia, veiculo, perfil) values (:genero, :idade, :estado_civil, :dependentes, :salario, :residencia, :veiculo, :perfil)';

      qryInsercao.Params[0].AsString := FieldByName('genero').AsString;
      qryInsercao.Params[1].AsString := FieldByName('idade').AsString;
      qryInsercao.Params[2].AsString := FieldByName('estado_civil').AsString;
      qryInsercao.Params[3].AsString := FieldByName('dependentes').AsString;
      qryInsercao.Params[4].AsString := FieldByName('salario').AsString;
      qryInsercao.Params[5].AsString := FieldByName('residencia').AsString;
      qryInsercao.Params[6].AsString := FieldByName('veiculo').AsString;
      qryInsercao.Params[7].AsString := FieldByName('perfil').AsString;
      qryInsercao.ExecSQL;

      Inc(AContador);
      Next;
    end;

    AContador := 1;
    Open('select * from pessoas_classificacao where perfil = ''Médio''');
    while not Eof do
    begin
      if AContador <= 438 then
        qryInsercao.SQL.Text := 'insert into pessoas_treinamento (genero, idade, estado_civil, dependentes, salario, residencia, veiculo, perfil) values (:genero, :idade, :estado_civil, :dependentes, :salario, :residencia, :veiculo, :perfil)'
      else
        qryInsercao.SQL.Text := 'insert into pessoas_teste (genero, idade, estado_civil, dependentes, salario, residencia, veiculo, perfil) values (:genero, :idade, :estado_civil, :dependentes, :salario, :residencia, :veiculo, :perfil)';

      qryInsercao.Params[0].AsString := FieldByName('genero').AsString;
      qryInsercao.Params[1].AsString := FieldByName('idade').AsString;
      qryInsercao.Params[2].AsString := FieldByName('estado_civil').AsString;
      qryInsercao.Params[3].AsString := FieldByName('dependentes').AsString;
      qryInsercao.Params[4].AsString := FieldByName('salario').AsString;
      qryInsercao.Params[5].AsString := FieldByName('residencia').AsString;
      qryInsercao.Params[6].AsString := FieldByName('veiculo').AsString;
      qryInsercao.Params[7].AsString := FieldByName('perfil').AsString;
      qryInsercao.ExecSQL;

      Inc(AContador);
      Next;
    end;

    AContador := 1;
    Open('select * from pessoas_classificacao where perfil = ''Ruim''');
    while not Eof do
    begin
      if AContador <= 96 then
        qryInsercao.SQL.Text := 'insert into pessoas_treinamento (genero, idade, estado_civil, dependentes, salario, residencia, veiculo, perfil) values (:genero, :idade, :estado_civil, :dependentes, :salario, :residencia, :veiculo, :perfil)'
      else
        qryInsercao.SQL.Text := 'insert into pessoas_teste (genero, idade, estado_civil, dependentes, salario, residencia, veiculo, perfil) values (:genero, :idade, :estado_civil, :dependentes, :salario, :residencia, :veiculo, :perfil)';

      qryInsercao.Params[0].AsString := FieldByName('genero').AsString;
      qryInsercao.Params[1].AsString := FieldByName('idade').AsString;
      qryInsercao.Params[2].AsString := FieldByName('estado_civil').AsString;
      qryInsercao.Params[3].AsString := FieldByName('dependentes').AsString;
      qryInsercao.Params[4].AsString := FieldByName('salario').AsString;
      qryInsercao.Params[5].AsString := FieldByName('residencia').AsString;
      qryInsercao.Params[6].AsString := FieldByName('veiculo').AsString;
      qryInsercao.Params[7].AsString := FieldByName('perfil').AsString;
      qryInsercao.ExecSQL;

      Inc(AContador);
      Next;
    end;
  finally
     Free;
  end;
end;

procedure TfrmTestesAlgoritmos.btnTreinarTestarClick(Sender: TObject);
var
  ADadosTreinamento: ISLRealMatrixBuffer;
  AClasseTreinamento, ADadosTeste: ISLRealBuffer;
  ALinhas: Integer;
begin
  ADadosTreinamento := TSLRealMatrixBuffer.CreateSize(800, 7);
  AClasseTreinamento := TSLRealBuffer.CreateSize(800);
  ALinhas := 0;
  with TFDQuery.Create(Self) do
  try
    Connection := dtmConexao.cnnConexao;
    Open('select * from pessoas_treinamento where perfil = ''Bom''');
    while not Eof do
    begin
      ADadosTreinamento[ALinhas, 0] := frmPrincipal.GetGeneroNumerico(FieldByName('genero').AsString);
      ADadosTreinamento[ALinhas, 1] := frmPrincipal.GetIdadeNumerico(FieldByName('idade').AsString);
      ADadosTreinamento[ALinhas, 2] := frmPrincipal.GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      ADadosTreinamento[ALinhas, 3] := frmPrincipal.GetDependentesNumerico(FieldByName('dependentes').AsString);
      ADadosTreinamento[ALinhas, 4] := frmPrincipal.GetRendaNumerico(FieldByName('salario').AsString);
      ADadosTreinamento[ALinhas, 5] := frmPrincipal.GetResidenciaNumerico(FieldByName('residencia').AsString);
      ADadosTreinamento[ALinhas, 6] := frmPrincipal.GetVeiculoNumerico(FieldByName('veiculo').AsString);
      AClasseTreinamento[ALinhas] := frmPrincipal.GetPerfilNumerico(FieldByName('perfil').AsString);

      Inc(ALinhas);
      Next;
    end;

    Close;
    Open('select * from pessoas_treinamento where perfil = ''Médio''');
    while not Eof do
    begin
      ADadosTreinamento[ALinhas, 0] := frmPrincipal.GetGeneroNumerico(FieldByName('genero').AsString);
      ADadosTreinamento[ALinhas, 1] := frmPrincipal.GetIdadeNumerico(FieldByName('idade').AsString);
      ADadosTreinamento[ALinhas, 2] := frmPrincipal.GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      ADadosTreinamento[ALinhas, 3] := frmPrincipal.GetDependentesNumerico(FieldByName('dependentes').AsString);
      ADadosTreinamento[ALinhas, 4] := frmPrincipal.GetRendaNumerico(FieldByName('salario').AsString);
      ADadosTreinamento[ALinhas, 5] := frmPrincipal.GetResidenciaNumerico(FieldByName('residencia').AsString);
      ADadosTreinamento[ALinhas, 6] := frmPrincipal.GetVeiculoNumerico(FieldByName('veiculo').AsString);
      AClasseTreinamento[ALinhas] := frmPrincipal.GetPerfilNumerico(FieldByName('perfil').AsString);

      Inc(ALinhas);
      Next;
    end;

    Close;
    Open('select * from pessoas_treinamento where perfil = ''Ruim''');
    while not Eof do
    begin
      ADadosTreinamento[ALinhas, 0] := frmPrincipal.GetGeneroNumerico(FieldByName('genero').AsString);
      ADadosTreinamento[ALinhas, 1] := frmPrincipal.GetIdadeNumerico(FieldByName('idade').AsString);
      ADadosTreinamento[ALinhas, 2] := frmPrincipal.GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      ADadosTreinamento[ALinhas, 3] := frmPrincipal.GetDependentesNumerico(FieldByName('dependentes').AsString);
      ADadosTreinamento[ALinhas, 4] := frmPrincipal.GetRendaNumerico(FieldByName('salario').AsString);
      ADadosTreinamento[ALinhas, 5] := frmPrincipal.GetResidenciaNumerico(FieldByName('residencia').AsString);
      ADadosTreinamento[ALinhas, 6] := frmPrincipal.GetVeiculoNumerico(FieldByName('veiculo').AsString);
      AClasseTreinamento[ALinhas] := frmPrincipal.GetPerfilNumerico(FieldByName('perfil').AsString);

      Inc(ALinhas);
      Next;
    end;

    naivebayes.Train(ADadosTreinamento, AClasseTreinamento, False);
    knn.Train(ADadosTreinamento, AClasseTreinamento, False);

    // Teste
    ADadosTeste := TSLRealBuffer.CreateSize(7);
    Close;
    Open('select * from pessoas_teste');
    while not Eof do
    begin
      ADadosTeste[0] := frmPrincipal.GetGeneroNumerico(FieldByName('genero').AsString);
      ADadosTeste[1] := frmPrincipal.GetIdadeNumerico(FieldByName('idade').AsString);
      ADadosTeste[2] := frmPrincipal.GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      ADadosTeste[3] := frmPrincipal.GetDependentesNumerico(FieldByName('dependentes').AsString);
      ADadosTeste[4] := frmPrincipal.GetRendaNumerico(FieldByName('salario').AsString);
      ADadosTeste[5] := frmPrincipal.GetResidenciaNumerico(FieldByName('residencia').AsString);
      ADadosTeste[6] := frmPrincipal.GetVeiculoNumerico(FieldByName('veiculo').AsString);
      FClasseEsperada := frmPrincipal.GetPerfilNumerico(FieldByName('perfil').AsString);

      naivebayes.Predict(ADadosTeste);
      knn.K := StrToInt(edtK.Text);
      knn.Predict(ADadosTeste);

      Next;
    end;

    TreinarTestarRedeNeural;

    // Naive Bayes
    mmNaiveBayes.Lines.Add('            Bom     Médio    Ruim');
    mmNaiveBayes.Lines.Add('Bom      ' + IntToStr(FNBomBom) + '           ' + IntToStr(FNBomMedio) + '           ' + IntToStr(FNBomRuim));
    mmNaiveBayes.Lines.Add('Médio   ' + IntToStr(FNMedioBom) + '           ' + IntToStr(FNMedioMedio) + '           ' + IntToStr(FNMedioRuim));
    mmNaiveBayes.Lines.Add('Ruim     '  + IntToStr(FNRuimBom) + '           ' + IntToStr(FNRuimMedio) + '           ' + IntToStr(FNRuimRuim));

    mmNaiveBayes.Lines.Add('');
    mmNaiveBayes.Lines.Add('Acertos: ' + FloatToStr(((FNBomBom + FNMedioMedio + FNRuimRuim) / 200) * 100));

    mmNaiveBayes.Lines.Add('Erros: ' + FloatToStr(((FNBomMedio + FNBomRuim +
                                                    FNMedioBom + FNMedioRuim +
                                                    FNRuimBom + FNRuimMedio) / 200) * 100));
    mmNaiveBayes.Lines.Add('Bom: ' + FloatToStr(((FNBomBom / (FNBomBom + FNBomMedio + FNBomRuim)) * 100)));
    mmNaiveBayes.Lines.Add('Médio: ' + FloatToStr(((FNMedioMedio / (FNMedioBom + FNMedioMedio + FNMedioRuim)) * 100)));
    mmNaiveBayes.Lines.Add('Ruim: ' + FloatToStr(((FNRuimRuim / (FNRuimBom + FNRuimMedio + FNRuimRuim)) * 100)));

    // KNN

    mmKNN.Lines.Add('            Bom     Médio    Ruim');
    mmKNN.Lines.Add('Bom      ' + IntToStr(FKBomBom) + '           ' + IntToStr(FKBomMedio) + '           ' + IntToStr(FKBomRuim));
    mmKNN.Lines.Add('Médio   ' + IntToStr(FKMedioBom) + '           ' + IntToStr(FKMedioMedio) + '           ' + IntToStr(FKMedioRuim));
    mmKNN.Lines.Add('Ruim     '  + IntToStr(FKRuimBom) + '           ' + IntToStr(FKRuimMedio) + '           ' + IntToStr(FKRuimRuim));

    mmKNN.Lines.Add('');
    mmKNN.Lines.Add('Acertos: ' + FloatToStr(((FKBomBom + FKMedioMedio + FKRuimRuim) / 200) * 100));

    mmKNN.Lines.Add('Erros: ' + FloatToStr(((FKBomMedio + FKBomRuim +
                                                    FKMedioBom + FKMedioRuim +
                                                    FKRuimBom + FKRuimMedio) / 200) * 100));
    mmKNN.Lines.Add('Bom: ' + FloatToStr(((FKBomBom / (FKBomBom + FKBomMedio + FKBomRuim)) * 100)));
    mmKNN.Lines.Add('Médio: ' + FloatToStr(((FKMedioMedio / (FKMedioBom + FKMedioMedio + FKMedioRuim)) * 100)));
    mmKNN.Lines.Add('Ruim: ' + FloatToStr(((FKRuimRuim / (FKRuimBom + FKRuimMedio + FKRuimRuim)) * 100)));
  finally
    Free;
  end;
end;

procedure TfrmTestesAlgoritmos.knnResult(ASender: TObject;
  AFeatures: ISLRealBuffer; AResult: TILKNearestNeighborResult);
begin
  if (FClasseEsperada = 0) and (AResult.ResultClass = 0) then
    Inc(FKBomBom)
  else if (FClasseEsperada = 0) and (AResult.ResultClass = 0.5) then
    Inc(FKBomMedio)
  else if (FClasseEsperada = 0) and (AResult.ResultClass = 1) then
    Inc(FKBomRuim)
  else if (FClasseEsperada = 0.5) and (AResult.ResultClass = 0) then
    Inc(FKMedioBom)
  else if (FClasseEsperada = 0.5) and (AResult.ResultClass = 0.5) then
    Inc(FKMedioMedio)
  else if (FClasseEsperada = 0.5) and (AResult.ResultClass = 1) then
    Inc(FKMedioRuim)
  else if (FClasseEsperada = 1) and (AResult.ResultClass = 0) then
    Inc(FKRuimBom)
  else if (FClasseEsperada = 1) and (AResult.ResultClass = 0.5) then
    Inc(FKRuimMedio)
  else if (FClasseEsperada = 1) and (AResult.ResultClass = 1) then
    Inc(FKRuimRuim);
end;

procedure TfrmTestesAlgoritmos.naivebayesResult(ASender: TObject;
  AFeatures: ISLRealBuffer; AResult: TILNaiveBayesResult);
begin
  //mmNaiveBayes.Lines.Add(floattostr(fclasseesperada) + ' - ' + floattostr(Aresult.ResultClass));
  if (FClasseEsperada = 0) and (AResult.ResultClass = 0) then
    Inc(FNBomBom)
  else if (FClasseEsperada = 0) and (AResult.ResultClass = 0.5) then
    Inc(FNBomMedio)
  else if (FClasseEsperada = 0) and (AResult.ResultClass = 1) then
    Inc(FNBomRuim)
  else if (FClasseEsperada = 0.5) and (AResult.ResultClass = 0) then
    Inc(FNMedioBom)
  else if (FClasseEsperada = 0.5) and (AResult.ResultClass = 0.5) then
    Inc(FNMedioMedio)
  else if (FClasseEsperada = 0.5) and (AResult.ResultClass = 1) then
    Inc(FNMedioRuim)
  else if (FClasseEsperada = 1) and (AResult.ResultClass = 0) then
    Inc(FNRuimBom)
  else if (FClasseEsperada = 1) and (AResult.ResultClass = 0.5) then
    Inc(FNRuimMedio)
  else if (FClasseEsperada = 1) and (AResult.ResultClass = 1) then
    Inc(FNRuimRuim);
end;

procedure TfrmTestesAlgoritmos.redebackpropagationResult(ASender: TObject;
  AFeatures: ISLRealBuffer; AResult: TILClassifierResult);
begin
  if (FClasseEsperada = 1) and (Round(AResult.Results[0]) = 1) then
    Inc(FRBBomBom)
  else if (FClasseEsperada = 1) and (Round(AResult.Results[0]) = 2) then
    Inc(FRBBomMedio)
  else if (FClasseEsperada = 1) and (Round(AResult.Results[0]) = 3) then
    Inc(FRBBomRuim)
  else if (FClasseEsperada = 2) and (Round(AResult.Results[0]) = 1) then
    Inc(FRBMedioBom)
  else if (FClasseEsperada = 2) and (Round(AResult.Results[0]) = 2) then
    Inc(FRBMedioMedio)
  else if (FClasseEsperada = 2) and (Round(AResult.Results[0]) = 3) then
    Inc(FRBMedioRuim)
  else if (FClasseEsperada = 3) and (Round(AResult.Results[0]) = 1) then
    Inc(FRBRuimBom)
  else if (FClasseEsperada = 3) and (Round(AResult.Results[0]) = 2) then
    Inc(FRBRuimMedio)
  else if (FClasseEsperada = 3) and (Round(AResult.Results[0]) = 3) then
    Inc(FRBRuimRuim);
end;

procedure TfrmTestesAlgoritmos.rederpropResult(ASender: TObject;
  AFeatures: ISLRealBuffer; AResult: TILClassifierResult);
begin
  if (FClasseEsperada = 1) and (Round(AResult.Results[0]) = 1) then
    Inc(FRPBomBom)
  else if (FClasseEsperada = 1) and (Round(AResult.Results[0]) = 2) then
    Inc(FRPBomMedio)
  else if (FClasseEsperada = 1) and (Round(AResult.Results[0]) = 3) then
    Inc(FRPBomRuim)
  else if (FClasseEsperada = 2) and (Round(AResult.Results[0]) = 1) then
    Inc(FRPMedioBom)
  else if (FClasseEsperada = 2) and (Round(AResult.Results[0]) = 2) then
    Inc(FRPMedioMedio)
  else if (FClasseEsperada = 2) and (Round(AResult.Results[0]) = 3) then
    Inc(FRPMedioRuim)
  else if (FClasseEsperada = 3) and (Round(AResult.Results[0]) = 1) then
    Inc(FRPRuimBom)
  else if (FClasseEsperada = 3) and (Round(AResult.Results[0]) = 2) then
    Inc(FRPRuimMedio)
  else if (FClasseEsperada = 3) and (Round(AResult.Results[0]) = 3) then
    Inc(FRPRuimRuim);
end;

procedure TfrmTestesAlgoritmos.TreinarTestarRedeNeural;
var
  ADadosTreinamentoRedeNeural: IILTrainingDataArray;
  APrevisores, ADadosTeste: ISLRealBuffer;
  ARegistro: IILTrainingDataItem;
  APerfil: Real;
begin
  ADadosTreinamentoRedeNeural := TILTrainingDataArray.Create;

  with TFDQuery.Create(Self) do
  try
    Connection := dtmConexao.cnnConexao;
    Open('select * from pessoas_treinamento where perfil = ''Bom''');
    while not Eof do
    begin
      APrevisores := TSLRealBuffer.CreateSize(7);
      APrevisores[0] := frmPrincipal.GetGeneroNumerico(FieldByName('genero').AsString);
      APrevisores[1] := frmPrincipal.GetIdadeNumerico(FieldByName('idade').AsString);
      APrevisores[2] := frmPrincipal.GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      APrevisores[3] := frmPrincipal.GetDependentesNumerico(FieldByName('dependentes').AsString);
      APrevisores[4] := frmPrincipal.GetRendaNumerico(FieldByName('salario').AsString);
      APrevisores[5] := frmPrincipal.GetResidenciaNumerico(FieldByName('residencia').AsString);
      APrevisores[6] := frmPrincipal.GetVeiculoNumerico(FieldByName('veiculo').AsString);
      ARegistro := TILTrainingDataItem.CreateData(APrevisores, 1);
      ADadosTreinamentoRedeNeural.Add(ARegistro);

      Next;
    end;

    Close;
    Open('select * from pessoas_treinamento where perfil = ''Médio''');
    while not Eof do
    begin
      APrevisores := TSLRealBuffer.CreateSize(7);
      APrevisores[0] := frmPrincipal.GetGeneroNumerico(FieldByName('genero').AsString);
      APrevisores[1] := frmPrincipal.GetIdadeNumerico(FieldByName('idade').AsString);
      APrevisores[2] := frmPrincipal.GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      APrevisores[3] := frmPrincipal.GetDependentesNumerico(FieldByName('dependentes').AsString);
      APrevisores[4] := frmPrincipal.GetRendaNumerico(FieldByName('salario').AsString);
      APrevisores[5] := frmPrincipal.GetResidenciaNumerico(FieldByName('residencia').AsString);
      APrevisores[6] := frmPrincipal.GetVeiculoNumerico(FieldByName('veiculo').AsString);
      ARegistro := TILTrainingDataItem.CreateData(APrevisores, 2);
      ADadosTreinamentoRedeNeural.Add(ARegistro);

      Next;
    end;

    Close;
    Open('select * from pessoas_treinamento where perfil = ''Ruim''');
    while not Eof do
    begin
      APrevisores := TSLRealBuffer.CreateSize(7);
      APrevisores[0] := frmPrincipal.GetGeneroNumerico(FieldByName('genero').AsString);
      APrevisores[1] := frmPrincipal.GetIdadeNumerico(FieldByName('idade').AsString);
      APrevisores[2] := frmPrincipal.GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      APrevisores[3] := frmPrincipal.GetDependentesNumerico(FieldByName('dependentes').AsString);
      APrevisores[4] := frmPrincipal.GetRendaNumerico(FieldByName('salario').AsString);
      APrevisores[5] := frmPrincipal.GetResidenciaNumerico(FieldByName('residencia').AsString);
      APrevisores[6] := frmPrincipal.GetVeiculoNumerico(FieldByName('veiculo').AsString);
      ARegistro := TILTrainingDataItem.CreateData(APrevisores, 3);
      ADadosTreinamentoRedeNeural.Add(ARegistro);

      Next;
    end;

    backpropagation.Train(ADadosTreinamentoRedeNeural);
    rprop.Train(ADadosTreinamentoRedeNeural);

    // Teste
    ADadosTeste := TSLRealBuffer.CreateSize(7);
    Close;
    Open('select * from pessoas_teste');
    while not Eof do
    begin
      ADadosTeste[0] := frmPrincipal.GetGeneroNumerico(FieldByName('genero').AsString);
      ADadosTeste[1] := frmPrincipal.GetIdadeNumerico(FieldByName('idade').AsString);
      ADadosTeste[2] := frmPrincipal.GetEstadoCivilNumerico(FieldByName('estado_civil').AsString);
      ADadosTeste[3] := frmPrincipal.GetDependentesNumerico(FieldByName('dependentes').AsString);
      ADadosTeste[4] := frmPrincipal.GetRendaNumerico(FieldByName('salario').AsString);
      ADadosTeste[5] := frmPrincipal.GetResidenciaNumerico(FieldByName('residencia').AsString);
      ADadosTeste[6] := frmPrincipal.GetVeiculoNumerico(FieldByName('veiculo').AsString);

      if frmPrincipal.GetPerfilNumerico(FieldByName('perfil').AsString) = 0 then
        FClasseEsperada := 1
      else if frmPrincipal.GetPerfilNumerico(FieldByName('perfil').AsString) = 0.5 then
        FClasseEsperada := 2
      else
        FClasseEsperada := 3;

      redebackpropagation.Predict(ADadosTeste);
      rederprop.Predict(ADadosTeste);

      Next;
    end;

    // Backpropagation
    mmBackPropagation.Lines.Add('            Bom     Médio    Ruim');
    mmBackPropagation.Lines.Add('Bom      ' + IntToStr(FRBBomBom) + '           ' + IntToStr(FRBBomMedio) + '           ' + IntToStr(FRBBomRuim));
    mmBackPropagation.Lines.Add('Médio   ' + IntToStr(FRBMedioBom) + '           ' + IntToStr(FRBMedioMedio) + '           ' + IntToStr(FRBMedioRuim));
    mmBackPropagation.Lines.Add('Ruim     '  + IntToStr(FRBRuimBom) + '           ' + IntToStr(FRBRuimMedio) + '           ' + IntToStr(FRBRuimRuim));

    mmBackPropagation.Lines.Add('');
    mmBackPropagation.Lines.Add('Acertos: ' + FloatToStr(((FRBBomBom + FRBMedioMedio + FRBRuimRuim) / 200) * 100));

    mmBackPropagation.Lines.Add('Erros: ' + FloatToStr(((FRBBomMedio + FRBBomRuim +
                                                    FRBMedioBom + FRBMedioRuim +
                                                    FRBRuimBom + FRBRuimMedio) / 200) * 100));
    mmBackPropagation.Lines.Add('Bom: ' + FloatToStr(((FRBBomBom / (FRBBomBom + FRBBomMedio + FRBBomRuim)) * 100)));
    mmBackPropagation.Lines.Add('Médio: ' + FloatToStr(((FRBMedioMedio / (FRBMedioBom + FRBMedioMedio + FRBMedioRuim)) * 100)));
    mmBackPropagation.Lines.Add('Ruim: ' + FloatToStr(((FRBRuimRuim / (FRBRuimBom + FRBRuimMedio + FRBRuimRuim)) * 100)));

    // RProp
    mmRprop.Lines.Add('            Bom     Médio    Ruim');
    mmRprop.Lines.Add('Bom      ' + IntToStr(FRPBomBom) + '           ' + IntToStr(FRPBomMedio) + '           ' + IntToStr(FRPBomRuim));
    mmRprop.Lines.Add('Médio   ' + IntToStr(FRPMedioBom) + '           ' + IntToStr(FRPMedioMedio) + '           ' + IntToStr(FRPMedioRuim));
    mmRprop.Lines.Add('Ruim     '  + IntToStr(FRPRuimBom) + '           ' + IntToStr(FRPRuimMedio) + '           ' + IntToStr(FRPRuimRuim));

    mmRprop.Lines.Add('');
    mmRprop.Lines.Add('Acertos: ' + FloatToStr(((FRPBomBom + FRPMedioMedio + FRPRuimRuim) / 200) * 100));

    mmRprop.Lines.Add('Erros: ' + FloatToStr(((FRPBomMedio + FRPBomRuim +
                                                    FRPMedioBom + FRPMedioRuim +
                                                    FRPRuimBom + FRPRuimMedio) / 200) * 100));
    mmRprop.Lines.Add('Bom: ' + FloatToStr(((FRPBomBom / (FRPBomBom + FRPBomMedio + FRPBomRuim)) * 100)));
    mmRprop.Lines.Add('Médio: ' + FloatToStr(((FRPMedioMedio / (FRPMedioBom + FRPMedioMedio + FRPMedioRuim)) * 100)));
    mmRprop.Lines.Add('Ruim: ' + FloatToStr(((FRPRuimRuim / (FRPRuimBom + FRPRuimMedio + FRPRuimRuim)) * 100)));


  finally
    Free;
  end;

end;

end.
