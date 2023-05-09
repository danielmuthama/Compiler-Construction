/* CMSC 430: Compiler Theory and Design */
/* Name: Angel Lee */
/* Project 4* /
/* Date: Nov 6, 2021*/
/* This file contains flex input file, edited from lecture source file to fit Project 4 criteria */
/*extracted portions from Project 2 scanner.l*/
		
%{ 
#include <cstdio>
#include <string>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment	\-\-.*\n
secondcomment	"//".*\n
line		[\n]
id		[A-Za-z](_?[A-Za-z0-9])*
digit		[0-9]
int		{digit}+
punc		[\(\),:;]

real		{digit}+\.{digit}*([eE][+-]?{digit}+)?
bool		(true|false)

%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{secondcomment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"		{ ECHO; return(RELOP); }
"+"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"=>"		{ ECHO; return(ARROW); }

"="		{ ECHO; return(RELOP); }
"/="		{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
">="		{ ECHO; return(RELOP); } 
"<="		{ ECHO; return(RELOP); } 

"-"		{ ECHO; return(ADDOP); }
"/"		{ ECHO; return(MULOP); }

"**"		{ ECHO; return(EXPOP); }

begin		{ ECHO; return(BEGIN_); }
boolean	{ ECHO; return(BOOLEAN); }
bool		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer	{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return REDUCE; }
returns	{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
case 		{ ECHO; return(CASE); }
else 		{ ECHO; return(ELSE); } 
endcase	{ ECHO; return(ENDCASE); } 
endif		{ ECHO; return(ENDIF); } 
if		{ ECHO; return(IF); } 
others		{ ECHO; return(OTHERS); } 
real		{ ECHO; return(REAL); } 
then		{ ECHO; return(THEN); } 
when		{ ECHO; return(WHEN); } 

or		{ ECHO; return(OROP); }
not		{ ECHO; return(NOTOP); }

rem		{ ECHO; return(REMOP); }

{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }
{real}		{ ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%

