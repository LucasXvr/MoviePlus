object DmUsuario: TDmUsuario
  OnCreate = DataModuleCreate
  Height = 292
  Width = 410
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    AfterConnect = ConnAfterConnect
    BeforeConnect = ConnBeforeConnect
    Left = 64
    Top = 32
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 184
    Top = 32
  end
  object qryUsuario: TFDQuery
    Connection = Conn
    Left = 64
    Top = 112
  end
  object TabUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 320
    Top = 32
  end
  object qryFilmes: TFDQuery
    Connection = Conn
    Left = 176
    Top = 112
  end
end
