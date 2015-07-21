package fr.inria.diverse.melange.ui.hyperlink

import fr.inria.diverse.melange.metamodel.melange.Import
import fr.inria.diverse.melange.metamodel.melange.Language
import org.eclipse.emf.common.util.URI
import org.eclipse.jface.text.Region
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkAcceptor
import org.eclipse.xtext.xbase.ui.navigation.XbaseHyperLinkHelper

class MelangeHyperlinkHelper extends XbaseHyperLinkHelper{
    
    override createHyperlinksByOffset(XtextResource resource, int offset, IHyperlinkAcceptor acceptor) {
        
        val element = getEObjectAtOffsetHelper.resolveElementAt(resource, offset)
        
        if (element instanceof Import) {            
            
            val uriConverter = resource.getResourceSet().getURIConverter()
            val uri = URI.createURI(element.ecoreUri)
//            val region = getRegionByOffset(resource, offset)
            var URI normalized
            if (uri.isPlatformResource)
                normalized = uri
            else 
                normalized = uriConverter.normalize(uri)
            
            val hyperlink = hyperlinkProvider.get()
            
//            hyperlink.setHyperlinkRegion(region)
            hyperlink.setHyperlinkRegion(new Region(offset, 1))
            hyperlink.setURI(normalized)
            hyperlink.setHyperlinkText("Open "+ (element.eContainer as Language).name +" Ecore file")
            hyperlink.typeLabel = "Ecore"
            acceptor.accept(hyperlink)
        }
        else {
            super.createHyperlinksByOffset(resource, offset, acceptor)
        }
    }
    
//    def Region getRegionByOffset(XtextResource resource, int offset) {
//        
//        var element = getEObjectAtOffsetHelper().resolveElementAt(resource, offset) as  XImportDeclaration
//        var textRegion = getTextRegion(element, offset)
//        val region = new Region(textRegion.offset, textRegion.length)
//            
//        return region
//    }
//    
//    def ITextRegion getTextRegion( XImportDeclaration ite,  int offset) {
//        val List<INode> nodes = NodeModelUtils.findNodesForFeature(ite,
//                XtypePackage.Literals.XIMPORT_DECLARATION__MEMBER_NAME);
//        for (INode node : nodes) {
//            val ITextRegion textRegion = node.getTextRegion();
//            if (textRegion.contains(offset)) {
//                return textRegion;
//            }
//        }
//        return null;
//    }
}
