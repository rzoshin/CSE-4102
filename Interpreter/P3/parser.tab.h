/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     CSUB = 258,
     MAIN = 259,
     LPAREN = 260,
     RPAREN = 261,
     DIM = 262,
     AS = 263,
     END = 264,
     ASSIGN = 265,
     ADDOP = 266,
     SEMI = 267,
     NEXT = 268,
     TO = 269,
     THEN = 270,
     GT = 271,
     PRINT = 272,
     ID = 273,
     ICONST = 274,
     INT = 275,
     FOR = 276,
     IF = 277,
     SINGLE = 278
   };
#endif
/* Tokens.  */
#define CSUB 258
#define MAIN 259
#define LPAREN 260
#define RPAREN 261
#define DIM 262
#define AS 263
#define END 264
#define ASSIGN 265
#define ADDOP 266
#define SEMI 267
#define NEXT 268
#define TO 269
#define THEN 270
#define GT 271
#define PRINT 272
#define ID 273
#define ICONST 274
#define INT 275
#define FOR 276
#define IF 277
#define SINGLE 278




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 13 "parser.y"
{
    char str_val[100];
    int int_val;
    struct lbs *lbls;
}
/* Line 1529 of yacc.c.  */
#line 101 "parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

