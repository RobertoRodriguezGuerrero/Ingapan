'#################################################### 
' Funcion para pintar los iconos de pestañas de Partes
'####################################################
function CargarIconosParte(nmenu) 
	select case cstr(nmenu)
		case "0"
			this("MAP_BTIMGPARTE1")="#ffda6b"
			this("MAP_BTIMGPARTE2")="#ffda6b"

     				
		case "1"
			this("MAP_BTIMGPARTE1")="#f19d16"
			this("MAP_BTIMGPARTE2")="#ffda6b"


		case "2"
			this("MAP_BTIMGPARTE1")="#ffda6b"
			this("MAP_BTIMGPARTE2")="#f19d16"


	
		
   end select
  	
end function

'#################################################### 
' Funcion cargar los menus de edicion de Parte
'####################################################
function CargarGruposParte(nmenu) 
	select case cstr(nmenu)
		case "0"
				
		case "1"
			this("MAP_TABPARTE")=1
		case "2"
			this("MAP_TABPARTE")=2
				
		
  end select 	
end function

'******************************************************************************************
'****  Funcion para editar un parte o abrir un nuevo parte.
'******************************************************************************************
Function MenuPartes
		set objparte=AppData.GetCollection("Partes_Basic").findobject("CERRADO='N'")
		if objparte is nothing then
					  set Coll=AppData.GetCollection("Partes_Menu")
					  set Item=Coll.CreateObject
					  Coll.AddItem(Item)
					  if not Item is nothing then
						AppData.PushValue Item
					  end if
					  set Item=nothing
					  set Coll=nothing		
		else
		     		  LB_ShowForm "Partes_Menu",objparte("ID")
		end if
		
		

End function				

'******************************************************************************************
'****  Funcion para crear una nueva linea dentro de un parte
'******************************************************************************************
Function NuevaLineaParte
		set Coll=AppData.GetCollection("Lineas_Parte_Editar")
		  set Item=Coll.CreateObject
		  Coll.AddItem(Item)
		  if not Item is nothing then
			AppData.PushValue Item
			item("IDPARTE")=this("ID")
		  end if
		  set Item=nothing
		  set Coll=nothing
End function					  

'******************************************************************************************
'****  Funcion para Salvar una nueva linea dentro de un parte
'******************************************************************************************
Function SalvarLineaParte (st_IDLINEA)
	if this("MAP_CONCEPTO")<>"" and this("IMPORTE")>0 then
	    if this("MAP_GRUPO")="INVITACION" and this("INV_QUIEN")="" then
	        LB_Msg "Es necesario introducir el invitado al tratarse de una Invitacion"
	    else
		 		if LB_MsgYesNo ("Desea almacenar la linea de parte?") then
		                if this("MAP_TARJETA")="Tarjeta" then
		                   this("TARJETA")=1
		                else
		                   this("TARJETA")=0
		                end if
          		  		this.save
						LB_RemarcarRegistro "gen_lineasparte",this("ID")	          		  		
	          			appdata.failwithmessage -11888,"##EXIT##"
	     		end if
	     end if
	else
	     LB_Msg "Es necesario introducir un concepto y un importe"
	end if
end function
'******************************************************************************************
'****  Funcion para borrar una nueva linea dentro de un parte
'******************************************************************************************
Function BorrarLineaParte (st_IDLINEA)
 if LB_MsgYesNo ("Desea eliminar la linea seleccionada?"+cstr(st_IDLINEA)) then
	LB_RunSQLRep "UPDATE GEN_LINEASPARTE SET ITX_BAJA=1,ITX_XONE=1 where ID="+cstr(st_IDLINEA)
  end if
End function	