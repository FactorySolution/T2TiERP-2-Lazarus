{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [PONTO_BANCO_HORAS] 
                                                                                
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
unit PontoBancoHorasVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL,
  ViewPessoaColaboradorVO, PontoBancoHorasUtilizacaoVO;

type
  TPontoBancoHorasVO = class(TVO)
  private
    FID: Integer;
    FID_COLABORADOR: Integer;
    FDATA_TRABALHO: TDateTime;
    FQUANTIDADE: String;
    FSITUACAO: String;

    //Transientes
    FColaboradorNome: String;

    FColaboradorVO: TViewPessoaColaboradorVO;

    FListaPontoBancoHorasUtilizacaoVO: TListaPontoBancoHorasUtilizacaoVO;


  published
    constructor Create; override;
    destructor Destroy; override;

    property Id: Integer  read FID write FID;

    property IdColaborador: Integer  read FID_COLABORADOR write FID_COLABORADOR;
    property ColaboradorNome: String read FColaboradorNome write FColaboradorNome;

    property DataTrabalho: TDateTime  read FDATA_TRABALHO write FDATA_TRABALHO;
    property Quantidade: String  read FQUANTIDADE write FQUANTIDADE;
    property Situacao: String  read FSITUACAO write FSITUACAO;

    //Transientes
    property ColaboradorVO: TViewPessoaColaboradorVO read FColaboradorVO write FColaboradorVO;

    property ListaPontoBancoHorasUtilizacaoVO: TListaPontoBancoHorasUtilizacaoVO read FListaPontoBancoHorasUtilizacaoVO write FListaPontoBancoHorasUtilizacaoVO;


  end;

  TListaPontoBancoHorasVO = specialize TFPGObjectList<TPontoBancoHorasVO>;

implementation

constructor TPontoBancoHorasVO.Create;
begin
  inherited;

  FColaboradorVO := TViewPessoaColaboradorVO.Create;
  FListaPontoBancoHorasUtilizacaoVO := TListaPontoBancoHorasUtilizacaoVO.Create;
end;

destructor TPontoBancoHorasVO.Destroy;
begin
  FreeAndNil(FColaboradorVO);
  FreeAndNil(FListaPontoBancoHorasUtilizacaoVO);

  inherited;
end;

initialization
  Classes.RegisterClass(TPontoBancoHorasVO);

finalization
  Classes.UnRegisterClass(TPontoBancoHorasVO);

end.
