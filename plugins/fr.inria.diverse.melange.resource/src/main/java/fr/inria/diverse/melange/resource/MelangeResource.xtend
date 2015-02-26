package fr.inria.diverse.melange.resource

import java.io.IOException
import java.util.Map
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceImpl
import org.eclipse.xtend.lib.annotations.Delegate

class MelangeResourceFactoryImpl implements Resource.Factory
{
	override Resource createResource(URI uri) {
		if (!#["resource", "plugin"].contains(uri.segments.head)) {
			throw new MelangeResourceException('''Melange resource only supports melange:/resource/ and melange:/plugin/ URIs''')
		}

		val splits = uri.query?.split("=")

		// Loading through a viewpoint
		if (splits !== null && splits.size == 2 && splits.head == "mt")
			return new MelangeResourceImpl(uri)
		// Nothing special: fallback to XMI resource creation
		else {
			val fallbackUri = URI::createURI(uri.toString.replaceFirst("melange:/", "platform:/"))
			return new XMIResourceImpl(fallbackUri)
		}
	}
}

class MelangeResourceImpl implements Resource$Internal
{
	String expectedMt
	@Delegate Resource$Internal wrappedResource

	new(URI melangeUri) {
		val fallbackUri = melangeUri.melangeURIToPlatformURI
		wrappedResource = new ResourceSetImpl().getResource(fallbackUri, true) as Resource$Internal
		expectedMt = melangeUri.query.split("=").get(1)
	}

	override getContents() throws RuntimeException {
		val objs = wrappedResource.getContents()

		if (objs.empty)
			return objs

		val actualPkgUri = objs.head.eClass.EPackage.nsURI
		val pair = actualPkgUri -> expectedMt
		val adapterCls = ModelTypeAdapter.Registry::INSTANCE.get(pair)

		if (adapterCls !== null) {
			try {
				val adapter = adapterCls.newInstance => [adaptee = wrappedResource]
				return adapter.contents
			} catch (InstantiationException e) {
				throw new MelangeResourceException('''Cannot instantiate adapter type «adapterCls»''', e)
			} catch (IllegalAccessException e) {
				throw new MelangeResourceException('''Cannot access adapter type «adapterCls»''', e)
			}
		}

		throw new MelangeResourceException('''No adapter class registered for «pair»''')
	}

	override getAllContents() {
		// FIXME: Should perform adaptation here
		throw new UnsupportedOperationException("FIXME: Should perform adaptation here")
//		return xmiResource.allContents
	}

	override getEObject(String uriFragment) {
		// FIXME: Should perform adaptation here
		throw new UnsupportedOperationException("FIXME: Should perform adaptation here")
//		return xmiResource.getEObject(uriFragment)
	}

	override save(Map<?, ?> options) throws IOException {
		// FIXME: Should perform adaptation here
		throw new UnsupportedOperationException("FIXME: Should perform adaptation here")
//		xmiResource.save(options)
	}

	private def URI melangeURIToPlatformURI(URI uri) {
		val path = uri.toString.replaceFirst("melange:/", "platform:/")
		val fallbackUri = path.substring(0, path.lastIndexOf("?"))
		return URI::createURI(fallbackUri)
	}
}

class MelangeResourceException extends RuntimeException {
	new(String msg) {
		super(msg)
	}

	new(String msg, Exception cause) {
		super(msg, cause)
	}
}
