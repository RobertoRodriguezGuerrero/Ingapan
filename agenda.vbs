'#################################################### 
' Funcion que crea un nuevo registro de Agenda
'####################################################
Function NuevaAgenda
						  set Coll=AppData.GetCollection("Agenda_Editar")
						  set Item=Coll.CreateObject
					      Coll.AddItem(Item)
						  if not Item is nothing then
						    Item("FECHA_VISITA")=left(this("MAP_FECHACALENDAR"),10)+" "	+left(right(now,8),5)		    
							AppData.PushValue Item
						  end if
						  set Item=nothing
						  set Coll=nothing
end function

'#################################################### 
' Funcion para cambiar el modo calendario visible en el menu principal
'####################################################
Function CambiarModoCalendario
            		if this("MAP_CALENDARMODE")=1 then
					 this("MAP_CALENDARMODE")=2
					else
					 this("MAP_CALENDARMODE")=1
					end if
end function	


'#################################################### 
' Funcion con acciones que se ejecutan en el before-edit (paramatro=1) o create (parametro=0) de la agenda
'####################################################
Function EditarAgenda (edit)
	if edit=1 then
				'Cargamos datos de barra de estado
				this("MAP_DATOSESTADO")=CargarBarraEstado()	
				this("MAP_LABELCABECERA")="INGAPAN Mobile CRM  -  Edicion Visita"	
				this("MAP_LABELCABECERA2")="INGAPAN Mobile CRM  -  Nueva Visita  -  Seleccion Cliente"	
				if this("FECHA_FIN") is null then
					this("MAP_CERRADO")=0
				else
				    this("MAP_CERRADO")=1
				    this("MAP_HORAFIN")=left(right(this("FECHA_FIN"),8),5)
				end if
				this("MAP_HORAVISITA")=left(right(this("FECHA_VISITA"),8),5)
   else
				'Cargamos datos de barra de estado
				this("MAP_DATOSESTADO")=CargarBarraEstado()	
				this("MAP_LABELCABECERA")="INGAPAN Mobile CRM  -  Nueva Visita"	
				this("MAP_LABELCABECERA2")="INGAPAN Mobile CRM  -  Nueva Visita  -  Seleccion Cliente"						
				this("MAP_HORAVISITA")=left(right(this("FECHA_VISITA"),8),5)
    end if				

End function		

'#################################################### 
' Funcion para salir del menu agenda
'####################################################
Function SalirAgenda
                 if this("MAP_CERRADO")=1 then
                   appdata.failwithmessage -11888,"##EXIT##"
                 else
                    if LB_MsgYesNo ("Desea anular la cita actual?") then                        
                        if this("ID")>0 then
                           this("ITX_BAJA")=1
                           this.Save
                           LB_RemarcarRegistro "gen_agenda",this("ID")
                        end if
	          			appdata.failwithmessage -11888,"##EXIT##"
	          	    end if
	          	 end if
end function	

'#################################################### 
' Funcion para salvar del menu agenda
'####################################################
Function SalvarAgenda
              if this("IDCLIENTE")=0 and this("NOMBRE_VISITA")="" then
                     LB_Msg "Es necesario seleccionar un cliente para almacenar la cita" 
              else
          			if LB_MsgYesNo ("Desea salir almacenando los cambios?") then
          			   this("FECHA_VISITA")=left(this("FECHA_VISITA"),10) +" "+ this("MAP_HORAVISITA")
          			   this.save          
          			   LB_RemarcarRegistro "gen_agenda",this("ID")
          			   appdata.failwithmessage -11888,"##EXIT##"
          			end if
          	  end if
end function	 

'#################################################### 
' Funcion para finalizar del menu agenda
'####################################################
Function FinalizarAgenda
              if this("IDCLIENTE")=0 and this("NOMBRE_VISITA")="" then
                     LB_Msg "Es necesario seleccionar un cliente para finalizar la cita" 
              else
          			if LB_MsgYesNo ("Desea finalizar la visita?") then
          			   this("FECHA_VISITA")=left(this("FECHA_VISITA"),10) +" "+ this("MAP_HORAVISITA")
          			   if this("FECHA_FIN") is null or this("MAP_HORAFIN") is null then
          			      this("FECHA_FIN")=now          			      
          			   else
          			      this("FECHA_FIN")=left(this("FECHA_FIN"),10) +" "+ this("MAP_HORAFIN")
          			   end if
          			   this.save
                       LB_RemarcarRegistro "gen_agenda",this("ID")          			   
          			   appdata.failwithmessage -11888,"##EXIT##"
          			end if
          	  end if
end function	

'#################################################### 
' Funcion que crea un nuevo registro de Adjunto Agenda
'####################################################
Function NuevoAdjuntoAgenda

						  this.save
						  set Coll=this.contents("AdjuntosAgenda_Contents")
						  set Item=Coll.CreateObject
					      Coll.AddItem(Item)
						  if not Item is nothing then
						    Item("IDAGENDA")=this("ID")		             		
							Item("PATH")=this("MAP_ADJUNTARFICHERO")
							Item.save	
							LB_RemarcarRegistro "gen_adjuntosagenda",Item("ID")							
						  end if
						  set Item=nothing
						  set Coll=nothing
						  this("MAP_ADJUNTARFICHERO")=""
						  this.contents("AdjuntosAgenda_Contents").loadall
end function
