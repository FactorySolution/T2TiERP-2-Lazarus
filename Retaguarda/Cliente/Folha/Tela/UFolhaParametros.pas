{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de Par�metros para a Folha de Pagamento

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
t2ti.com@gmail.com</p>

@author Albert Eije (alberteije@gmail.com)
@version 2.0
******************************************************************************* }
unit UFolhaParametros;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO, FolhaParametroVO,
  FolhaParametroController;

  type

  TFFolhaParametros = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditCompetencia: TLabeledMaskEdit;
    EditDiaPagamento: TLabeledCalcEdit;
    EditAliquotaPis: TLabeledCalcEdit;
    ComboBoxContribuiPis: TLabeledComboBox;
    ComboBoxDiscriminarDsr: TLabeledComboBox;
    ComboBoxCalculoProporcionalidade: TLabeledComboBox;
    GroupBox1: TGroupBox;
    ComboBoxDescontarFaltas13: TLabeledComboBox;
    ComboBoxPagarAdicionais13: TLabeledComboBox;
    ComboBoxPagarEstagiarios13: TLabeledComboBox;
    ComboBoxMesAdiantamento13: TLabeledComboBox;
    EditPercentualAdiantamento13: TLabeledCalcEdit;
    GroupBox2: TGroupBox;
    ComboBoxDescontarFaltasFerias: TLabeledComboBox;
    ComboBoxPagarAdicionaisFerias: TLabeledComboBox;
    ComboBoxPagarEstagiariosFerias: TLabeledComboBox;
    ComboBoxAdiantar13Ferias: TLabeledComboBox;
    ComboBoxCalculoJustaCausaFerias: TLabeledComboBox;
    ComboBoxMovimentoMensalFerias: TLabeledComboBox;
    procedure FormCreate(Sender: TObject);
    procedure BotaoConsultarClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FFolhaParametros: TFFolhaParametros;

implementation

{$R *.lfm}

{$REGION 'Controles Infra'}
procedure TFFolhaParametros.BotaoConsultarClick(Sender: TObject);
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
    RetornoConsulta := TFolhaParametroController.Consulta(Filtro, IntToStr(Pagina));
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

procedure TFFolhaParametros.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFFolhaParametros.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TFolhaParametroVO;
  ObjetoController := TFolhaParametroController.Create;

  inherited;
  BotaoImprimir.Visible := False;
  MenuImprimir.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFFolhaParametros.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditCompetencia.SetFocus;
  end;
end;

function TFFolhaParametros.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditCompetencia.SetFocus;
  end;
end;

function TFFolhaParametros.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TFolhaParametroController.Exclui(IdRegistroSelecionado);
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

function TFFolhaParametros.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TFolhaParametroVO.Create;

      TFolhaParametroVO(ObjetoVO).IdEmpresa := Sessao.Empresa.Id;
      TFolhaParametroVO(ObjetoVO).Competencia := EditCompetencia.Text;
      TFolhaParametroVO(ObjetoVO).ContribuiPis := IfThen(ComboBoxContribuiPis.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).AliquotaPis := EditAliquotaPis.Value;
      TFolhaParametroVO(ObjetoVO).DiscriminarDsr := IfThen(ComboBoxDiscriminarDsr.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).DiaPagamento := EditDiaPagamento.Text;
      TFolhaParametroVO(ObjetoVO).CalculoProporcionalidade := IntToStr(ComboBoxCalculoProporcionalidade.ItemIndex);
      TFolhaParametroVO(ObjetoVO).DescontarFaltas13 := IfThen(ComboBoxDescontarFaltas13.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).PagarAdicionais13 := IfThen(ComboBoxPagarAdicionais13.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).PagarEstagiarios13 := IfThen(ComboBoxPagarEstagiarios13.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).MesAdiantamento13 := Copy(ComboBoxMesAdiantamento13.Text, 1, 2);
      TFolhaParametroVO(ObjetoVO).PercentualAdiantam13 := EditPercentualAdiantamento13.Value;
      TFolhaParametroVO(ObjetoVO).FeriasDescontarFaltas := IfThen(ComboBoxDescontarFaltasFerias.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).FeriasPagarAdicionais := IfThen(ComboBoxPagarAdicionaisFerias.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).FeriasPagarEstagiarios := IfThen(ComboBoxPagarEstagiariosFerias.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).FeriasAdiantar13 := IfThen(ComboBoxAdiantar13Ferias.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).FeriasCalcJustaCausa := IfThen(ComboBoxCalculoJustaCausaFerias.ItemIndex = 0, 'S', 'N');
      TFolhaParametroVO(ObjetoVO).FeriasMovimentoMensal := IfThen(ComboBoxMovimentoMensalFerias.ItemIndex = 0, 'S', 'N');

      if StatusTela = stInserindo then
      begin
        TFolhaParametroController.Insere(TFolhaParametroVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        if TFolhaParametroVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TFolhaParametroController.Altera(TFolhaParametroVO(ObjetoVO));
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
procedure TFFolhaParametros.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TFolhaParametroController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin

    EditCompetencia.Text := TFolhaParametroVO(ObjetoVO).Competencia;
    ComboBoxContribuiPis.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).ContribuiPis, ['S', 'N']);
    EditAliquotaPis.Value := TFolhaParametroVO(ObjetoVO).AliquotaPis;
    ComboBoxDiscriminarDsr.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).DiscriminarDsr, ['S', 'N']);
    EditDiaPagamento.Text := TFolhaParametroVO(ObjetoVO).DiaPagamento;
    ComboBoxCalculoProporcionalidade.ItemIndex := StrToInt(TFolhaParametroVO(ObjetoVO).CalculoProporcionalidade);
    ComboBoxDescontarFaltas13.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).DescontarFaltas13, ['S', 'N']);
    ComboBoxPagarAdicionais13.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).PagarAdicionais13, ['S', 'N']);
    ComboBoxPagarEstagiarios13.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).PagarEstagiarios13, ['S', 'N']);
    ComboBoxMesAdiantamento13.ItemIndex := StrToInt(TFolhaParametroVO(ObjetoVO).MesAdiantamento13) - 1;
    EditPercentualAdiantamento13.Value := TFolhaParametroVO(ObjetoVO).PercentualAdiantam13;
    ComboBoxDescontarFaltasFerias.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).FeriasDescontarFaltas, ['S', 'N']);
    ComboBoxPagarAdicionaisFerias.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).FeriasPagarAdicionais, ['S', 'N']);
    ComboBoxPagarEstagiariosFerias.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).FeriasPagarEstagiarios, ['S', 'N']);
    ComboBoxAdiantar13Ferias.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).FeriasAdiantar13, ['S', 'N']);
    ComboBoxCalculoJustaCausaFerias.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).FeriasCalcJustaCausa, ['S', 'N']);
    ComboBoxMovimentoMensalFerias.ItemIndex := AnsiIndexStr(TFolhaParametroVO(ObjetoVO).FeriasMovimentoMensal, ['S', 'N']);

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.

