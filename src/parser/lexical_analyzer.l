%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <stdio.h>
#include <stdlib.h>

#include "syntax_tree.h"
#include "syntax_analyzer.h"

int lines=1;
int pos_start=1;
int pos_end=1;

void pass_node(char *text){
     yylval.node = new_syntax_tree_node(text);
}

/* 打印一个 token 并返回：统一处理 pos_start / pos_end */
#define RETURN_TOKEN(tok) do { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return (tok); } while (0)

/*****************声明和选项设置  end*****************/

%}

%x COMMENT

%%
 /* to do for students */
 /* two cases for you, pass_node will send flex's token to bison */
\+ 	{pos_start = pos_end; pos_end += 1; pass_node(yytext); return ADD;}
\-	{pos_start = pos_end; pos_end += 1; pass_node(yytext); return SUB;}
\*	{pos_start = pos_end; pos_end += 1; pass_node(yytext); return MUL;}
\/	{pos_start = pos_end; pos_end += 1; pass_node(yytext); return DIV;}
\<	{pos_start = pos_end; pos_end += 1; pass_node(yytext); return LT;}
\<=	{pos_start = pos_end; pos_end += 2; pass_node(yytext); return LTE;}
\>	{pos_start = pos_end; pos_end += 1; pass_node(yytext); return GT;}
\>=	{pos_start = pos_end; pos_end += 2; pass_node(yytext); return GTE;}
==	{pos_start = pos_end; pos_end += 2; pass_node(yytext); return EQ;}
!=	{pos_start = pos_end; pos_end += 2; pass_node(yytext); return NEQ;}
=	{pos_start = pos_end; pos_end += 1; pass_node(yytext); return ASSIGN;}
;	{pos_start = pos_end; pos_end += 1; pass_node(yytext); return SEMICOLON;}
,	{pos_start = pos_end; pos_end += 1; pass_node(yytext); return COMMA;}
 /* TODO: phase1. 请在这里补充其他的词法规则 */
\(  {pos_start = pos_end; pos_end += 1; pass_node(yytext); return LPARENTHESE;}
\)  {pos_start = pos_end; pos_end += 1; pass_node(yytext); return RPARENTHESE;}
\[  {pos_start = pos_end; pos_end += 1; pass_node(yytext); return LBRACKET;}
\]  {pos_start = pos_end; pos_end += 1; pass_node(yytext); return RBRACKET;}
\{  {pos_start = pos_end; pos_end += 1; pass_node(yytext); return LBRACE;}
\}  {pos_start = pos_end; pos_end += 1; pass_node(yytext); return RBRACE;}

"if"     {pos_start = pos_end; pos_end += 2; pass_node(yytext); return IF;}
"else"   {pos_start = pos_end; pos_end += 4; pass_node(yytext); return ELSE;}
"int"    {pos_start = pos_end; pos_end += 3; pass_node(yytext); return INT;}
"float"  {pos_start = pos_end; pos_end += 5; pass_node(yytext); return FLOAT;}
"void"   {pos_start = pos_end; pos_end += 4; pass_node(yytext); return VOID;}
"while"  {pos_start = pos_end; pos_end += 5; pass_node(yytext); return WHILE;}
"return" {pos_start = pos_end; pos_end += 6; pass_node(yytext); return RETURN;}

 /* 浮点数必须写在整数之前（虽然 flex 取最长匹配，这样更清晰） */
[0-9]+\.|[0-9]*\.[0-9]+ {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return FLOATPOINT;}
[0-9]+ {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return INTEGER;}
[a-zA-Z]+ {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return IDENTIFIER;}

 /* 空白：不产生 token，但要推进列号 */
[ \t\r]+ { pos_end += yyleng; }

 /* 换行：行号加一，列号归 1 */
\n { lines++; pos_start = 1; pos_end = 1; }

 /* 块注释：可以跨行，不能嵌套；内部的换行也要维护 lines 与列号 */
"/*"([^*]|\*+[^*/])*\*+"/" {
    int i;
    for (i = 0; i < yyleng; ++i) {
        if (yytext[i] == '\n') {
            lines++;
            pos_end = 1;
        } else {
            pos_end++;
        }
    }
    pos_start = pos_end;
}

 /* 非法字符：返回 ERROR，让 bison 报语法错误 */
. { pos_start = pos_end; pos_end++; pass_node(yytext); return ERROR; }

 /****请在此补全所有flex的模式与动作  end******/
%%
