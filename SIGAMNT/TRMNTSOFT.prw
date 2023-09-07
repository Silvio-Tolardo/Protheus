#Include "TOTVS.ch"
#INCLUDE "Protheus.ch"
/*
Integração com SoftDesk
*/
User Function postSoft(nCham,cDesc)
    Local cError as Character
    Local cStatus as Character
    Local cJson as Character
    Local lRet := .T.

    Local aArea     := GetArea()
    Local aAreaTJ   := SX6->(GetArea())

    Local cURI      := GETMV("TR_SOFTURL") //"https://suporte.ceramfix.com.br/homologacao" 
    Local cResource := GETMV("TR_SOFTPNT") //"/api/api.php/atividade-chamado"                 
    Local cSoftKey  := GETMV("TR_SOFTKEY ")
    Local cAtend    := GETMV("TR_SOFTAT" )
    Local oRest     := FwRest():New(cURI)                           
    
    Local aHeader   := {}  

    Aadd(aHeader, (cSoftKey)/*("hash-api: h!ftCujhkTFnvtPBkSpzdgUaCh6F6WF")*/)
    //AAdd(aHeader, "Content-Type: application/json; charset=UTF-8")
    AAdd(aHeader,  "Content-Type: application/json; charset=iso-8859-1")
    AAdd(aHeader, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")

    
    oRest:SetPath(cResource)
    oRest:SetPostParams(GetJson(nCham, cDesc, cAtend))

    If (oRest:Post(aHeader))
        ConOut("POST: " + oRest:GetResult())
    Else
        ConOut("POST: " + oRest:GetLastError())
        cError  := oRest:GetLastError()
        cAlert :=  oRest:GetResult()
        cStatus := oRest:GetHTTPCode()
        cJson   := GetJson()
        lRet := .F.
    EndIf

    RestArea(aAreaTJ)
    RestArea(aArea)

Return (lRet)

Static Function GetJson(N1, N2, cAtend)
    Local bObject := {|| JsonObject():New()}
    Local oJson   := Eval(bObject)
    
    oJson["codigo_chamado"]                     := N1
    oJson["descricao"]                          := N2
    oJson["atendente"]                          := cAtend
    oJson["status_chamado"]                     := "encerrado"
    
Return (oJson:ToJson())
