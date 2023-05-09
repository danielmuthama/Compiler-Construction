/* CMSC 430: Compiler Theory and Design */
/* Name: Angel Lee */
/* Project 4* /
/* Date: Nov 6, 2021*/
/* This file is the parser with parsing methods, edited from lecture source file to fit Project 4 criteria */

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token TYPE
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token ADDOP MULOP RELOP REMOP EXPOP
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token ARROW CASE ELSE ENDCASE ENDIF IF OTHERS REAL THEN WHEN

%type <type> type body statement_ statement reductions expression relation term
	factor primary andop remop expop case_ case
	
%%

function:	
	function_header optional_variable body ;
	
function_header: ///first line, must start with "function", and IDENTIFIER or test name based off the id in scanner.l, optional parameter, "returns", and then type
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ';'; ///added otherwise parser will stop at error at function header

optional_variable: ///optional variable can include a variable or nothing/blank
	optional_variable variable | ///another optional_variable added in case of 2 or more variable lines such as in test12
	;

variable: ///identifier + ':' + 'is', then type (int, real, or bool), word 'is', then statement	
	IDENTIFIER ':' type IS statement_ {checkAssignment($3, $5, "Variable Initialization");
			if (symbols.find($1, $3)) appendError(DUPLICATE_IDENTIFIER, $1);
			symbols.insert($1, $3);} |
	error ';' ; ///added otherwise parser will stop at error at variable problems

parameters: ///used in function header
	parameters ',' parameter | ///make it optional to have multiple parameters with commas
	parameter ; ///or parameter

parameter: ///used in parameters
	IDENTIFIER ':' type {symbols.insert($1, $3);} | ///identifier or test name with ':' and then type (int, real, or bool)
	; ///or be blank
	
type:
	INTEGER {$$ = INT_TYPE;} |
	REAL {$$ = REAL_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {checkIf($2, $4, $6);}| ///check if then
	CASE expression {caseExpression($2);} IS case_ OTHERS ARROW statement_ ENDCASE {checkOtherStatement($8);}; ///check case is
	///case _ is 'when int. => statement' others => statement endcase
	
operator:
	ADDOP |
	MULOP ;

case_: ///can be a case, or blank
	case_ case | ///can have multiple cases {$$ = evaluateCase($1, $2);}
	{$$ = MISMATCH;}; ///case can be empty and provide value of 0 for case_ in 'case_ case'
		
case: ///used in statement
	WHEN INT_LITERAL ARROW statement_ {checkCase($4);}| ///when int. => 'statement'.
	error ';' {$$ = MISMATCH;} ; ///added otherwise parser will stop at error at variable problems 
	 
	
reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;
		    
expression:
	expression OROP relation {$$ = checkLogical($1, $3);} |
	andop ;

///added
andop:
	expression ANDOP relation {$$ = checkLogical($1, $3);}  |
	relation;
	
relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP remop {$$ = checkArithmetic($1, $3);} |
	remop ;

///added
remop:
	remop REMOP factor {$$ = checkArithmetic($1, $3); checkRemainder($1, $3);}  | ///add a check. might needs it own check made
	factor;
	      
factor:
	factor MULOP expop  {$$ = checkArithmetic($1, $3);} |
	expop ;

///added
expop:
	expop EXPOP primary {$$ = checkArithmetic($1, $3);} | ///primary ** exponent, right associative
	primary; ///or just primary
	
primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
