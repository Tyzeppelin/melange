package fr.inria.diverse.melange.ui.console

import com.google.inject.ImplementedBy

@ImplementedBy(MelangeConsole.MelangeLoggerImpl)
interface MelangeLogger {
	def void log(Object o)
}