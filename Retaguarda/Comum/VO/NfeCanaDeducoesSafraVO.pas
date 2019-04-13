{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [NFE_CANA_DEDUCOES_SAFRA] 
                                                                                
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
unit NfeCanaDeducoesSafraVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL;

type
  TNfeCanaDeducoesSafraVO = class(TVO)
  private
    FID: Integer;
    FID_NFE_CANA: Integer;
    FDECRICAO: String;
    FVALOR_DEDUCAO: Extended;
    FVALOR_FORNECIMENTO: Extended;
    FVALOR_TOTAL_DEDUCAO: Extended;
    FVALOR_LIQUIDO_FORNECIMENTO: Extended;

  published 
    property Id: Integer  read FID write FID;
    property IdNfeCana: Integer  read FID_NFE_CANA write FID_NFE_CANA;
    property Decricao: String  read FDECRICAO write FDECRICAO;
    property ValorDeducao: Extended  read FVALOR_DEDUCAO write FVALOR_DEDUCAO;
    property ValorFornecimento: Extended  read FVALOR_FORNECIMENTO write FVALOR_FORNECIMENTO;
    property ValorTotalDeducao: Extended  read FVALOR_TOTAL_DEDUCAO write FVALOR_TOTAL_DEDUCAO;
    property ValorLiquidoFornecimento: Extended  read FVALOR_LIQUIDO_FORNECIMENTO write FVALOR_LIQUIDO_FORNECIMENTO;

  end;

  TListaNfeCanaDeducoesSafraVO = specialize TFPGObjectList<TNfeCanaDeducoesSafraVO>;

implementation


initialization
  Classes.RegisterClass(TNfeCanaDeducoesSafraVO);

finalization
  Classes.UnRegisterClass(TNfeCanaDeducoesSafraVO);

end.
