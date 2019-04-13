{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [NIVEL_FORMACAO] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2014 T2Ti.COM                                          
                                                                                
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
unit NivelFormacaoVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL;

type
  TNivelFormacaoVO = class(TVO)
  private
    FID: Integer;
    FNOME: String;
    FDESCRICAO: String;
    FGRAU_INSTRUCAO_CAGED: Integer;
    FGRAU_INSTRUCAO_SEFIP: Integer;
    FGRAU_INSTRUCAO_RAIS: Integer;

  published
    property Id: Integer  read FID write FID;
    property Nome: String  read FNOME write FNOME;
    property Descricao: String  read FDESCRICAO write FDESCRICAO;
    property GrauInstrucaoCaged: Integer  read FGRAU_INSTRUCAO_CAGED write FGRAU_INSTRUCAO_CAGED;
    property GrauInstrucaoSefip: Integer  read FGRAU_INSTRUCAO_SEFIP write FGRAU_INSTRUCAO_SEFIP;
    property GrauInstrucaoRais: Integer  read FGRAU_INSTRUCAO_RAIS write FGRAU_INSTRUCAO_RAIS;


  end;

  TListaNivelFormacaoVO = specialize TFPGObjectList<TNivelFormacaoVO>;

implementation


initialization
  Classes.RegisterClass(TNivelFormacaoVO);

finalization
  Classes.UnRegisterClass(TNivelFormacaoVO);

end.
