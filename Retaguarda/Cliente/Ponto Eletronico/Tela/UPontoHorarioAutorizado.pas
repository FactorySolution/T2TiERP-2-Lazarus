{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de Hor�rios Autorizados para o Ponto Eletr�nico

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
unit UPontoHorarioAutorizado;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO, PontoHorarioAutorizadoVO,
  PontoHorarioAutorizadoController;

  type

  TFPontoHorarioAutorizado = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditCargaHoraria: TLabeledMaskEdit;
    EditHoraFechamentoDia: TLabeledMaskEdit;
    ComboboxTipo: TLabeledComboBox;
    GroupBoxRegistros: TGroupBox;
    EditEntrada01: TLabeledMaskEdit;
    EditEntrada02: TLabeledMaskEdit;
    EditEntrada03: TLabeledMaskEdit;
    EditEntrada04: TLabeledMaskEdit;
    EditEntrada05: TLabeledMaskEdit;
    EditSaida01: TLabeledMaskEdit;
    EditSaida02: TLabeledMaskEdit;
    EditSaida03: TLabeledMaskEdit;
    EditSaida04: TLabeledMaskEdit;
    EditSaida05: TLabeledMaskEdit;
    EditIdColaborador: TLabeledCalcEdit;
    EditColaborador: TLabeledEdit;
    EditDataHorario: TLabeledDateEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditIdColaboradorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
  FPontoHorarioAutorizado: TFPontoHorarioAutorizado;

implementation

uses ViewPessoaColaboradorVO, ViewPessoaColaboradorController;

{$R *.lfm}

{$REGION 'Infra'}
procedure TFPontoHorarioAutorizado.BotaoConsultarClick(Sender: TObject);
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
    RetornoConsulta := TPontoHorarioAutorizadoController.Consulta(Filtro, IntToStr(Pagina));
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

procedure TFPontoHorarioAutorizado.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFPontoHorarioAutorizado.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TPontoHorarioAutorizadoVO;
  ObjetoController := TPontoHorarioAutorizadoController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFPontoHorarioAutorizado.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdColaborador.SetFocus;
  end;
end;

function TFPontoHorarioAutorizado.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditIdColaborador.SetFocus;
  end;
end;

function TFPontoHorarioAutorizado.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TPontoHorarioAutorizadoController.Exclui(IdRegistroSelecionado);
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

function TFPontoHorarioAutorizado.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TPontoHorarioAutorizadoVO.Create;

      TPontoHorarioAutorizadoVO(ObjetoVO).IdColaborador := EditIdColaborador.AsInteger;
      TPontoHorarioAutorizadoVO(ObjetoVO).DataHorario := EditDataHorario.Date;
      TPontoHorarioAutorizadoVO(ObjetoVO).Tipo := Copy(ComboboxTipo.Text, 1, 1);
      TPontoHorarioAutorizadoVO(ObjetoVO).CargaHoraria := EditCargaHoraria.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Entrada01 := EditEntrada01.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Entrada02 := EditEntrada02.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Entrada03 := EditEntrada03.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Entrada04 := EditEntrada04.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Entrada05 := EditEntrada05.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Saida01 := EditSaida01.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Saida02 := EditSaida02.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Saida03 := EditSaida03.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Saida04 := EditSaida04.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).Saida05 := EditSaida05.Text;
      TPontoHorarioAutorizadoVO(ObjetoVO).HoraFechamentoDia := EditHoraFechamentoDia.Text;

      if StatusTela = stInserindo then
      begin
        TPontoHorarioAutorizadoController.Insere(TPontoHorarioAutorizadoVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        /// EXERCICIO: Verifique se tem como serializar as listas junto com o objeto para realizar a compara��o
        //if TPontoHorarioAutorizadoVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        //begin
          TPontoHorarioAutorizadoController.Altera(TPontoHorarioAutorizadoVO(ObjetoVO));
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

{$REGION 'Campos Transientes'}
procedure TFPontoHorarioAutorizado.EditIdColaboradorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Filtro: String;
begin
  if Key = VK_F1 then
  begin
    if EditIdColaborador.Value <> 0 then
      Filtro := 'ID = ' + EditIdColaborador.Text
    else
      Filtro := 'ID=0';

    try
      EditIdColaborador.Clear;
      EditColaborador.Clear;

        ViewPessoaColaboradorVO := TViewPessoaColaboradorController.ConsultaObjeto(Filtro);
        if Assigned(ViewPessoaColaboradorVO) then
      begin
        EditIdColaborador.Text := CDSTransiente.FieldByName('ID').AsString;
        EditColaborador.Text := CDSTransiente.FieldByName('NOME').AsString;
      end
      else
      begin
        Exit;
        EditDataHorario.SetFocus;
      end;
    finally
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFPontoHorarioAutorizado.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TPontoHorarioAutorizadoController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    case AnsiIndexStr(TPontoHorarioAutorizadoVO(ObjetoVO).Tipo, ['F', 'D', 'S', 'M']) of
      0:
        ComboboxTipo.ItemIndex := 0;
      1:
        ComboboxTipo.ItemIndex := 1;
      2:
        ComboboxTipo.ItemIndex := 2;
      3:
        ComboboxTipo.ItemIndex := 3;
    end;

    EditIdColaborador.AsInteger := TPontoHorarioAutorizadoVO(ObjetoVO).IdColaborador;
    EditColaborador.Text := TPontoHorarioAutorizadoVO(ObjetoVO).ColaboradorNome;
    EditDataHorario.Date := TPontoHorarioAutorizadoVO(ObjetoVO).DataHorario;
    EditCargaHoraria.Text := TPontoHorarioAutorizadoVO(ObjetoVO).CargaHoraria;
    EditEntrada01.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Entrada01;
    EditEntrada02.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Entrada02;
    EditEntrada03.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Entrada03;
    EditEntrada04.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Entrada04;
    EditEntrada05.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Entrada05;
    EditSaida01.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Saida01;
    EditSaida02.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Saida02;
    EditSaida03.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Saida03;
    EditSaida04.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Saida04;
    EditSaida05.Text := TPontoHorarioAutorizadoVO(ObjetoVO).Saida05;
    EditHoraFechamentoDia.Text := TPontoHorarioAutorizadoVO(ObjetoVO).HoraFechamentoDia;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.

