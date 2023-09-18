unit uFrmMeuPerfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, uLoading, uSession;

type
  TFrmMeuPerfil = class(TForm)
    lytToolBar: TLayout;
    imgVoltar: TImage;
    Label1: TLabel;
    Image1: TImage;
    lytMeuPerfil: TLayout;
    rectNome: TRectangle;
    edtNome: TEdit;
    rectEmail: TRectangle;
    edtEmail: TEdit;
    rectAcessar: TRectangle;
    btnEditarPerfil: TSpeedButton;
    rectSenha: TRectangle;
    edtSenha: TEdit;
    StyleBook: TStyleBook;
    procedure imgVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditarPerfilClick(Sender: TObject);
  private
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure ThreadEditarTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMeuPerfil: TFrmMeuPerfil;

implementation

{$R *.fmx}

uses DataModuleUsuario, uFrmPrincipal;

procedure TFrmMeuPerfil.ThreadDadosTerminate(Sender: TObject);
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
end;

procedure TFrmMeuPerfil.ThreadEditarTerminate(Sender: TObject);
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

  Close;
end;

procedure TFrmMeuPerfil.btnEditarPerfilClick(Sender: TObject);
var
  t: TThread;
begin
  TLoading.Show(FrmMeuPerfil, '');

  t := TThread.CreateAnonymousThread(procedure
  begin
    DmUsuario.EditarUsuario(TSession.ID_USUARIO, edtNome.Text, edtEmail.Text, edtSenha.Text);

    TSession.Nome := edtNome.Text;
    TSession.Email := edtEmail.Text;

    FrmPrincipal.lblMenuNome.Text := edtNome.Text;
    FrmPrincipal.lblMenuEmail.Text := edtEmail.Text;
  end);

  t.OnTerminate := ThreadEditarTerminate;
  t.Start;
end;

procedure TFrmMeuPerfil.CarregarDados;
var
  t: TThread;
begin
  TLoading.Show(FrmMeuPerfil, '');

  t := TThread.CreateAnonymousThread(procedure
  begin
    //Buscar dados do produto...

    TThread.Synchronize(TThread.CurrentThread, procedure
    begin
      edtNome.Text := TSession.Nome;
      edtEmail.Text := TSession.Email;
      edtSenha.Text := '';
    end);

  end);

  t.OnTerminate := ThreadDadosTerminate;
  t.Start;
end;

procedure TFrmMeuPerfil.FormShow(Sender: TObject);
begin
  CarregarDados;
end;

procedure TFrmMeuPerfil.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
