package fr.inria.diverse.melange.typesystem

import com.google.common.collect.ArrayListMultimap
import com.google.common.collect.Multimap

import fr.inria.diverse.melange.metamodel.melange.ModelType

import java.util.Collection

import com.google.inject.Singleton

/**
 * This class store Model type hierarchy
 */
@Singleton
class MelangeTypesRegistry
{
	/**
	 * <MM, MT> <=> MM implements MT
	 */
	Multimap<String, ModelType> implementationRelations = ArrayListMultimap.create

	/**
	 * <MT, MT'> <=> MT subtypeOf MT'
	 */
	Multimap<String, ModelType> subtypingRelations = ArrayListMultimap.create
	
	/**
	 * <MM, MT> <=> MM is mapped to MT
	 */
	Multimap<String, ModelType> mappingRelations = ArrayListMultimap.create

	def void registerImplementation(String mm, ModelType mt) {
		if (!implementationRelations.containsEntry(mm, mt))
			implementationRelations.put(mm, mt)
	}

	def void registerSubtyping(String subType, ModelType superType) {
		if (!subtypingRelations.containsEntry(subType, superType))
			subtypingRelations.put(subType, superType)
	}
	
	def void registerMapping(String mm, ModelType mt) {
		if (!mappingRelations.containsEntry(mm, mt))
			mappingRelations.put(mm, mt)
	}

	def Collection<ModelType> getImplementations(String mmFqn) {
		return implementationRelations.get(mmFqn)
	}

	def Collection<ModelType> getSubtypings(String mtFqn) {
		return subtypingRelations.get(mtFqn)
	}
	
	def Collection<ModelType> getMappings(String mmFqn) {
		return mappingRelations.get(mmFqn)
	}

	def void clear() {
		implementationRelations.clear
		mappingRelations.clear
		subtypingRelations.clear
	}
}
