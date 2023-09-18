unit uFrmCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns, uLoading,
  uSession;

type
  TFrmCadastro = class(TForm)
    imgLogo: TImage;
    lblCadastrar: TLabel;
    lytLogin: TLayout;
    rectNome: TRectangle;
    edtNome: TEdit;
    rectEmail: TRectangle;
    edtEmail: TEdit;
    Label1: TLabel;
    rectAcessar: TRectangle;
    btnCriarConta: TSpeedButton;
    StyleBook: TStyleBook;
    rectSenha: TRectangle;
    edtSenha: TEdit;
    procedure btnCriarContaClick(Sender: TObject);
    procedure lblCadastrarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ThreadLoginTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCadastro: TFrmCadastro;

implementation

{$R *.fmx}

uses DataModuleUsuario, uFrmPrincipal, uFrmLogin;

procedure TFrmCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmCadastro := nil;
end;

procedure TFrmCadastro.lblCadastrarClick(Sender: TObject);
begin
  if not Assigned(FrmLogin) then
    Application.CreateForm(TFrmLogin, FrmLogin);

  FrmLogin.Show;
end;

procedure TFrmCadastro.ThreadLoginTerminate(Sender: TObject);
begin
  TLoading.Hide;

  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
      ShowMessage(Exception(TThread(sender).FatalException).Message);
      Exit;
    end;
  end;

  if DmUsuario.QryUsuario.RecordCount > 0 then
  begin
    if not Assigned(FrmPrincipal) then
      Application.CreateForm(TFrmPrincipal, FrmPrincipal);


    Application.MainForm := FrmPrincipal;
    FrmPrincipal.lblMenuNome.Text := edtNome.Text;
    FrmPrincipal.lblMenuEmail.Text := edtEmail.Text;
    TSession.Nome := edtNome.Text;
    TSession.Email := edtEmail.Text;
    FrmPrincipal.Show;
  end;
end;

procedure TFrmCadastro.btnCriarContaClick(Sender: TObject);
var
  t: TThread;

begin
  TLoading.Show(FrmCadastro, 'Criando Conta...');

  t := TThread.CreateAnonymousThread(procedure
  begin
    DmUsuario.InserirUsuario(edtEmail.Text,
                             edtNome.Text,
                             edtSenha.Text);
  end);

  t.OnTerminate := ThreadLoginTerminate;
  t.Start;
end;

end.
