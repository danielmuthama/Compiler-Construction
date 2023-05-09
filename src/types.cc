/* CMSC 430: Compiler Theory and Design */
/* Name: Angel Lee */
/* Project 4* /
/* Date: Nov 6, 2021*/
// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

Types caseExpressionType;

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
	{
		if (lValue ==INT_TYPE && rValue == REAL_TYPE)
		{
			appendError(GENERAL_SEMANTIC, "Cannot narrow variable initialization, must be Integer");
		}
		if (lValue ==BOOL_TYPE && rValue != BOOL_TYPE)
		{
			appendError(GENERAL_SEMANTIC, "must be Boolean");
		}
		if (lValue !=BOOL_TYPE && rValue == BOOL_TYPE)
		{
			appendError(GENERAL_SEMANTIC, "cannot be Boolean");
		}
	}
}

void checkIf(Types expression, Types thenStatement, Types elseStatement)
{
	if(expression != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "If Expression must be Boolean");
	}
	if(thenStatement != elseStatement)
	{
		appendError(GENERAL_SEMANTIC, "Then and Else statements must be the same type");
	}
}

void caseExpression(Types expression)
{
	caseExpressionType = expression;
}

void checkOtherStatement(Types otherStatement)
{
	if(otherStatement != caseExpressionType)
	{
	appendError(GENERAL_SEMANTIC, "Case Type Mismatch in Other statement");	
	}
}


void checkCase(Types statement)
{
	if(statement != caseExpressionType)
	{
	appendError(GENERAL_SEMANTIC, "Case Type Mismatch");	
	}
}

void checkRemainder(Types left, Types right)
{
	if(left != INT_TYPE || right !=INT_TYPE)
	{
	appendError(GENERAL_SEMANTIC, "Both whole and remainder should be Integers");	
	}
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}
	if (left == REAL_TYPE && right == INT_TYPE)
	{
		return REAL_TYPE;
	}	
	if (left == INT_TYPE && right == REAL_TYPE)
	{
		return REAL_TYPE;
	}
	return INT_TYPE;
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}	
		return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}
