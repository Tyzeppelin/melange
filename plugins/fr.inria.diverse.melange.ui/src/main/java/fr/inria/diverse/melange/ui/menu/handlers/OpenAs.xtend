package fr.inria.diverse.melange.ui.menu.handlers

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.resources.IFile
import org.eclipse.jface.viewers.TreeSelection
import org.eclipse.ui.PartInitException
import org.eclipse.ui.handlers.HandlerUtil
import org.eclipse.ui.part.FileEditorInput

class OpenAs extends AbstractHandler{

	override execute(ExecutionEvent event) throws ExecutionException {

		// "I have concealed my sins as people do, by hiding my guilt in bytecode"
		
		val songname = event.parameters.get("editorID")
		println(songname)

		val file =  (HandlerUtil.getActiveMenuSelection(event) as TreeSelection).firstElement as IFile
		val currentPage = HandlerUtil.getActiveWorkbenchWindow(event).activePage
		
		val editorID = event.parameters.get("editorID") as String
		
		if (editorID == null) {
			println("Soon™")
			return null
		}
		
		val input = new FileEditorInput(file)
		try {
			currentPage.openEditor(input, editorID)
		} catch (PartInitException e){
			throw new RuntimeException(e)
		}

		return null
	}
}