/**
 */
package activitydiagram;

import org.k3.lua.dynamic.Environment;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Field Add Entry To Table Brackets</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link activitydiagram.Field_AddEntryToTable_Brackets#getIndexExpression <em>Index Expression</em>}</li>
 * </ul>
 * </p>
 *
 * @see activitydiagram.ActivitydiagramPackage#getField_AddEntryToTable_Brackets()
 * @model
 * @generated
 */
public interface Field_AddEntryToTable_Brackets extends Field {
	/**
	 * Returns the value of the '<em><b>Index Expression</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Index Expression</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index Expression</em>' containment reference.
	 * @see #setIndexExpression(Expression)
	 * @see activitydiagram.ActivitydiagramPackage#getField_AddEntryToTable_Brackets_IndexExpression()
	 * @model containment="true"
	 * @generated
	 */
	Expression getIndexExpression();

	/**
	 * Sets the value of the '{@link activitydiagram.Field_AddEntryToTable_Brackets#getIndexExpression <em>Index Expression</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index Expression</em>' containment reference.
	 * @see #getIndexExpression()
	 * @generated
	 */
	void setIndexExpression(Expression value);

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @model cDataType="activitydiagram.Environment"
	 * @generated
	 */
	void execute(Environment c);

} // Field_AddEntryToTable_Brackets
