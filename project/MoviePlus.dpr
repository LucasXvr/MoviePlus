program MoviePlus;

uses
  System.StartUpCopy,
  FMX.Forms,
  uFrmLogin in '..\src\View\uFrmLogin.pas' {FrmLogin},
  uFrmCadastro in '..\src\View\uFrmCadastro.pas' {FrmCadastro},
  uFrmPrincipal in '..\src\View\uFrmPrincipal.pas' {FrmPrincipal},
  Frame.Principal in '..\src\Frame\Frame.Principal.pas' {FramePrincipal: TFrame},
  uFrmMinhaLista in '..\src\View\uFrmMinhaLista.pas' {FrmMinhaLista},
  uFunctions in '..\src\Units\uFunctions.pas',
  uLoading in '..\src\Units\uLoading.pas',
  uFrmDetalhe in '..\src\View\uFrmDetalhe.pas' {FrmDetalhe},
  DataModuleDados in '..\src\Controller\DataModuleDados.pas' {DmDados: TDataModule},
  uConsts in '..\src\Units\uConsts.pas',
  DataModuleUsuario in '..\src\Controller\DataModuleUsuario.pas' {DmUsuario: TDataModule},
  uSession in '..\src\Units\uSession.pas',
  uFrmMeuPerfil in '..\src\View\uFrmMeuPerfil.pas' {FrmMeuPerfil};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDmUsuario, DmUsuario);
  Application.CreateForm(TDmDados, DmDados);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
