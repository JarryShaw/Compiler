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
    /* #include <math.h>                                */
    /* due to unknown reasons, pow function was missing */
    /* as compiling with gcc; thus alternative declared */
%}

/* binary number */
BIN     ((0)(b|B)[0-1]+)
/* octal number */
OCT     ((0)(o|O)[0-7]+)
OCT0    ((0)[0-7]+)
/* hexademical number */
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
    /* binary to demical */

    int DIGIT = 0;
    char * NUMB = &yytext[2];

    int LEN = strlen(NUMB);
    int EXP = LEN - 1;
    for (int PTR=0; PTR<LEN; ++PTR) {
        DIGIT += (NUMB[PTR] - '0') * power(2, EXP);
        --EXP;
    }
    printf("%d", DIGIT);
}

{OCT} {
    /* octal to demical */

    int DIGIT = 0;
    char * NUMB = &yytext[2];

    int LEN = strlen(NUMB);
    int EXP = LEN - 1;
    for (int PTR=0; PTR<LEN; ++PTR) {
        DIGIT += (NUMB[PTR] - '0') * power(8, EXP);
        --EXP;
    }
    printf("%d", DIGIT);
}

{OCT0} {
    /* octal to demical (deprecated) */
    char * ENDPTR;
    char * STRING = &yytext[1];
    long DIGIT = strtol(STRING, &ENDPTR, 8);
    printf("%ld", DIGIT);
}

{HEX} {
    /* hexademical to demical */

    int DIGIT = 0;
    char * NUMB = &yytext[2];

    int LEN = strlen(NUMB);
    int EXP = LEN - 1;
    for (int PTR=0; PTR<LEN; ++PTR) {
        int BUFF;
        switch (NUMB[PTR]) {
            case 'A':
            case 'a':
                BUFF = 10;    break;
            case 'B':
            case 'b':
                BUFF = 11;    break;
            case 'C':
            case 'c':
                BUFF = 12;    break;
            case 'D':
            case 'd':
                BUFF = 13;    break;
            case 'E':
            case 'e':
                BUFF = 14;    break;
            case 'F':
            case 'f':
                BUFF = 15;    break;
            default:
                BUFF = NUMB[PTR] - '0';
        }
        DIGIT += BUFF * power(16, EXP);
        --EXP;
    }
    printf("%d", DIGIT);
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

int power(int base, int exponent);
int power(int base, int exponent) {
     same as pow declared in math.h
    int power = 1;
    for (int ctr=1; ctr<=exponent; ++ctr) {
        power *= base;
    }
    return power;
}

void main(void) {
    yylex();
}
