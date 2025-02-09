object DataModule1: TDataModule1
  Height = 480
  Width = 640
  object cnnConection: TFDConnection
    Params.Strings = (
      'Database=sales'
      'User_Name=root'
      'Password=GFpl301004@#$%'
      'Server=localhost'
      'DriverID=MySQL')
    Connected = True
    LoginPrompt = False
    Left = 56
    Top = 72
  end
  object driver: TFDPhysMySQLDriverLink
    VendorLib = 
      'D:\Inteligencia-Artificial-com-Delphi-e-Intelligence-Lab\DelphiA' +
      'pplication\LIBMYSQL.DLL'
    Left = 136
    Top = 72
  end
  object queryPreProcessedData: TFDQuery
    Active = True
    Connection = cnnConection
    SQL.Strings = (
      'SELECT * FROM pre_processed_data;')
    Left = 56
    Top = 160
    object queryPreProcessedDataGender: TStringField
      FieldName = 'Gender'
      Size = 10
    end
    object queryPreProcessedDataAge: TStringField
      FieldName = 'Age'
      Size = 10
    end
    object queryPreProcessedDataMarital_Status: TStringField
      FieldName = 'Marital_Status'
      Size = 10
    end
    object queryPreProcessedDataDependents: TStringField
      FieldName = 'Dependents'
      Size = 10
    end
    object queryPreProcessedDataIncome: TStringField
      FieldName = 'Income'
      Size = 10
    end
    object queryPreProcessedDataResidence_Type: TStringField
      FieldName = 'Residence_Type'
      Size = 10
    end
    object queryPreProcessedDataVehicle: TStringField
      FieldName = 'Vehicle'
      Size = 10
    end
    object queryPreProcessedDataClient_Profile: TStringField
      FieldName = 'Client_Profile'
      Size = 10
    end
  end
end
