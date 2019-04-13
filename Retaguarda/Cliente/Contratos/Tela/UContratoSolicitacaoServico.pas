{ *******************************************************************************
Title: T2Ti ERP
Description: Janela de Solicita��o de Servi�os - Gest�o de Contratos

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

@author Albert Eije (alberteije@gmail.com)
@version 2.0
******************************************************************************* }
unit UContratoSolicitacaoServico;

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, ShellApi, db, BufDataset, Biblioteca,
  ULookup, VO;

  type

  TFContratoSolicitacaoServico = class(TFTelaCadastro)
    BevelEdits: TBevel;
    ComboBoxUrgente: TLabeledComboBox;
    EditIdCliente: TLabeledCalcEdit;
    EditCliente: TLabeledEdit;
    EditIdFornecedor: TLabeledCalcEdit;
    EditFornecedor: TLabeledEdit;
    EditIdSetor: TLabeledCalcEdit;
    EditSetor: TLabeledEdit;
    EditColaborador: TLabeledEdit;
    EditIdColaborador: TLabeledCalcEdit;
    EditTipoServico: TLabeledEdit;
    EditIdTipoServico: TLabeledCalcEdit;
    EditDataSolicitacao: TLabeledDateEdit;
    EditDataDesejadaInicio: TLabeledDateEdit;
    ComboBoxStatusSolicitacao: TLabeledComboBox;
    RadioGroupTipoContratacao: TRadioGroup;
    EditDescricao: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroupTipoContratacaoClick(Sender: TObject);
    procedure EditIdColaboradorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdSetorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdTipoServicoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdFornecedorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdClienteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BotaoConsultarClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FContratoSolicitacaoServico: TFContratoSolicitacaoServico;

implementation

uses ContratoSolicitacaoServicoController, ContratoSolicitacaoServicoVO,
   SetorVO, SetorController, ContratoTipoServicoVO, ContratoTipoServicoController,
  ViewPessoaColaboradorVO, ViewPessoaColaboradorController,
  ViewPessoaFornecedorVO, ViewPessoaFornecedorController,
  ViewPessoaClienteVO, ViewPessoaClienteController;
{$R *.lfm}

{$REGION 'Infra'}
procedure TFContratoSolicitacaoServico.BotaoConsultarClick(Sender: TObject);
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
    RetornoConsulta := TContratoSolicitacaoServicoController.Consulta(Filtro, IntToStr(Pagina));
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

procedure TFContratoSolicitacaoServico.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFContratoSolicitacaoServico.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TContratoSolicitacaoServicoVO;
  ObjetoController := TContratoSolicitacaoServicoController.Create;

  inherited;
  BotaoImprimir.Visible := False;
  MenuImprimir.Visible := False;
end;

procedure TFContratoSolicitacaoServico.RadioGroupTipoContratacaoClick(Sender: TObject);
begin
  if RadioGroupTipoContratacao.ItemIndex = 0 then
  begin
    EditIdCliente.Visible := True;
    EditCliente.Visible := True;
    EditIdFornecedor.Visible := False;
    EditFornecedor.Visible := False;
    EditIdFornecedor.Clear;
    EditFornecedor.Clear;
    EditIdCliente.SetFocus;
  end
  else
  begin
    EditIdCliente.Visible := False;
    EditCliente.Visible := False;
    EditIdCliente.Clear;
    EditCliente.Clear;
    EditIdFornecedor.Visible := True;
    EditFornecedor.Visible := True;
    EditIdFornecedor.SetFocus;
  end;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFContratoSolicitacaoServico.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdSetor.SetFocus;
  end;
end;

function TFContratoSolicitacaoServico.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditIdSetor.SetFocus;
  end;
end;

function TFContratoSolicitacaoServico.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TContratoSolicitacaoServicoController.Exclui(IdRegistroSelecionado);
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

function TFContratoSolicitacaoServico.DoSalvar: Boolean;
begin
  if RadioGroupTipoContratacao.ItemIndex = -1 then
  begin
    Application.MessageBox('� necess�rio informar o tipo de contrata��o.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    Exit(False);
  end
  else if RadioGroupTipoContratacao.ItemIndex = 0 then
  begin
    if EditIdCliente.AsInteger = 0 then
    begin
      Application.MessageBox('� necess�rio informar o cliente.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      EditIdCliente.SetFocus;
      Exit(False);
    end;
  end
  else if RadioGroupTipoContratacao.ItemIndex = 1 then
  begin
    if EditIdFornecedor.AsInteger = 0 then
    begin
      Application.MessageBox('� necess�rio informar o fornecedor.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      EditIdFornecedor.SetFocus;
      Exit(False);
    end;
  end;

  if EditIdSetor.AsInteger = 0 then
  begin
    Application.MessageBox('� necess�rio informar o setor.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    EditIdSetor.SetFocus;
    Exit(False);
  end;
  if EditIdColaborador.AsInteger = 0 then
  begin
    Application.MessageBox('� necess�rio informar o colaborador.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    EditIdColaborador.SetFocus;
    Exit(False);
  end;
  if EditIdTipoServico.AsInteger = 0 then
  begin
    Application.MessageBox('� necess�rio informar o tipo do servi�o.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    EditIdTipoServico.SetFocus;
    Exit(False);
  end;

  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TContratoSolicitacaoServicoVO.Create;

      TContratoSolicitacaoServicoVO(ObjetoVO).IdCliente := EditIdCliente.AsInteger;
      TContratoSolicitacaoServicoVO(ObjetoVO).ClientePessoaNome := EditCliente.Text;
      TContratoSolicitacaoServicoVO(ObjetoVO).IdFornecedor := EditIdFornecedor.AsInteger;
      TContratoSolicitacaoServicoVO(ObjetoVO).FornecedorPessoaNome := EditFornecedor.Text;
      TContratoSolicitacaoServicoVO(ObjetoVO).IdSetor := EditIdSetor.AsInteger;
      TContratoSolicitacaoServicoVO(ObjetoVO).SetorNome := EditSetor.Text;
      TContratoSolicitacaoServicoVO(ObjetoVO).IdColaborador := EditIdColaborador.AsInteger;
      TContratoSolicitacaoServicoVO(ObjetoVO).ColaboradorPessoaNome := EditColaborador.Text;
      TContratoSolicitacaoServicoVO(ObjetoVO).IdContratoTipoServico := EditIdTipoServico.AsInteger;
      TContratoSolicitacaoServicoVO(ObjetoVO).ContratoTipoServicoNome := EditTipoServico.Text;
      TContratoSolicitacaoServicoVO(ObjetoVO).Descricao := EditDescricao.Text;
      TContratoSolicitacaoServicoVO(ObjetoVO).DataSolicitacao := EditDataSolicitacao.Date;
      TContratoSolicitacaoServicoVO(ObjetoVO).DataDesejadaInicio := EditDataDesejadaInicio.Date;
      TContratoSolicitacaoServicoVO(ObjetoVO).Urgente := IfThen(ComboBoxUrgente.ItemIndex = 0, 'S', 'N');
      TContratoSolicitacaoServicoVO(ObjetoVO).StatusSolicitacao := Copy(ComboBoxStatusSolicitacao.Text, 1, 1);

      if StatusTela = stInserindo then
      begin
        TContratoSolicitacaoServicoController.Insere(TContratoSolicitacaoServicoVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
          TContratoSolicitacaoServicoController.Altera(TContratoSolicitacaoServicoVO(ObjetoVO));
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
/// EXERCICIO: Implemente a busca usando o FLookup
procedure TFContratoSolicitacaoServico.EditIdClienteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  ViewPessoaClienteVO :TViewPessoaClienteVO ;
begin
  if Key = VK_F1 then
  begin
    if EditIdCliente.Value <> 0 then
      Filtro := 'ID = ' + EditIdCliente.Text
    else
      Filtro := 'ID=0';

    try
      EditCliente.Clear;

        ViewPessoaClienteVO := TViewPessoaClienteController.ConsultaObjeto(Filtro);
        if Assigned(ViewPessoaClienteVO) then
      begin
        EditCliente.Text := ViewPessoaClienteVO.Nome;
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

procedure TFContratoSolicitacaoServico.EditIdColaboradorKeyUp(Sender: TObject;  var Key: Word; Shift: TShiftState);
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
      EditIdTipoServico.SetFocus;
    end;
  end;
end;

procedure TFContratoSolicitacaoServico.EditIdFornecedorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  ViewPessoaFornecedorVO :TViewPessoaFornecedorVO ;
begin
  if Key = VK_F1 then
  begin
    if EditIdFornecedor.Value <> 0 then
      Filtro := 'ID = ' + EditIdFornecedor.Text
    else
      Filtro := 'ID=0';

    try
      EditFornecedor.Clear;

        ViewPessoaFornecedorVO := TViewPessoaFornecedorController.ConsultaObjeto(Filtro);
        if Assigned(ViewPessoaFornecedorVO) then
      begin
        EditFornecedor.Text := ViewPessoaFornecedorVO.Nome;
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

procedure TFContratoSolicitacaoServico.EditIdSetorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  SetorVO :TSetorVO ;
begin
  if Key = VK_F1 then
  begin
    if EditIdSetor.Value <> 0 then
      Filtro := 'ID = ' + EditIdSetor.Text
    else
      Filtro := 'ID=0';

    try
      EditSetor.Clear;

        SetorVO := TSetorController.ConsultaObjeto(Filtro);
        if Assigned(SetorVO) then
      begin
        EditSetor.Text := SetorVO.Nome;
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

procedure TFContratoSolicitacaoServico.EditIdTipoServicoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  ContratoTipoServicoVO :TContratoTipoServicoVO ;
begin
  if Key = VK_F1 then
  begin
    if EditIdTipoServico.Value <> 0 then
      Filtro := 'ID = ' + EditIdTipoServico.Text
    else
      Filtro := 'ID=0';

    try
      EditTipoServico.Clear;

        ContratoTipoServicoVO := TContratoTipoServicoController.ConsultaObjeto(Filtro);
        if Assigned(ContratoTipoServicoVO) then
      begin
        EditTipoServico.Text := ContratoTipoServicoVO.Nome;
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

{$REGION 'Controle de Grid'}
procedure TFContratoSolicitacaoServico.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TContratoSolicitacaoServicoController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    if TContratoSolicitacaoServicoVO(ObjetoVO).IdCliente > 0 then
    begin
      EditIdCliente.AsInteger := TContratoSolicitacaoServicoVO(ObjetoVO).IdCliente;
      EditCliente.Text := TContratoSolicitacaoServicoVO(ObjetoVO).ClientePessoaNome;
      EditIdCliente.Visible := True;
      EditCliente.Visible := True;
      EditIdFornecedor.Visible := False;
      EditFornecedor.Visible := False;
      RadioGroupTipoContratacao.ItemIndex := 0;
    end
    else if TContratoSolicitacaoServicoVO(ObjetoVO).IdFornecedor > 0 then
    begin
      EditIdFornecedor.AsInteger := TContratoSolicitacaoServicoVO(ObjetoVO).IdFornecedor;
      EditFornecedor.Text := TContratoSolicitacaoServicoVO(ObjetoVO).FornecedorPessoaNome;
      EditIdCliente.Visible := False;
      EditCliente.Visible := False;
      EditIdFornecedor.Visible := True;
      EditFornecedor.Visible := True;
      RadioGroupTipoContratacao.ItemIndex := 1;
    end;

    EditIdSetor.AsInteger := TContratoSolicitacaoServicoVO(ObjetoVO).IdSetor;
    EditSetor.Text := TContratoSolicitacaoServicoVO(ObjetoVO).SetorNome;
    EditIdColaborador.AsInteger := TContratoSolicitacaoServicoVO(ObjetoVO).IdColaborador;
    EditColaborador.Text := TContratoSolicitacaoServicoVO(ObjetoVO).ColaboradorPessoaNome;
    EditIdTipoServico.AsInteger := TContratoSolicitacaoServicoVO(ObjetoVO).IdContratoTipoServico;
    EditTipoServico.Text := TContratoSolicitacaoServicoVO(ObjetoVO).ContratoTipoServicoNome;
    EditDescricao.Text := TContratoSolicitacaoServicoVO(ObjetoVO).Descricao;
    EditDataSolicitacao.Date := TContratoSolicitacaoServicoVO(ObjetoVO).DataSolicitacao;
    EditDataDesejadaInicio.Date := TContratoSolicitacaoServicoVO(ObjetoVO).DataDesejadaInicio;
    ComboBoxUrgente.ItemIndex := StrToInt(IfThen(TContratoSolicitacaoServicoVO(ObjetoVO).Urgente = 'S', '0', '1'));

    case AnsiIndexStr(TContratoSolicitacaoServicoVO(ObjetoVO).StatusSolicitacao, ['A', 'D', 'I']) of
      0:
        ComboBoxStatusSolicitacao.ItemIndex := 0;
      1:
        ComboBoxStatusSolicitacao.ItemIndex := 1;
      2:
        ComboBoxStatusSolicitacao.ItemIndex := 2;
    else
      ComboBoxStatusSolicitacao.ItemIndex := -1;
    end;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.

