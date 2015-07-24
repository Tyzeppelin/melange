package fr.inria.diverse.melange.ui.scope

import fr.inria.diverse.melange.metamodel.melange.MelangePackage
import fr.inria.diverse.melange.metamodel.melange.Slice
import java.util.List
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider

class MelangeScopeProvider extends AbstractDeclarativeScopeProvider {
    
    override IScope getScope(EObject context, EReference reference){
        if (context instanceof Slice && reference.featureID == MelangePackage.SLICE__ROOTS) {
           val rootElement = EcoreUtil.getRootContainer(context)
           val List<EClass> candidates = EcoreUtil2.getAllContentsOfType(rootElement,typeof(EClass));
           val  scope = Scopes.scopeFor(candidates)
           println("Hey red.")
           return scope
        }
        else {
            return super.getScope(context, reference)
        }    
    }
}
