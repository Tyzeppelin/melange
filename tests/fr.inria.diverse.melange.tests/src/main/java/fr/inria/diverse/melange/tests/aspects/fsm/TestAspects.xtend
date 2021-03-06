package fr.inria.diverse.melange.tests.aspects.fsm

import fr.inria.diverse.k3.al.annotationprocessor.Aspect

import fsm.FSM
import fsm.State
import fsm.Transition

import java.util.ArrayList
import java.util.Collection
import java.util.List

// TODO: Inheritance, can't test static, etc.
// TODO: Test overriding EMF code, etc.

@Aspect(className = State)
class SimpleAttributes {
	public String foo
	public int i
	public boolean b
	public char c
	public long l
	public double d
	public float f
}

@Aspect(className = Transition)
class AttributesCollections {
	public List<String> ls
	public ArrayList<String> als
}

@Aspect(className = FSM)
class SimpleReferences {
	public State s
	public FSM f
}

@Aspect(className = State)
class ReferencesCollections {
	public List<State> ls
	public ArrayList<FSM> lf
	public Collection<Transition> lt
}

interface A {}
class B {}
enum C {
	X, Y, Z
}
@Aspect(className = Transition)
class ExternalReferences {
	public A a
	public List<B> b
	public C c

	def Object foo(A arg1, C arg2) { return null }
}

@Aspect(className = Transition)
class Visibility {
	private int i
	protected int j
	public int k
	int l

	def void f1() {}
	public def void f2() {}
	protected def void f3() { _self.f4() }
	private def void f4() {}
}

@Aspect(className = FSM)
class Operations {
	def int i(int arg1) { return 0 }
	def void j(String arg1, Transition arg2) {}
	def List<State> k(List<Transition> arg1) { return null }
}
