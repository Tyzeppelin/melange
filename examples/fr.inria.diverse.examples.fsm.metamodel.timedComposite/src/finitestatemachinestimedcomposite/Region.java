/**
 */
package finitestatemachinestimedcomposite;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Region</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link finitestatemachinestimedcomposite.Region#getStates <em>States</em>}</li>
 *   <li>{@link finitestatemachinestimedcomposite.Region#getParent <em>Parent</em>}</li>
 * </ul>
 * </p>
 *
 * @see finitestatemachinestimedcomposite.FinitestatemachinestimedcompositePackage#getRegion()
 * @model
 * @generated
 */
public interface Region extends EObject {
	/**
	 * Returns the value of the '<em><b>States</b></em>' containment reference list.
	 * The list contents are of type {@link finitestatemachinestimedcomposite.State}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>States</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>States</em>' containment reference list.
	 * @see finitestatemachinestimedcomposite.FinitestatemachinestimedcompositePackage#getRegion_States()
	 * @model containment="true"
	 * @generated
	 */
	EList<State> getStates();

	/**
	 * Returns the value of the '<em><b>Parent</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Parent</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Parent</em>' reference.
	 * @see #setParent(CompositeState)
	 * @see finitestatemachinestimedcomposite.FinitestatemachinestimedcompositePackage#getRegion_Parent()
	 * @model required="true"
	 * @generated
	 */
	CompositeState getParent();

	/**
	 * Sets the value of the '{@link finitestatemachinestimedcomposite.Region#getParent <em>Parent</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Parent</em>' reference.
	 * @see #getParent()
	 * @generated
	 */
	void setParent(CompositeState value);

} // Region
