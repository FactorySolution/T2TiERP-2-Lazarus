{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: VO relacionado � tabela [FUNCAO]
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2010 T2Ti.COM                                          
                                                                                
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
           t2ti.com@gmail.com</p>                                               
                                                                                
@author Albert Eije (T2Ti.COM)                                                  
@version 1.0                                                                    
*******************************************************************************}
unit FuncaoVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL;

type
  TFuncaoVO = class(TVO)
  private
    FID: Integer;
    FFORMULARIO: String;
    FNOME: String;
    FDescricao: String;
    FHabilitado: String;

  published
    property Id: Integer  read FID write FID;
    property Nome: String  read FNOME write FNOME;
    property Formulario: String  read FFORMULARIO write FFORMULARIO;

    property Descricao: String  read FDescricao write FDescricao;
    property Habilitado: string  read FHabilitado write FHabilitado;
  end;

  TListaFuncaoVO = specialize TFPGObjectList<TFuncaoVO>;

implementation

initialization
  Classes.RegisterClass(TFuncaoVO);

finalization
  Classes.UnRegisterClass(TFuncaoVO);

end.
