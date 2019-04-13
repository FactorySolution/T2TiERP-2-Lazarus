{ *******************************************************************************
Title: T2Ti ERP
Description: Janela de Requisi��o de Compra

The MIT License

Copyright: Copyright (C) 2015 T2Ti.COM

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

The author may be contacted at:
t2ti.com@gmail.com

@author Albert Eije
@version 2.0
******************************************************************************* }
unit UCompraRequisicao;

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, ShellApi, db, BufDataset, Biblioteca,
  ULookup, VO;

type

  TFCompraRequisicao = class(TFTelaCadastro)
    GroupBoxCompraRequisicaoDetalhe: TGroupBox;
    GridCompraRequisicaoDetalhe: TRxDbGrid;
    CDSCompraRequisicaoDetalhe: TBufDataSet;
    DSCompraRequisicaoDetalhe: TDataSource;
    BevelEdits: TBevel;
    EditIdCompraTipoRequisicao: TLabeledCalcEdit;
    EditIdColaborador: TLabeledCalcEdit;
    EditColaborador: TLabeledEdit;
    EditCompraTipoRequisicao: TLabeledEdit;
    EditDataRequisicao: TLabeledDateEdit;
    ActionToolBar1: TToolPanel;
    ActionManager: TActionList;
    ActionIncluirItem: TAction;
    ActionExcluirItem: TAction;
    ActionAtualizarTotais: TAction;
    procedure FormCreate(Sender: TObject);
    procedure CDSCompraRequisicaoDetalheAfterEdit(DataSet: TDataSet);
    procedure GridCompraRequisicaoDetalheKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdCompraTipoRequisicaoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdColaboradorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActionIncluirItemExecute(Sender: TObject);
    procedure ActionExcluirItemExecute(Sender: TObject);
    procedure BotaoConsultarClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure LimparCampos; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FCompraRequisicao: TFCompraRequisicao;

implementation

uses CompraRequisicaoController, CompraRequisicaoVO, CompraTipoRequisicaoController,
  CompraTipoRequisicaoVO, CompraRequisicaoDetalheVO,
  ViewPessoaColaboradorVO, ViewPessoaColaboradorController, 
  ProdutoVO, ProdutoController, CompraRequisicaoDetalheController;
{$R *.lfm}

{$REGION 'Infra'}
procedure TFCompraRequisicao.BotaoConsultarClick(Sender: TObject);
var
  RetornoConsulta: TZQuery;
  ListaCampos: TStringList;
  i: integer;
begin
  inherited;

  if Sessao.Camadas = 2 then
  begin
    Filtro := MontaFiltro;

    CDSGrid.Close;
    CDSGrid.Open;
    ConfiguraGridFromVO(Grid, ClasseObjetoGridVO);

    ListaCampos  := TStringList.Create;
    RetornoConsulta := TCompraRequisicaoController.Consulta(Filtro, IntToStr(Pagina));
    RetornoConsulta.Active := True;

    RetornoConsulta.GetFieldNames(ListaCampos);

    RetornoConsulta.First;
    while not RetornoConsulta.EOF do begin
      CDSGrid.Append;
      for i := 0 to ListaCampos.Count - 1 do
      begin
        CDSGrid.FieldByName(ListaCampos[i]).Value := RetornoConsulta.FieldByName(ListaCampos[i]).Value;
      end;
      CDSGrid.Post;
      RetornoConsulta.Next;
    end;
  end;
end;

procedure TFCompraRequisicao.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFCompraRequisicao.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TCompraRequisicaoVO;
  ObjetoController := TCompraRequisicaoController.Create;

  inherited;

  // Configura a Grid dos itens
  ConfiguraCDSFromVO(CDSCompraRequisicaoDetalhe, TCompraRequisicaoDetalheVO);
  ConfiguraGridFromVO(GridCompraRequisicaoDetalhe, TCompraRequisicaoDetalheVO);
end;

procedure TFCompraRequisicao.LimparCampos;
begin
  inherited;
  CDSCompraRequisicaoDetalhe.Close;
  CDSCompraRequisicaoDetalhe.Open;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFCompraRequisicao.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditDataRequisicao.SetFocus;
  end;
end;

function TFCompraRequisicao.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditDataRequisicao.SetFocus;
  end;
end;

function TFCompraRequisicao.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TCompraRequisicaoController.Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    BotaoConsultar.Click;
end;

function TFCompraRequisicao.DoSalvar: Boolean;
var
  CompraRequisicaoDetalhe: TCompraRequisicaoDetalheVO;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TCompraRequisicaoVO.Create;

      TCompraRequisicaoVO(ObjetoVO).IdCompraTipoRequisicao := EditIdCompraTipoRequisicao.AsInteger;
      TCompraRequisicaoVO(ObjetoVO).CompraTipoRequisicaoNome := EditCompraTipoRequisicao.Text;
      TCompraRequisicaoVO(ObjetoVO).IdColaborador := EditIdColaborador.AsInteger;
      TCompraRequisicaoVO(ObjetoVO).ColaboradorPessoaNome := EditColaborador.Text;
      TCompraRequisicaoVO(ObjetoVO).DataRequisicao := EditDataRequisicao.Date;

      /// EXERCICIO: Implemente o campo OBSERVACAO

      // Itens da requisi��o
      CDSCompraRequisicaoDetalhe.DisableControls;
      CDSCompraRequisicaoDetalhe.First;
      while not CDSCompraRequisicaoDetalhe.Eof do
      begin
        CompraRequisicaoDetalhe := TCompraRequisicaoDetalheVO.Create;
        CompraRequisicaoDetalhe.Id := CDSCompraRequisicaoDetalhe.FieldByName('ID').AsInteger;
        CompraRequisicaoDetalhe.IdCompraRequisicao := TCompraRequisicaoVO(ObjetoVO).Id;
        CompraRequisicaoDetalhe.IdProduto := CDSCompraRequisicaoDetalhe.FieldByName('ID_PRODUTO').AsInteger;
        //CompraRequisicaoDetalhe.ProdutoNome := CDSCompraRequisicaoDetalheProdutoNome.AsString;
        CompraRequisicaoDetalhe.Quantidade := CDSCompraRequisicaoDetalhe.FieldByName('QUANTIDADE').AsFloat;
        CompraRequisicaoDetalhe.QuantidadeCotada := CDSCompraRequisicaoDetalhe.FieldByName('QUANTIDADE_COTADA').AsFloat;
        CompraRequisicaoDetalhe.ItemCotado := CDSCompraRequisicaoDetalhe.FieldByName('ITEM_COTADO').AsString;
        TCompraRequisicaoVO(ObjetoVO).ListaCompraRequisicaoDetalheVO.Add(CompraRequisicaoDetalhe);
        CDSCompraRequisicaoDetalhe.Next;
      end;
      CDSCompraRequisicaoDetalhe.First;
      CDSCompraRequisicaoDetalhe.EnableControls;

      if StatusTela = stInserindo then
      begin
        TCompraRequisicaoController.Insere(TCompraRequisicaoVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        /// EXERCICIO: Verifique se tem como serializar as listas junto com o objeto para realizar a compara��o
        //if TCompraRequisicaoVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        //begin
          TCompraRequisicaoController.Altera(TCompraRequisicaoVO(ObjetoVO));
        //end
        //else
        //Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFCompraRequisicao.GridCompraRequisicaoDetalheKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    ActionIncluirItem.Execute;
  end;
  If Key = VK_RETURN then
    EditDataRequisicao.SetFocus;
end;

procedure TFCompraRequisicao.GridParaEdits;
var
  IdCabecalho: String;
  I: Integer;
  Current: TCompraRequisicaoDetalheVO;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TCompraRequisicaoController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdCompraTipoRequisicao.AsInteger := TCompraRequisicaoVO(ObjetoVO).IdCompraTipoRequisicao;
    EditCompraTipoRequisicao.Text := TCompraRequisicaoVO(ObjetoVO).CompraTipoRequisicaoVO.Nome;
    EditIdColaborador.AsInteger := TCompraRequisicaoVO(ObjetoVO).IdColaborador;
    EditColaborador.Text := TCompraRequisicaoVO(ObjetoVO).ColaboradorVO.Nome;
    EditDataRequisicao.Date := TCompraRequisicaoVO(ObjetoVO).DataRequisicao;

    // Itens da Requisi��o
    for I := 0 to TCompraRequisicaoVO(ObjetoVO).ListaCompraRequisicaoDetalheVO.Count - 1 do
    begin
      Current := TCompraRequisicaoVO(ObjetoVO).ListaCompraRequisicaoDetalheVO[I];

      CDSCompraRequisicaoDetalhe.Append;

      CDSCompraRequisicaoDetalhe.FieldByName('ID').AsInteger := Current.Id;
      CDSCompraRequisicaoDetalhe.FieldByName('ID_PRODUTO').AsInteger := Current.IdProduto;
      //CDSCompraRequisicaoDetalhe.FieldByName('ProdutoNome.AsString := Current.ProdutoVO.Nome;
      CDSCompraRequisicaoDetalhe.FieldByName('QUANTIDADE').AsFloat := Current.Quantidade;
      CDSCompraRequisicaoDetalhe.FieldByName('QUANTIDADE_COTADA').AsFloat := Current.QuantidadeCotada;
      CDSCompraRequisicaoDetalhe.FieldByName('ITEM_COTADO').AsString := Current.ItemCotado;
      CDSCompraRequisicaoDetalhe.FieldByName('ID_COMPRA_REQUISICAO').AsInteger := Current.IdCompraRequisicao;

      CDSCompraRequisicaoDetalhe.Post;
    end;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;

procedure TFCompraRequisicao.CDSCompraRequisicaoDetalheAfterEdit(DataSet: TDataSet);
begin
  if CDSCompraRequisicaoDetalhe.FieldByName('ITEM_COTADO').AsString = 'S' then
  begin
    Application.MessageBox('N�o � poss�vel alterar esse item. Item j� foi cotado.', 'Informa��o do sistema', MB_OK + MB_ICONINFORMATION);
    CDSCompraRequisicaoDetalhe.Cancel;
  end;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
/// EXERCICIO: Implemente a busca usando o FLookup
procedure TFCompraRequisicao.EditIdCompraTipoRequisicaoKeyUp(Sender: TObject;  var Key: Word; Shift: TShiftState);
var
  CompraTipoRequisicaoVO :TCompraTipoRequisicaoVO ;
begin
  if Key = VK_F1 then
  begin
    if EditIdCompraTipoRequisicao.Value <> 0 then
      Filtro := 'ID = ' + EditIdCompraTipoRequisicao.Text
    else
      Filtro := 'ID=0';

    try
      EditCompraTipoRequisicao.Clear;

      CompraTipoRequisicaoVO := TCompraTipoRequisicaoController.ConsultaObjeto(Filtro);
      if Assigned(CompraTipoRequisicaoVO) then
      begin
        EditCompraTipoRequisicao.Text := CompraTipoRequisicaoVO.Nome;
      end
      else
      begin
        Exit;
      end;
    finally
      EditIdColaborador.SetFocus;
    end;
  end;
end;

procedure TFCompraRequisicao.EditIdColaboradorKeyUp(Sender: TObject;  var Key: Word; Shift: TShiftState);
var
  ViewPessoaColaboradorVO :TViewPessoaColaboradorVO ;
begin
  if Key = VK_F1 then
  begin
    if EditIdColaborador.Value <> 0 then
      Filtro := 'ID = ' + EditIdColaborador.Text
    else
      Filtro := 'ID=0';

    try
      EditColaborador.Clear;

      ViewPessoaColaboradorVO := TViewPessoaColaboradorController.ConsultaObjeto(Filtro);
      if Assigned(ViewPessoaColaboradorVO) then
      begin
        EditColaborador.Text := ViewPessoaColaboradorVO.Nome;
      end
      else
      begin
        Exit;
      end;
    finally
      EditDataRequisicao.SetFocus;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Actions'}
procedure TFCompraRequisicao.ActionExcluirItemExecute(Sender: TObject);
begin
  if CDSCompraRequisicaoDetalhe.IsEmpty then
    Application.MessageBox('N�o existe registro selecionado.', 'Erro', MB_OK + MB_ICONERROR)
  else
  begin
    if Application.MessageBox('Deseja realmente excluir o registro selecionado?', 'Pergunta do sistema', MB_YESNO + MB_ICONQUESTION) = IDYES then
    begin
      if StatusTela = stInserindo then
        CDSCompraRequisicaoDetalhe.Delete
      else if StatusTela = stEditando then
      begin
        if TCompraRequisicaoDetalheController.Exclui(CDSCompraRequisicaoDetalhe.FieldByName('ID').AsInteger) then
          CDSCompraRequisicaoDetalhe.Delete;
      end;
    end;
  end;
end;

procedure TFCompraRequisicao.ActionIncluirItemExecute(Sender: TObject);
begin
  /// EXERCICIO: Implemente a busca usando o FLookup
    begin
      CDSCompraRequisicaoDetalhe.Append;
      CDSCompraRequisicaoDetalhe.FieldByName('ID_PRODUTO').AsInteger := 1;//CDSTransiente.FieldByName('ID').AsInteger;
      //CDSCompraRequisicaoDetalhe.FieldByName('PRODUTO.NOME').AsString := 'PRODUTO TESTE';//CDSTransiente.FieldByName('NOME').AsString;
    end;
end;
{$ENDREGION}

end.

