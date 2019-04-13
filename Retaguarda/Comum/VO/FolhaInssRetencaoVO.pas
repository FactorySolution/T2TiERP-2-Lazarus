{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [FOLHA_INSS_RETENCAO] 
                                                                                
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
unit FolhaInssRetencaoVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL;

type
  TFolhaInssRetencaoVO = class(TVO)
  private
    FID: Integer;
    FID_FOLHA_INSS: Integer;
    FID_FOLHA_INSS_SERVICO: Integer;
    FVALOR_MENSAL: Extended;
    FVALOR_13: Extended;

    //Transientes



  published 
    property Id: Integer  read FID write FID;
    property IdFolhaInss: Integer  read FID_FOLHA_INSS write FID_FOLHA_INSS;
    property IdFolhaInssServico: Integer  read FID_FOLHA_INSS_SERVICO write FID_FOLHA_INSS_SERVICO;
    property ValorMensal: Extended  read FVALOR_MENSAL write FVALOR_MENSAL;
    property Valor13: Extended  read FVALOR_13 write FVALOR_13;


    //Transientes



  end;

  TListaFolhaInssRetencaoVO = specialize TFPGObjectList<TFolhaInssRetencaoVO>;

implementation


initialization
  Classes.RegisterClass(TFolhaInssRetencaoVO);

finalization
  Classes.UnRegisterClass(TFolhaInssRetencaoVO);

end.
