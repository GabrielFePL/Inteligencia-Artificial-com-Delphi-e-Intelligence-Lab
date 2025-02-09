object dtmConexao: TdtmConexao
  OldCreateOrder = False
  Height = 207
  Width = 359
  object cnnConexao: TFDConnection
    Params.Strings = (
      'Database=vendas'
      'User_Name=root'
      'Password=123456'
      'Server=localhost'
      'DriverID=MySQL')
    Connected = True
    LoginPrompt = False
    Left = 80
    Top = 24
  end
  object driver: TFDPhysMySQLDriverLink
    VendorLib = 'E:\Ensino\IA Expert\Curso Intelligence Lab\Projeto\libmysql.dll'
    Left = 184
    Top = 24
  end
  object qryPessoas: TFDQuery
    Active = True
    Connection = cnnConexao
    SQL.Strings = (
      'select * from pessoas_classificacao')
    Left = 80
    Top = 88
    object qryPessoasgenero: TStringField
      FieldName = 'genero'
      FixedChar = True
      Size = 1
    end
    object qryPessoasidade: TStringField
      FieldName = 'idade'
      FixedChar = True
      Size = 5
    end
    object qryPessoasestado_civil: TStringField
      FieldName = 'estado_civil'
      FixedChar = True
      Size = 10
    end
    object qryPessoasdependentes: TStringField
      FieldName = 'dependentes'
      FixedChar = True
      Size = 3
    end
    object qryPessoassalario: TStringField
      FieldName = 'salario'
      FixedChar = True
      Size = 10
    end
    object qryPessoasresidencia: TStringField
      FieldName = 'residencia'
      FixedChar = True
      Size = 8
    end
    object qryPessoasveiculo: TStringField
      FieldName = 'veiculo'
      FixedChar = True
      Size = 3
    end
    object qryPessoasperfil: TStringField
      FieldName = 'perfil'
      FixedChar = True
      Size = 5
    end
  end
end
