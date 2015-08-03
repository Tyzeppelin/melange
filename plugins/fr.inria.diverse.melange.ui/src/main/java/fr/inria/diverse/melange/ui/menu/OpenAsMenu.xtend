package fr.inria.diverse.melange.ui.menu

import org.eclipse.core.expressions.Expression
import org.eclipse.core.internal.expressions.AdaptExpression
import org.eclipse.core.internal.expressions.IterateExpression
import org.eclipse.core.internal.expressions.TestExpression
import org.eclipse.core.internal.expressions.WithExpression
import org.eclipse.jface.action.ContributionItem
import org.eclipse.jface.action.MenuManager
import org.eclipse.ui.menus.CommandContributionItem
import org.eclipse.ui.menus.CommandContributionItemParameter
import org.eclipse.ui.menus.ExtensionContributionFactory
import org.eclipse.ui.menus.IContributionRoot
import org.eclipse.ui.services.IServiceLocator

class OpenAsMenu extends ExtensionContributionFactory {
	
	override createContributionItems(IServiceLocator serviceLocator, IContributionRoot additions) {
		
		val camus = createCommand(serviceLocator, "Camus") 
		
		val aldebaran = createCommand(serviceLocator, "Aldebaran") 
		
		val m = new MenuManager("Open &As ...", "dunno")

		m.add(camus)
		m.add(aldebaran)
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
	
	def createCommand(IServiceLocator serviceLocator, String name) {
		return new CommandContributionItem 
				(new CommandContributionItemParameter
					(serviceLocator, "melange."+name, "fr.inria.diverse.melange.ui.command.open", 
						null, null, null, null, name, "o", null, CommandContributionItem.STYLE_PUSH, null, true
					))
	}
}