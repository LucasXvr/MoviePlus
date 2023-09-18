unit uSession;

interface

type
  TSession = class
  private
    class var FID_USUARIO: integer;
    class var FId_Filme: Integer;
    class var FEmail: String;
    class var FNome: String;

  public
    class property ID_USUARIO: integer read FID_USUARIO write FID_USUARIO;
    class property Id_Filme: Integer read FId_Filme write FId_Filme;
    class property Nome: String read FNome write FNome;
    class property Email: String read FEmail write FEmail;
  end;

implementation

end.
