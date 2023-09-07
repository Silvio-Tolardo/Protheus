#include "protheus.ch"
#INCLUDE "parmtype.ch"
#INCLUDE "totvs.ch"
#INCLUDE "restful.ch"

WSRESTFUL TRCADUSER DESCRIPTION "Consulta cadastro user"

    WSMETHOD GET;
    DESCRIPTION "Retorna informação dos usuarios";
    WSSYNTAX "/TRCADUSER/{matricula}"

END WSRESTFUL

WSMETHOD GET WSSERVICE TRCADUSER

    Local cId := self:aURLParms[1]
    Local cCadastro :=jSonObject():new()
    Local cResponse :=jSonObject():new()

    LOCAL aAreaAnt := GETAREA()
    DBSelectArea("SB1")
    SB1->(DBSetOrder(1))
    SB1->(DBGOTO())

    cCadastro["matricula"]  :=alltrim(ZZ1->ZZ1_ID)
    cCadastro["nome"]  :=alltrim(ZZ1->ZZ1_NOME)
    cCadastro["cidade"]  :=alltrim(ZZ1->ZZ1_CIDADE)
    cCadastro["genero"]  :=alltrim(ZZ1->ZZ1_GENERO)

    cResponse := cCadastro:toJson()

    self:SetContenType("application/json")

    self:SetResponse(EncodeUtf8(cResponse))

return .T.
