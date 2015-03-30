package fr.inria.diverse.melange.jvmmodel

import com.google.inject.Inject
import fr.inria.diverse.melange.adapters.AdaptersFactory
import fr.inria.diverse.melange.adapters.EObjectAdapter
import fr.inria.diverse.melange.ast.MetamodelExtensions
import fr.inria.diverse.melange.ast.ModelTypeExtensions
import fr.inria.diverse.melange.ast.NamingHelper
import fr.inria.diverse.melange.lib.EcoreExtensions
import fr.inria.diverse.melange.lib.IMetamodel
import fr.inria.diverse.melange.metamodel.melange.Metamodel
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.util.internal.Stopwatches
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypeReferenceBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import fr.inria.diverse.melange.metamodel.melange.ModelTypingSpace
import fr.inria.diverse.melange.ast.ASTHelper

/**
 * This class manages generation of Java classes that implements a Metamodel.
 */
class MetamodelInferrer
{
	@Inject extension ASTHelper
	@Inject extension JvmTypesBuilder
	@Inject extension IQualifiedNameProvider
	@Inject extension NamingHelper
	@Inject extension ModelTypeExtensions
	@Inject extension MetamodelExtensions
	@Inject extension EcoreExtensions
	@Inject extension MetamodelAdapterInferrer
	@Inject extension MetaclassAdapterInferrer

	/**
	 * Creates:
	 * - A Java class for {@link mm}
	 * - A Java class for each Model type in {@link mm}
	 * - A concrete factory for each Model type
	 * - A factory to create adapters for each Model type
	 * - Adapters for each Object type in Model types
	 * 
	 * @param mm
	 * @param acceptor
	 * @param builder
	 */
	def void generateAdapters(Metamodel mm, ModelTypingSpace root, IJvmDeclaredTypeAcceptor acceptor, extension JvmTypeReferenceBuilder builder) {
		val task = Stopwatches.forTask("generate metamodels")
		task.start

		acceptor.accept(mm.toClass(mm.fullyQualifiedName.normalize.toString))
		[
			superTypes += IMetamodel.typeRef

			members += mm.toField("resource",  Resource.typeRef)
			members += mm.toGetter("resource", Resource.typeRef)
			members += mm.toSetter("resource", Resource.typeRef)

			members += mm.toMethod("load", mm.fullyQualifiedName.normalize.toString.typeRef)[
				^static = true
				parameters += mm.toParameter("uri", String.typeRef)

				body = '''
					org.eclipse.emf.ecore.resource.ResourceSet rs = new org.eclipse.emf.ecore.resource.impl.ResourceSetImpl() ;
					Resource res = rs.getResource(org.eclipse.emf.common.util.URI.createURI(uri), true) ;
					«mm.name» mm = new «mm.name»() ;
					mm.setResource(res) ;
					return mm ;
				'''
			]

			mm.^implements.forEach[mt |
				val adapName = mm.adapterNameFor(mt)

				members += mm.toMethod("to" + mt.name, mt.fullyQualifiedName.toString.typeRef)[
					body = '''
						«adapName» adaptee = new «adapName»() ;
						adaptee.setAdaptee(resource) ;
						return adaptee ;
					'''
				]
			]
			
			root.mappings.filter[from == mm.name].forEach[ bind |
				val mt = root.modelTypes.findFirst[bind.to == name]
				
				val adapName = mm.mapperNameFor(mt)

				members += mm.toMethod("to" + mt.name, mt.fullyQualifiedName.toString.typeRef)[
					body = '''
						«adapName» adapter = new «adapName»() ;
						adapter.setAdaptee(resource) ;
						return adapter ;
					'''
				]
			]
		]

		// TODO: Test when the subtype has more classes than the supertype and vice-versa
		mm.^implements.forEach[mt |
			mm.generateAdapter(mt, acceptor, builder)

			mt.allClasses.filter[abstractable].forEach[cls |
				mm.generateAdapter(mt, cls, acceptor, builder)
			]

			val adapFactName = mm.getAdaptersFactoryNameFor(mt)
			acceptor.accept(mm.toClass(adapFactName))
			[
				superTypes += AdaptersFactory.typeRef

				members += mm.toField("instance", adapFactName.typeRef)[static = true]

				members += mm.toMethod("getInstance", adapFactName.typeRef)[
					static = true
					body = '''
						if (instance == null) {
							instance = new «adapFactName»() ;
						}
						return instance ;
					'''
				]

				members += mm.toMethod("createAdapter", EObjectAdapter.typeRef)[
					parameters += mm.toParameter("o", EObject.typeRef)

					body = '''
						«FOR cls : mt.allClasses.filter[mm.hasAdapterFor(mt, it) && instantiable && abstractable].sortByClassInheritance»
						if (o instanceof «mm.getFqnFor(cls)»)
							return create«cls.name»Adapter((«mm.getFqnFor(cls)») o) ;
						«ENDFOR»
						return null ;
					'''
				]

				mt.allClasses.filter[abstractable].forEach[cls |
					val adapName = mm.adapterNameFor(mt, cls)

					members += mm.toMethod('''create«cls.name»Adapter''', adapName.typeRef)[
						parameters += mm.toParameter("adaptee", mm.getFqnFor(cls).typeRef)

						body = '''
							«adapName» adap = new «adapName»() ;
							adap.setAdaptee(adaptee) ;
							return adap ;
						'''
					]
				]
			]
		]

		//if (mm.hasSuperMetamodel)
		//	mm.generateAdapters(mm.inheritanceRelation.superMetamodel, acceptor, builder)

		task.stop
	}
}
