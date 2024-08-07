grammar Hydrogen;

program:
    importStatement*
    declaration*
    EOF
    ;
    
declaration:
    functionDeclaration
    | variableDeclaration
    | constDeclaration
    ;
    
variableDeclaration: 
    LET name=ID (COLON variableType=typeName)? (EQUAL value=expression)? SEMICOLON;
constDeclaration: 
    CONST name=ID (COLON variableType=typeName)? (EQUAL value=expression) SEMICOLON;
functionDeclaration:
    FN name=ID (LEFT_PAREN argsList? RIGHT_PAREN)? (MINUS_ARROW returnType=typeName)?
    (LEFT_CURVE_PAREN
        statement*
    RIGHT_CURVE_PAREN | EQUAL_ARROW oneLineExpression = expression SEMICOLON)
    ;
argsList:
    arg (COMMA arg)*;
    
arg:
    name=ID (COLON argType = typeName)? (EQUAL defaultValue = expression)?
    ;
statement:
    declaration
    | expression SEMICOLON
    ;
expression:
    
     callable = expression LEFT_PAREN expressionList RIGHT_PAREN #CallExpression
     | leftExpression=expression operator=(STAR|SLASH) rightExpression=expression #MulExpression
     | leftExpression=expression operator=(PLUS|MINUS) rightExpression=expression #AddExpression
     | ID #IdExpression
     | typeName #TypeNameExpression
     | FLOAT #FloatExpression
     | INT #IntExpression
     ;
     
expressionList:
    expression? (COMMA expression)*;
         
importStatement:
    IMPORT what=packageName (AS alias=ID)? SEMICOLON;
    
packageName:
    ID (DOT ID)*;
typeName:
    ID (COLON COLON ID) *;
    
IMPORT: 'import';
AS: 'as';
DOT: '.';
COMMA: ',';
FN: 'fn';
LET: 'let';
CONST: 'const';
MINUS_ARROW: '->';
EQUAL_ARROW: '=>';
PLUS: '+';
MINUS: '-';
STAR: '*';
SLASH: '/';
SEMICOLON: ';';
COLON: ':';
EQUAL: '=';
RIGHT_PAREN: ')';
LEFT_PAREN: '(';
RIGHT_CURVE_PAREN: '}';
LEFT_CURVE_PAREN: '{';
INT: [0-9]+;
FLOAT: [0-9]+ '.' [0-9]+;
ID: [a-zA-Z_] [a-zA-Z_0-9]*;

WS: [ \t\n\r] -> skip;