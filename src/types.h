/* CMSC 430: Compiler Theory and Design */
/* Name: Angel Lee */
/* Project 4* /
/* Date: Nov 6, 2021*/
// This file contains type definitions and the function
// prototypes for the type checking functions

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE};

void checkAssignment(Types lValue, Types rValue, string message);
void checkIf(Types expression, Types thenStatement, Types elseStatement);
void caseExpression(Types expression);
void checkOtherStatement(Types otherStatement);
void checkCase(Types statement);
void checkRemainder(Types left, Types right);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);
