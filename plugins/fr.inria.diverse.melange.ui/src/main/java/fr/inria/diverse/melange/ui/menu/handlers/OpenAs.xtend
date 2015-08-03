package fr.inria.diverse.melange.ui.menu.handlers

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.resources.IFile
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.jface.viewers.TreeSelection
import org.eclipse.ui.handlers.HandlerUtil

class OpenAs extends AbstractHandler{

	// Default Constructor
	def OpenAs() {
	}
	
	override execute(ExecutionEvent event) throws ExecutionException {
		
		// "I have concealed my sins as people do, by hiding my guilt in bytecode"
		println("I don't know where I am")
		
		val tree =  HandlerUtil.getActiveMenuSelection(event) as TreeSelection
		val file = tree.firstElement as IFile
		val fp = file.fullPath
		val furi = URI::createURI(fp.toString)
		
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put("*", new XMIResourceFactoryImpl)
		
		val rs = new ResourceSetImpl()
		val uriConverter = rs.URIConverter
		val normalized = if (furi.isPlatformResource)
                furi
            else 
                uriConverter.normalize(furi)
        
		val pkg = (rs.getResource(normalized, true).contents.get(0).eClass as EClassifier).EPackage

		

		return null
	}
}