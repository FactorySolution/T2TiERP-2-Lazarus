{ *******************************************************************************
Title: T2Ti ERP
Description: Janela de Romaneio de Entrega

The MIT License

Copyright: Copyright (C) 2016 T2Ti.COM

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
unit UVendaRomaneioEntrega;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO;

  type

  { TFVendaRomaneioEntrega }

  TFVendaRomaneioEntrega = class(TFTelaCadastro)
    CDSVenda: TBufDataset;
    DSVenda: TDataSource;
    GroupBoxParcelas: TGroupBox;
    GridParcelas: TRxDbGrid;
    ScrollBox1: TScrollBox;
    EditDescricao: TLabeledEdit;
    MemoObservacao: TLabeledMemo;
    EditEntregador: TLabeledEdit;
    ComboBoxSituacao: TLabeledComboBox;
    EditDataEmissao: TLabeledDateEdit;
    EditDataPrevista: TLabeledDateEdit;
    EditDataSaida: TLabeledDateEdit;
    EditIdEntregador: TLabeledCalcEdit;
    ActionManager1: TActionList;
    ActionAdicionarVenda: TAction;
    ActionToolBar1: TToolPanel;
    EditDataEncerramento: TLabeledDateEdit;
    Bevel1: TBevel;
    ActionRemoverVenda: TAction;
    procedure FormCreate(Sender: TObject);
    procedure GridParcelasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActionAdicionarVendaExecute(Sender: TObject);
    procedure ActionRemoverVendaExecute(Sender: TObject);
    procedure EditIdEntregadorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
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
  FVendaRomaneioEntrega: TFVendaRomaneioEntrega;

implementation

uses VendaRomaneioEntregaVO, VendaRomaneioEntregaController, VendaCabecalhoVO,
  VendaCabecalhoController, UDataModule, ViewPessoaColaboradorVO,
  ViewPessoaColaboradorController;
{$R *.lfm}

{$REGION 'Infra'}
procedure TFVendaRomaneioEntrega.BotaoConsultarClick(Sender: TObject);
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
    RetornoConsulta := TVendaRomaneioEntregaController.Consulta(Filtro, IntToStr(Pagina));
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

procedure TFVendaRomaneioEntrega.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFVendaRomaneioEntrega.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TVendaRomaneioEntregaVO;
  ObjetoController := TVendaRomaneioEntregaController.Create;

  inherited;

  ConfiguraCDSFromVO(CDSVenda, TVendaCabecalhoVO);

  BotaoImprimir.Visible := False;
  MenuImprimir.Visible := False;
end;

procedure TFVendaRomaneioEntrega.LimparCampos;
begin
  inherited;
  CDSVenda.Close;
  CDSVenda.Open;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFVendaRomaneioEntrega.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdEntregador.SetFocus;
  end;
end;

function TFVendaRomaneioEntrega.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditIdEntregador.SetFocus;
  end;
end;

function TFVendaRomaneioEntrega.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TVendaRomaneioEntregaController.Exclui(IdRegistroSelecionado);
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

function TFVendaRomaneioEntrega.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TVendaRomaneioEntregaVO.Create;

      TVendaRomaneioEntregaVO(ObjetoVO).IdColaborador := EditIdEntregador.AsInteger;
      TVendaRomaneioEntregaVO(ObjetoVO).ColaboradorPessoaNome := EditEntregador.Text;
      TVendaRomaneioEntregaVO(ObjetoVO).Descricao := EditDescricao.Text;
      TVendaRomaneioEntregaVO(ObjetoVO).DataEmissao := EditDataEmissao.Date;
      TVendaRomaneioEntregaVO(ObjetoVO).DataPrevista := EditDataPrevista.Date;
      TVendaRomaneioEntregaVO(ObjetoVO).DataSaida := EditDataSaida.Date;
      TVendaRomaneioEntregaVO(ObjetoVO).DataEncerramento := EditDataEncerramento.Date;
      TVendaRomaneioEntregaVO(ObjetoVO).Situacao := Copy(ComboBoxSituacao.Text, 1, 1);
      TVendaRomaneioEntregaVO(ObjetoVO).Observacao := MemoObservacao.Text;

      if StatusTela = stEditando then
        TVendaRomaneioEntregaVO(ObjetoVO).Id := IdRegistroSelecionado;

      // Vendas vinculadas
      CDSVenda.DisableControls;
      CDSVenda.First;
      TVendaRomaneioEntregaVO(ObjetoVO).VendasVinculadas := '';
      while not CDSVenda.Eof do
      begin
        TVendaRomaneioEntregaVO(ObjetoVO).VendasVinculadas := TVendaRomaneioEntregaVO(ObjetoVO).VendasVinculadas + '|' + CDSVenda.FieldByName('ID').AsString;
        CDSVenda.Next;
      end;
      CDSVenda.EnableControls;

      if StatusTela = stInserindo then
      begin
        TVendaRomaneioEntregaController.Insere(TVendaRomaneioEntregaVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        if TVendaRomaneioEntregaVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TVendaRomaneioEntregaController.Altera(TVendaRomaneioEntregaVO(ObjetoVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFVendaRomaneioEntrega.GridParaEdits;
var
  IdCabecalho: String;
  RetornoConsulta: TZQuery;
  ListaCampos: TStringList;
  I: Integer;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TVendaRomaneioEntregaController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdEntregador.AsInteger := TVendaRomaneioEntregaVO(ObjetoVO).IdColaborador;
    EditEntregador.Text := TVendaRomaneioEntregaVO(ObjetoVO).ColaboradorPessoaNome;
    EditDescricao.Text := TVendaRomaneioEntregaVO(ObjetoVO).Descricao;
    EditDataEmissao.Date := TVendaRomaneioEntregaVO(ObjetoVO).DataEmissao;
    EditDataPrevista.Date := TVendaRomaneioEntregaVO(ObjetoVO).DataPrevista;
    EditDataSaida.Date := TVendaRomaneioEntregaVO(ObjetoVO).DataSaida;
    EditDataEncerramento.Date := TVendaRomaneioEntregaVO(ObjetoVO).DataEncerramento;
    ComboBoxSituacao.ItemIndex := AnsiIndexStr(TVendaRomaneioEntregaVO(ObjetoVO).Situacao, ['A', 'T', 'E']);
    MemoObservacao.Text := TVendaRomaneioEntregaVO(ObjetoVO).Observacao;

    // Vendas Vinculadas
    Filtro := 'ID_VENDA_ROMANEIO_ENTREGA=' + CDSGrid.FieldByName('ID').AsString;

    ListaCampos  := TStringList.Create;
    RetornoConsulta := TVendaCabecalhoController.Consulta(Filtro, '0');
    RetornoConsulta.Active := True;

    RetornoConsulta.GetFieldNames(ListaCampos);

    RetornoConsulta.First;
    while not RetornoConsulta.EOF do begin
      CDSVenda.Append;
      for i := 0 to ListaCampos.Count - 1 do
      begin
        CDSVenda.FieldByName(ListaCampos[i]).Value := RetornoConsulta.FieldByName(ListaCampos[i]).Value;
      end;
      CDSVenda.Post;
      RetornoConsulta.Next;
    end;

    // Serializa o objeto para consultar posteriormente se houve alterações
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;

procedure TFVendaRomaneioEntrega.GridParcelasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Filtro: String;
begin
  if Key = VK_F1 then
  begin
    ActionAdicionarVenda.Execute;
  end;
  If Key = VK_RETURN then
    EditIdEntregador.SetFocus;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
// Vendedor
procedure TFVendaRomaneioEntrega.EditIdEntregadorKeyUp(Sender: TObject;  var Key: Word; Shift: TShiftState);
var
  Filtro: String;
  ViewPessoaColaboradorVO :TViewPessoaColaboradorVO ;
begin
  if Key = VK_F1 then
  begin
    if EditIdEntregador.Value <> 0 then
      Filtro := 'ID = ' + EditIdEntregador.Text
    else
      Filtro := 'ID=0';

    try
      EditEntregador.Clear;

        ViewPessoaColaboradorVO := TViewPessoaColaboradorController.ConsultaObjeto(Filtro);
        if Assigned(ViewPessoaColaboradorVO) then
      begin
        EditEntregador.Text := ViewPessoaColaboradorVO.Nome;
      end
      else
      begin
        Exit;
      end;
    finally
      EditDescricao.SetFocus;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Actions'}
procedure TFVendaRomaneioEntrega.ActionAdicionarVendaExecute(Sender: TObject);
begin
  (*

  /// EXERCICIO: use a janela FLookup
  try
    if Assigned(ViewPessoaColaboradorVO) then
    begin
      CDSVenda.Append;
      CDSVenda.FieldByName('ID').AsInteger := CDSTransiente.FieldByName('ID').AsInteger;
      CDSVenda.FieldByName('DATA_VENDA.Value := CDSTransiente.FieldByName('DATA_VENDA').Value;
      CDSVenda.FieldByName('CLIENTENOME').AsString := CDSTransiente.FieldByName('CLIENTE.NOME').AsString;
      CDSVenda.FieldByName('VALOR_TOTAL').AsFloat := CDSTransiente.FieldByName('VALOR_TOTAL').AsFloat;
      CDSVenda.Post;
    end;
  finally
  end;
  *)
end;

procedure TFVendaRomaneioEntrega.ActionRemoverVendaExecute(Sender: TObject);
var
  RetornoConsulta: TZQuery;
  ListaCampos: TStringList;
  I: Integer;
begin
  TVendaRomaneioEntregaController.ExcluiVendaVinculada(CDSVenda.FieldByName('ID').AsInteger);

  // Vendas Vinculadas
  Filtro := 'ID_VENDA_ROMANEIO_ENTREGA=' + CDSGrid.FieldByName('ID').AsString;

  ListaCampos  := TStringList.Create;
  RetornoConsulta := TVendaCabecalhoController.Consulta(Filtro, '0');
  RetornoConsulta.Active := True;

  RetornoConsulta.GetFieldNames(ListaCampos);

  RetornoConsulta.First;
  while not RetornoConsulta.EOF do begin
    CDSVenda.Append;
    for i := 0 to ListaCampos.Count - 1 do
    begin
      CDSVenda.FieldByName(ListaCampos[i]).Value := RetornoConsulta.FieldByName(ListaCampos[i]).Value;
    end;
    CDSVenda.Post;
    RetornoConsulta.Next;
  end;
end;
{$ENDREGION}

end.

