{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de Hor�rios para o Ponto Eletr�nico

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
unit UPontoHorario;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO, PontoHorarioVO,
  PontoHorarioController;

  type

  TFPontoHorario = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditCargaHoraria: TLabeledMaskEdit;
    ComboboxTipo: TLabeledComboBox;
    EditCodigo: TLabeledEdit;
    EditNome: TLabeledEdit;
    ComboboxTipoTrabalho: TLabeledComboBox;
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
    EditHoraInicioJornada: TLabeledMaskEdit;
    EditHoraFimJornada: TLabeledMaskEdit;
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
  FPontoHorario: TFPontoHorario;

implementation

{$R *.lfm}

{$REGION 'Infra'}
procedure TFPontoHorario.BotaoConsultarClick(Sender: TObject);
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
    RetornoConsulta := TPontoHorarioController.Consulta(Filtro, IntToStr(Pagina));
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

procedure TFPontoHorario.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFPontoHorario.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TPontoHorarioVO;
  ObjetoController := TPontoHorarioController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFPontoHorario.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    ComboboxTipo.SetFocus;
  end;
end;

function TFPontoHorario.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    ComboboxTipo.SetFocus;
  end;
end;

function TFPontoHorario.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TPontoHorarioController.Exclui(IdRegistroSelecionado);
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

function TFPontoHorario.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TPontoHorarioVO.Create;

      TPontoHorarioVO(ObjetoVO).IdEmpresa := Sessao.Empresa.Id;
      TPontoHorarioVO(ObjetoVO).Tipo := Copy(ComboboxTipo.Text, 1, 1);
      TPontoHorarioVO(ObjetoVO).Codigo := EditCodigo.Text;
      TPontoHorarioVO(ObjetoVO).Nome := EditNome.Text;
      TPontoHorarioVO(ObjetoVO).TipoTrabalho := Copy(ComboboxTipoTrabalho.Text, 1, 1);
      TPontoHorarioVO(ObjetoVO).CargaHoraria := EditCargaHoraria.Text;
      TPontoHorarioVO(ObjetoVO).Entrada01 := EditEntrada01.Text;
      TPontoHorarioVO(ObjetoVO).Entrada02 := EditEntrada02.Text;
      TPontoHorarioVO(ObjetoVO).Entrada03 := EditEntrada03.Text;
      TPontoHorarioVO(ObjetoVO).Entrada04 := EditEntrada04.Text;
      TPontoHorarioVO(ObjetoVO).Entrada05 := EditEntrada05.Text;
      TPontoHorarioVO(ObjetoVO).Saida01 := EditSaida01.Text;
      TPontoHorarioVO(ObjetoVO).Saida02 := EditSaida02.Text;
      TPontoHorarioVO(ObjetoVO).Saida03 := EditSaida03.Text;
      TPontoHorarioVO(ObjetoVO).Saida04 := EditSaida04.Text;
      TPontoHorarioVO(ObjetoVO).Saida05 := EditSaida05.Text;
      TPontoHorarioVO(ObjetoVO).HoraInicioJornada := EditHoraInicioJornada.Text;
      TPontoHorarioVO(ObjetoVO).HoraFimJornada := EditHoraFimJornada.Text;

      if StatusTela = stInserindo then
      begin
        TPontoHorarioController.Insere(TPontoHorarioVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        if TPontoHorarioVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TPontoHorarioController.Altera(TPontoHorarioVO(ObjetoVO));
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
procedure TFPontoHorario.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TPontoHorarioController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    case AnsiIndexStr(TPontoHorarioVO(ObjetoVO).Tipo, ['F', 'D', 'S', 'M']) of
      0:
        ComboboxTipo.ItemIndex := 0;
      1:
        ComboboxTipo.ItemIndex := 1;
      2:
        ComboboxTipo.ItemIndex := 2;
      3:
        ComboboxTipo.ItemIndex := 3;
    end;

    EditCodigo.Text := TPontoHorarioVO(ObjetoVO).Codigo;
    EditNome.Text := TPontoHorarioVO(ObjetoVO).Nome;

    case AnsiIndexStr(TPontoHorarioVO(ObjetoVO).TipoTrabalho, ['N', 'C', 'F']) of
      0:
        ComboboxTipoTrabalho.ItemIndex := 0;
      1:
        ComboboxTipoTrabalho.ItemIndex := 1;
      2:
        ComboboxTipoTrabalho.ItemIndex := 2;
    end;

    EditCargaHoraria.Text := TPontoHorarioVO(ObjetoVO).CargaHoraria;
    EditEntrada01.Text := TPontoHorarioVO(ObjetoVO).Entrada01;
    EditEntrada02.Text := TPontoHorarioVO(ObjetoVO).Entrada02;
    EditEntrada03.Text := TPontoHorarioVO(ObjetoVO).Entrada03;
    EditEntrada04.Text := TPontoHorarioVO(ObjetoVO).Entrada04;
    EditEntrada05.Text := TPontoHorarioVO(ObjetoVO).Entrada05;
    EditSaida01.Text := TPontoHorarioVO(ObjetoVO).Saida01;
    EditSaida02.Text := TPontoHorarioVO(ObjetoVO).Saida02;
    EditSaida03.Text := TPontoHorarioVO(ObjetoVO).Saida03;
    EditSaida04.Text := TPontoHorarioVO(ObjetoVO).Saida04;
    EditSaida05.Text := TPontoHorarioVO(ObjetoVO).Saida05;
    EditHoraInicioJornada.Text := TPontoHorarioVO(ObjetoVO).HoraInicioJornada;
    EditHoraFimJornada.Text := TPontoHorarioVO(ObjetoVO).HoraFimJornada;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.

