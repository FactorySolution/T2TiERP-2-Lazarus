{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [FIN_FECHAMENTO_CAIXA_BANCO] 
                                                                                
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
unit FinFechamentoCaixaBancoVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL;

type
  TFinFechamentoCaixaBancoVO = class(TVO)
  private
    FID: Integer;
    FID_CONTA_CAIXA: Integer;
    FDATA_FECHAMENTO: TDateTime;
    FMES_ANO: String;
    FMES: String;
    FANO: String;
    FSALDO_ANTERIOR: Extended;
    FRECEBIMENTOS: Extended;
    FPAGAMENTOS: Extended;
    FSALDO_CONTA: Extended;
    FCHEQUE_NAO_COMPENSADO: Extended;
    FSALDO_DISPONIVEL: Extended;

    //Transientes



  published 
    property Id: Integer  read FID write FID;
    property IdContaCaixa: Integer  read FID_CONTA_CAIXA write FID_CONTA_CAIXA;
    property DataFechamento: TDateTime  read FDATA_FECHAMENTO write FDATA_FECHAMENTO;
    property MesAno: String  read FMES_ANO write FMES_ANO;
    property Mes: String  read FMES write FMES;
    property Ano: String  read FANO write FANO;
    property SaldoAnterior: Extended  read FSALDO_ANTERIOR write FSALDO_ANTERIOR;
    property Recebimentos: Extended  read FRECEBIMENTOS write FRECEBIMENTOS;
    property Pagamentos: Extended  read FPAGAMENTOS write FPAGAMENTOS;
    property SaldoConta: Extended  read FSALDO_CONTA write FSALDO_CONTA;
    property ChequeNaoCompensado: Extended  read FCHEQUE_NAO_COMPENSADO write FCHEQUE_NAO_COMPENSADO;
    property SaldoDisponivel: Extended  read FSALDO_DISPONIVEL write FSALDO_DISPONIVEL;


    //Transientes



  end;

  TListaFinFechamentoCaixaBancoVO = specialize TFPGObjectList<TFinFechamentoCaixaBancoVO>;

implementation


initialization
  Classes.RegisterClass(TFinFechamentoCaixaBancoVO);

finalization
  Classes.UnRegisterClass(TFinFechamentoCaixaBancoVO);

end.
