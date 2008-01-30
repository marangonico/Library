#tag ClassProtected Class AppInherits Application	#tag Event		Sub Open()		  // The file menu is empty on the Mac, so hide it		  //#if targetMacOS		  //FileMenu.visible = false		  //#endif		  		  // Remove the separator under the help item if we're not on a Mac (no separator needed in Help menu on Windows and Linux)		  #if not TargetMacOS		    HelpAboutSeparator.Close		  #endif		  		  pPreferences = new Dictionary()		  loadPreferences()		  		  dim xPlanePath as String		  if (pPreferences.hasKey("XPlanePath")) then xPlanePath = pPreferences.value("XPlanePath")		  if (xPlanePath <> "") then pXPlaneFolder = getFolderItem(xPlanePath, FolderItem.PathTypeAbsolute)		  		  if (pXPlaneFolder = nil or not pXPlaneFolder.exists() or not pXPlaneFolder.directory or not pXPlaneFolder.child("Custom Scenery").exists()) then		    dim result as Boolean = getXPlaneFolder(true)		  end if		End Sub	#tag EndEvent	#tag Event		Sub Close()		  savePreferences()		End Sub	#tag EndEvent#tag MenuHandler		Function HelpAbout() As Boolean Handles HelpAbout.Action			wndAbout.show			Return True					End Function#tag EndMenuHandler	#tag Method, Flags = &h21		Private Sub loadPreferences()		  dim prefsFile as FolderItem = PreferencesFolder().Child(App.kApplicationName + ".plist")		  if (prefsFile.exists()) then		    if (not pPreferences.loadXML(prefsFile)) then		      pPreferences = new Dictionary()		    end if		  end if		  		End Sub	#tag EndMethod	#tag Method, Flags = &h0		Function getXPlaneFolder(require as Boolean) As boolean		  // Returns true if the user chose a new folder (and require is false)		  		  dim dialog as SelectFolderDialog = new SelectFolderDialog()		  dim xPlanePath as String		  dim xPlaneFolder as FolderItem		  		  dialog.title = kLocateXPlaneFolder		  dialog.promptText = kLocateXPlaneFolder		  		  #if TargetWin32		    dialog.initialDirectory = Volume(0).Child("Program Files")		  #elseif TargetMacOS		    dialog.initialDirectory = Volume(0).Child("Applications")		  #elseif TargetLinux		    dialog.initialDirectory = Volume(0)		  #endif		  		  while true		    xPlaneFolder = dialog.showModal()		    if (xPlaneFolder = nil) then		      if (require) then		        msgBox(kErrorNoXPlaneFolderSelected)		        quit		      else		        return false		      end if		    end if		    		    dim customSceneryFolder as FolderItem = xPlaneFolder.child("Custom Scenery")		    if (customSceneryFolder = nil or not customSceneryFolder.exists()) then		      msgBox(kErrorNoCustomSceneryFolder)		    else		      pXPlaneFolder = xPlaneFolder		      pPreferences.value("XPlanePath") = pXPlaneFolder.absolutePath		      return true		    end if		  wend		  		  		End Function	#tag EndMethod	#tag Method, Flags = &h21		Private Sub savePreferences()		  dim prefsFile as FolderItem = PreferencesFolder().Child(App.kApplicationName + ".plist")		  dim result as Boolean = pPreferences.saveXML(prefsFile, true)		End Sub	#tag EndMethod	#tag Method, Flags = &h0		Function processParameterizedString(str as String, parameters() as String) As String		  if ubound(parameters) > -1 then		    dim i as integer		    for i = 0 to ubound(parameters)		      str = str.ReplaceAll("${" + str(i+1) + "}", parameters(i))		    next		  end if		  		  return str		  		exception err as NilObjectException		  // Will throw exception if no second parameter passed		  return str		End Function	#tag EndMethod	#tag Property, Flags = &h21		Private pPreferences As Dictionary	#tag EndProperty	#tag Property, Flags = &h0		pXPlaneFolder As FolderItem	#tag EndProperty	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"	#tag EndConstant	#tag Constant, Name = kFileQuit, Type = String, Dynamic = True, Default = \"&Quit", Scope = Public		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Salir"		#Tag Instance, Platform = Windows, Language = es, Definition  = \"&Salir"		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Quitter"		#Tag Instance, Platform = Windows, Language = fr, Definition  = \"&Quitter"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Surt"		#Tag Instance, Platform = Windows, Language = ca, Definition  = \"&Surt"	#tag EndConstant	#tag Constant, Name = kEditClear, Type = String, Dynamic = True, Default = \"&Delete", Scope = Public		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Borrar"		#Tag Instance, Platform = Windows, Language = es, Definition  = \"&Borrar"		#Tag Instance, Platform = Linux, Language = es, Definition  = \"&Borrar"		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Effacer"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Esborra"		#Tag Instance, Platform = Windows, Language = ca, Definition  = \"&Esborra"		#Tag Instance, Platform = Linux, Language = ca, Definition  = \"&Esborra"	#tag EndConstant	#tag Constant, Name = kApplicationName, Type = String, Dynamic = True, Default = \"OpenSceneryX Installer", Scope = Public		#Tag Instance, Platform = Any, Language = es, Definition  = \"Instalador de OpenSceneryX"		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Installeur OpenSceneryX"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"Insta\xC5\x80lador de l\'OpenSceneryX"	#tag EndConstant	#tag Constant, Name = kRepositoryLocalURL, Type = String, Dynamic = False, Default = \"127.0.0.1/~austin/opensceneryx", Scope = Public	#tag EndConstant	#tag Constant, Name = kRepositoryURL, Type = String, Dynamic = False, Default = \"www.opensceneryx.com", Scope = Public	#tag EndConstant	#tag Constant, Name = kConnectionRetries, Type = Double, Dynamic = False, Default = \"3", Scope = Public	#tag EndConstant	#tag Constant, Name = kLocateXPlaneFolder, Type = String, Dynamic = True, Default = \"Please locate your X-Plane\xC2\xAE folder", Scope = Public		#Tag Instance, Platform = Any, Language = es, Definition  = \"Por favor localice su carpeta de X-Plane\xC2\xAE"		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Indiquer le chemin de votre installation X-Plane\xC2\xAE"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"Trieu la carpeta de l\'X-Plane\xC2\xAE"	#tag EndConstant	#tag Constant, Name = kErrorNoXPlaneFolderSelected, Type = String, Dynamic = True, Default = \"This installer cannot work without knowing where your X-Plane\xC2\xAE folder is located and will now quit.", Scope = Public		#Tag Instance, Platform = Any, Language = es, Definition  = \"Este instalador no puede operar sin saber donde est\xC3\xA1 ubicada su carpeta de X-Plane\xC2\xAE y dejar\xC3\xA1 de ejecutarse."		#Tag Instance, Platform = Any, Language = fr, Definition  = \"L\'installeur ne peut pas fonctionner sans X-Plane\xC2\xAE et va maintenant \xC3\xAAtre ferm\xC3\xA9."		#Tag Instance, Platform = Any, Language = ca, Definition  = \"Aquest insta\xC5\x80lador no pot continuar sense saber on \xC3\xA9s la vostra carpeta de l\'X-Plane\xC2\xAE i ara s\'acabar\xC3\xA0."	#tag EndConstant	#tag Constant, Name = kErrorNoCustomSceneryFolder, Type = String, Dynamic = True, Default = \"A \"Custom Scenery\" folder could not be found inside the X-Plane\xC2\xAE folder you specified\x2C please try again.", Scope = Public		#Tag Instance, Platform = Any, Language = es, Definition  = \"No fue posible localizar una carpeta \"Custom Scenery\" dentro de la carpeta de X-Plane\xC2\xAE que usted especific\xC3\xB3\x2C por favor intente de nuevo."		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Le dossier \"Custom Scenery\"  n\'a pas pu \xC3\xAAtre trouv\xC3\xA9 dans le r\xC3\xA9pertoire sp\xC3\xA9cifi\xC3\xA9. Veuillez r\xC3\xA9essayer."		#Tag Instance, Platform = Any, Language = ca, Definition  = \"La carpeta \xC2\xABCustom Scenery\xC2\xBB no es troba dins la carpeta d\'X-Plane\xC2\xAE que heu seleccionat\x2C torneu-hi un altre cop."	#tag EndConstant	#tag Constant, Name = kFile, Type = String, Dynamic = True, Default = \"&File", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Fichier"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Archivo"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Fitxer"	#tag EndConstant	#tag Constant, Name = kEdit, Type = String, Dynamic = True, Default = \"&Edit", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Editer"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Editar"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Edita"	#tag EndConstant	#tag Constant, Name = kEditUndo, Type = String, Dynamic = True, Default = \"&Undo", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Annuler"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Deshacer"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Desf\xC3\xA9s"	#tag EndConstant	#tag Constant, Name = kEditCut, Type = String, Dynamic = True, Default = \"Cu&t", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Co&uper"		#Tag Instance, Platform = Any, Language = es, Definition  = \"C&ortar"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"Re&talla"	#tag EndConstant	#tag Constant, Name = kEditPaste, Type = String, Dynamic = True, Default = \"&Paste", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Coller"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Pegar"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Enganxa"	#tag EndConstant	#tag Constant, Name = kEditCopy, Type = String, Dynamic = True, Default = \"&Copy", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"Co&pier"		#Tag Instance, Platform = Any, Language = es, Definition  = \"&Copiar"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Copia"	#tag EndConstant	#tag Constant, Name = kEditSelectAll, Type = String, Dynamic = True, Default = \"Select &All", Scope = Public		#Tag Instance, Platform = Any, Language = fr, Definition  = \"&Tout s\xC3\xA9lectionner"		#Tag Instance, Platform = Any, Language = es, Definition  = \"Seleccionar &Todo"		#Tag Instance, Platform = Any, Language = ca, Definition  = \"&Selecciona-ho tot"	#tag EndConstant	#tag Constant, Name = kHelp, Type = String, Dynamic = True, Default = \"&Help", Scope = Public	#tag EndConstant	#tag Constant, Name = kHelpAbout, Type = String, Dynamic = True, Default = \"&About OpenSceneryX Installer", Scope = Public	#tag EndConstant	#tag ViewBehavior	#tag EndViewBehaviorEnd Class#tag EndClass