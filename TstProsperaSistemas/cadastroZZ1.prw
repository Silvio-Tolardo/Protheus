#include 'protheus.ch'
#INCLUDE "totvs.ch"

/*
Fonte utilizado para fazer criação tabela customizada ZZ1
*/

user function cadZZ1()

    Local cAlias := "ZZ1"
    Local cTitulo := "Usuarios"
    Local cVldAlt := ".T."
    Local cVldExc := ".T."

    //Local lRet 
    //lRet := U_TrProspera()
    AxCadastro(cAlias,  cTitulo, cVldExc, cVldAlt)
    


return
