
/*
	Autor: Egler Vieira
	Data Criação: 24/02/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_ImportaCalculoImpostosProtheus_INDICADORES
	Descrição: Procedimento que realiza a verificação de imposto calculado (no Protheus) e importação para o extrato de indicadores .
		
	Parâmetros de entrada:	
					
	Retorno:

*******************************************************************************/

CREATE PROCEDURE Dados.proc_ImportaCalculoImpostosProtheus_INDICADORES
AS

-----------CARREGA OS LOTES DISPONÍVEIS - INÍCIO-----------------
BEGIN TRAN
--##BLOCO REMOVIDO EM 10/08/2015 por não atender mais às necessidades de integração Protheus x ODS
--##Quem: Egler Vieira

--;
--MERGE INTO ControleDados.LoteProtheus 
--AS T
--USING
--(
--	--SELECT  ZB2_CODIGO Codigo, CASE WHEN Z.D_E_L_E_T_ = '' THEN ZB2_STATUS ELSE 'EXCLUIDO' END [Status] --, ZB2_ANO, ZB2_MES, Z.D_E_L_E_T_
--	--       , ZB2_ANO Ano, ZB2_MES Mes
--	--	   select *
--	--FROM [SCASE].[RBDF27].[dbo].[ZB2010] Z
--	--WHERE Z.ZB2_CODIGO COLLATE SQL_Latin1_General_CP1_CI_AI NOT IN (SELECT Codigo
--	--															    FROM ControleDados.LoteProtheus LP
--	--															    WHERE LP.Processado = 1
--	--																OR LP.[Status] = 'EXCLUIDO')

																	
--	SELECT DISTINCT ZB3_CODIGO, Cast(ZB3_IDLOTE as int) ZB3_IDLOTE 
--	FROM [SCASE].[RBDF27].[dbo].[ZB3010] Z WITH(NOLOCK) 
--	WHERE ZB3_ARQVAN = 'S' AND ZB3_IDLOTE IN (
--	                                          SELECT ID
--											  FROM [ControleDados].[LoteProtheus]  LP
--										  	  WHERE LP.Codigo IS NULL
--											  AND  (LP.Processado IS NULL OR LP.Processado = 0)
--											  )

--	--SELECT *
--	--FROM [ControleDados].[LoteProtheus] 
--	--WHERE Codigo IS NULL
--) S
--ON
-- T.ID = S.ZB3_IDLOTE

--WHEN MATCHED  THEN
--  UPDATE set [Status] = S.[Status]
--		   , Ano = S.Ano
--		   , Mes = S.Mes
--WHEN  NOT MATCHED THEN
--  INSERT (Tipo, Codigo, [Status], Ano, Mes)
--  VALUES (S.Tipo, S.Codigo, S.[Status], S.Ano, S.Mes);
 
-----------CARREGA OS LOTES DISPONÍVEIS - FIM-----------------
--BEGIN TRAN
--SELECT @@TRANCOUNT

DECLARE @TOTAL INT = 0
DECLARE @I     INT
DECLARE @Lote NVARCHAR(10)
DECLARE @IDLote INT = 0
declare @DESTINATARIOS NVARCHAR(500)
DECLARE @ASSUNTO NVARCHAR(300)
DECLARE @TEXTO NVARCHAR(4000)
DECLARE @Status VARCHAR(50)



-----------IMPORTA OS IMPOSTOS DOS OS LOTES DISPONÍVEIS FECHADOS - INÍCIO-----------------
DECLARE C CURSOR
LOCAL SCROLL STATIC
FOR
	--##BLOCO REMOVIDO EM 10/08/2015 por não atender mais às necessidades de integração Protheus x ODS
	--##Quem: Egler Vieira
	--SELECT Codigo--, Ano, Mes
	--FROM ControleDados.LoteProtheus LP
	--WHERE Tipo = 'GI'
	--  AND ([Status] IN ('7') )-- FECHADO
	--  AND LP.Processado = 0

	SELECT DISTINCT ZB3_CODIGO, Cast(ZB3_IDLOTE as int) ZB3_IDLOTE, CASE WHEN Z.D_E_L_E_T_ = '' THEN ZB2_STATUS ELSE 'EXCLUIDO' END [Status]--, ZB2_ANO Ano, ZB2_MES Mes 
	FROM [SCASE].[RBDF27].[dbo].[ZB3010] Z WITH(NOLOCK) 
	INNER JOIN [SCASE].[RBDF27].[dbo].[ZB2010] ZZ WITH(NOLOCK) 
	ON ZZ.ZB2_CODIGO = Z.ZB3_CODIGO
	WHERE  
		 ZZ.D_E_L_E_T_ = ''
	  AND Z.ZB3_ARQVAN = 'S' 
	  AND ZB3_IDLOTE IN  (SELECT ID
						  FROM [ControleDados].[LoteProtheus] LP
						  WHERE  LP.Codigo IS NULL
						     OR (LP.Processado IS NULL OR LP.Processado = 0)
						 )

OPEN C

SET @TOTAL = @@CURSOR_ROWS
SET @I = 1

IF @TOTAL > 0
BEGIN

SELECT @DESTINATARIOS = email, @ASSUNTO = [Desc] 
FROM ControleDados.EmailList WHERE ID = 3 -- INDICADORES NOTIFICAÇÃO DE IMPORTAÇÃO DE LOTE

WHILE @I <= @TOTAL
BEGIN
	FETCH ABSOLUTE @I FROM C INTO @Lote, @IDLote, @Status  

	UPDATE Dados.RePremiacaoIndicadores SET CalculadoAliquotaISS = Z.ZB3_ALIISS,
											CalculadoAliquotaIRRF = Z.ZB3_ALIIRF,
											CalculadoAliquotaINSS = Z.ZB3_ALIINS,
											CalculadoValorISS = Z.ZB3_VALISS, 
											CalculadoValorIRRF = Z.ZB3_VALIRF,
											CalculadoValorINSS = ZB3_VALINS,
											CalculadoTetoINSS = Z.ZB3_INSTET,
											ItemImportacaoPROTHEUS = Z.ZB3_ITEM,
											LoteImportacaoPROTHEUS = Z.ZB3_CODIGO,
											CodigoImportacaoProtheus = Z.ZB3_CODIGO,
											CodigoEmpresaProtheus = '01',
											DataCalculo = Cast(ZB3_DATPRO + ' ' + ZB3_HORPRO as datetime)											

	--SELECT R.*, Z.*
	FROM Dados.RePremiacaoIndicadores R
	INNER JOIN Dados.Funcionario F
	ON F.ID = R.IDFuncionario
	INNER JOIN [SCASE].[RBDF27].[dbo].[ZB3010] Z WITH(NOLOCK) 
	ON Z.[ZB3_MATRIC] COLLATE SQL_Latin1_General_CP1_CI_AI = F.Matricula
	AND Z.[ZB3_NOMARQ] COLLATE SQL_Latin1_General_CP1_CI_AI = R.NomeArquivo
	WHERE Z.[ZB3_CODIGO] = @Lote

	UPDATE ControleDados.LoteProtheus SET Codigo = @Lote, Status = @Status, Processado = 1
	WHERE ID = @IDLote

SET @TEXTO =
'Caro operador,

Informamos que o calculo dos impostos realizado pelo sistema Protheus foi importado e disponibilizado para o Extrato de Indicadores.

Número do lote: ' + @Lote + CHAR(13)
 
set @TEXTO = @TEXTO + 'Data: ' + Cast(Convert(varchar(20), getdate(), 103) as varchar(20)) + ' ' + Cast(Convert(varchar(5), getdate(), 108) as varchar(5)) + CHAR(13) + CHAR(13) 

set @TEXTO = @TEXTO + CHAR(13) + 
'Att,

Gerência de Tecnologia da Informação
PAR CORRETORA DE SEGUROS
www.parcorretora.com.br
'

    -------NOTIFICA IMPORTAÇÃO DO LOTE-----------------
	exec [dbo].[Dados_SendDBMail] @recipients = @DESTINATARIOS,
							      @body = @TEXTO,
							      @subject = @ASSUNTO 

	
	SET @I+=1
END
-----------IMPORTA OS IMPOSTOS DOS OS LOTES DISPONÍVEIS FECHADOS - FIM-----------------
END

COMMIT TRAN
