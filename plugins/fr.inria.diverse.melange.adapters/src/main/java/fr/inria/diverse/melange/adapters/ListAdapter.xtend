package fr.inria.diverse.melange.adapters

import com.google.common.collect.Iterators
import java.util.Collection
import java.util.List

/**
 * Adapter delegation pattern for manipulating a {@link java.util.List list} of
 * elements of type {@link F} as a list of elements of type {@link E},
 * providing that we have an {@link ListAdapter#adapType adapter type} between
 * {@link F} and {@link E}.
 * 
 * @deprecated For EObjects, {@link EListAdapter} should do the job instead.
 */
class ListAdapter<E, F> implements GenericAdapter<List<F>>, List<E>
{
	List<F> adaptee
	Class<? extends GenericAdapter<F>> adapType

	def static <E, F> ListAdapter<E, F> newInstance(List<F> a, Class<? extends GenericAdapter<F>> type) {
		return new ListAdapter<E, F>(a, type)
	}

	new(List<F> a, Class<? extends GenericAdapter<F>> type) {
		adaptee = a
		adapType = type
	}

	override add(E e) {
		return adaptee.add(decapsulate(e))
	}

	override add(int index, E element) {
		adaptee.add(index, decapsulate(element))
	}

	override addAll(Collection<? extends E> c) {
		c.forEach[adaptee.add(decapsulate(it))]
		return true
	}

	override addAll(int index, Collection<? extends E> c) {
		c.forEach[it, i | adaptee.add(index + i, decapsulate(it))]
		return true
	}

	override clear() {
		adaptee.clear
	}

	override contains(Object o) {
		return adaptee.contains(o)
	}

	override containsAll(Collection<?> c) {
		return adaptee.containsAll(c)
	}

	override get(int index) {
		try {
			val adap = adapType.newInstance
			adap.adaptee = adaptee.get(index)
			return adap as E
		} catch (InstantiationException e) {
			// ...
		} catch (IllegalAccessException e) {
			// ...
		}
	}

	override indexOf(Object o) {
		return adaptee.indexOf(o)
	}

	override isEmpty() {
		return adaptee.isEmpty
	}

	override iterator() {
		return Iterators.transform(adaptee.iterator, new IteratorTranslator<F, E>(adapType))
	}

	override lastIndexOf(Object o) {
		return adaptee.lastIndexOf(decapsulate(o))
	}

	override listIterator() {
		return new ListIteratorWrapper(
			Iterators.transform(adaptee.listIterator, new IteratorTranslator<F, E>(adapType))
		)
	}

	override listIterator(int index) {
		return new ListIteratorWrapper(
			Iterators.transform(adaptee.listIterator(index), new IteratorTranslator<F, E>(adapType))
		)
	}

	override remove(Object o) {
		return adaptee.remove(decapsulate(o))
	}

	override remove(int index) {
		try {
			val adap = adapType.newInstance
			adap.adaptee = adaptee.remove(index)
			return adap as E
		} catch (InstantiationException e) {
			// ...
		} catch (IllegalAccessException e) {
			// ...
		}
	}

	override removeAll(Collection<?> c) {
		return adaptee.removeAll(c)
	}

	override retainAll(Collection<?> c) {
		return adaptee.retainAll(c)
	}

	override set(int index, E element) {
		try {
			val adap = adapType.newInstance
			adap.adaptee = adaptee.set(index, decapsulate(element))
			return adap as E
		} catch (InstantiationException e) {
			// ...
		} catch (IllegalAccessException e) {
			// ...
		}
	}

	override size() {
		return adaptee.size
	}

	override subList(int fromIndex, int toIndex) {
		return new ListAdapter<E, F>(adaptee.subList(fromIndex, toIndex), adapType)
	}

	override toArray() {
		return adaptee.toArray
	}

	override <T> toArray(T[] a) {
		return adaptee.toArray(a)
	}

	def F decapsulate(Object e) {
		return (e as GenericAdapter<F>).adaptee
	}

	override getAdaptee() {
		return adaptee
	}

	override setAdaptee(List<F> a) {
		adaptee = a
	}
}
