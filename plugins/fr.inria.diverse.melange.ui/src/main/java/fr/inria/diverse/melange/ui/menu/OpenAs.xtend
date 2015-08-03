package fr.inria.diverse.melange.ui.menu

import org.eclipse.core.expressions.Expression
import org.eclipse.core.internal.expressions.AdaptExpression
import org.eclipse.core.internal.expressions.IterateExpression
import org.eclipse.core.internal.expressions.TestExpression
import org.eclipse.core.internal.expressions.WithExpression
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.jface.action.IContributionItem
import org.eclipse.jface.action.MenuManager
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.menus.CommandContributionItem
import org.eclipse.ui.menus.CommandContributionItemParameter
import org.eclipse.ui.menus.ExtensionContributionFactory
import org.eclipse.ui.menus.IContributionRoot
import org.eclipse.ui.services.IServiceLocator

class OpenAs extends ExtensionContributionFactory {
	
	override createContributionItems(IServiceLocator serviceLocator, IContributionRoot additions) {
		
		val m = new MenuManager("Language")
		
		// get the current selection
		val tree = PlatformUI.workbench.activeWorkbenchWindow.selectionService.selection as IStructuredSelection
		val file = tree.firstElement
		
		val name = getLanguageName(file)
		
		println("nooo " + name)
		
		if (name != null){
			
			val camus = createCommand(serviceLocator, "Camus")
			val aldebaran = createCommand(serviceLocator, "Aldebaran")
			val language = createCommand(serviceLocator, name)
			
			
			m.add(camus)
			m.add(aldebaran)
			m.add(language)
		}
		
		
		//		val reg = Platform.extensionRegistry.getConfigurationElementsFor("org.eclipse.ui.editors").filter[it.attributeNames.contains("extensions")
		
		additions.addContributionItem(m, getExpression)
		
	}
	
	def Expression getExpression() {
		
		val test = new TestExpression(getNamespace, "isMelangeLanguage", null, null)

		val adapt = new AdaptExpression("org.eclipse.core.resources.IFile")
		adapt.add(test)

		val iterate = new IterateExpression(null, "false")
		iterate.add(adapt)

		val with = new WithExpression("activeMenuSelection")
		with.add(iterate)

		return with
	}
	
	def IContributionItem createCommand(IServiceLocator serviceLocator, String name) {
		
		return new CommandContributionItem 
				(new CommandContributionItemParameter
					(serviceLocator, "melange."+name, "fr.inria.diverse.melange.ui.command.open", 
						null, null, null, null, name, "o", null, CommandContributionItem.STYLE_PUSH, null, true
					))
	}
	
	def boolean isValidSelection(Object file) {
		return file instanceof IFile
	}
	
	
	def String getLanguageName(Object file) {
		
		// test both if the object "file" is a file and have a known extension
		if (! (file instanceof IFile)) {
				println("Not a file.")
				return null		
		}
		val ext = (file as IFile).fileExtension
		
		val reg = Platform.extensionRegistry.getConfigurationElementsFor("org.eclipse.ui.editors").filter[it.attributeNames.contains("extensions")]
			
		if( ! (reg.exists[it.getAttribute("extensions") == ext] || ext != "xmi")) {
			println("ext unknown : " + ext)
			return null	
		}
		
		// try to open the current file as a EPackage
		val fullPath = URI::createURI((file as IFile).fullPath.toString)
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put("*", new XMIResourceFactoryImpl)
		
		val rs = new ResourceSetImpl()
		val uriConverter = rs.URIConverter
		val normalized = if (fullPath.isPlatformResource)
                fullPath
            else 
                uriConverter.normalize(fullPath)
        
		val pkg = (rs.getResource(normalized, true).contents.get(0).eClass as EClassifier).EPackage
		
		val uri =  pkg.nsURI
		
//		val languages = Platform.extensionRegistry.getConfigurationElementsFor("fr.inria.diverse.melange.language")//.filter[it.attributeNames.contains("uri")]
//		val name = languages.findFirst[it.getAttribute("uri") == uri]
//		
//		println(languages.toString)
		
		return uri
	}
}