package fr.inria.diverse.melange.ui.scope

import com.google.inject.Inject
import fr.inria.diverse.melange.ast.ModelingElementExtensions
import fr.inria.diverse.melange.metamodel.melange.Language
import fr.inria.diverse.melange.metamodel.melange.MelangePackage
import fr.inria.diverse.melange.metamodel.melange.Slice
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider

class MelangeScopeProvider extends AbstractDeclarativeScopeProvider {
    
    @Inject EPackage.Registry reg
    @Inject extension ModelingElementExtensions
    
    def dispatch IScope getScope(EObject context, EReference reference) {
        return super.getScope(context, reference)
    }
    
    def dispatch IScope getScope(Slice slice, EReference ref){
        if (ref.featureID == MelangePackage.SLICE__ROOTS) {
            val language = slice.slicedLanguage
            val candidates = language.syntax.pkgs.map[EClassifiers].flatten
            val  scope = Scopes.scopeFor(candidates)
            return scope
        }
        return super.getScope(slice as EObject, ref)
    }
    
    def dispatch IScope getScope(Language language, EReference ref){
        if (ref.featureID == MelangePackage.LANGUAGE__OPERATORS) {
            val owning = language.name
            println(owning)
            val basic = super.getScope((language as EObject), ref).allElements
            println(basic.get(0).class)
            val enhanced = basic.filter[!it.name.toString.contains(owning)]
//            val List<EObject> res = enhanced.toList
//            val scope = Scopes.scopeFor(enhanced)
            return super.getScope(language as EObject, ref)
//            return scope
        }
        return super.getScope(language as EObject, ref)
    }
}
