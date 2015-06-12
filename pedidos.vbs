'#################################################### 
' Funcion para crear nuevo pedido
'####################################################
Function CreatePedido
				'Cargamos datos de barra de estado
				this("MAP_DATOSESTADO")=CargarBarraEstado()		
				this("MAP_LBCABECERA1")="INGAPAN Mobile CRM -  PEDIDOS (Seleccionar Cliente)"
				CargarIconosPedido 1
				CargarGruposPedido 1
				'Calculamos Numero de Pedido
				NumeroPedido this
				this.contents("Catalogo_Contents_Pedido").filter="1=0"
				this.contents("Catalogo_Contents_Pedido").lock
				this.save
				
end function

'#################################################### 
' Funcion para cancelar pedido
'####################################################
Function CancelarPedido
          		    if LB_MsgYesNo ("Desea cerrar el pedido si guardarlo?") then
          		        this("ITX_BAJA")=1
          		        this("N_PEDIDO")="BAJA"
          		        this.save
          		        
	          			appdata.failwithmessage -11888,"##EXIT##"
	          	    end if
end function

'#################################################### 
' Funcion para Finalizar pedido
'####################################################
Function FinalizarPedido
On error resume next
          		    if LB_MsgYesNo ("Desea finalizar el pedido?") then
          		        if this("IDCLIENTE")=0 then
          		           LB_Msg "Es obligatorio seleccionar un cliente"
          		        else
	          		        this("ITX_BAJA")=0
	          		        ConfirmarNumeroPedido this
	          		        this.save
 							LB_RemarcarRegistro "gen_pedidoscab",this("ID")	 	          		        
	          		        'Incluimos numeros de linea
							   Set colpedlin=appdata.GetCollection("PedidosLin_Basic")
							   colpedlin.filter="(t1.ITX_BAJA=0 or t1.ITX_BAJA is null) and t1.IDPEDIDO="+cstr(this("ID"))
							   colpedlin.startbrowse
							   i=0
							   while not colpedlin.currentitem is nothing 
							      i=i+1
							      set objpedlin = colpedlin.currentitem
							      objpedlin("N_LIN")=i
							      objpedlin("ITX_XONE")=1
							      objpedlin.save
								  colpedlin.movenext						      
							   wend
							   colpedlin.endbrowse
							   colpedlin.clear
	          		        
         		            'Enviamos email
         		            ui.SendMail "informatica@ingapan.com","informatica@ingapan.com","Pedido CRM Ingapan: "+cstr(this("N_PEDIDO"))+"/  Usuario: "+cstr(this("MAP_USUARIO")), "Pedido finalizado en CRM Ingapan XOne: "+chr(10)+chr(13)+chr(10)+chr(13)+"  Usuario: "+cstr(this("MAP_USUARIO"))+chr(10)+chr(13)+"  Nº Pedido: "+cstr(this("N_PEDIDO"))+chr(10)+chr(13)+"  Cliente: "+cstr(this("MAP_NOMBRE_CLIENTE"))+chr(10)+chr(13)+chr(10)+chr(13)+"Pedido finalizado con exito.", ""
		          			appdata.failwithmessage -11888,"##EXIT##"
	          			end if
	          	    end if
end function

'#################################################### 
' Funcion para pintar los iconos de pestañas de Pedidos
'####################################################
function CargarIconosPedido(nmenu) 
	select case cstr(nmenu)
		case "0"
			this("MAP_BTIMGPED1")="#ffda6b"
			this("MAP_BTIMGPED2")="#ffda6b"
			this("MAP_BTIMGPED3")="#ffda6b"
     				
		case "1"
			this("MAP_BTIMGPED1")="#f19d16"
			this("MAP_BTIMGPED2")="#ffda6b"
			this("MAP_BTIMGPED3")="#ffda6b"

		case "2"
			this("MAP_BTIMGPED1")="#ffda6b"
			this("MAP_BTIMGPED2")="#f19d16"
			this("MAP_BTIMGPED3")="#ffda6b"
		
		case "3"
			this("MAP_BTIMGPED1")="#ffda6b"
			this("MAP_BTIMGPED2")="#ffda6b"
			this("MAP_BTIMGPED3")="#f19d16"
	
		
   end select
  	
end function

'#################################################### 
' Funcion cargar los menus de edicion de Pedido
'####################################################
function CargarGruposPedido(nmenu) 
	select case cstr(nmenu)
		case "0"
				
		case "1"
			this("MAP_TABPED")=1
		case "2"
			this("MAP_TABPED")=2
		case "3"
			this("MAP_TABPED")=3				
		
  end select 	
end function

'******************************************************************************************
'**** Funcion para eliminar una  linea de pedido
'******************************************************************************************
function EliminarLineaPedido (stIDLINEA)
  if LB_MsgYesNo ("Desea eliminar la linea seleccionada?") then
	   LB_RunSQLRep "UPDATE GEN_PEDIDOSLIN SET ITX_BAJA=1,ITX_XONE=1 where ID="+cstr(stIDLINEA)   
  end if
end function

'******************************************************************************************
'**** Funcion para crear una nueva linea de pedido
'******************************************************************************************
function NuevaLineaPedido (stIDART,stUND,stIDPEDIDO)
  
   Set colpedlin=appdata.GetCollection("PedidosLin_Basic")
   colpedlin.filter="(t1.ITX_BAJA=0 or t1.ITX_BAJA is null) and t1.IDPEDIDO="+cstr(stIDPEDIDO)+" and t1.IDARTICULO="+cstr(stIDART)
   colpedlin.startbrowse
   if not colpedlin.currentitem is nothing then
      ok=1
      set objpedlin = colpedlin.currentitem
      objpedlin("C_UNI2")=objpedlin("C_UNI2")+stUND
      objpedlin.save
      LB_RemarcarRegistro "gen_pedidoslin",objpedlin("ID")	  
   else
     ok=0
   end if
   colpedlin.endbrowse
   colpedlin.clear
   if ok=0 then
	   Set colpedlin=this.contents("PedidosLin_Pedido_Contents")
	   set objpedlin = colpedlin.createObject
	   colpedlin.AddItem Empty,objpedlin
	   objpedlin("IDPEDIDO")=stIDPEDIDO
	   objpedlin("IDARTICULO")=stIDART
	   objpedlin("C_UNI2")=stUND
	   objpedlin.save	  
    end if

end function


'******************************************************************************************
'**** Funcion para crear una nueva linea de pedido de articulo simple
'******************************************************************************************
function NuevaLineaPedidoArticulo 
                if this("MAP_UNIDADESSEL2")>0 and this("MAP_IDARTICULOSEL2")>0 then
          		    NuevaLineaPedido this("MAP_IDARTICULOSEL2"),this("MAP_UNIDADESSEL2"),this("ID")
          		    this("MAP_IDARTICULOSEL2")=0
          		    this("MAP_UNIDADESSEL2")=0
          		    this("MAP_ARTICULOSEL2")="" 
					this("MAP_TABPED")=2	
				else
				   LB_Msg "Debe seleccionar un articulo y una cantidad"
				end if	
end function

'******************************************************************************************
'**** Funcion para crear una nueva linea de pedido de catalogo 
'******************************************************************************************
function NuevaLineaPedidoCatalogo
 				if this("MAP_UNIDADESSELEDIT")>0 and this("MAP_IDARTICULOSEL")>0 then          
                   'Creamos una nueva linea del articulo seleccionado en el catalogo
          		    NuevaLineaPedido this("MAP_IDARTICULOSEL"),this("MAP_UNIDADESSELEDIT"),this("ID")
          		    this("MAP_IDARTICULOSEL")=0

          		    this("MAP_UNIDADESSELEDIT")=0
          		    this("MAP_ARTICULOSELEDIT")="" 
				   'Mostramos ventana general de catalogo          
          		   this("MAP_TABPED")=3     
          		   'Refresca el grid modificado.
          		   
		          ' ui.RefreshContentSelectedRow "PedidosLin_Pedido_Contents"	
          		else
				   LB_Msg "Debe seleccionar un articulo y una cantidad"
				end if
end function

'******************************************************************************************
'**** Funcion para crear una nueva linea de pedido de EstadisticaSeleccionada
'******************************************************************************************
function NuevaLineaPedidoEstadisticaTodos
				   'Recorremos el contents en memoria y vamos añadiendo lineas
					for i=0 to this.contents("Estadisticas_Contents").count-1 
					  obj=this.contents("Estadisticas_Contents")(i)
					  obj("MAP_SEL")=0
					  NuevaLineaPedido obj("IDARTICULO"),obj("C_UNI2"),this("ID")
					next
end function

'******************************************************************************************
'**** Funcion para crear una nueva linea de pedido de Estadistica todos
'******************************************************************************************
function NuevaLineaPedidoEstadisticaSel
				   'Recorremos el contents en memoria y vamos añadiendo lineas
					for i=0 to this.contents("Estadisticas_Contents").count-1 
					  obj=this.contents("Estadisticas_Contents")(i)
					  if obj("MAP_SEL")=1 then
					     obj("MAP_SEL")=0
					      NuevaLineaPedido obj("IDARTICULO"),obj("C_UNI2"),this("ID")
					  end if
					next
end function
'******************************************************************************************
'**** Funcion para filtrar estadisticas
'******************************************************************************************
function FiltrarEstadisticas ()
				this.contents("Estadisticas_Contents").unlock
				this.contents("Estadisticas_Contents").filter="t1.IDCLIENTE="+cstr(this("IDCLIENTE"))
				this.contents("Estadisticas_Contents").loadall				
				this.contents("Estadisticas_Contents").lock

end function	
'******************************************************************************************
'****  Funcion que calcula la numeracion de un pedido
'****  Parametros:
'****			obj = pedido
'******************************************************************************************

function NumeroPedido (obj)
					           appdata.getcollection("UsuariosScript").clear
					           Set coll=appdata.getcollection("UsuariosScript")
					           coll.filter="t1.ID=##USERID##"
					           coll.startbrowse
					           if not coll.currentitem is nothing then
					              set userr=coll.currentitem					              
					               'Calculamos codigo de denuncia
					               num=userr("SERIE_PEDIDOS")					               
					               obj("N_PEDIDO")=year(now)					              
					               num=obj("N_PEDIDO")
					               for i=len(cstr(userr("SERIE_PEDIDOS"))) to 6
					                num=cstr(num)+cstr("0")					          
					               next
					               obj("N_PEDIDO")=cstr(num)+cstr(userr("SERIE_PEDIDOS")+1)				               
					           else
					           end if
					           coll.endbrowse
							   coll.clear
							   Set coll=nothing	
end function
'******************************************************************************************
'****  Funcion que Confirma la numeracion de un pedido
'****  Parametros:
'****			obj = pedido
'******************************************************************************************

function ConfirmarNumeroPedido (obj)
					           appdata.getcollection("UsuariosScript").clear
					           Set coll=appdata.getcollection("UsuariosScript")
					           coll.filter="t1.ID=##USERID##"
					           coll.startbrowse
					           if not coll.currentitem is nothing then
					              set userr=coll.currentitem					              
					               'Calculamos codigo de denuncia
					               userr("SERIE_PEDIDOS")=userr("SERIE_PEDIDOS")+1
					               num=userr("SERIE_PEDIDOS")					               
					               obj("N_PEDIDO")=year(now)					              
					               num=obj("N_PEDIDO")
					               for i=len(cstr(userr("SERIE_PEDIDOS"))) to 6
					                num=cstr(num)+cstr("0")					          
					               next
					               obj("N_PEDIDO")=cstr(num)+cstr(userr("SERIE_PEDIDOS"))	
								   userr.save
					           else
					           end if
					           coll.endbrowse
							   coll.clear
							   Set coll=nothing	
end function

'******************************************************************************************
'****  Funcion de cambio de pestaña en pedidos
'******************************************************************************************
Function CambioPestanaPedido
          		    this("MAP_IDARTICULOSEL")=0
          		    this("MAP_UNIDADESSELEDIT")=0
          		    this("MAP_ARTICULOSELEDIT")=""  
          		    this("MAP_IDARTICULOSEL2")=0
          		    this("MAP_UNIDADESSEL2")=0
          		    this("MAP_ARTICULOSEL2")=""          		    
      				this("MAP_BUTTONSELECT")=nmenu
      				CargarIconosPedido nmenu
      				CargarGruposPedido nmenu
      				FiltrarEstadisticas
end function

'******************************************************************************************
'****  Funcion para filtrar contents de estadisticas
'******************************************************************************************
Function FiltrarEstadisticas
          		if this("MAP_FECHAFILTROESTADISTICA")<>"" then
          		   FiltrarContentsLock "t1.IDCLIENTE="+cstr(this("IDCLIENTE"))+" and date(t1.F_ALBARAN)=date(##FLD_MAP_FECHAFILTROESTADISTICA##) and (t1.ITX_BAJA=0 or t1.ITX_BAJA is null)" ,"Estadisticas_Contents"
          		else
          		  if this("MAP_FILTROESTADISTICA")<>"" then
          		      select CASE this("MAP_FILTROESTADISTICA")
          		        case "Ultimo"
          		           Set collest=appdata.getcollection("Estadisticas_Basic")
          		           collest.filter="t1.IDCLIENTE="+cstr(this("IDCLIENTE"))
          		           collest.sort="t1.N_ALBARAN DESC"
          		           collest.StartBrowse
          		           if not collest.currentitem is nothing then
          		               alb=collest.currentitem("N_ALBARAN")
          		           else
          		           	   alb=0
          		           end if
          		           collest.EndBrowse
          		           collest.clear
          		           collest=nothing
             		       FiltrarContentsLock "t1.IDCLIENTE="+cstr(this("IDCLIENTE"))+" and t1.N_ALBARAN="+alb+" and (t1.ITX_BAJA=0 or t1.ITX_BAJA is null)" ,"Estadisticas_Contents"
             		    case "Ultima Semana"
             		      FiltrarContentsLock "t1.IDCLIENTE="+cstr(this("IDCLIENTE"))+" and t1.F_ALBARAN BETWEEN datetime('now', '-6 days') AND datetime('now', 'localtime') and (t1.ITX_BAJA=0 or t1.ITX_BAJA is null)" ,"Estadisticas_Contents"
             		    case "Ultimo Mes"
             		    FiltrarContentsLock "t1.IDCLIENTE="+cstr(this("IDCLIENTE"))+" and t1.F_ALBARAN BETWEEN datetime('now', 'start of month') AND datetime('now', 'localtime') and (t1.ITX_BAJA=0 or t1.ITX_BAJA is null)" ,"Estadisticas_Contents"
             		    end select
				  else
          		     FiltrarContentsLock "t1.IDCLIENTE="+cstr(this("IDCLIENTE"))+" and (t1.ITX_BAJA=0 or t1.ITX_BAJA is null)" ,"Estadisticas_Contents"          		 
          		  end if
          		end if
end function