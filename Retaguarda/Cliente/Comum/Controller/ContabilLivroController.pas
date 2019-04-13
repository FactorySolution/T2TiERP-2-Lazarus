{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller do lado Cliente relacionado � tabela [CONTABIL_LIVRO] 
                                                                                
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
unit ContabilLivroController;

{$MODE Delphi}

interface

uses
  Classes, Dialogs, SysUtils, DB, LCLIntf, LCLType, LMessages, Forms, Controller,
  VO, ZDataset, ContabilLivroVO, ContabilTermoVO;

type
  TContabilLivroController = class(TController)
  private
  public
    class function Consulta(pFiltro: String; pPagina: String): TZQuery;
    class function ConsultaLista(pFiltro: String): TListaContabilLivroVO;
    class function ConsultaObjeto(pFiltro: String): TContabilLivroVO;

    class procedure Insere(pObjeto: TContabilLivroVO);
    class function Altera(pObjeto: TContabilLivroVO): Boolean;

    class function Exclui(pId: Integer): Boolean;

  end;

implementation

uses UDataModule, T2TiORM;

var
  ObjetoLocal: TContabilLivroVO;

class function TContabilLivroController.Consulta(pFiltro: String; pPagina: String): TZQuery;
begin
  try
    ObjetoLocal := TContabilLivroVO.Create;
    Result := TT2TiORM.Consultar(ObjetoLocal, pFiltro, pPagina);
  finally
    ObjetoLocal.Free;
  end;
end;

class function TContabilLivroController.ConsultaLista(pFiltro: String): TListaContabilLivroVO;
begin
  try
    ObjetoLocal := TContabilLivroVO.Create;
    Result := TListaContabilLivroVO(TT2TiORM.Consultar(ObjetoLocal, pFiltro, True));
  finally
    ObjetoLocal.Free;
  end;
end;

class function TContabilLivroController.ConsultaObjeto(pFiltro: String): TContabilLivroVO;
begin
  try
    Result := TContabilLivroVO.Create;
    Result := TContabilLivroVO(TT2TiORM.ConsultarUmObjeto(Result, pFiltro, True));

    Filtro := 'ID_CONTABIL_LIVRO = ' + IntToStr(Result.Id);

    // Objetos Vinculados

    // Listas
    Result.ListaContabilTermoVO := TListaContabilTermoVO(TT2TiORM.Consultar(TContabilTermoVO.Create, Filtro, True));
  finally
  end;
end;

class procedure TContabilLivroController.Insere(pObjeto: TContabilLivroVO);
var
  UltimoID: Integer;
  I: Integer;
  Current: TContabilTermoVO;
begin
  try
    UltimoID := TT2TiORM.Inserir(pObjeto);

    // Detalhes
    for I := 0 to pObjeto.ListaContabilTermoVO.Count - 1 do
    begin
      Current := pObjeto.ListaContabilTermoVO[I];

      Current.IdContabilLivro := UltimoID;
      TT2TiORM.Inserir(Current);
    end;

    Consulta('ID = ' + IntToStr(UltimoID), '0');
  finally
  end;
end;

class function TContabilLivroController.Altera(pObjeto: TContabilLivroVO): Boolean;
begin
  try
    Result := TT2TiORM.Alterar(pObjeto);
  finally
  end;
end;

class function TContabilLivroController.Exclui(pId: Integer): Boolean;
var
  ObjetoLocal: TContabilLivroVO;
begin
  try
    ObjetoLocal := TContabilLivroVO.Create;
    ObjetoLocal.Id := pId;
    Result := TT2TiORM.Excluir(ObjetoLocal);
  finally
    FreeAndNil(ObjetoLocal)
  end;
end;

initialization
  Classes.RegisterClass(TContabilLivroController);

finalization
  Classes.UnRegisterClass(TContabilLivroController);

end.

