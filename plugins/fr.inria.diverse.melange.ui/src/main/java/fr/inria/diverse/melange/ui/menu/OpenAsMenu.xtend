package fr.inria.diverse.melange.ui.menu

import org.eclipse.core.expressions.Expression
import org.eclipse.core.internal.expressions.AdaptExpression
import org.eclipse.core.internal.expressions.IterateExpression
import org.eclipse.core.internal.expressions.TestExpression
import org.eclipse.core.internal.expressions.WithExpression
import org.eclipse.jface.action.IContributionItem
import org.eclipse.ui.menus.CommandContributionItem
import org.eclipse.ui.menus.CommandContributionItemParameter
import org.eclipse.ui.menus.ExtensionContributionFactory
import org.eclipse.ui.menus.IContributionRoot
import org.eclipse.ui.services.IServiceLocator

class OpenAsMenu extends ExtensionContributionFactory {
	
	override createContributionItems(IServiceLocator serviceLocator, IContributionRoot additions) {
		
//		val CommandContributionItemParameter okarin = createCommand(serviceLocator, "Okarin") 
		
		val CommandContributionItemParameter mayushi = createCommand(serviceLocator, "~ Tuturu ~") 
			
//		val IContributionItem m = new MenuManager("Steins;gate", "dunno")
//		
//		val IContributionItem c = new CommandContributionItem(okarin)
		
		val IContributionItem a = new CommandContributionItem(mayushi)
		
//		additions.addContributionItem(m, getExpression)
		
//		additions.addContributionItem(c, getExpression)
		additions.addContributionItem(a, getExpression)
		
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
		return new CommandContributionItemParameter
				(serviceLocator, "opop", "fr.inria.diverse.melange.ui.command.open", null, null, null, null, name, "o", null, CommandContributionItem.STYLE_PUSH, null, true)
	}
}