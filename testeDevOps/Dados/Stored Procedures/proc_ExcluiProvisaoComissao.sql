
/*

	Autor: Jorge Chaves
	Data Criação: 09/01/2018

	Nome: [Dados].[proc_ExcluiProvisaoComissao]
	Descrição:	Procedure que recebe como parametro numero de recibo, 
				data recibo e data competencia e exclui na tabela de comissão Dados.Comissao_partitioned 
				tudo com esses filtros e que estejam com o campo lancamentoprovisao = 1.
		
	Parâmetros de entrada:
	
	 @NumeroRecibo bigint
	,@DataRecibo date 
	,@DataCompetencia date

	Última alteração : 
	
*/

CREATE PROCEDURE [Dados].[proc_ExcluiProvisaoComissao] 
(
 @NumeroRecibo bigint
,@DataRecibo date 
,@DataCompetencia date
)

AS 
BEGIN

DELETE
FROM	Dados.Comissao_partitioned
WHERE       NumeroRecibo	= @NumeroRecibo
		AND DataRecibo		= @DataRecibo
		AND DataCompetencia = @DataCompetencia
		AND LancamentoProvisao = 1
END
