#INCLUDE "Totvs.ch"
#INCLUDE "Protheus.ch"
/*
Ponto entrada utilizado para chamada integração com SoftDesk
*/

User Function MNTA4352() 
    Local nRetorno  := ParamIXB[1]
    Local lRet := .T.
    Local aArea     := GetArea()
    Local aAreaTJ   := STJ->(GetArea())
    
     
    local pOrdem := ""
    Local pDesc := ""
    Local pCham := ""

    

    pOrdem := Alltrim(STJ->TJ_ORDEM) 
    pDesc  := Alltrim(STJ->TJ_OBSERVA) 
    pCham  := Alltrim(STJ->TJ_CHAMADO)

    if pCham <> ""
    
         lRet := u_postSoft(pCham,FwNoAccent(pDesc))
         
         if lRet == .F.
            If MsgYesNo("Numero chamado "+ pCham +" nao encontrado, deseja continuar? " , "Confirma?")
                
                nRetorno := 1
            Else
                nRetorno := 2
            EndIf
        endif
    endif
    
    RestArea(aAreaTJ)
    RestArea(aArea)
    
Return nRetorno
