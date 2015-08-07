package fr.inria.diverse.melange.ui.preferences

import fr.inria.diverse.melange.preferences.MelangePreferencesConstants
import fr.inria.diverse.melange.ui.internal.MelangeActivator
import org.eclipse.jface.preference.BooleanFieldEditor
import org.eclipse.ui.IWorkbench
import org.eclipse.xtext.ui.editor.preferences.LanguageRootPreferencePage

class MelangePreferencePage extends LanguageRootPreferencePage
{
	override init(IWorkbench workbench) {
		setPreferenceStore(MelangeActivator.instance.preferenceStore)
	}

	override createFieldEditors() {
//		val parent = fieldEditorParent
//		val group = new Group(parent, GRID) => [
//			text = "Generation"
//			layoutData = new GridData(SWT.FILL, SWT.TOP, true, false)
//			layout = new GridLayout(1, false)
//		]

//		val composite = new Composite(group, GRID)

		addField(
			new BooleanFieldEditor(
				MelangePreferencesConstants.GENERATE_ADAPTERS_CODE,
				"Always generate adapters code",
				fieldEditorParent
			)
		)

//		group.pack
	}
}
