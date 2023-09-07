#include 'protheus.ch'
#INCLUDE "totvs.ch"

/*
MSdialog criado para a fim de teste Prospera Sistema.
*/

User Function TrProspera()
   
   Local cNome 
   cNome := GetUser("Insira seu cadastro")

Return

   static Function GetUser(cTitulo)

      Local oDlg
      Local oGet
      Local oBtn1,oBtn2

      Local cNome     := space(130)
      Local cTel      := space(11)

      Local acSexoP := {} 
      aAdd(acSexoP , "")
      aAdd(acSexoP , "Masculino")
      aAdd(acSexoP , "Feminino")
      Local cOpcao := ' '

      Local cCidade     := Space(TamSX3('CC2_MUN')[1])   
      Local cCodCid      
      Local cFontNome   := 'Tahoma'
      Local oFontPadrao := TFont():New(cFontNome, , -12)

      Local cExit := .F.
      //Local cId
      DEFINE DIALOG oDlg TITLE (cTitulo) ;
         FROM 0,0 TO 200,400 ;      
         COLOR CLR_BLACK, CLR_WHITE PIXEL

         @ 05,05 SAY oGet PROMPT "Nome: " SIZE 200,8 OF oDlg PIXEL 
         @ 05,30 GET oGet VAR cNome SIZE 150,8 OF oDlg PIXEL PICTURE ("!@")

         @ 18,05 SAY oGet PROMPT "Telefone: " SIZE 200,12 OF oDlg PIXEL 
         @ 18,30 Get oGet VAR cTel SIZE 60,8 OF oDlg PIXEL PICTURE ("@R 99-99999-9999")

         @ 31,05 SAY oGet PROMPT "Sexo: " SIZE 200,12 OF oDlg PIXEL 
         @ 31,30 MSCOMBOBOX oGet VAR cOpcao ITEMS acSexoP SIZE 60,12 OF oDlg PIXEL COLORS 0, 16777215

         @ 44,05 SAY oGet PROMPT "Cidade: " SIZE 200,12 OF oDlg PIXEL 
         //@ 44,70 Get oGet VAR cCid SIZE 35,8 OF oDlg PIXEL PICTURE ("!@")
         oGet  := TGet():New(44, 30, {|u| Iif(PCount() > 0 , cCidade := u, cCidade)}, oDlg, 120, 8,,,,, oFontPadrao, , , .T. )
         oGet:cF3        := 'CC2'

         @ 80,05  BUTTON oBtn1 PROMPT "Confirmar" SIZE 40,15 ; 
                  ACTION (oDlg:End()) OF oDlg PIXEL 

         @ 80,50  BUTTON oBtn2 PROMPT "Voltar" SIZE 40,15 ; 
                  ACTION (cExit := .T. , oDlg:End()) OF oDlg PIXEL 


      ACTIVATE DIALOG oDlg CENTER

      if cExit = .T.
         return 
      endif

      if empty(cNome)  
         MsgStop("Nome não informado, cadastro nao realizado!","Atenção")
         GetUser("Insira seu cadastro")
      else   
          id := zzRec(cNome,cTel,cCodCid,cOpcao,cCidade)
         MsgInfo("Cadastro realizado, Matricula: "+id,"Prospera Sistemas")
         GetUser("Insira seu cadastro")
      endif
      

   Return cNome
   
   static Function zzRec(cNome,cTel,cCodCid,cOpcao,cCidade)
 
         DBSelectArea("ZZ1")
         RECLOCK( "ZZ1", .T. )

         Local vId := cValToChar(calcSeq())
         Local vNome := cNome
         Local vTel := cTel
         Local vCodCid := cCodCid
         Local vOpcao := cOpcao
         Local vCidade :=cCidade
         
            ZZ1->ZZ1_FILIAL := xFilial("ZZ1")
            ZZ1->ZZ1_ID := vId
            ZZ1->ZZ1_NOME := vNome
            ZZ1->ZZ1_TEL := vTel
            ZZ1->ZZ1_CODCID := vCodCid
            ZZ1->ZZ1_CIDADE := vCidade
            ZZ1->ZZ1_GENERO := vOpcao
            ZZ1->(MSUNLOCK())

   return vId

   static function calcSeq()
         
      local cQuery as char
      local cSeq as char
      local cAlias as char

      cAlias := Alias()
      cQuery := GetNextAlias()

         BeginSQL alias cQuery
            SELECT MAX(ZZ1_ID) SEQ_MAX
               FROM %table:ZZ1%
            WHERE ZZ1_FILIAL = %xfilial:ZZ1%
               AND %notDel%
         EndSQL

      if !(cQuery)->(Eof())
         cSeq := (cQuery)->SEQ_MAX 
         cSeq := val(cSeq) + 1
      else
         cSeq := ""
      endif

      (cQuery)->(DBCloseArea())

      if !Empty(cAlias)
         DBSelectArea(cAlias)
      endif

   return cSeq

   