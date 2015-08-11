package fr.inria.diverse.melange.ui.console

import java.io.PrintStream
import org.eclipse.ui.console.ConsolePlugin
import org.eclipse.ui.console.IConsoleFactory
import org.eclipse.ui.console.IOConsole
import com.google.inject.Singleton

// Copy from Xtext Build Console
// I still need to fully understand how it really works.
class MelangeConsole extends IOConsole {
	
	private PrintStream out
	
	new() {
		super("Melange Compiler", "MelangeConsole", null, true)
		this.out = new PrintStream(newOutputStream(), true)
	}
	
	def println(String it) {
		out.println(it)
	}

	static class Factory implements IConsoleFactory {
		override void openConsole() {
			var consoleManager = ConsolePlugin.^default.consoleManager
			consoleManager.addConsoles(#[new MelangeConsole()])
		}
	}
	
	@Singleton
	static class MelangeLoggerImpl implements MelangeLogger {
		
		override log(Object o) {
			val consoleManager = ConsolePlugin.getDefault.consoleManager
			val console = consoleManager.consoles.filter(MelangeConsole).head
			console?.println(o.toString)
			consoleManager.showConsoleView(console)
		}
		
	}
	
}