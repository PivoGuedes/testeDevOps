﻿
/*
	Autor: Egler Vieira
	Data Criação: 01/02/2013

	Descrição: 
	
	Última alteração : 
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_ChecaConflitoDeCanal
	Descrição: Procedimento que realiza a verificação de conflitos de regras de formação de canal
		
	Parâmetros de entrada: @DigitoIdentificador bit  -> Se o canal é identificado por digito(s) no número da proposta
	                     , @DigitosPosicoes varchar(2000) -> Quais os digitos e posições no seguinto formato (digito-posição) -> '8-1'. Pode ser com lista encadeada separada por ; '8-1;0-1;'.
                       , @ProdutoIdentificador bit  -> Se o canal é identificado por produto(s)
                       , @Produtos varchar(2500) -> Quais os produtos do que compõem a regra do canal -> '8105'. Pode ser com lista encadeada separada por ; '8105;9320;1404;'.
                       , @MatriculaVendedorIdentificadora bit -> Se o canal é identificado pro matricula(s) de vendedor
                       , @Matriculas varchar(2000) -> Quais os produtos do que compõem a regra do canal -> '09999'. Pode ser com lista encadeada separada por ; '09999;55869;77777'. 
	
	Retorno: Retorna as linhas de canais em conflito com as regras informadas (caso haja).
	
	Exemplo de utilização:
	  Vide fim deste arquivo para o exemplo simples de utilização.
	  
*******************************************************************************/
CREATE PROCEDURE  [Dados].[proc_ChecaConflitoDeCanal](@DigitoIdentificador bit, @DigitosPosicoes varchar(2000)
                                                , @ProdutoIdentificador bit, @Produtos varchar(2500)
                                                , @MatriculaVendedorIdentificadora bit, @Matriculas varchar(2000) )
AS
BEGIN
/*RETURNS @Validacao TABLE(IDCanal SMALLINT,
                         NomeCanal varchar(80),
                         DigitoIdentificador bit,
                         Digito varchar(20),
                         Posicao tinyint,
                         ProdutoIdentificador bit,
                         CodigoProduto varchar(5),
                         MatriculaVendedorIdentificadora bit,
                         Matricula varchar(20))
                         */
DECLARE @TOTAL_ROWS INT
DECLARE @I          INT 
DECLARE @Parametros varchar(max) = ''

/********************************************************/  
/*SETA PARAMETROS DO(S) DIGITOS*/
/********************************************************/
IF @DigitoIdentificador = 1
BEGIN
  SET @Parametros = ' AND DigitoIdentificador = 1 AND (1 = 1 '
  
  DECLARE @Digito varchar(20)
  DECLARE @Posicao tinyint
  
  SET @TOTAL_ROWS = 0
  SET @I = 0  
  
  DECLARE CrDigitos CURSOR
  LOCAL SCROLL STATIC
  FOR
    SELECT left(ITEMS, CHARINDEX('-',ITEMS)-1) [Digito], RIGHT(ITEMS, LEN(ITEMS) - CHARINDEX('-',ITEMS)) [Posicao]
    FROM [CleansingKit].[dbo].[fn_Split](@DigitosPosicoes, ';') A
  OPEN CrDigitos  
  SET @TOTAL_ROWS = @@CURSOR_ROWS
  WHILE @I < @TOTAL_ROWS
  BEGIN
    SET @I+=1
    FETCH ABSOLUTE @I FROM CrDigitos INTO @Digito, @Posicao
    
    IF @I > 1
       SET @Parametros += ' OR '
    ELSE
       SET @Parametros += ' AND '        
       
    SET @Parametros += '(''' + Cast(@Digito as varchar(20)) + ''' like Digito + ''%'' AND Posicao = ''' + Cast(@Posicao as varchar(3))+ ''')' 
  END
  CLOSE CrDigitos
  DEALLOCATE CrDigitos

  SET @Parametros += ')'  

END
ELSE
SET @Parametros += ' AND DigitoIdentificador IN (0,1)  '
/********************************************************/  

/********************************************************/  
/*SETA PARAMETROS DO(S) DIGITO(S)*/
/********************************************************/
IF @ProdutoIdentificador = 1
BEGIN
  SET @Parametros += ' AND ProdutoIdentificador = 1 AND (1 = 1 '
  
  DECLARE @Produto varchar(5)
  
  SET @TOTAL_ROWS = 0
  SET @I = 0  
  
  DECLARE CrProdutos CURSOR
  LOCAL SCROLL STATIC
  FOR
    SELECT ITEMS [Produto]
    FROM [CleansingKit].[dbo].[fn_Split](@Produtos, ';') A
  OPEN CrProdutos  
  SET @TOTAL_ROWS = @@CURSOR_ROWS
  WHILE @I < @TOTAL_ROWS
  BEGIN
    SET @I+=1
    FETCH ABSOLUTE @I FROM CrProdutos INTO @Produto
    
    IF @I > 1
       SET @Parametros += ' OR '
    ELSE
       SET @Parametros += ' AND '        
          
    SET @Parametros += '(CodigoComercializado = ''' + Cast(@Produto as varchar(5)) + ''')' 
  END
  
  CLOSE CrProdutos
  DEALLOCATE CrProdutos

  SET @Parametros += ')'  
  
END
ELSE
  SET @Parametros += ' AND ProdutoIdentificador = 0 '
/********************************************************/   

/********************************************************/  
/*SETA PARAMETROS DA(S) MATRICULA(S)*/
/********************************************************/
IF @MatriculaVendedorIdentificadora = 1
BEGIN
  SET @Parametros += ' AND MatriculaVendedorIdentificadora = 1 AND (1 = 1 '
  
  DECLARE @Matricula varchar(5)
  
  SET @TOTAL_ROWS = 0
  SET @I = 0  
  
  DECLARE CrMatriculas CURSOR
  LOCAL SCROLL STATIC
  FOR
    SELECT ITEMS [Produto]
    FROM [CleansingKit].[dbo].[fn_Split](@Matriculas, ';') A
  OPEN CrMatriculas  
  SET @TOTAL_ROWS = @@CURSOR_ROWS
  WHILE @I < @TOTAL_ROWS
  BEGIN
    SET @I+=1
    FETCH ABSOLUTE @I FROM CrMatriculas INTO @Matricula
    
    IF @I > 1
       SET @Parametros += ' OR '
    ELSE
       SET @Parametros += ' AND '        
       
    SET @Parametros += ' (Matricula = ''' + Cast(@Matricula as varchar(5)) + ''')' 
  END
  
  CLOSE CrMatriculas
  DEALLOCATE CrMatriculas

  SET @Parametros += ')'  

END
ELSE
  SET @Parametros += ' AND MatriculaVendedorIdentificadora = 0 '
/********************************************************/
      --  print @Parametros
DECLARE @COMANDO AS NVARCHAR(max)   

        /*
      AND DigitoIdentificador = 1 AND ((Digito = '00' AND Posicao = '1' OR Digito = '99' and Posicao = '1'))
      AND PRD.CodigoComercializado IN ('1405', '1404', '9304') AND ProdutoIdentificador = 1
      AND CM.Matricula IN ('9999','') AND MatriculaVendedorIdentificadora = 1 */          


SET @COMANDO = '
                SELECT DISTINCT CVP.ID [IDCanalVenda], CVP.Nome, CVP.Codigo [CodigoCanal]
                              , CVP.DigitoIdentificador, CDI.Posicao, CDI.Digito 
                              , CVP.ProdutoIdentificador, PRD.CodigoComercializado
                              , CVP.MatriculaVendedorIdentificadora, CM.Matricula 
                FROM Dados.CanalVendaPAR CVP 
                LEFT JOIN Dados.CanalProduto CP
                ON CP.IDCanal = CVP.ID
                LEFT JOIN Dados.CanalDigitoIdentificador CDI
                ON CDI.IDCanal = CVP.ID
                LEFT JOIN Dados.CanalMatricula CM
                ON CM.IDCanal = CVP.ID
                LEFT JOIN Dados.Produto PRD
                ON PRD.ID = CP.IDProduto
                WHERE CVP.CanalVinculador = 1
                  AND CVP.DataFim IS NULL 
                ' + @Parametros 
print @COMANDO                
exec sp_executesql @COMANDO

END  

--EXEC Corporativo.Dados.proc_ChecaConflitoDeCanal @DigitoIdentificador = 0, @DigitosPosicoes = '', @ProdutoIdentificador = 1, @Produtos = '1403', @MatriculaVendedorIdentificadora = 0, @Matriculas = ''

