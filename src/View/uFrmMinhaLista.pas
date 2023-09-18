unit uFrmMinhaLista;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Ani, FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  FMX.ListBox, uFunctions, uLoading, uSession, System.JSON;

type
  TFrmMinhaLista = class(TForm)
    lytToolBar: TLayout;
    imgVoltar: TImage;
    Image2: TImage;
    rectSwitch: TRectangle;
    lbFilmes: TListBox;
    lblFilmes: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lbFilmesItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure imgVoltarClick(Sender: TObject);
  private
    procedure DownloadFoto(lb: TListBox);
    procedure AddFilme(id_Filme: integer;
                                  nome, url_foto: string);
    procedure ListarFilmes;
    procedure ThreadFilmesTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMinhaLista: TFrmMinhaLista;

implementation

{$R *.fmx}

uses Frame.Principal, uFrmDetalhe, DataModuleUsuario, DataModuleDados,
  uFrmPrincipal;

procedure TFrmMinhaLista.DownloadFoto(lb: TListBox);
var
  t: TThread;
  foto: TBitmap;
  frame: TFramePrincipal;
begin
    // Carregar imagens...
  t := TThread.CreateAnonymousThread(procedure
  var
      i : integer;
  begin
    for i := 0 to lb.Items.Count - 1 do
    begin
      frame := TFramePrincipal(lb.ItemByIndex(i).Components[0]);


      if frame.imgFoto.TagString <> '' then
      begin
          foto := TBitmap.Create;
          LoadImageFromURL(foto, frame.imgFoto.TagString);

          frame.imgFoto.TagString := '';
          frame.imgFoto.Bitmap.Assign(foto);
      end;
    end;
  end);

  t.Start;
end;

procedure TFrmMinhaLista.FormShow(Sender: TObject);
begin
  ListarFilmes;
end;

procedure TFrmMinhaLista.imgVoltarClick(Sender: TObject);
begin
   Close;
end;

procedure TFrmMinhaLista.AddFilme(id_Filme: integer;
                                  nome, url_foto: string);
var
    item: TListBoxItem;
    frame: TFramePrincipal;
begin
    item := TListBoxItem.Create(lbfilmes);

    item.Selectable := false;
    item.Text := '';
    item.Height := 200;
    item.Tag := id_Filme;

    // Frame...
    frame := TFramePrincipal.Create(item);
    frame.lblNome.text := nome;
    frame.imgFoto.TagString := url_foto;

    item.AddObject(frame);

    lbFilmes.AddObject(item);
end;

procedure TFrmMinhaLista.ThreadFilmesTerminate(Sender: TObject);
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

  DownloadFoto(lbFilmes);
end;


procedure TFrmMinhaLista.ListarFilmes;
var
  t: TThread;
begin
  lbFilmes.Items.Clear;

  DmUsuario.BuscarFilmeUsuario;

  t := TThread.CreateAnonymousThread(procedure
  begin
    with DmUsuario.qryFilmes do
    begin
      while not Eof do
      begin
          TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            AddFilme(FieldByName('id_filme').AsInteger,
                     FieldByName('titulo').AsString,
                     FieldByName('url_foto').AsString);
          end);

        Next;
      end;
    end;
  end);

  t.OnTerminate := ThreadFilmesTerminate;
  t.Start;
end;

procedure TFrmMinhaLista.lbFilmesItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  TSession.Id_Filme := item.Tag;

  if not Assigned(FrmDetalhe) then
    Application.CreateForm(TFrmDetalhe, FrmDetalhe);

  FrmDetalhe.Show;
end;

end.
