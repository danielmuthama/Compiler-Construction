/* CMSC 430: Compiler Theory and Design */
/* Name: Angel Lee */
/* Project 4* /
/* Date: Nov 6, 2021*/
// This file contains the bodies of the functions that produces the compilation
// edited from lecture source file to fit Project 4 criteria 

#include <cstdio>
#include <string>
#include <queue>
#include <stack>
#include <iostream>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = ""; //to show error message including type of error and the invalid character
static int totalErrors = 0; //total err start is 0
static int lexical; //lexical err count
static int syntax; //syntax err count
static int semantic; //semantic err count

static void displayErrors();

///queue to store error messages in
std::queue<std::string> que;

void firstLine()
{
	lineNumber = 1; //line number starts with 1
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++; //next line adds to the line number
	printf("%4d  ",lineNumber);
}

///lastLine is modified to compute the total number of errors
int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
		///if no errors, otherwise show errors
		if (totalErrors == 0){
		printf("Compiled Successfully \n");
		}
		else {
		printf("Lexical Errors: %d", lexical);
		printf("\nSyntax Errors: %d", syntax);
		printf("\nSemantic Errors: %d", semantic);
		printf("\n");
		}
	
	return totalErrors;
}

///appendError is modified to compute number of all errors
///this method is called in scanner.l where yytext is converted to string message
void appendError(ErrorCategories errorCategory, string message)
{	
	//string array of possible messages based on error category 0-3
	string messages[] = { "Lexical Error, Invalid Character ",
		"", 
		"Semantic Error, ",
		"Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	///split error categories 0-3 and count them
	if (errorCategory == 0){
		lexical++;
	}
	else if (errorCategory == 1){
		syntax++;
	}
	else if (errorCategory == 2){
		semantic++;
	}
	else if (errorCategory == 3){
		semantic++;
	}
	else if (errorCategory == 4){
		semantic++;
	}

	///form error string with the type of error plus invalid character
	error = messages[errorCategory] + message;
	
	///running this method and finding an error adds to the totalErrors count
	totalErrors++;
	
	///push error message into queue
	que.push(error);
}

///this method displays error string, which is the line that appears
///right after the line that was just read if there is an error
void displayErrors()
{
	//if error string isnt blank, print out the error
	while (!que.empty())
	{
	//output is starting from front of que, FIFO style
	std::cout << que.front() << std::endl;
	///pop error message out of que
	que.pop();
	}
	///otherwise, blank or no error
	error = "";
}









