#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Include <GUIEdit.au3>
#Include <ScrollBarConstants.au3>

#include <Date.au3>
#notrayicon
#Region ### START Koda GUI section ### Form=Z:\Projetos\AutoIT\Monitor de Internet\frmPrincipal.kxf
$frmPrincipal = GUICreate("Monitor de Internet", 285, 301, -1, -1)
GUISetIcon("Z:\Imagens\Icones\iceevil3d.ico", -1)
$lblLigadoDesdeLabel = GUICtrlCreateLabel("Ligado desde:", 8, 8, 71, 17)
$lblLigadoDesde = GUICtrlCreateLabel("Obtendo....", 80, 8, 180, 17)
$lblPacotesSucessoLabel = GUICtrlCreateLabel("Pacotes sucesso:", 8, 24, 88, 17)
$lblPacotesSucesso = GUICtrlCreateLabel("0", 104, 24, 180, 17)
$lblPacotesFalhaLabel = GUICtrlCreateLabel("Pacotes falha:", 8, 40, 72, 17)
$lblPacotesFalha = GUICtrlCreateLabel("0", 80, 40, 180, 17)
$lblPorcentagemFalhaLabel = GUICtrlCreateLabel("Percentagem de falha:", 8, 56, 120, 17)
$lblPorcentagemFalha = GUICtrlCreateLabel("0%", 118, 56, 250, 17)
$lbxLog = GUICtrlCreateEdit("", 0, 75, 284, 225, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
GUICtrlSetData(-1, "Inicializando....")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$contErro = 0
$contErroInternet = 0;
$contErroModem = 0;
$contSucesso = 0
GUICtrlSetData($lbxLog, @CRLF & "Inicializado em " & _Now(), 1)
GUICtrlSetData($lblLigadoDesde, _Now())

While 1

   $ret = _GetDOSOutput("ping 8.8.8.8 -n 10 -l 256 -w 1500 > NUL && echo 1")
   If $ret <> 1 Then
	  $contErro += 1

 	  $ret = _GetDOSOutput("ping 192.168.1.1 -n 10 -l 256 -w 1500 > NUL && echo 1")
 	  If $ret <> 1 Then
 		 $reason = "Modem offline"
		 $contErroModem += 1
 	  Else
 		 $reason = "Falha na internet"
		 $contErroInternet += 1
 	  EndIf

 	  GUICtrlSetData($lbxLog, @CRLF & $reason & " em " & _Now(), 1)

 	  GUICtrlSetData($lblPacotesFalha, $contErro)
 	  Sleep(3750)
   Else
 		$contSucesso += 1
 		GUICtrlSetData($lblPacotesSucesso, $contSucesso)
   EndIf

   If $contSucesso > 0 Then
	  $porcentagem_de_falha = Round(($contErro / $contSucesso) * 100, 1)
   Else
	  If $contErro > $contSucesso Then
		 $porcentagem_de_falha = 100
	  Else
		 $porcentagem_de_falha = 0
	  EndIf
   EndIf

   If $contErroModem > 0 Then
	  $porcentagem_de_falha_internet = Round(($contErroInternet / $contErroModem) * 100, 1)
   Else
	  If $contErroInternet > $contErroModem Then
		 $porcentagem_de_falha_internet = 100
	  Else
		 $porcentagem_de_falha_internet = 0
	  EndIf
   EndIf

   GUICtrlSetData($lblPorcentagemFalha, $porcentagem_de_falha & "% | Culpa do Provedor em " &  $porcentagem_de_falha_internet & "%")

 	$nMsg = GUIGetMsg()
 	Switch $nMsg
 		Case $GUI_EVENT_CLOSE
			GUISetState(@SW_MINIMIZE)

 	EndSwitch

WEnd

Func _GetDOSOutput($sCommand)
    Local $iPID, $sOutput = ""
    $iPID = Run('"' & @ComSpec & '" /c ' & $sCommand, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	$cont = 0
    While 1
        $sOutput &= StdoutRead($iPID, False, False)
        If @error or ($cont > 1000) Then
            ExitLoop
        EndIf
        Sleep(10)
		$cont = $cont + 1
    WEnd
    Return $sOutput
EndFunc   ;==>_GetDOSOutput

