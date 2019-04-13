{ *******************************************************************************
Title: T2Ti ERP
Description: Janela de Recados

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
unit URecado;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO;
{
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, LabeledCtrls, Atributos, Constantes,
  Mask, JvExMask, JvToolEdit, JvBaseEdits, DB, DBClient, Generics.Collections,
  WideStrings, DBXMySql, FMTBcd, Provider, SqlExpr, StrUtils, System.Actions,
  Vcl.ActnList, Vcl.RibbonSilverStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin,
  Vcl.ActnCtrls, Controller, Biblioteca;

}type

  { TFRecado }

  TFRecado = class(TFTelaCadastro)
    BevelEdits: TBevel;
    BotaoConsultar: TSpeedButton;
    BotaoExportar: TSpeedButton;
    BotaoFiltrar: TSpeedButton;
    BotaoImprimir: TSpeedButton;
    BotaoSair: TSpeedButton;
    BotaoSeparador1: TSpeedButton;
    EditCriterioRapido: TLabeledMaskEdit;
    EditIdColaborador: TLabeledCalcEdit;
    EditColaborador: TLabeledEdit;
    ActionManager: TActionList;
    ActionIncluirItem: TAction;
    ActionExcluirItem: TAction;
    ActionAtualizarTotais: TAction;
    EditAssunto: TLabeledEdit;
    Grid: TRxDbGrid;
    MemoTexto: TLabeledMemo;
    PageControl: TPageControl;
    PaginaEdits: TTabSheet;
    PaginaGrid: TTabSheet;
    PanelEdits: TPanel;
    PanelFiltroRapido: TPanel;
    PanelGrid: TPanel;
    PanelToolBar: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure EditIdColaboradorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
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
  FRecado: TFRecado;

implementation

uses RecadoRemetenteController, RecadoRemetenteVO,
  ULookup,
  ViewPessoaColaboradorVO, ViewPessoaColaboradorController;
{$R *.lfm}

{$REGION 'Infra'}
procedure TFRecado.BotaoConsultarClick(Sender: TObject);
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
    RetornoConsulta := TRecadoController.Consulta(Filtro, IntToStr(Pagina));
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

procedure TFRecado.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFRecado.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TRecadoRemetenteVO;
  ObjetoController := TRecadoRemetenteController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFRecado.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdColaborador.SetFocus;
  end;
end;

function TFRecado.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditIdColaborador.SetFocus;
  end;
end;

function TFRecado.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TRecadoController.Exclui(IdRegistroSelecionado);
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

function TFRecado.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TRecadoRemetenteVO.Create;

      TRecadoRemetenteVO(ObjetoVO).IdColaborador := Sessao.Usuario.ColaboradorVO.Id;
      TRecadoRemetenteVO(ObjetoVO).DataEnvio := Now;
      TRecadoRemetenteVO(ObjetoVO).HoraEnvio := TimeToStr(Now);
      TRecadoRemetenteVO(ObjetoVO).Assunto := EditAssunto.Text;
      TRecadoRemetenteVO(ObjetoVO).Texto := MemoTexto.Text;

      TRecadoRemetenteVO(ObjetoVO).RecadoDestinatarioVO.IdColaborador := EditIdColaborador.AsInteger;
      TRecadoRemetenteVO(ObjetoVO).RecadoDestinatarioVO.IdRecadoRemetente := Sessao.Usuario.ColaboradorVO.Id;

      /// EXERCICIO
      ///  E se o recado fosse enviado para v�rios contatos? Implemente uma lista
      ///  dentro de RecadoRemetenteVO para enviar o recado para v�rios contatos.

      if StatusTela = stInserindo then
      begin
        TRecadoController.Insere(TRecadoVO(ObjetoVO));
        TRecadoController.Insere(TRecadoVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        /// EXERCICIO: Verifique se tem como serializar as listas junto com o objeto para realizar a compara��o
        //if TRecadoRemetenteVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        //begin
          TRecadoController.Altera(TRecadoVO(ObjetoVO));
        //TController.ExecutarMetodo('RecadoDestinatarioController.TRecadoDestinatarioController', 'Altera', [TRecadoRemetenteVO(ObjetoVO).RecadoDestinatarioVO], 'POST', 'Boolean');
        //end
        //else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFRecado.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TRecadoController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin

    /// EXERCICIO:
    ///  Esse ID do colaborador est� sendo carregado corretamente? Por que?
    EditIdColaborador.AsInteger := TRecadoRemetenteVO(ObjetoVO).IdColaborador;

    EditAssunto.Text := TRecadoRemetenteVO(ObjetoVO).Assunto;
    MemoTexto.Text := TRecadoRemetenteVO(ObjetoVO).Texto;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
procedure TFRecado.EditIdColaboradorKeyUp(Sender: TObject;  var Key: Word; Shift: TShiftState);
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
        EditAssunto.SetFocus;
      end;
    finally
    end;
  end;
end;
{$ENDREGION}

/// EXERCICIO
///  Implemente uma caixa de entrada para que o colaborador destinat�rio
///  consiga enxergar todos os recados enviados para ele, como se fosse
///  uma caixa de entrada de e-mail.

end.

