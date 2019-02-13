grammar PostgreSQLBase;

import PostgreSQLKeyword, DataType, Keyword, Symbol, BaseRule;

dataType
    : typeName intervalFields? dataTypeLength? (WITHOUT TIME ZONE | WITH TIME ZONE)? (LBT_ RBT_)* | ID
    ;
    
typeName
    : DOUBLE PRECISION | CHARACTER VARYING? | BIT VARYING? | ID
    ;
    
typeNames
    : typeName (COMMA_ typeName)*
    ;
    
intervalFields
    : intervalField (TO intervalField)?
    ;
    
intervalField
    : YEAR
    | MONTH
    | DAY
    | HOUR
    | MINUTE
    | SECOND
    ;
    
privateExprOfDb
    : aggregateExpression
    | windowFunction
    | arrayConstructorWithCast
    | (TIMESTAMP (WITH TIME ZONE)? STRING_)
    | extractFromFunction
    ;
    
pgExpr
    : castExpr | collateExpr | expr
    ;
    
aggregateExpression
    : ID (LP_ (ALL | DISTINCT)? exprs orderByClause? RP_) asteriskWithParen (LP_ exprs RP_ WITHIN GROUP LP_ orderByClause RP_) filterClause?
    ;
    
filterClause
    : FILTER LP_ WHERE booleanPrimary RP_
    ;
    
asteriskWithParen
    : LP_ ASTERISK_ RP_
    ;
    
windowFunction
    : ID (exprsWithParen | asteriskWithParen) filterClause? windowFunctionWithClause
    ;
    
windowFunctionWithClause
    : OVER (ID | LP_ windowDefinition RP_)
    ;
    
windowDefinition
    : ID? (PARTITION BY exprs)? (orderByExpr (COMMA_ orderByExpr)*)? frameClause?
    ;
    
orderByExpr
    : ORDER BY expr (ASC | DESC | USING operator)? (NULLS (FIRST | LAST))?
    ;
    
operator
    : SAFE_EQ_
    | EQ_
    | NEQ_
    | GT_
    | GTE_
    | LT_
    | LTE_
    | AND_
    | OR_
    | NOT_
    ;
    
frameClause
    : (RANGE | ROWS) frameStart | (RANGE | ROWS) BETWEEN frameStart AND frameEnd
    ;
    
frameStart
    : UNBOUNDED PRECEDING
    | NUMBER_ PRECEDING
    | CURRENT ROW
    | NUMBER_ FOLLOWING
    | UNBOUNDED FOLLOWING
    ;
    
frameEnd
    : frameStart
    ;
    
castExpr
    : CAST LP_ expr AS dataType RP_ | expr COLON_ COLON_ dataType
    ;
    
castExprWithCOLON_
    : COLON_ COLON_ dataType(LBT_ RBT_)*
    ;
    
collateExpr
    : expr COLLATE expr
    ;
arrayConstructorWithCast
    : arrayConstructor castExprWithCOLON_? | ARRAY LBT_ RBT_ castExprWithCOLON_
    ;
    
arrayConstructor
    : ARRAY LBT_ exprs RBT_ | ARRAY LBT_ arrayConstructor (COMMA_ arrayConstructor)* RBT_
    ;
    
extractFromFunction
    : EXTRACT LP_ ID FROM ID RP_
    ;
