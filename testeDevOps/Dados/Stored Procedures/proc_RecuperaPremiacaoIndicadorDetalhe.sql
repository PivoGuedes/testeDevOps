

/*
	Autor: Egler Vieira
	Data Criação: 19/05/2015

	Descrição: 
	
	Última alteração : 


*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaPremiacaoIndicadorDetalhe
	Descrição: Procedimento que realiza o retorno dos itens pagos para o indicador.
		
	Parâmetros de entrada: Mês de recebimento do arquivo
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE Dados.proc_RecuperaPremiacaoIndicadorDetalhe(@Matricula varchar(20), @Ano int, @Mes int)
AS

--DECLARE @Matricula varchar(20) = '00829187', @Ano int = 2015, @Mes int = 4
--SELECT * FROM DADOS.Funcionario WHERE ID = 27490

DECLARE @DATAINI DATE = Cast(Cast(@Ano as varchar(4)) + '-' + right('00' + Cast(@Mes as varchar(2)),2) + '-01' AS DATE)

DECLARE @DATAFIM DATE = EOMONTH (@DATAINI )

--SELECT  @DATAINI, @DATAFIM

SELECT
    F.Nome AS NomeIndicador,
    F.Matricula,
    P.ValorBruto,
    P.DataArquivo,
    P.NumeroApolice, 
    P.NumeroParcela, 
    P.NumeroEndosso, 
    PP.Descricao AS NomeProduto,
	P.NumeroApolice,
    P.NumeroTitulo,
	P.Gerente,
	P.IDLote
FROM DADOS.PremiacaoIndicadores P 
INNER JOIN DADOS.Funcionario F ON F.ID = P.IDFuncionario 
INNER JOIN Dados.ProdutoPremiacao PP ON PP.ID = P.IDProdutoPremiacao
WHERE 
     F.Matricula = @Matricula
AND P.DataArquivo BETWEEN @DATAINI AND @DATAFIM
OPTION(OPTIMIZE FOR(@Matricula UNKNOWN, @DATAINI UNKNOWN, @DATAFIM UNKNOWN))
