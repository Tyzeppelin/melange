package fr.inria.diverse.melange.ui.menu

import java.util.List
import org.eclipse.core.expressions.Expression
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.jface.action.IContributionItem
import org.eclipse.jface.action.MenuManager
import org.eclipse.jface.action.Separator
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.menus.CommandContributionItem
import org.eclipse.ui.menus.CommandContributionItemParameter
import org.eclipse.ui.menus.ExtensionContributionFactory
import org.eclipse.ui.menus.IContributionRoot
import org.eclipse.ui.services.IServiceLocator

class OpenAs extends ExtensionContributionFactory {

	override createContributionItems(IServiceLocator serviceLocator, IContributionRoot additions) {

		val m = new MenuManager("Open &As")

		val tree = PlatformUI.workbench.activeWorkbenchWindow.selectionService.selection as IStructuredSelection
		val file = tree.firstElement

		val name = getLanguageName(file)

		if (name != null){

			val ext = (file as IFile).fileExtension
			val language = createCommand(serviceLocator, name, getEditorFromExtension(ext))
			m.add(language)

			val subtypes = getSubtypes(name)
			if (subtypes != null) {
				val sep = new Separator("subtypes")
				m.add(sep)
				subtypes.forEach[
					m.add(createCommand(serviceLocator, it, getEditorFromSubtype(it), name, it))
				]
			}
		}
		additions.addContributionItem(m, Expression::TRUE)
	}


	// Test-purpose method. Will disappear soon™
	def IContributionItem createCommand(IServiceLocator serviceLocator, String name) {
		return createCommand(serviceLocator, name, null, null, null)
	}
	
	def IContributionItem createCommand(IServiceLocator serviceLocator, 
		String name, String editorID) {
			return createCommand(serviceLocator, name, editorID, null, null)
		}

	def IContributionItem createCommand(IServiceLocator serviceLocator, 
		String name, String editorID, String exactType, String subType) {
		val map = newHashMap()
		map.put("exactType", exactType)
		map.put("subType", subType)
		map.put("editorID", editorID)
//		println("tast "+map)
		return new CommandContributionItem (
				new CommandContributionItemParameter(
					serviceLocator, "melange."+name, "fr.inria.diverse.melange.ui.command.open", 
					map, null, null, null, name, "o", null, CommandContributionItem.STYLE_PUSH, null, true
				))
	}


	def String getLanguageName(Object file) {
		
		// test both if the object "file" is a file and have a known extension
		if (! (file instanceof IFile)) {
				return null		
		}
		
		val ext = (file as IFile).fileExtension
		val reg = Platform.extensionRegistry.getConfigurationElementsFor("org.eclipse.ui.editors")
					.filter[it.attributeNames.contains("extensions")]

		if( ! (reg.exists[it.getAttribute("extensions") == ext] || ext != "xmi") || ext == null) {
			return null	
		}
		
		// try to open the current file as a EPackage
		val fullPath = URI::createURI((file as IFile).fullPath.toString)
		val rs = new ResourceSetImpl()
		val normalized = if (fullPath.isPlatformResource)
                fullPath
            else 
                rs.URIConverter.normalize(fullPath)
		
		try {
			rs.getResource(normalized, true)
		}catch(Throwable k) {
			println("Objection!")
			return null
		}
		
		val uri = rs.getResource(normalized, true).contents.get(0).eClass.EPackage.nsURI

		val language = Platform.extensionRegistry.getConfigurationElementsFor("fr.inria.diverse.melange.language")
					.findFirst[it.getAttribute("uri") == uri]

		if (language == null){
			return null
		}
		
		return language.getAttribute("exactType")
	}


	def List<String> getSubtypes(String exactType) {
		
		val subtypes = newArrayList()
		
		val lang = Platform.extensionRegistry.getConfigurationElementsFor("fr.inria.diverse.melange.modeltype")
					.filter[it.getAttribute("id") == exactType].get(0).getChildren("subtyping")
		if (lang.length == 0) {
			return null
		}
		lang.forEach[subtypes.add(it.getAttribute("modeltypeId"))]
		return subtypes
	}


	def String getEditorFromSubtype(String subType) {
		
		val ext = Platform.extensionRegistry.getConfigurationElementsFor("fr.inria.diverse.melange.language")
					.findFirst[it.getAttribute("exactType") == subType]
					.getAttribute("fileExtension")

		println(ext)
		return getEditorID(ext)
	} 
	
	def String getEditorFromExtension(String ext) {
		return getEditorID(ext)
	}

	def String getEditorID(String ext) {
		val editors = Platform.extensionRegistry.getConfigurationElementsFor("org.eclipse.ui.editors")
						.filter[it.attributeNames.contains("extensions")]
		val editorID = if (editors.length == 0) 
							""
						else
							editors.findFirst[it.getAttribute("extensions") == ext]
							.getAttribute("id")
		return editorID
	}
}