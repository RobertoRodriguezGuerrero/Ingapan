'#################################################### 
' Funcion que carga la informacion de la pantalla principal
'####################################################
Function CreateMenuPrincipal
				'Cargamos datos de barra de estado
				this("MAP_DATOSESTADO")=CargarBarraEstado()		
				'Cargamos iconos de menus y pestañas virtuales
				CargarIconosMenu 0
				CargarIconosEstadisticas 1
				CargarGruposEstadisticas 1	
				CargarIconosDocumentos 1
				CargarGruposDocumentos 1					
				this("MAP_BUTTONSELECT")=0	
				this("MAP_CALENDARMODE")=1	
				this("MAP_FECHACALENDAR")=now
				this("MAP_TAB")=99
				LB_ShowGroup 99
end function

'#################################################### 
' Funcion que devuelve los datos a mostrar en barra de estado
'####################################################
function CargarBarraEstado() 
  st_text=""
  Set coll=appdata.getcollection("UsuariosScript")
  coll.filter="t1.ID=##USERID##"
  coll.startbrowse
  if not coll.currentitem is nothing then
  		
  		st_text="IMEI: "+cstr(coll.CurrentItem("MAP_IMEI"))+" / Usuario: "+cstr(coll.currentitem("LOGIN"))+" /  Lic: "+replace(cstr(coll.currentitem("MAP_MID")),"'","")+" /  App: "+cstr(coll.currentitem("MAP_VERSIONAPP"))+" /  Framework: "+cstr(coll.currentitem("MAP_VERSIONFRAMEWORK"))+" /  BD: "+cstr(coll.currentitem("MAP_VERSIONBD"))
  end if
  coll.endbrowse
  set coll=nothing  

  CargarBarraEstado=st_text
  	
end function

'#################################################### 
' Funcion para pintar los iconos del menu principal
'####################################################
function CargarIconosMenu(nmenu) 
	select case cstr(nmenu)
		case "0"
			this("MAP_BTIMG1")="bt-calendar2-grey.png"
			this("MAP_BTIMG2")="bt-clientes-grey.png"
			this("MAP_BTIMG3")="bt-estadis-grey.png"
			this("MAP_BTIMG4")="bt-pedido-grey.png"
			this("MAP_BTIMG5")="bt-parte-grey.png"
			this("MAP_BTIMG6")="bt-doc-grey.png"
			this("MAP_BTIMG7")="bt-alert-grey.png"      				
			this("MAP_BTIMG8")="bt-web-grey.png"
		case "1"
			this("MAP_BTIMG1")="bt-calendar2-black.png"
			this("MAP_BTIMG2")="bt-clientes-grey.png"
			this("MAP_BTIMG3")="bt-estadis-grey.png"
			this("MAP_BTIMG4")="bt-pedido-grey.png"
			this("MAP_BTIMG5")="bt-parte-grey.png"
			this("MAP_BTIMG6")="bt-doc-grey.png"
			this("MAP_BTIMG7")="bt-alert-grey.png"
			this("MAP_BTIMG8")="bt-web-grey.png"
		case "2"
			this("MAP_BTIMG1")="bt-calendar2-grey.png"
			this("MAP_BTIMG2")="bt-clientes-black.png"
			this("MAP_BTIMG3")="bt-estadis-grey.png"
			this("MAP_BTIMG4")="bt-pedido-grey.png"
			this("MAP_BTIMG5")="bt-parte-grey.png"
			this("MAP_BTIMG6")="bt-doc-grey.png"
			this("MAP_BTIMG7")="bt-alert-grey.png"		
			this("MAP_BTIMG8")="bt-web-grey.png"
		case "3"
			this("MAP_BTIMG1")="bt-calendar2-grey.png"
			this("MAP_BTIMG2")="bt-clientes-grey.png"
			this("MAP_BTIMG3")="bt-estadis-black.png"
			this("MAP_BTIMG4")="bt-pedido-grey.png"
			this("MAP_BTIMG5")="bt-parte-grey.png"
			this("MAP_BTIMG6")="bt-doc-grey.png"
			this("MAP_BTIMG7")="bt-alert-grey.png"		
			this("MAP_BTIMG8")="bt-web-grey.png"
		case "4"
			this("MAP_BTIMG1")="bt-calendar2-grey.png"
			this("MAP_BTIMG2")="bt-clientes-grey.png"
			this("MAP_BTIMG3")="bt-estadis-grey.png"
			this("MAP_BTIMG4")="bt-pedido-black.png"
			this("MAP_BTIMG5")="bt-parte-grey.png"
			this("MAP_BTIMG6")="bt-doc-grey.png"
			this("MAP_BTIMG7")="bt-alert-grey.png"		
			this("MAP_BTIMG8")="bt-web-grey.png"
		case "5"
			this("MAP_BTIMG1")="bt-calendar2-grey.png"
			this("MAP_BTIMG2")="bt-clientes-grey.png"
			this("MAP_BTIMG3")="bt-estadis-grey.png"
			this("MAP_BTIMG4")="bt-pedido-grey.png"
			this("MAP_BTIMG5")="bt-parte-black.png"
			this("MAP_BTIMG6")="bt-doc-grey.png"
			this("MAP_BTIMG7")="bt-alert-grey.png"		
			this("MAP_BTIMG8")="bt-web-grey.png"
		case "6"
			this("MAP_BTIMG1")="bt-calendar2-grey.png"
			this("MAP_BTIMG2")="bt-clientes-grey.png"
			this("MAP_BTIMG3")="bt-estadis-grey.png"
			this("MAP_BTIMG4")="bt-pedido-grey.png"
			this("MAP_BTIMG5")="bt-parte-grey.png"
			this("MAP_BTIMG6")="bt-doc-black.png"
			this("MAP_BTIMG7")="bt-alert-grey.png"		
			this("MAP_BTIMG8")="bt-web-grey.png"
		case "7"
			this("MAP_BTIMG1")="bt-calendar2-grey.png"
			this("MAP_BTIMG2")="bt-clientes-grey.png"
			this("MAP_BTIMG3")="bt-estadis-grey.png"
			this("MAP_BTIMG4")="bt-pedido-grey.png"
			this("MAP_BTIMG5")="bt-parte-grey.png"
			this("MAP_BTIMG6")="bt-doc-grey.png"
			this("MAP_BTIMG7")="bt-alert-black.png"
			this("MAP_BTIMG8")="bt-web-grey.png"
		case "8"
			this("MAP_BTIMG1")="bt-calendar2-grey.png"
			this("MAP_BTIMG2")="bt-clientes-grey.png"
			this("MAP_BTIMG3")="bt-estadis-grey.png"
			this("MAP_BTIMG4")="bt-pedido-grey.png"
			this("MAP_BTIMG5")="bt-parte-grey.png"
			this("MAP_BTIMG6")="bt-doc-grey.png"
			this("MAP_BTIMG7")="bt-alert-grey.png"
			this("MAP_BTIMG8")="bt-web-black.png"

end select
  	
end function



'#################################################### 
' Funcion cargar los menus principales
'####################################################
function CargarMenu(nmenu) 
	select case cstr(nmenu)
		case "0"
				
		case "1"
			this("MAP_TAB")=1
			LB_ShowGroup 1
		case "2"
			this("MAP_TAB")=2
			LB_ShowGroup 2
		case "3"
			this("MAP_TAB")=3
			LB_ShowGroup 3	
		case "4" 			
			LB_ShowForm "Pedidos_Menu",-1
			this("MAP_TAB")=99
			LB_ShowGroup 99
 			CargarIconosMenu(0)			
		case "5"
			MenuPartes
			this("MAP_TAB")=99
			LB_ShowGroup 99
 			CargarIconosMenu(0) 			
		case "6"
			this("MAP_TAB")=6		
			LB_ShowGroup 6
		case "7"
			this("MAP_TAB")=7
			LB_ShowGroup 7
		case "8"
			this("MAP_TAB")=8
			LB_ShowGroup 8	
			RefreshReplica			
			
  end select 	        
end function

'#################################################### 
' Funcion para pintar los iconos de pestañas de clientes
'####################################################
function CargarIconosCliente(nmenu) 
	select case cstr(nmenu)
		case "0"
			this("MAP_BTIMGCLI1")="#ffda6b"
			this("MAP_BTIMGCLI2")="#ffda6b"
			this("MAP_BTIMGCLI3")="#ffda6b"
			this("MAP_BTIMGCLI4")="#ffda6b"
			this("MAP_BTIMGCLI5")="#ffda6b"
			this("MAP_BTIMGCLI6")="#ffda6b"
			this("MAP_BTIMGCLI7")="#ffda6b"      				
		case "1"
			this("MAP_BTIMGCLI1")="#f19d16"
			this("MAP_BTIMGCLI2")="#ffda6b"
			this("MAP_BTIMGCLI3")="#ffda6b"
			this("MAP_BTIMGCLI4")="#ffda6b"
			this("MAP_BTIMGCLI5")="#ffda6b"
			this("MAP_BTIMGCLI6")="#ffda6b"
			this("MAP_BTIMGCLI7")="#ffda6b"
		case "2"
			this("MAP_BTIMGCLI1")="#ffda6b"
			this("MAP_BTIMGCLI2")="#f19d16"
			this("MAP_BTIMGCLI3")="#ffda6b"
			this("MAP_BTIMGCLI4")="#ffda6b"
			this("MAP_BTIMGCLI5")="#ffda6b"
			this("MAP_BTIMGCLI6")="#ffda6b"
			this("MAP_BTIMGCLI7")="#ffda6b"		
		case "3"
			this("MAP_BTIMGCLI1")="#ffda6b"
			this("MAP_BTIMGCLI2")="#ffda6b"
			this("MAP_BTIMGCLI3")="#f19d16"
			this("MAP_BTIMGCLI4")="#ffda6b"
			this("MAP_BTIMGCLI5")="#ffda6b"
			this("MAP_BTIMGCLI6")="#ffda6b"
			this("MAP_BTIMGCLI7")="#ffda6b"		
		case "4"
			this("MAP_BTIMGCLI1")="#ffda6b"
			this("MAP_BTIMGCLI2")="#ffda6b"
			this("MAP_BTIMGCLI3")="#ffda6b"
			this("MAP_BTIMGCLI4")="#f19d16"
			this("MAP_BTIMGCLI5")="#ffda6b"
			this("MAP_BTIMGCLI6")="#ffda6b"
			this("MAP_BTIMGCLI7")="#ffda6b"		
		case "5"
			this("MAP_BTIMGCLI1")="#ffda6b"
			this("MAP_BTIMGCLI2")="#ffda6b"
			this("MAP_BTIMGCLI3")="#ffda6b"
			this("MAP_BTIMGCLI4")="#ffda6b"
			this("MAP_BTIMGCLI5")="#f19d16"
			this("MAP_BTIMGCLI6")="#ffda6b"
			this("MAP_BTIMGCLI7")="#ffda6b"		
		case "6"
			this("MAP_BTIMGCLI1")="#ffda6b"
			this("MAP_BTIMGCLI2")="#ffda6b"
			this("MAP_BTIMGCLI3")="#ffda6b"
			this("MAP_BTIMGCLI4")="#ffda6b"
			this("MAP_BTIMGCLI5")="#ffda6b"
			this("MAP_BTIMGCLI6")="#f19d16"
			this("MAP_BTIMGCLI7")="#ffda6b"		
		case "7"
			this("MAP_BTIMGCLI1")="#ffda6b"
			this("MAP_BTIMGCLI2")="#ffda6b"
			this("MAP_BTIMGCLI3")="#ffda6b"
			this("MAP_BTIMGCLI4")="#ffda6b"
			this("MAP_BTIMGCLI5")="#ffda6b"
			this("MAP_BTIMGCLI6")="#ffda6b"
			this("MAP_BTIMGCLI7")="#f19d16"
   end select
  	
end function

'#################################################### 
' Funcion cargar los menus de edicion de cliente
'####################################################
function CargarGruposCliente(nmenu) 
	select case cstr(nmenu)
		case "0"
				 
		case "1"
			this("MAP_TABCLI")=1
		case "2"
			this("MAP_TABCLI")=2
		case "3"
			this("MAP_TABCLI")=3				
		case "4"
			this("MAP_TABCLI")=4				
		case "5"
			
			'Cargamos direccion de QLikView
			 CargaQLikViewCliente
			 ui.refresh "MAP_LIKVIEW"
			 this("MAP_TABCLI")=5				 
		case "6"
			this("MAP_TABCLI")=6			
		case "7"
			this("MAP_TABCLI")=7			
  end select 	
end function




'#################################################### 
' Funcion para pintar los iconos de pestañas de estadisticas
'####################################################
function CargarIconosEstadisticas(nmenu) 
	select case cstr(nmenu)
		case "0"
			this("MAP_BTIMGEST1")="#ffda6b"
			this("MAP_BTIMGEST2")="#ffda6b"
     				
		case "1"
			this("MAP_BTIMGEST1")="#f19d16"
			this("MAP_BTIMGEST2")="#ffda6b"
			this("MAP_BTIMGEST3")="#ffda6b"
		case "2"
			this("MAP_BTIMGEST1")="#ffda6b"
			this("MAP_BTIMGEST2")="#f19d16"
			this("MAP_BTIMGEST3")="#ffda6b"			
		case "3"
			this("MAP_BTIMGEST1")="#ffda6b"
			this("MAP_BTIMGEST2")="#ffda6b"
			this("MAP_BTIMGEST3")="#f19d16"			
			
   end select
  	
end function

'#################################################### 
' Funcion cargar los menus de estadisticas
'####################################################
function CargarGruposEstadisticas(nmenu) 
	select case cstr(nmenu)
		case "0"
				
		case "1"
			this("MAP_TABESTADISTICAS")=1
		case "2"
			this("MAP_TABESTADISTICAS")=2			
		case "3"
			this("MAP_TABESTADISTICAS")=3
			'Cargamos el qlikview
			CargaQLikView
			ui.refresh "MAP_LIKVIEWESTADISTICAS"				
  end select 	
end function

'#################################################### 
' Funcion para pintar los iconos de pestañas de Documentos
'####################################################
function CargarIconosDocumentos(nmenu) 
	select case cstr(nmenu)
		case "0"
			this("MAP_BTIMGDOC1")="#ffda6b"
			this("MAP_BTIMGDOC2")="#ffda6b"
			this("MAP_BTIMGDOC3")="#ffda6b"
			this("MAP_BTIMGDOC4")="#ffda6b"			
     				
		case "1"
			this("MAP_BTIMGDOC1")="#f19d16"
			this("MAP_BTIMGDOC2")="#ffda6b"
			this("MAP_BTIMGDOC3")="#ffda6b"
			this("MAP_BTIMGDOC4")="#ffda6b"			

		case "2"
			this("MAP_BTIMGDOC1")="#ffda6b"
			this("MAP_BTIMGDOC2")="#f19d16"
			this("MAP_BTIMGDOC3")="#ffda6b"
			this("MAP_BTIMGDOC4")="#ffda6b"

		case "3"
			this("MAP_BTIMGDOC1")="#ffda6b"
			this("MAP_BTIMGDOC2")="#ffda6b"
			this("MAP_BTIMGDOC3")="#f19d16"
			this("MAP_BTIMGDOC4")="#ffda6b"			

		case "4"
			this("MAP_BTIMGDOC1")="#ffda6b"
			this("MAP_BTIMGDOC2")="#ffda6b"
			this("MAP_BTIMGDOC3")="#ffda6b"
			this("MAP_BTIMGDOC4")="#f19d16"
   end select
  	
end function

'#################################################### 
' Funcion cargar los menus de documentos
'####################################################
function CargarGruposDocumentos(nmenu) 
	select case cstr(nmenu)
		case "0"
				
		case "1"
			this("MAP_TABDOCUMENTOS")=1
		case "2"
			this("MAP_TABDOCUMENTOS")=2
		case "3"
			this("MAP_TABDOCUMENTOS")=3
		case "4"
			this("MAP_TABDOCUMENTOS")=4
  end select 	
end function