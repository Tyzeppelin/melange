package fr.inria.diverse.melange.ui.hyperlink

import fr.inria.diverse.melange.metamodel.melange.Ecore
import fr.inria.diverse.melange.metamodel.melange.Metamodel
import java.util.List
import org.eclipse.emf.common.util.URI
import org.eclipse.jface.text.Region
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkAcceptor
import org.eclipse.xtext.util.ITextRegion
import org.eclipse.xtext.xbase.ui.navigation.XbaseHyperLinkHelper
import org.eclipse.xtext.xtype.XImportDeclaration
import org.eclipse.xtext.xtype.XtypePackage

@SuppressWarnings("restricted")
class MelangeHyperlinkHelper extends XbaseHyperLinkHelper{
    
    override createHyperlinksByOffset(XtextResource resource, int offset, IHyperlinkAcceptor acceptor) {
        
        val element = getEObjectAtOffsetHelper.resolveElementAt(resource, offset)
        
        if (element instanceof Ecore) {
            val URI = URI.createURI(element.ecoreUri)
            val region = getRegionByOffset(resource, offset)
            val hyperlink = hyperlinkProvider.get()
            
            hyperlink.setHyperlinkRegion(region)
            hyperlink.setURI(URI)
            hyperlink.setHyperlinkText("Open "+ (element.eContainer as Metamodel).name +" Ecore file")
            
            acceptor.accept(hyperlink)
        }
        else {
            super.createHyperlinksByOffset(resource, offset, acceptor)
        }
    }
    
    def Region getRegionByOffset(XtextResource resource, int offset) {
        
        var element = getEObjectAtOffsetHelper().resolveElementAt(resource, offset) as  XImportDeclaration
        var textRegion = getTextRegion(element, offset)
        val region = new Region(textRegion.offset, textRegion.length)
            
        return region
    }
    
    def ITextRegion getTextRegion( XImportDeclaration ite,  int offset) {
        val List<INode> nodes = NodeModelUtils.findNodesForFeature(ite,
                XtypePackage.Literals.XIMPORT_DECLARATION__MEMBER_NAME);
        for (INode node : nodes) {
            val ITextRegion textRegion = node.getTextRegion();
            if (textRegion.contains(offset)) {
                return textRegion;
            }
        }
        return null;
    }
}
