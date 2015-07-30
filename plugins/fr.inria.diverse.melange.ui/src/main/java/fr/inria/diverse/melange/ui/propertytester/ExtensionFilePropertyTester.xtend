package fr.inria.diverse.melange.ui.propertytester

import org.eclipse.core.expressions.PropertyTester
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.Platform

class ExtensionFilePropertyTester extends PropertyTester {
	
	String[] exts
	
	override test(Object receiver, String property, Object[] args, Object expectedValue) {
		
		if (receiver instanceof IFile) {
			
			this.exts = newArrayList()
			
			val file = receiver as IFile
			val ext = file.fileExtension
			
//			println("Let me shake your hand!")
						
			val reg = Platform.extensionRegistry.getConfigurationElementsFor("org.eclipse.ui.editors").filter[it.attributeNames.contains("extensions")]
			
			if(reg.exists[it.getAttribute("extensions") == ext] || ext == "xmi") {
//				println("C'est pas que ca fuit c'est que ca deborde!")
				return true	
			}
		}
		
//		println("And now the spinning. You useless reptile.")
		
		return false
	}
	
	
}