package fr.inria.diverse.melange.processors

import com.google.inject.Inject
import fr.inria.diverse.melange.ast.MetamodelExtensions
import fr.inria.diverse.melange.ast.ModelingElementExtensions
import fr.inria.diverse.melange.eclipse.EclipseProjectHelper
import fr.inria.diverse.melange.metamodel.melange.Metamodel
import fr.inria.diverse.melange.utils.IOUtils
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.nio.charset.StandardCharsets
import org.apache.log4j.Logger
import org.eclipse.core.runtime.CoreException
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

class EclipseProjectSynchronizer extends DispatchMelangeProcessor
{
	@Inject extension MetamodelExtensions
	@Inject extension ModelingElementExtensions
	@Inject extension EclipseProjectHelper
	static private final Logger log = Logger.getLogger(EclipseProjectSynchronizer)

	def dispatch void preProcess(Metamodel mm) {
		val project = mm.eResource.project
		val ws = project.workspace.root

		if (project !== null && ws !== null && mm.generatedByMelange) {
			try {
				val runtimeProjectName = mm.externalRuntimeName
				val oldEcore = project.getFile(mm.externalEcorePath)
				val oldEcoreStream = oldEcore.contents
				val tmpStream = new ByteArrayOutputStream
				val rs = new ResourceSetImpl
				val res = rs.createResource(URI::createURI("WontBeSavedAnyway"))
				res.contents += mm.pkgs
				res.save(tmpStream, null)

				val actualEcoreStream = new ByteArrayInputStream(tmpStream.toString.getBytes(StandardCharsets.UTF_8))
				val ecoreHasChanged = !IOUtils.contentEquals(oldEcoreStream, actualEcoreStream)

				// Re-generate if
				//     1- First generation
				//     2- Ecore is obsolete
				if (!mm.runtimeHasBeenGenerated || ecoreHasChanged) {
					log.debug('''«mm.name»: «runtimeProjectName» project is obsolete, regenerating''')
				}
				// Up-to-date, skipping
				else
					log.debug('''«mm.name»: «runtimeProjectName» project is up-to-date, skipping''')
			} catch (IOException e) {
				log.debug(e)
			} catch (CoreException e) {
				log.debug(e)
			} finally {
				// Yeah we might have stuff to close here
			}
		}
	}
}
