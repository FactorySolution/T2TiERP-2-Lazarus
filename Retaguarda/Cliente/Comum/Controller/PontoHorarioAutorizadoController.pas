{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller do lado Cliente relacionado � tabela [PONTO_HORARIO_AUTORIZADO] 
                                                                                
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
                                                                                
@author Albert Eije (t2ti.com@gmail.com)                    
@version 2.0                                                                    
*******************************************************************************}
unit PontoHorarioAutorizadoController;

{$MODE Delphi}

interface

uses
  Classes, Dialogs, SysUtils, DB, LCLIntf, LCLType, LMessages, Forms, Controller,
  VO, ZDataset, PontoHorarioAutorizadoVO;

type
  TPontoHorarioAutorizadoController = class(TController)
  private
  public
    class function Consulta(pFiltro: String; pPagina: String): TZQuery;
    class function ConsultaLista(pFiltro: String): TListaPontoHorarioAutorizadoVO;
    class function ConsultaObjeto(pFiltro: String): TPontoHorarioAutorizadoVO;

    class procedure Insere(pObjeto: TPontoHorarioAutorizadoVO);
    class function Altera(pObjeto: TPontoHorarioAutorizadoVO): Boolean;

    class function Exclui(pId: Integer): Boolean;

  end;

implementation

uses UDataModule, T2TiORM;

var
  ObjetoLocal: TPontoHorarioAutorizadoVO;

class function TPontoHorarioAutorizadoController.Consulta(pFiltro: String; pPagina: String): TZQuery;
begin
  try
    ObjetoLocal := TPontoHorarioAutorizadoVO.Create;
    Result := TT2TiORM.Consultar(ObjetoLocal, pFiltro, pPagina);
  finally
    ObjetoLocal.Free;
  end;
end;

class function TPontoHorarioAutorizadoController.ConsultaLista(pFiltro: String): TListaPontoHorarioAutorizadoVO;
begin
  try
    ObjetoLocal := TPontoHorarioAutorizadoVO.Create;
    Result := TListaPontoHorarioAutorizadoVO(TT2TiORM.Consultar(ObjetoLocal, pFiltro, True));
  finally
    ObjetoLocal.Free;
  end;
end;

class function TPontoHorarioAutorizadoController.ConsultaObjeto(pFiltro: String): TPontoHorarioAutorizadoVO;
begin
  try
    Result := TPontoHorarioAutorizadoVO.Create;
    Result := TPontoHorarioAutorizadoVO(TT2TiORM.ConsultarUmObjeto(Result, pFiltro, True));
  finally
  end;
end;

class procedure TPontoHorarioAutorizadoController.Insere(pObjeto: TPontoHorarioAutorizadoVO);
var
  UltimoID: Integer;
begin
  try
    UltimoID := TT2TiORM.Inserir(pObjeto);
    Consulta('ID = ' + IntToStr(UltimoID), '0');
  finally
  end;
end;

class function TPontoHorarioAutorizadoController.Altera(pObjeto: TPontoHorarioAutorizadoVO): Boolean;
begin
  try
    Result := TT2TiORM.Alterar(pObjeto);
  finally
  end;
end;

class function TPontoHorarioAutorizadoController.Exclui(pId: Integer): Boolean;
var
  ObjetoLocal: TPontoHorarioAutorizadoVO;
begin
  try
    ObjetoLocal := TPontoHorarioAutorizadoVO.Create;
    ObjetoLocal.Id := pId;
    Result := TT2TiORM.Excluir(ObjetoLocal);
  finally
    FreeAndNil(ObjetoLocal)
  end;
end;

initialization
  Classes.RegisterClass(TPontoHorarioAutorizadoController);

finalization
  Classes.UnRegisterClass(TPontoHorarioAutorizadoController);

end.

