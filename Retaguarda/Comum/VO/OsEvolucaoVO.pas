{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [OS_EVOLUCAO] 
                                                                                
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
unit OsEvolucaoVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL;

type
  TOsEvolucaoVO = class(TVO)
  private
    FID: Integer;
    FID_OS_ABERTURA: Integer;
    FDATA_REGISTRO: TDateTime;
    FHORA_REGISTRO: String;
    FOBSERVACAO: String;
    FENVIAR_EMAIL: String;

    //Usado no lado cliente para controlar quais registros ser�o persistidos
    FPersiste: String;



  published 
    property Id: Integer  read FID write FID;
    property IdOsAbertura: Integer  read FID_OS_ABERTURA write FID_OS_ABERTURA;
    property DataRegistro: TDateTime  read FDATA_REGISTRO write FDATA_REGISTRO;
    property HoraRegistro: String  read FHORA_REGISTRO write FHORA_REGISTRO;
    property Observacao: String  read FOBSERVACAO write FOBSERVACAO;
    property EnviarEmail: String  read FENVIAR_EMAIL write FENVIAR_EMAIL;


    //Transientes
    property Persiste: String  read FPersiste write FPersiste;



  end;

  TListaOsEvolucaoVO = specialize TFPGObjectList<TOsEvolucaoVO>;

implementation


initialization
  Classes.RegisterClass(TOsEvolucaoVO);

finalization
  Classes.UnRegisterClass(TOsEvolucaoVO);

end.
