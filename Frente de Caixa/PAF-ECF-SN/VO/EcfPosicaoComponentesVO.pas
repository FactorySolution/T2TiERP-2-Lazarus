{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [ECF_POSICAO_COMPONENTES] 
                                                                                
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
unit EcfPosicaoComponentesVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL;

type
  TEcfPosicaoComponentesVO = class(TVO)
  private
    FID: Integer;
    FID_ECF_RESOLUCAO: Integer;
    FNOME: String;
    FALTURA: Integer;
    FLARGURA: Integer;
    FTOPO: Integer;
    FESQUERDA: Integer;
    FTAMANHO_FONTE: Integer;
    FTEXTO: String;

  published 
    property Id: Integer  read FID write FID;
    property IdEcfResolucao: Integer  read FID_ECF_RESOLUCAO write FID_ECF_RESOLUCAO;
    property Nome: String  read FNOME write FNOME;
    property Altura: Integer  read FALTURA write FALTURA;
    property Largura: Integer  read FLARGURA write FLARGURA;
    property Topo: Integer  read FTOPO write FTOPO;
    property Esquerda: Integer  read FESQUERDA write FESQUERDA;
    property TamanhoFonte: Integer  read FTAMANHO_FONTE write FTAMANHO_FONTE;
    property Texto: String  read FTEXTO write FTEXTO;

  end;

  TListaEcfPosicaoComponentesVO = specialize TFPGObjectList<TEcfPosicaoComponentesVO>;

implementation


initialization
  Classes.RegisterClass(TEcfPosicaoComponentesVO);

finalization
  Classes.UnRegisterClass(TEcfPosicaoComponentesVO);

end.
