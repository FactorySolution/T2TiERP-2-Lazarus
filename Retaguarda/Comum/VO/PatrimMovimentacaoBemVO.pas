{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [PATRIM_MOVIMENTACAO_BEM] 
                                                                                
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
unit PatrimMovimentacaoBemVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL,
  PatrimTipoMovimentacaoVO;

type
  TPatrimMovimentacaoBemVO = class(TVO)
  private
    FID: Integer;
    FID_PATRIM_BEM: Integer;
    FID_PATRIM_TIPO_MOVIMENTACAO: Integer;
    FDATA_MOVIMENTACAO: TDateTime;
    FRESPONSAVEL: String;

    //Transientes
    FPatrimTipoMovimentacaoNome: String;

    FPatrimTipoMovimentacaoVO: TPatrimTipoMovimentacaoVO;


  published
    constructor Create; override;
    destructor Destroy; override;

    property Id: Integer  read FID write FID;
    property IdPatrimBem: Integer  read FID_PATRIM_BEM write FID_PATRIM_BEM;

    property IdPatrimTipoMovimentacao: Integer  read FID_PATRIM_TIPO_MOVIMENTACAO write FID_PATRIM_TIPO_MOVIMENTACAO;
    property PatrimTipoMovimentacaoNome: String read FPatrimTipoMovimentacaoNome write FPatrimTipoMovimentacaoNome;

    property DataMovimentacao: TDateTime  read FDATA_MOVIMENTACAO write FDATA_MOVIMENTACAO;
    property Responsavel: String  read FRESPONSAVEL write FRESPONSAVEL;


    //Transientes
    property PatrimTipoMovimentacaoVO: TPatrimTipoMovimentacaoVO read FPatrimTipoMovimentacaoVO write FPatrimTipoMovimentacaoVO;


  end;

  TListaPatrimMovimentacaoBemVO = specialize TFPGObjectList<TPatrimMovimentacaoBemVO>;

implementation

constructor TPatrimMovimentacaoBemVO.Create;
begin
  inherited;

  FPatrimTipoMovimentacaoVO := TPatrimTipoMovimentacaoVO.Create;
end;

destructor TPatrimMovimentacaoBemVO.Destroy;
begin
  FreeAndNil(FPatrimTipoMovimentacaoVO);

  inherited;
end;


initialization
  Classes.RegisterClass(TPatrimMovimentacaoBemVO);

finalization
  Classes.UnRegisterClass(TPatrimMovimentacaoBemVO);

end.
