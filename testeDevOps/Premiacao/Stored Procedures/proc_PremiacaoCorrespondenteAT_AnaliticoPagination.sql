

/*
	Autor: Egler Vieira
	Data Criação: 2014/04/16

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Premiacao.proc_PremiacaoCorrespondenteAT_AnaliticoPagination
	Descrição: Procedimento que realiza a recuperação da premiação analítica dos correspondentes lotéricos (paginado).
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/  
CREATE PROCEDURE [Premiacao].[proc_PremiacaoCorrespondenteAT_AnaliticoPagination]
	@Mes CHAR(2),
	@Ano CHAR(4),
	@StartingRowNumber INT,
    @RowCountPerPage INT
AS

DECLARE	@Dia CHAR(2) = '01',
		@DataInicio date,
		@DataFim date

SET @DataInicio = CAST(@Ano + '-' + @Mes + '-' + @Dia AS DATE)
SET @DataFim = DATEADD(DD,-1,DATEADD(MM,1,@DataInicio))

SELECT 
	VW.ID, 
	VW.Matricula, 
	VW.CPFCNPJ, 
	VW.Nome, 
	VW.Cidade, 
	VW.UF,
	VW.Banco,	
	VW.[AgenciaConta],	
	REPLACE(VW.[ContaCorrente],'-',' . '),
	VW.NumeroProposta, 
	VW.NumeroContrato, 
	VW.NumeroBilhete, 
	VW.NumeroEndosso, 
	VW.NumeroRecibo, 
	VW.NumeroParcela, 
	VW.[CodigoOperacao],  
	VW.DataArquivo, 
	VW.[ValoCorretagem]
FROM Premiacao.vw_PremiacaoCorrespondenteAT_Analitico VW
WHERE VW.DataArquivo BETWEEN @DataInicio  and  @DataFim
ORDER BY VW.ID
OFFSET (@StartingRowNumber - 1) * @RowCountPerPage 
ROWS FETCH NEXT @RowCountPerPage ROWS ONLY