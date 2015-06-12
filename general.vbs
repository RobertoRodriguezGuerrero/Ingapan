


'******************************************************************************************
'****  Pulsar boton OK en ventana de login
'******************************************************************************************
Function ClickEntrar
  				st_msg=""					
				
				'Vamos a comprobar si las versiones de la aplicacion son correctas
				st_msg=ComprobarVersiones
				      

				if This("MAP_USUARIO")=""  then
					st_msg="Debe Introducir Usuario"
				end if
				if st_msg<>"" then 
					appdata.failwithmessage -8100,st_msg
				else
					st_erraut=""
					Set CollB=appdata.GetCollection("UsuariosScript")
					CollB.filter="LOGIN='"+Cstr(This("MAP_LOGIN")) +"'"
					CollB.StartBrowse
					Set ObjB=CollB.CurrentItem
					if ObjB is nothing then
						This("MAP_PWD")=""
						st_erraut="El usuario no existe"
					else		
					    if this("MAP_PWD")=objB("PWD") then
					    	st_ROWID=ObjB("ROWID")					    	
					    else
					    	st_erraut="Pasword no valido"
					    end if
					end if
					Set ObjB=nothing
					CollB.EndBrowse
					CollB.Clear
					Set CollB=nothing
					
					if st_erraut="" then
					    'Vamos a actualizar el versionado en GEN_VERSIONES para el usuario qeu hace login
					    ActualizarVersiones st_ROWID
						This.Variables("##LOGIN_USERCOLL##")="Usuarios"
						This.Variables("##LOGIN_NEWUSER##")="LOGIN,"+This("MAP_LOGIN")
						This.Variables("##LOGIN_NEWPASS##")="PWD,"+This("MAP_PWD")
						This.Variables("##LOGIN_NEWNOUSERIN##")=0										
						appdata.failwithmessage -11888,"##LOGIN_START##"					
					else
						appdata.failwithmessage -8100,st_erraut
					end if
				end if
end function 
'******************************************************************************************
'****  Function Comprobar Versiones
'******************************************************************************************
function ComprobarVersiones
        On Error Resume Next
		ComprobarVersiones=""
	'## Versiones minimas indicadas en coleccion LogonColl
        minimaversionBD=this("MAP_MINIMA_VERSION_BD")
        if 	this("MAP_PLATFORM")="IOS" then   
          minimaversionFramework=this("MAP_MINIMA_VERSION_FRAMEWORK_IOS")
        else
          minimaversionFramework=this("MAP_MINIMA_VERSION_FRAMEWORK_AND")
        end if

	'## Version de framework numerica
        version_Framework=""
        for i=1 to len(this("MAP_VERSIONFRAME"))
           ch=MID(this("MAP_VERSIONFRAME"),i,1)
           if isnumeric(ch) then
             version_Framework=version_Framework+ch
           end if
        next		   
        version_Framework=cint(left(version_Framework,4))

	'## Version de BD numerica        
		Set CollB=appdata.GetCollection("Versiones").createclone
		CollB.filter="MID=0"
		CollB.StartBrowse
		Set ObjB=CollB.CurrentItem
		if not ObjB is nothing then
		   version_BD=cint(replace(ObjB("VERSION_BD"),".",0))		   
		else
		   version_BD=0
		end if
		Set ObjB=nothing
		CollB.EndBrowse
		CollB.Clear
		Set CollB=nothing 

	'## Comprobamos versiones			
		if version_BD>0 then
		   if version_BD>=minimaversionBD then
			   if version_Framework>=minimaversionFramework then
			      ComprobarVersiones=""
			   else
			      ComprobarVersiones="Version de Framework erronea."+chr(10)+chr(13)+"El dispositivo requiere de reinstalacion."+chr(10)+chr(13)+chr(10)+chr(13)+" Version terminal: "+cstr(version_Framework)+chr(10)+chr(13)+" Version requerida: "+cstr(minimaversionFramework)
			     
			   end if		      
		   else
		      ComprobarVersiones="Version de base de datos erronea."+chr(10)+chr(13)+"El dispositivo requiere de provision de datos."+chr(10)+chr(13)+chr(10)+chr(13)+" Version terminal: "+cstr(version_BD)+chr(10)+chr(13)+" Version requerida: "+cstr(minimaversionBD)
		   end if
		else
		   ComprobarVersiones="Version de base de datos erronea."+chr(10)+chr(13)+"El dispositivo requiere de provision de datos."+chr(10)+chr(13)+chr(10)+chr(13)+" Version terminal: "+cstr(version_BD)+chr(10)+chr(13)+" Version requerida: "+cstr(minimaversionBD)
		end if        
		appdata.error.clear
end function


'******************************************************************************************
'****  Function Actualizar Versiones
'******************************************************************************************
function ActualizarVersiones (rowid_user)
    On Error Resume Next
    appdata.CurrentEnterprise.variables("IMEI")="999"
    appdata.CurrentEnterprise.variables("MID")=999
    
	Set CollB2=appdata.GetCollection("Versiones").createclone
	CollB2.filter="MID=0"
	CollB2.StartBrowse
	Set ObjB2=CollB2.CurrentItem
	if not ObjB2 is nothing then
		
	'## Version de framework numerica
        version_Framework=ObjB2("MAP_VERSIONFRAME")

    '## Version de BD numerica 
		version_BD=cint(replace(ObjB2("VERSION_BD"),".",0))		   

	'## Licencia
        licencia=""
        for i=1 to len(ObjB2("MAP_MID"))
           ch=MID(ObjB2("MAP_MID"),i,1)
           if isnumeric(ch) then
             licencia=licencia+ch
           end if
        next		   
        licencia=cint(licencia)
       
	'## Version App
        version_app=ObjB2("MAP_VERSIONAPP")

	'## IMEI
        imei=ObjB2("MAP_IMEI")
   
       
    end if
	Set ObjB2=nothing
	CollB2.EndBrowse
	CollB2.Clear
	Set CollB2=nothing 
	'## Actualizamos versiones			
		Set CollB2=appdata.GetCollection("Versiones").createclone
		CollB2.filter="MID="+cstr(licencia)
		CollB2.StartBrowse
		Set ObjB2=CollB2.CurrentItem
		if not ObjB2 is nothing then
		
		   ObjB2("VERSION_BD")=version_BD
		   ObjB2("VERSION_FRAMEWORK")=version_Framework
		   ObjB2("VERSION_APP")=version_app
		   objB2("FECHA_LOGIN")=now
		   objB2("IMEI")=imei		   
		   objB2("USUARIO")=rowid_user
		   objB2.save
		   		 
		else
		   set ObjB2 = CollB2.createObject
		   CollB2.AddItem Empty,ObjB2
		   ObjB2("VERSION_BD")=version_BD
		   ObjB2("VERSION_FRAMEWORK")=version_Framework
		   ObjB2("VERSION_APP")=version_app
		   objB2("FECHA_LOGIN")=now
		   objB2("MID")=licencia		   
		   objB2("IMEI")=imei
		   objB2("USUARIO")=rowid_user
		   objB2.save		   

		end if
		Set ObjB2=nothing
		CollB2.EndBrowse
		CollB2.Clear
		Set CollB2=nothing 		
		
		appdata.error.clear
end function 


'******************************************************************************************
'****  Function CargaOnLogon
'******************************************************************************************
function CargaOnLogon 
                appdata.userinterface.startgps
	           Set coll=appdata.getcollection("UsuariosScript")
			   coll.filter="t1.ID=##USERID##"
	           coll.startbrowse          
	           if not coll.currentitem is nothing then          
				   appdata.CurrentEnterprise.variables("QL_USERNAME")=coll.currentitem("QL_USERNAME")          					
	               appdata.CurrentEnterprise.variables("QL_PASSWD")=coll.currentitem("QL_PASSWD")
	               appdata.CurrentEnterprise.variables("QL_NOMFIC")=coll.currentitem("QL_NOMFIC")
	               appdata.CurrentEnterprise.variables("MAIL_USERNAME")=coll.currentitem("MAIL_USERNAME") 
	               appdata.CurrentEnterprise.variables("MAIL_PASSWD")=coll.currentitem("MAIL_PASSWD")	               
	               appdata.CurrentEnterprise.variables("EMAIL_MUESTRAS")=coll.currentitem("EMAIL_MUESTRAS")	 
				   appdata.CurrentEnterprise.variables("OS")=coll.currentitem("MAP_OS")
				   appdata.CurrentEnterprise.variables("PLATFORM")=coll.currentitem("MAP_PLATFORM")
				   
	           end if
	           coll.endbrowse
	           coll.clear
	           Set coll=nothing
end function


'******************************************************************************************
'****  Function CargaQLikView
'******************************************************************************************
function CargaQLikView

    			'QLikView General
			    st_user=appdata.CurrentEnterprise.variables("QL_USERNAME")
	            st_pwd=appdata.CurrentEnterprise.variables("QL_PASSWD")
	            st_fich=appdata.CurrentEnterprise.variables("QL_NOMFIC")
	            if cint(appdata.CurrentEnterprise.variables("OS"))>=9999 then   '19 para autentificacion
				   this("MAP_LIKVIEWESTADISTICAS")="http://"+st_user+":"+st_pwd+"@212.170.198.179/QvAJAXZfc/opendoc.htm?document=INGAPAN%20S.L.%2FDEP.COMERCIAL%2F"+st_fich+".qvw&host=Local"
				else
				  ui.openurl "http://"+st_user+":"+st_pwd+"@212.170.198.179/QvAJAXZfc/opendoc.htm?document=INGAPAN%20S.L.%2FDEP.COMERCIAL%2F"+st_fich+".qvw&host=Local"
				end if
				'this("MAP_LIKVIEWESTADISTICAS")="http://rubeng:rubeng@212.170.198.179/QvAJAXZfc/opendoc.htm?document=INGAPAN%20S.L.%2FDEP.COMERCIAL%2FING330.qvw&host=Local"

end function

'******************************************************************************************
'****  Function CargaQLikView General
'******************************************************************************************
function CargaQLikViewCliente

			    st_user=appdata.CurrentEnterprise.variables("QL_USERNAME")
	            st_pwd=appdata.CurrentEnterprise.variables("QL_PASSWD")
	            st_fich=appdata.CurrentEnterprise.variables("QL_NOMFIC")
	            st_cli=this("COD")	           
	            if cint(appdata.CurrentEnterprise.variables("OS"))>=99999 then
					this("MAP_LIKVIEW")="http://"+st_user+":"+st_pwd+"@212.170.198.179/QvAJAXZfc/opendoc.htm?document=INGAPAN%20S.L.%2FDEP.COMERCIAL%2F"+st_fich+".qvw&host=Local&select=Document\LB02,"+st_cli
				else
				   ui.openurl "http://"+st_user+":"+st_pwd+"@212.170.198.179/QvAJAXZfc/opendoc.htm?document=INGAPAN%20S.L.%2FDEP.COMERCIAL%2F"+st_fich+".qvw&host=Local&select=Document\LB02,"+st_cli
				end if
end function

'******************************************************************************************
'****  Function Descargar Adjuntos para descargar Adjuntos de URL del servidor
'******************************************************************************************
function DescargarAdjuntos
  Msg="¿Desea descargar todos los documentos de adjuntos de la agenda al dispositivo?. Es recomendable trabajar con conexion WIFI para realizar esta accion."
  Res=LB_MsgYesNo(Msg)
  on error resume next
  if Res=True then
              contador=0
			  ui.UpdateWaitDialog "Descargando Adjuntos...",contador 
              if this("MAP_PLATFORM")="IOS" then
					stURL=""
			  else
			        stURL="/mnt/sdcard/xone/app_ingapan/files/cache/media/replicadocs/"
			  end if
					Set coll=appdata.getcollection("AdjuntosAgenda_Basic")
					coll.filter="(t1.ITX_BAJA=0 or t1.ITX_BAJA is null) and t1.ID_ERP>0"
					coll.loadall
					if coll.count>0 then
					 aumento=100/coll.count
					end if
					st_msg="Documentos descargadas correctamente"

					for i=0 to coll.count-1  
					  contador=contador+aumento
					  ui.UpdateWaitDialog "Descargando Adjuntos..."+coll(i)("PATH"),contador
                      Set filemanager01 = CreateObject("FileManager")
                      
                      fotog=coll.currentitem("PATH")                                          
                      st_error=filemanager01.Download ("http://212.170.61.117:8080/replicadocs/"+replace(fotog,"\","/"),stURL+replace(fotog,"\","/"),"Descargando imagen...")
                      if st_error=-1 then
                         if st_msg="Documentos descargadas correctamente" then
                           st_msg="Se produjo un error en la descarga de la imagen :"+fotog
                         else
                           st_msg=st_msg+" , "+fotog
                         end if
                      end if                      
                      Set filemanager01 = nothing					
					next
					ui.msgbox st_msg,"AVISO",0	
	end if					
end function

'******************************************************************************************
'****  Function Descargar Documentos para descargar documentos de URL del servidor
'******************************************************************************************
function DescargarDocumentos
  Msg="¿Desea descargar todos los documentos al dispositivo?. Es recomendable trabajar con conexion WIFI para realizar esta accion."
  Res=LB_MsgYesNo(Msg)
  on error resume next
  if Res=True then
              contador=0
			  ui.UpdateWaitDialog "Descargando Documentos...",contador   
              if this("MAP_PLATFORM")="IOS" then
					stURL=""
			  else
			        stURL="/mnt/sdcard/xone/app_ingapan/files/cache/media/replicadocs/"
			  end if
					Set coll=appdata.getcollection("Documentos_Basic")
					coll.filter="t1.ITX_BAJA=0 or t1.ITX_BAJA is null"
					st_msg="Documentos descargadas correctamente"
					coll.loadall					
					if coll.count>0 then
					 aumento=100/coll.count
					end if					

					for i=0 to coll.count-1 
					  contador=contador+aumento
					  ui.UpdateWaitDialog "Descargando Documentos..."+coll(i)("PATH"),contador					
                      Set filemanager01 = CreateObject("FileManager")
                      fotog=coll(i)("PATH")
                                           
                      st_error=filemanager01.Download ("http://212.170.61.117:8080/replicadocs/"+replace(fotog,"\","/"),stURL+replace(fotog,"\","/"),"Descargando documento...")
                      if st_error=-1 then
                         if st_msg="Documentos descargadas correctamente" then
                           st_msg="Se produjo un error en la descarga de la imagen :"+fotog
                         else
                           st_msg=st_msg+" , "+fotog
                         end if
                      end if
                      
                      Set filemanager01 = nothing					
					next
					ui.msgbox st_msg,"AVISO",0	
	end if					
end function

'******************************************************************************************
'****  Function Descargar Imagenes para descargar imagenes de URL del servidor
'******************************************************************************************
function DescargarImagenes
  Msg="¿Desea descargar todas las imagenes de articulos al dispositivo?. Es recomendable trabajar con conexion WIFI para realizar esta accion."
  Res=LB_MsgYesNo(Msg)
  on error resume next
  if Res=True then
              contador=0
			  ui.UpdateWaitDialog "Descargando Imagenes...",contador   
              if this("MAP_PLATFORM")="IOS" then
					stURL=""
			  else
			        stURL="/mnt/sdcard/xone/app_ingapan/files/cache/media/replicaimages/"
			  end if
					Set coll=appdata.getcollection("Articulos_Basic")
					coll.filter="t1.ITX_BAJA=0 or t1.ITX_BAJA is null"
					st_msg="Imagenes descargadas correctamente"
					coll.loadall					
					if coll.count>0 then
					 aumento=100/coll.count
					end if					
					for i=0 to coll.count-1
					  contador=contador+aumento
					  ui.UpdateWaitDialog "Descargando imagenes..."+coll(i)("COD"),contador					
                      Set filemanager01 = CreateObject("FileManager")
                      fotog=coll(i)("COD")+"G.jpg"
                                           
                      st_error=filemanager01.Download ("http://212.170.61.117:8080/replicaimages/"+fotog,stURL+fotog,"Descargando imagen...")
                      if st_error=-1 then
                         if st_msg="Imagenes descargadas correctamente" then
                           st_msg="Se produjo un error en la descarga de la imagen :"+fotog
                         else
                           st_msg=st_msg+" , "+fotog
                         end if
                      end if
                      
                      
                      fotop=coll(i)("COD")+"P.jpg"                       
                      st_error=filemanager01.Download ("http://212.170.61.117:8080/replicaimages/"+fotop,stURL+fotop,"Descargando imagen...")
                      if st_error=-1 then
                         if st_msg="Imagenes descargadas correctamente" then
                           st_msg="Se produjo un error en la descarga de la imagen : "+fotop
                         else
                           st_msg=st_msg+" , "+fotop
                         end if
                      end if
                      
                      Set filemanager01 = nothing								  
					next
					ui.msgbox st_msg,"AVISO",0	
   end if					
end function

'******************************************************************************************
'****  Funcion para enviar logs a servidor
'******************************************************************************************
function EnviarLogs
  Msg="¿Quiere mandar información de diagnóstico?"
  Res=LB_MsgYesNo(Msg)
  on error resume next
  if Res=True then
      Servidor_UrlLogs="http://xoneisp.com/XoneLogRec/reclog.aspx"
      Set DT=CreateObject("DebugTools")
      Res1=DT.SendReplicaDebugDatabase(Servidor_UrlLogs)
      Res1=DT.SendLog(Servidor_UrlLogs)
      Res2=DT.SendDatabase(Servidor_UrlLogs)
      if Res1=0 and Res2=0 then
        Msg="Datos enviados correctamente"
      else
        Msg="Se produjo un error enviando los datos"
      end if
      DT=nothing
      LB_Msg Msg

  end if
  AppData.Error.Clear
end function

'******************************************************************************************
'****  Refrescar Informacion de Replica
'******************************************************************************************
function RefreshReplica
	   this("MAP_RECORDSRX")=cstr(Replica.RecordsRX)+"/"+cstr(Replica.TotalRecordsRX)
	   this("MAP_RECORDSTX")=cstr(Replica.RecordsTX)+"/"+cstr(Replica.TotalRecordsTX)
	   this("MAP_RECORDSPEND")=Replica.RecordsPend
	   this("MAP_LOG")=CStr(Replica.Log)
	   set coll=appdata.getcollection("Ficheros0")
	   coll.loadall
	   this("MAP_FICHEROSXENVIAR")=coll.count
	   coll.clear
end function

'******************************************************************************************
'****  Sincronizacion Replica
'******************************************************************************************
function SincronizarReplica
               AppData.FailWithMessage -11888,"##STARTREPLICA##"          
			   this("MAP_RECORDSRX")=cstr(Replica.RecordsRX)+"/"+cstr(Replica.TotalRecordsRX)
			   this("MAP_RECORDSTX")=cstr(Replica.RecordsTX)+"/"+cstr(Replica.TotalRecordsTX)
			   this("MAP_RECORDSPEND")=Replica.RecordsPend
			   this("MAP_LOG")=CStr(Replica.Log)
			   
	   			set coll=appdata.getcollection("Ficheros0")
	   			coll.loadall
	   			this("MAP_FICHEROSXENVIAR")=coll.count
	   			coll.clear	
			   ui.ExecuteActionAfterDelay "refreshreplica",10 	   
end function
'******************************************************************************************
'****  Carga de datos en OnLogon
'******************************************************************************************
function CargaOnLogonSINUSO
			On Error Resume Next 

                    		   appdata.userinterface.startgps               
					           Set coll=appdata.getcollection("UsuariosScript")
					           coll.filter="t1.ID=##USERID##"
					           coll.startbrowse
					           if not coll.currentitem is nothing then
					           		' Cargamos algunas variables Globales
					                 appdata.CurrentEnterprise.variables("ROWIDUSER")=coll.currentitem("ROWID")
					                 appdata.CurrentEnterprise.variables("IMEI")=coll.currentitem("MAP_IMEI")
					                 appdata.CurrentEnterprise.variables("LOGINUSER")=coll.currentitem("LOGIN")
					           else				           
			
					           end if	
					           'Parametros
					           coll.endbrowse
					           set coll=nothing
					           Set coll=appdata.getcollection("Parametros")
					           coll.filter="t1.IDEMPRESA=##ENTID##"
					           coll.startbrowse
					           if not coll.currentitem is nothing then								 

					           else

					           end if	
					           coll.endbrowse
					           set coll=nothing
						
end function		

'******************************************************************************************
'****  Funcion para Capturar posiciones de GPS y almacenarlas en la tabla Coordenadas GPS
'****  Parametros:  
'****		Campo = Campo para almacenar dato en tabla coordenadasGOS
'****		Valor = Dato a almacenar en el "Campo"
'****		Aviso = Si no hay conexion GPS que avise
'******************************************************************************************
function CapturarGPS (Campo,Valor,Aviso)

   if appdata.CurrentEnterprise.variables("GPS")=1 and Campo<>"" and ui.CheckGPSStatus()=1 then	
               appdata.CurrentEnterprise.variables("GPS")=0
               horarioOK=1
				On error resume next
				'Vamos a comprobar si existe un horario de captura de GPS:
				if appdata.CurrentEnterprise.variables("HORAINIGPS")<>"" and appdata.CurrentEnterprise.variables("HORAFINGPS")<>"" then
				      hora = right("0"+cstr(Hour(now)),2)
              		  minutos =right("0"+cstr(minute(now)),2)  
              		  horaactual=cint(cstr(hora)+cstr(minutos))
              		  if isnumeric(replace(appdata.CurrentEnterprise.variables("HORAINIGPS"),":","")) and isnumeric(replace(appdata.CurrentEnterprise.variables("HORAFINGPS"),":",""))then
	              		  horaini=cint(replace(appdata.CurrentEnterprise.variables("HORAINIGPS"),":",""))
              		  	  horafin=cint(replace(appdata.CurrentEnterprise.variables("HORAFINGPS"),":",""))
              		      if horaactual>horafin or horaactual<horaini then
              		         horarioOK=0
              		      end if              		      
              		  end if
				end if
				if horarioOK=1 then
						'Captura de GPS					
		      			Dim collGPS,x,contador,obj
						Set collGPS =appdata.GetCollection("ConectarGPS")									
						Set x =collGPS("LONGITUD")		
						stlatitud=""
						If not x is nothing then						
			 				If x("STATUS")="1" then	
			 				    ' si status vale 1 significa que no hay error de conexion con el servicio
								If x("HGPS")<>"" then
									appdata.CurrentEnterprise.Variables("GPSError")=0
									appdata.CurrentEnterprise.Variables("GPSErrorCounter")=0
									stlatitud=x("LATITUD")
									stlongitud=x("LONGITUD")
									stfecha=x("FGPS")
									
								end if
							Else
							
								' si status vale 0 es que no ha podido conectar con el servicio
								appdata.CurrentEnterprise.Variables("GPSError")=1
								contador=appdata.CurrentEnterprise.Variables("GPSErrorCounter")
								appdata.CurrentEnterprise.Variables("GPSErrorCounter")=contador+1
							End If
						End If
						
						If appdata.CurrentEnterprise.Variables("GPSErrorCounter")>=3 then
							appdata.CurrentEnterprise.Variables("GPSErrorCounter")=0
						End If
						Set x =nothing
						collGPS.Clear						
						if stlongitud<>"" then
						    ' Almacenamos la posicion
							set collGPS= appdata.GetCollection("CoordenadasGPS")
							set obj = collGPS.createObject
							collGPS.AddItem Empty,obj
							obj("LATITUDGPS")=stlatitud
							obj("LONGITUDGPS")=stlongitud
							obj("FECHAHORAGPS")= stfecha
							if Campo<>"" then
							  obj(Campo)=Valor
							end if
							obj.save 			
							set obj= nothing
							collGPS.clear
					    else
						    ' Almacenamos la posicion como erronea con ceros
								'set collGPS= appdata.GetCollection("CoordenadasGPS")
								'set obj = collGPS.createObject
								'collGPS.AddItem Empty,obj
								'obj("LATITUDGPS")="000"
								'obj("LONGITUDGPS")="000"
								'obj("FECHAHORAGPS")= ""
								'if Campo<>"" then
								'  obj(Campo)=Valor
								'end if
								'obj.save 					
								'set obj= nothing
								'collGPS.clear			    
					       ' No se consiguio capturar la posicion
					       if Aviso=1 then
					           appdata.userinterface.msgbox "No es posible conectar con el GPS","Aviso",0
					       end if
					    end if
		        end if
				appdata.CurrentEnterprise.variables("GPS")=1
	end if

end function


'******************************************************************************************
'****  Limpieza de datos en OnLogoff
'******************************************************************************************
Function MaintenanceOnLogoff         
					ui.ShowToast "Realizando mantenimiento de borrado de Datos e Imagenes"
           			On error resume next
							    
           			                
						            appdata.IsReplicating = false 
									'appdata.executeSQL "DELETE FROM Gen_XX WHERE julianday('now')-julianday(FECHA)>2  and  ROWID not in (select ROWID from master_replica_queue)"						            
						            appdata.IsReplicating = true 
						            appdata.error.clear	
						            ' Eliminamos los ficheros que no esten en tablas ni pendientes de replica en ../Files y UCAM
						             Mantenimiento_Ficheros						            
end function						            


'#################################################### 
' Funcion que ejecuta los mantenimientos de los ficheros
'####################################################
function Mantenimiento_Ficheros
  ' Primero ficheros de XOne
	  Set filemanager01 = CreateObject("FileManager")
	  lst = filemanager01.ListFiles("/sdcard/xone/app_ingapan/files")
	  if not lst is nothing then
		  for i = 0 to UBound(lst)				    
		    if instr(cstr(lst(i)),"nomedia")<1 then
		      stfile=lst(i)
		      while instr(stfile,"/")>0		       
		            stfile=MID(stfile,instr(stfile,"/")+1,999) 
		      wend
		      if not ExisteEnDB("Ficheros0","FILENAME",stfile)  then
		        filemanager01.Delete(lst(i))
		      end if
		    end if
		  next
      end if
	  Set filemanager01 = nothing

end function


'#################################################### 
' Funcion que Filtra un contents en base a los parametros de filtro y de contents.
'####################################################
function FiltrarContents (st_filtro,st_contents)

    this.contents(st_contents).filter=""
	this.contents(st_contents).linkfilter=st_filtro
	this.contents(st_contents).loadall

end function

'#################################################### 
' Funcion que Filtra un contents en base a los parametros de filtro y de contents.
'####################################################
function FiltrarContentsLock (st_filtro,st_contents)
    this.contents(st_contents).unlock
    this.contents(st_contents).filter=""
	this.contents(st_contents).linkfilter=st_filtro
	this.contents(st_contents).loadall
    this.contents(st_contents).lock

end function

'******************************************************************************************
'****  Funcion para Capturar posiciones de GPS y devolverlas 
'******************************************************************************************
function CapturarGPS2 ()

			    On error resume next
				'Captura de GPS	
      			Dim collGPS,x,contador,obj
				Set collGPS =appdata.GetCollection("ConectarGPS")									
				Set x =collGPS("LONGITUD")		
				stlatitud=""
				If not x is nothing then						
	 				If x("STATUS")="1" then	
	 				    ' si status vale 1 significa que no hay error de conexion con el servicio
						If x("HGPS")<>"" then
							appdata.CurrentEnterprise.Variables("GPSError")=0
							appdata.CurrentEnterprise.Variables("GPSErrorCounter")=0
							stlatitud=x("LATITUD")
							stlongitud=x("LONGITUD")
							stfecha=x("FGPS")											
						end if
					Else
					
						' si status vale 0 es que no ha podido conectar con el servicio
						appdata.CurrentEnterprise.Variables("GPSError")=1
						contador=appdata.CurrentEnterprise.Variables("GPSErrorCounter")
						appdata.CurrentEnterprise.Variables("GPSErrorCounter")=contador+1
					End If
			    else
			  
				End If
				
				If appdata.CurrentEnterprise.Variables("GPSErrorCounter")>=3 then
					appdata.CurrentEnterprise.Variables("GPSErrorCounter")=0
				End If
				Set x =nothing
				collGPS.Clear						
				if stlongitud<>"" then
				    ' Almacenamos la posicion
					CapturarGPS2=left(cstr(stlatitud)+"000000000000",12)+" / "+left(cstr(stlongitud)+"000000000000",12)
			    else
			       CapturarGPS2=""
			    end if
				appdata.error.clear

end function

'******************************************************************************************
'****  Remarcar la marca de integracion en un registro
'******************************************************************************************

function LB_RemarcarRegistro(tbl,stID)

  On Error resume Next
  appdata.ExecuteSql "UPDATE "+tbl+" set ITX_XONE=1 where ID="+cstr(stID)
  appdata.error.clear
end function
'#############################################################
' LIBRERIA BASICA DE FUNCIONES 
'#############################################################
'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------
function ExisteEnDB(CollName, Columname, ColumnValue)
	dim coll
	RetValue=false
	set coll=appdata.getcollection(CollName)
	coll.filter=Columname+" like '%" + CStr(ColumnValue) + "%'"
	
	coll.startbrowse
    if not coll.currentitem is nothing then
      RetValue = true
    end if	
	coll.endbrowse
	coll.clear
	set coll=nothing
	appdata.error.clear
	ExisteEnDB=RetValue
end function
'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------
function LB_Coll(CollName, Filter)
  RetValue = AppData.GetCollection(CollName).CreateClone
  RetValue.Filter=Filter
  LB_Coll=RetValue
end function

'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------
function LB_ObjExist(CollName, Filter)
  RetValue = false
  Set col=AppData.GetCollection(CollName).CreateClone  
  col.Filter=Filter
  col.startbrowse
  if not col.currentitem is nothing then
     RetValue=true
  end if
  col.endbrowse
  col.Clear
  Set col=nothing  
  LB_ObjExist=RetValue
end function
'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------
function LB_ColCount(CollName, Filter)
  RetValue = false
  Set col=AppData.GetCollection(CollName).CreateClone  
  col.Filter=Filter
  col.loadall
  
  RetValue=col.count
  col.Clear
  Set col=nothing
  LB_ColCount=RetValue
end function
'---------------------------------------------------------------------------------------------------
function LB_CollField(Coll, FieldName)
  RetValue=""
  if not Coll.IsBrowsing then
   Coll.StartBrowse
  end if
  if not Coll.CurrentItem is nothing then
    RetValue=Coll.CurrentItem(FieldName)
  end if
  coll.endbrowse
  coll.Clear
  Set coll=nothing  
  LB_CollField=RetValue
end function 
'---------------------------------------------------------------------------------------------------
function LB_Free(Coll)
  if Coll.IsBrowsing then
    Coll.EndBrowse
  end if
  Coll.Clear
end function
'---------------------------------------------------------------------------------------------------
function LB_Field(CollName, Filter, FieldName)
  set Coll=LB_Coll(CollName, Filter)
  RetValue=LB_CollField(Coll, FieldName)
  LB_Free(Coll)
  Coll=nothing
  LB_Field=RetValue
end function 
'---------------------------------------------------------------------------------------------------
function LB_Field_Id(CollName, Filter, FieldName)
  RetValue=LB_Field(CollName, Filter, FieldName)
  if RetValue = "" then
   RetValue = -1
  end if
  LB_Field_Id = RetValue
end function 
'---------------------------------------------------------------------------------------------------
function LB_Msg(Texto)
  AppData.UserInterface.MsgBox CStr(Texto), "", 0
end function
'---------------------------------------------------------------------------------------------------
function LB_MsgFail(Texto)
  AppData.FailWithMessage -8100, CStr(Texto)
end function
'---------------------------------------------------------------------------------------------------
function LB_Kill 
 AppData.FailWithMessage -666,""
end function
'---------------------------------------------------------------------------------------------------
function LB_ShowForm(CollName, Id)
  set Coll=AppData.GetCollection(CollName)
  if Id=-1 then
    set Item=Coll.CreateObject
	Coll.AddItem(Item)
  else
    Coll.clear
    set Item=Coll.Item(Cstr(Id))
  end if
  if not Item is nothing then
	AppData.PushValue Item
  end if
  set Item=nothing
  set Coll=nothing
end function
'---------------------------------------------------------------------------------------------------
function LB_Close
  AppData.FailWithMessage -11888,"##EXIT####STARTREPLICA##"
end function
'---------------------------------------------------------------------------------------------------
function LB_Fail
  AppData.FailWithMessage -8100,""
end function
'---------------------------------------------------------------------------------------------------
function LB_CloseYesNo (MessageText)
  R = AppData.UserInterface.MsgBox(MessageText, "", 4)
  if R=6 then
    AppData.FailWithMessage -11888,"##EXIT####STARTREPLICA##"
  end if
end function
'---------------------------------------------------------------------------------------------------
function LB_CloseApp
  AppData.FailWithMessage -11888,"##EXITAPP##"
end function
function LB_SetVar(VarName, Value)
 if not AppData.CurrentEnterprise is null then
  AppData.CurrentEnterprise.Variables(VarName)=Value
 else
  LB_Msg("No CurrentEnterprise")
 end if
end function
'---------------------------------------------------------------------------------------------------
function LB_GetVar(VarName)
 RetValue=""
 if not AppData.CurrentEnterprise is null then
  RetValue=AppData.CurrentEnterprise.Variables(VarName)
 else
  LB_Msg("No CurrentEnterprise")
 end if
 LB_GetVar=RetValue
end function
'---------------------------------------------------------------------------------------------------
function LB_RunSQL(SQL)

  On Error resume Next
  appdata.isreplicating=false
  appdata.ExecuteSql SQL
  appdata.isreplicating=true

 'appdata.GetCollection("ForMaintenance").ExecuteSqlString SQL

end function

'---------------------------------------------------------------------------------------------------
function LB_RunSQLRep(SQL)

  On Error resume Next  
  appdata.ExecuteSql SQL  
end function
'---------------------------------------------------------------------------------------------------
function LB_Set(VarName, Value)
 this.Variables(VarName)=Value
end function
'---------------------------------------------------------------------------------------------------
function LB_Get(VarName)
 LB_Get=this.Variables(VarName)
end function
'---------------------------------------------------------------------------------------------------
function LB_MsgYesNo(MessageText)
 R = ui.MsgBox(MessageText, "", 4)
 LB_MsgYesNo = (R = 6)
end function
'---------------------------------------------------------------------------------------------------
function LB_ShowGroup(GroupId)
  ui.ShowGroup CStr(GroupId),"##ALPHA_IN##",300,"##ALPHA_OUT##",300
end function

'---------------------------------------------------------------------------------------------------
function LB_StartReplica
  AppData.FailWithMessage -11888,"##STARTREPLICA##"
end function
'---------------------------------------------------------------------------------------------------
function Call_OnLine (stColl,st_filter)
On error resume next
	               ui.ShowToast "Conectando con el servidor..."
  				   result=1
				   
		           appdata.getcollection(stColl).clear
		           Set coll=appdata.getcollection(stColl)
		           coll.filter=""
		           coll.linkfilter=st_filter
	           
		           coll.startbrowse
         	   				 	

		           Set obj=coll.currentitem
		           if not obj is nothing then		           
		                st_result=obj("ERRDESC")
						if obj("STATUS")=0 then
						   result=0
						else
						   result=1
						end if	
                   else		                   
                        result=1
                        ' No devuelve objeto por lo que no debe de haber conectado
                        appdata.userinterface.msgbox "Error en conexion con el servidor","",0
				   end if

			   
		           Set obj=nothing
		           coll.clear
		           Set coll=nothing
				   appdata.error.clear
				   if UCase(st_result)<>"OK"  then				   
				     if st_result<>"" then
				       LB_msg st_result
				     end if		
				   end if
		           Call_OnLine=result
end function	