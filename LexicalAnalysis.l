/*                                                      */
/* LexicalAnalysis.l                                    */
/*                                                      */
/* Lex program indicated for Python source              */
/*     - convert non-demical numbers to demical         */
/*     - convert uppercase comments to lowercase        */
/*                                                      */
/* Created by Jarry Shaw on 10/29/2017.                 */
/* Copyright © 2017 Jarry Shaw. All rights reserved.    */
/*                                                      */


/*** Definition section ***/

%option noyywrap

%{
    /* C code to be copied verbatim */
    #include <ctype.h>
    #include <stdio.h>
    #include <stdlib.h>
%}

/* binary number */
BIN     ((0)(b|B)[0-1]+)
/* octal number */
OCT     ((0)(o|O)[0-7]+)
OCT0    ((0)[0-7]+)
/* hexadecimal number */
HEX     ((0)(x|X)[0-9A-Fa-f]+)

/* one-line comment after number signs */
%x PY_COMMENT
/* multi-line comment in single quotes */
%x PY_SINGLE_QUOTE
/* multi-line comment in double quotes */
%x PY_DOUBLE_QUOTE


%%
  /*** Rules section ***/

{BIN} {
    /* binary to decimal */

    char * ENDPTR;
    char * STRING = &yytext[2];
    long DIGIT = strtol(STRING, &ENDPTR, 2);
    printf("%ld", DIGIT);
}

{OCT} {
    /* octal to decimal */

    char * ENDPTR;
    char * STRING = &yytext[2];
    long DIGIT = strtol(STRING, &ENDPTR, 8);
    printf("%ld", DIGIT);
}

{OCT0} {
    /* octal to decimal (deprecated) */
    char * ENDPTR;
    char * STRING = &yytext[1];
    long DIGIT = strtol(STRING, &ENDPTR, 8);
    printf("%ld", DIGIT);
}

{HEX} {
    /* hexadecimal to decimal */

    char * ENDPTR;
    char * STRING = &yytext[2];
    long DIGIT = strtol(STRING, &ENDPTR, 16);
    printf("%ld", DIGIT);
}

    /* one line comment after number signs */
"#"                         { BEGIN(PY_COMMENT); printf("#"); }
<PY_COMMENT>"\n"            { BEGIN(INITIAL); printf("\n"); }
<PY_COMMENT>[A-Z]           { putchar(tolower(yytext[0])); }
<PY_COMMENT>.               { putchar(yytext[0]); }

    /* multi-line comment in single quotes */
"'''"                       { BEGIN(PY_SINGLE_QUOTE); printf("'''"); }
<PY_SINGLE_QUOTE>"'''"      { BEGIN(INITIAL); printf("'''"); }
<PY_SINGLE_QUOTE>[A-Z]      { putchar(tolower(yytext[0])); }
<PY_SINGLE_QUOTE>.          { putchar(yytext[0]); }

    /* multi-line comment in double quotes */
"\"\"\""                    { BEGIN(PY_DOUBLE_QUOTE); printf("\"\"\""); }
<PY_DOUBLE_QUOTE>"\"\"\""   { BEGIN(INITIAL); printf("\"\"\""); }
<PY_DOUBLE_QUOTE>[A-Z]      { putchar(tolower(yytext[0])); }
<PY_DOUBLE_QUOTE>.          { putchar(yytext[0]); }


%%
/*** C Code section ***/

void main(void) {
    yylex();
}
