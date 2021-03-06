package org.modelexecution.operationalsemantics.gemoc.sequential.dynamic

import activitydiagram.Activity
import activitydiagram.ActivityNode
import activitydiagram.ActivitydiagramPackage
import activitydiagram.BooleanValue
import activitydiagram.BooleanVariable
import activitydiagram.Input
import activitydiagram.InputValue
import activitydiagram.IntegerValue
import activitydiagram.IntegerVariable
import activitydiagram.Value
import activitydiagram.Variable
import java.io.BufferedWriter
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.OutputStreamWriter
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.xtext.resource.XtextResourceSet
import org.modelexecution.operationalsemantics.ActivityDiagramInputStandaloneSetup
import org.modelexecution.operationalsemantics.ActivityDiagramStandaloneSetup
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.ActivityAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.ControlFlowAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.OpaqueActionAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.InitialNodeAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.ActivityFinalNodeAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.ForkNodeAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.JoinNodeAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.MergeNodeAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.DecisionNodeAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.IntegerVariableAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.BooleanVariableAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.IntegerCalculationExpressionAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.IntegerComparisonExpressionAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.BooleanUnaryExpressionAspect.*
import static extension org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.BooleanBinaryExpressionAspect.*

import fr.inria.diverse.k3.al.annotationprocessor.Aspect
import activitydiagram.OpaqueAction
import activitydiagram.InitialNode
import activitydiagram.ActivityFinalNode
import activitydiagram.ForkNode
import activitydiagram.JoinNode
import activitydiagram.MergeNode
import activitydiagram.DecisionNode
import activitydiagram.IntegerCalculationExpression
import activitydiagram.IntegerComparisonExpression
import activitydiagram.BooleanUnaryExpression
import activitydiagram.BooleanBinaryExpression
import activitydiagram.ControlFlow
import activitydiagram.NamedElement
import fr.inria.diverse.k3.al.annotationprocessor.OverrideAspectMethod
import fr.inria.diverse.k3.al.annotationprocessor.ReplaceAspectMethod
import java.util.concurrent.Executors
import activitydiagram.ActivityEdge
import java.util.concurrent.Future
import java.util.concurrent.Callable
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.ecore.resource.Resource
import activitydiagram.Expression
import activitydiagram.IntegerCalculationOperator
import activitydiagram.IntegerComparisonOperator
import activitydiagram.BooleanUnaryOperator
import activitydiagram.BooleanBinaryOperator

class Main {
	protected XtextResourceSet resourceSet ;
	protected ResourceSet resourceSetxmi ;

	def static void main(String[] args) {
		new Main().run(args);
	}

	def void run(String[] args) {
		resourceSet = new XtextResourceSet();
		resourceSetxmi = new ResourceSetImpl();
		ActivityDiagramStandaloneSetup.doSetup();
		ActivityDiagramInputStandaloneSetup.doSetup();
		if (!EPackage.Registry.INSTANCE.containsKey(ActivitydiagramPackage.eNS_URI)) {
			EPackage.Registry.INSTANCE.put(ActivitydiagramPackage.eNS_URI, ActivitydiagramPackage.eINSTANCE);
		}
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl);

//		var inputPath = "../../moliz.ttc2015/org.modelexecution.operationalsemantics.ad.test/model/test4.ad"
//		var inputPath = "../../moliz.ttc2015/org.modelexecution.operationalsemantics.ad.test/model/test4.ad"
		var inputPath = "../../moliz.ttc2015/org.modelexecution.operationalsemantics.ad.test/model/testperformance_variant3_1.ad"
		var inputPath1 = "../../moliz.ttc2015/org.modelexecution.operationalsemantics.ad.test/model/testperformance_variant3_2.adinput"
		var inputValues = this.getInputValues(inputPath1);
//		var inputValues = new ArrayList<InputValue>()
		var activity = getActivity(inputPath)
//		var inputPath = "../../moliz.ttc2015/org.modelexecution.operationalsemantics.ad.test/model/xmi/test5.xmi"
//		var activity = getActivityfromXMI(inputPath)
		var start = System.nanoTime;
		activity.main(inputValues);
		var stop = System.nanoTime;
		println("time to execute " + ( stop - start))
		println(activity.printTrace())
	}

	def Activity getActivity(String modelPath) {
		var resource = resourceSet.getResource(createFileURI(modelPath), true);
		var eObject = resource.getContents().get(0);
		if (eObject instanceof Activity) {
			var activity = eObject as Activity;
			return activity;
		}
		return null;
	}

	def URI createFileURI(String path) {
		return URI.createFileURI(createFile(path).getAbsolutePath());
	}

	def Activity getActivityfromXMI(String modelPath) {
		var resource = resourceSetxmi.getResource(createFileURI(modelPath), true);
		var eObject = resource.getContents().get(0);
		if (eObject instanceof Activity) {
			var activity = eObject as Activity;
			// println((activity.locals.get(0) as BooleanVariable).initialValue)
			return activity;
		}
		return null;
	}

	def File createFile(String path) {
		return new File(path);
	}

	def List<InputValue> getInputValues(String inputPath) {
		var inputValues = new ArrayList<InputValue>();
		var input = getInput(inputPath);
		if (input != null) {
			inputValues.addAll(input.getInputValues());
		}
		return inputValues;
	}

	def Input getInput(String inputPath) {
		var Input input = null;
		if (inputPath != null) {
			var resource = resourceSet.getResource(createFileURI(inputPath), true);
			var eObject = resource.getContents().get(0);
			if (eObject instanceof Input) {
				input = eObject as Input;
			}
		}
		return input;
	}

}

class Util {
	public static final Object LINE_BREAK = System.getProperty("line.separator");

}

class Offer {
	public List<Token> offeredTokens = new ArrayList<Token>() ;

	def boolean hasTokens() {
		removeWithdrawnTokens();
		return offeredTokens.size() > 0;
	}

	def void removeWithdrawnTokens() {
		val tokensToBeRemoved = new ArrayList<Token>();
		offeredTokens.forEach [ token |
			if (token.withdrawn) {
				tokensToBeRemoved.add(token);
			}
		]
		this.offeredTokens.removeAll(tokensToBeRemoved);
	}

}

abstract class Token {

	public ActivityNode holder

	def Token transfer(ActivityNode holder) {
		if (this.holder != null) {
			this.withdraw();
		}
		this.holder = holder;
		return this;
	}

	def void withdraw() {
		if (!isWithdrawn()) {
			holder.removeToken(this);
			holder = null;
		}
	}

	def boolean isWithdrawn() {
		return this.holder == null;
	}
}

class Trace {
	public List<ActivityNode> executedNodes = new ArrayList<ActivityNode>();
}

class ControlToken extends Token {
}

class ForkedToken extends Token {
	public Token baseToken ;
	public Integer remainingOffersCount;
}

class Context {
	public Trace output;
	public Activity activity;
	public Context parent;
	public List<InputValue> inputValues ;
	public JoinNode node ;

	new() {
	}

	new(Trace c, Activity a, List<InputValue> inputValues, Context parent) {
		this.output = c
		this.activity = a
		this.inputValues = inputValues
		this.parent = parent
	}

}

@Aspect(className=Activity)
class ActivityAspect extends NamedElementAspect {

	Trace trace

	@ReplaceAspectMethod
	def void main(List<InputValue> value) {
		var c = new Context
		c.inputValues = value
		c.activity = _self
		_self.trace = new Trace;
		c.output = _self.trace
		value?.forEach[v|v.getVariable().setCurrentValue(v.getValue());]
		_self.nodes.forEach[n|n.running =true]
		_self.execute(c)
	}

	@OverrideAspectMethod
	def void execute(Context c) {
		_self.locals.forEach[v|v.init(c)]
		_self.nodes.filter[node|node instanceof InitialNode].get(0).execute(c)
		
		var list =  _self.nodes.filter[node|node.hasOffers]
		while (list!=null && list.size>0 ){
			list.get(0).execute(c)
			list =  _self.nodes.filter[node|node.hasOffers]
			
		}
	}

	def void reset() {
		_self.trace = null;
	}

	def void writeToFile() {
		var text = _self.printTrace();
		try {
			var writer = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(new File("trace/" + _self.getName() + ".txt"))));
			writer.write(text);
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	def String printTrace() {
		val text = new StringBuffer();
		_self.trace.executedNodes.forEach[n|text.append(n.getName()); text.append(Util.LINE_BREAK);]

		_self.getLocals().forEach [ v |
			text.append(v.print);
			text.append(Util.LINE_BREAK);
		]
		return text.toString();
	}

	def int getIntegerVariableValue(String variableName) {
		var currentValue = _self.getVariableValue(variableName);
		if (currentValue instanceof IntegerValue) {
			var integerValue = currentValue as IntegerValue;
			return integerValue.getValue();
		}
		return -1;
	}

	def boolean getBooleanVariableValue(String variableName) {
		var currentValue = _self.getVariableValue(variableName);
		if (currentValue instanceof BooleanValue) {
			var booleanValue = currentValue as BooleanValue;
			return booleanValue.isValue();
		}
		return false;
	}

	def Value getVariableValue(String variableName) {
		var variable = _self.getVariable(variableName);
		var currentValue = variable.getCurrentValue();
		return currentValue;
	}

	def Variable getVariable(String variableName) {
		var allVariables = new ArrayList<Variable>();
		allVariables.addAll(_self.getLocals());
		allVariables.addAll(_self.getInputs());
		for (Variable var1 : allVariables) {
			if (var1.getName().equals(variableName)) {
				return var1;
			}
		}
		return null;
	}

	def void writeTrace() {
		_self.writeToFile;
		_self.reset();
	}

}

@Aspect(className=NamedElement)
class NamedElementAspect {
	def void execute(Context c) {
	}
}

@Aspect(className=ActivityNode)
class ActivityNodeAspect extends org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.NamedElementAspect {
	List<Token> heldTokens = new ArrayList<Token>

	@OverrideAspectMethod
	def void execute(Context c) {
		//_self.sendOffers1(_self.takeOfferdTokens1)
	}

	def void terminate() {
		_self.running = false;
	}

	def boolean isReady() {
		return _self.isRunning();
	}

	def void sendOffers(List<Token> tokens) {
		_self.outgoing.forEach[edge|edge.sendOffer(tokens)]		
	}

	def List<Token> takeOfferdTokens() {
		val allTokens = new ArrayList<Token>();
		_self.getIncoming.forEach[edge|
			val tokens = edge.takeOfferedTokens();
			for (Token token : tokens) {
				token.withdraw();
				token.holder=_self
			}
			allTokens.addAll(tokens);
		]
		return allTokens;
	}

	/**
	 * @generated NOT
	 */
	def void addTokens(List<Token> tokens) {
		for (Token token : tokens) {
			var transferredToken = token.transfer(_self);
			_self.heldTokens.add(transferredToken);
		}
	}

	def boolean hasOffers() {
		var hasOffer = true;
		for (ActivityEdge edge : _self.getIncoming()) {
			if (!edge.hasOffer()) {
				hasOffer = false;
			}
		}
		return hasOffer;
	}

	def void removeToken(Token token) {
		_self.heldTokens.remove(token);
	}

}

@Aspect(className=ActivityEdge)
class ActivityEdgeAspect extends NamedElementAspect {
	public List<Offer> offers = new ArrayList<Offer>

	def void sendOffer(List<Token> tokens) {
		val offer = new Offer;
		tokens.forEach[token|offer.offeredTokens.add(token)];
		_self.offers.add(offer);
	}

	def List<Token> takeOfferedTokens() {
		val tokens = new ArrayList<Token>()
		_self.offers.forEach[o|tokens.addAll(o.offeredTokens)]
		_self.offers.clear();
		return tokens;
	}

	def boolean hasOffer() {
		return _self.offers.exists[o1|o1.hasTokens()]
	}

}

@Aspect(className=ControlFlow)
class ControlFlowAspect extends ActivityEdgeAspect {

}

@Aspect(className=OpaqueAction)
class OpaqueActionAspect extends ActivityNodeAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		c.output.executedNodes.add(_self)
		_self.expressions.forEach[e|e.execute(c)]
		_self.sendOffers(_self.takeOfferdTokens)
	}
}

@Aspect(className=InitialNode)
class InitialNodeAspect extends ActivityNodeAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		var r = new ControlToken
		r.holder = _self
		var list = new ArrayList<Token>
		list.add(r)
		_self.sendOffers(list)
		c.output.executedNodes.add(_self)
	}
	@OverrideAspectMethod
	def boolean hasOffers() {		
		return false;
	}
	
}

@Aspect(className=Expression)
class ExpressionAspect {
	def void execute(Context c) {
	}
}

@Aspect(className=ActivityFinalNode)
class ActivityFinalNodeAspect extends ActivityNodeAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		c.output.executedNodes.add(_self)
		_self.sendOffers(_self.takeOfferdTokens)
	}
}


@Aspect(className=ForkNode)
class ForkNodeAspect extends ActivityNodeAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		c.output.executedNodes.add(_self)
		var tokens  =_self.takeOfferdTokens	
		var forkedTokens = new ArrayList<Token>();
		for(Token token : tokens) {
			var forkedToken = new ForkedToken();
			forkedToken.baseToken = token;
			forkedToken.remainingOffersCount = _self.outgoing.size();
			forkedTokens.add(forkedToken);
		}
		_self.addTokens(forkedTokens);
		_self.sendOffers(forkedTokens);
	}
}

@Aspect(className=JoinNode)
class JoinNodeAspect extends ActivityNodeAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		c.output.executedNodes.add(_self)
		var tokens = _self.takeOfferdTokens
		tokens.forEach[t| if ((t as ForkedToken).remainingOffersCount>1){
			(t as ForkedToken).remainingOffersCount = (t as ForkedToken).remainingOffersCount -1
		}else{
			var list = new ArrayList<Token>
			list.add(t)
			_self.sendOffers(list)
		}
		]
	}
}

@Aspect(className=MergeNode)
class MergeNodeAspect extends ActivityNodeAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		c.output.executedNodes.add(_self)		
		_self.sendOffers(_self.takeOfferdTokens)

	}
	def boolean hasOffers() {
		return  _self.incoming.exists[edge|edge.hasOffer()]
	}
}

@Aspect(className=DecisionNode)
class DecisionNodeAspect extends ActivityNodeAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		c.output.executedNodes.add(_self)
		_self.sendOffers(_self.takeOfferdTokens)

	}
	@OverrideAspectMethod
	def void sendOffers(List<Token> tokens) {
		for (ActivityEdge edge : _self.getOutgoing()) {
			if (edge instanceof ControlFlow &&  ( edge as ControlFlow).guard != null) {
				if ((( edge as ControlFlow).guard.currentValue as BooleanValue).value) {
					edge.sendOffer(tokens);
				}
			}		
		}
	}
}

@Aspect(className=Variable)
class VariableAspect {
	def void execute(Context c) {
	}

	def void init(Context c) {
		_self.currentValue = _self.initialValue
	}

	def String print() {
	}
}

@Aspect(className=IntegerVariable)
class IntegerVariableAspect extends org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.VariableAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
	}

	@OverrideAspectMethod
	def String print() {
		var text = new StringBuffer();
		text.append(_self.getName());
		text.append(" = ");
		text.append((_self.getCurrentValue() as IntegerValue).getValue());
		return text.toString();
	}
}

@Aspect(className=BooleanVariable)
@OverrideAspectMethod
class BooleanVariableAspect extends org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.VariableAspect {
	def void execute(Context c) {
	}

	@OverrideAspectMethod
	def String print() {
		var text = new StringBuffer();
		text.append(_self.getName());
		text.append(" = ");
		text.append((_self.getCurrentValue() as BooleanValue).isValue());
		return text.toString();
	}

}



@Aspect(className=IntegerCalculationExpression)
class IntegerCalculationExpressionAspect extends org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.ExpressionAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		if (_self.operator.value == IntegerCalculationOperator.ADD_VALUE) {
			(_self.assignee.currentValue as IntegerValue).value = (_self.operand1.currentValue as IntegerValue).value +
				(_self.operand2.currentValue as IntegerValue).value
		} else if (_self.operator.value == IntegerCalculationOperator.SUBRACT_VALUE) {
			(_self.assignee.currentValue as IntegerValue).value = (_self.operand1.currentValue as IntegerValue).value -
				(_self.operand2.currentValue as IntegerValue).value
		}

	}
}

@Aspect(className=IntegerComparisonExpression)
class IntegerComparisonExpressionAspect extends org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.ExpressionAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		if (_self.operator.value == IntegerComparisonOperator.EQUALS_VALUE) {
			(_self.assignee.currentValue as BooleanValue).value = (_self.operand1.currentValue as IntegerValue).value ==
				(_self.operand2.currentValue as IntegerValue).value
		} else if (_self.operator.value == IntegerComparisonOperator.GREATER_EQUALS_VALUE) {
			(_self.assignee.currentValue as BooleanValue).value = (_self.operand1.currentValue as IntegerValue).value >=
				(_self.operand2.currentValue as IntegerValue).value
		} else if (_self.operator.value == IntegerComparisonOperator.GREATER_VALUE) {
			(_self.assignee.currentValue as BooleanValue).value = (_self.operand1.currentValue as IntegerValue).value >
				(_self.operand2.currentValue as IntegerValue).value
		} else if (_self.operator.value == IntegerComparisonOperator.SMALLER_EQUALS_VALUE) {
			(_self.assignee.currentValue as BooleanValue).value = (_self.operand1.currentValue as IntegerValue).value <=
				(_self.operand2.currentValue as IntegerValue).value
		} else if (_self.operator.value == IntegerComparisonOperator.SMALLER_VALUE) {
			(_self.assignee.currentValue as BooleanValue).value = (_self.operand1.currentValue as IntegerValue).value <
				(_self.operand2.currentValue as IntegerValue).value
		}
	}
}

@Aspect(className=BooleanUnaryExpression)
class BooleanUnaryExpressionAspect extends org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.ExpressionAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		if (_self.operator.value == BooleanUnaryOperator.NOT_VALUE) {
			(_self.assignee.currentValue as BooleanValue).value = !(_self.operand.currentValue as BooleanValue).value
		}

	}
}

@Aspect(className=BooleanBinaryExpression)
class BooleanBinaryExpressionAspect extends org.modelexecution.operationalsemantics.gemoc.sequential.dynamic.ExpressionAspect {
	@OverrideAspectMethod
	def void execute(Context c) {
		if (_self.operator.value == BooleanBinaryOperator.AND_VALUE) {
			(_self.assignee.currentValue as BooleanValue).value = (_self.operand1.currentValue as BooleanValue).value &&
				(_self.operand2.currentValue as BooleanValue).value
		} else if (_self.operator.value == BooleanBinaryOperator.OR_VALUE) {
			(_self.assignee.currentValue as BooleanValue).value = (_self.operand1.currentValue as BooleanValue).value ||
				(_self.operand2.currentValue as BooleanValue).value
		}
	}
}

