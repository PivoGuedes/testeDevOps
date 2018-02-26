
/*
	Autor: Egler Vieira
	Data Criação: 10/04/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_AUTOVARIAVEL_TIPO4
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_AUTOVARIAVEL_TIPO4] 
AS

SET DATEFORMAT YMD

BEGIN TRY		

SET NOCOUNT ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP]') AND type in (N'U') /*ORDER BY NAME*/)
	RAISERROR   (N'A tabela temporária [AUTOVARIAVEL_TIPO4_SRG_TMP] não foi encontrada',
    16, -- Severity.
    1 -- State.
    );
	
DECLARE @Codigo [bigint] 
DECLARE @NomeArquivo [nvarchar](100) 
DECLARE @DataArquivo [date] 
DECLARE @NumeroProposta [VARchar](20)
DECLARE @IDProposta [bigint]
DECLARE @DataHoraProcessamento [datetime2](7) 
DECLARE @TipoArquivo [varchar](15)
DECLARE	@CodigoVeiculo [varchar](6)
DECLARE	@DescricaoVeiculo [varchar](60)
DECLARE	@CodigoRegiao [varchar](4)
DECLARE	@AnoFabricacao [varchar](4)
DECLARE	@AnoModelo [varchar](4)
DECLARE	@Capacidade [tinyint]
DECLARE	@CodigoBonus [tinyint]
DECLARE	@CodigoSubProduto [varchar] (6)
DECLARE	@ClasseFranquia [varchar](13)
DECLARE	@CodigoClasseFranquia [TINYINT]
DECLARE	@Cobertura [varchar](1) 
DECLARE	@DataInicioVigencia [date]
DECLARE	@DataFimVigencia [date]
DECLARE	@Combustivel [varchar](8)
DECLARE	@PlacaVeiculo [varchar](8)
DECLARE	@CHASSIS [varchar](20)
DECLARE	@NumeroApoliceAnterior [varchar](21)
DECLARE	@QuantidadeParcelas [varchar](2)
DECLARE	@NomeCondutor1 [varchar](100)
DECLARE	@EstadoCivilCondutor1 [varchar] (20)
DECLARE	@SexoCondutor1 [varchar] (20)
DECLARE	@RGCondutor1 [varchar](20)
DECLARE	@DataNascimentoCondutor1 [date]
DECLARE	@CNHCondutor1 [varchar](20)
DECLARE	@DataCNHCondutor1 [date]
DECLARE	@CodigoRelacionamento [varchar](2)
DECLARE	@NomeCondutor2 [varchar] (100)
DECLARE	@EstadoCivilCondutor2 [varchar] (20)
DECLARE	@SexoCondutor2 [varchar] (20)
DECLARE	@RGCondutor2 [varchar] (20)
DECLARE	@DataNascimentoCondutor2 [date]
DECLARE	@CNHCondutor2 [varchar] (20)
DECLARE	@DataCNHCondutor2 [date]
DECLARE	@CodigoRelacionamentoCondutor2 [varchar] (2)
DECLARE	@VersaoCalculo [varchar](4)
DECLARE	@CodigoSeguradora [varchar](5)
DECLARE	@CodigoRegiaoVistoriada [varchar](4)
DECLARE	@CodigoTipoSeguro [varchar](2)
DECLARE	@TipoSeguro [varchar](35)
DECLARE @TP [varchar] (50)
DECLARE @LastValue bit/*Caso não exista nenhum registro ainda, o registro será lançado como LastValue = 1 (ATIVO)*/

DECLARE @I INT
DECLARE @TOTALROWS INT

update [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP] set NumeroProposta =  Cast(dbo.fn_TrataNumeroPropostaZeroExtra([NumeroProposta]) as VARCHAR(20))

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------
      
      ;MERGE INTO Dados.Proposta AS T
	      USING (SELECT   SRG.[NumeroProposta] NumeroProposta, 1 [IDSeguradora], 'AUTO_SRG' [TipoDado], MAX(SRG.DataArquivo) DataArquivo
				 FROM [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP] SRG
				 GROUP BY SRG.[NumeroProposta]
              ) X
         ON T.NumeroProposta = X.NumeroProposta  
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);		               
	-----------------------------------------------------------------------------------------------------------------------

    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 1 [IDSeguradora], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], 'AUTO_SRG' [TipoDado], MAX(SRG.DataArquivo) [DataArquivo]
             FROM [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP] SRG
		  INNER JOIN Dados.Proposta PRP
          ON PRP.NumeroProposta = SRG.NumeroProposta
          AND PRP.IDSeguradora = 1
		  GROUP BY PRP.ID
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN NOT MATCHED
	          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
	               VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);


DECLARE C CURSOR LOCAL SCROLL STATIC
FOR
SELECT A.[Codigo],A.[NomeArquivo],A.[DataArquivo], Cast(dbo.fn_TrataNumeroPropostaZeroExtra(A.[NumeroProposta]) as VARCHAR(20)) NumeroProposta
      ,PRP.ID [IDProposta], A.[DataHoraProcessamento],A.[TipoArquivo]
      ,A.[CodigoVeiculo],A.[DescricaoVeiculo],A.[CodigoRegiao],A.[AnoFabricacao],A.[AnoModelo],A.[Capacidade]
      ,A.[CodigoBonus],A.[CodigoSubProduto],A.[CodigoClasseFranquia],A.[ClasseFranquia],A.[Cobertura],Cast(A.[DataInicioVigencia] as date),cast(A.[DataFimVigencia] as date)
      ,A.[Combustivel],A.[PlacaVeiculo],A.[CHASSIS],A.[NumeroApoliceAnterior],A.[QuantidadeParcelas],A.[NomeCondutor1]
      ,A.[EstadoCivilCondutor1],A.[SexoCondutor1],A.[RGCondutor1],cast(A.[DataNascimentoCondutor1] as date),A.[CNHCondutor1]
      ,cast(A.[DataCNHCondutor1] as date),A.[CodigoRelacionamento],A.[NomeCondutor2],A.[EstadoCivilCondutor2],A.[SexoCondutor2]
      ,A.[RGCondutor2], Cast(A.[DataNascimentoCondutor2] as date),A.[CNHCondutor2],Cast(A.[DataCNHCondutor2] as date),A.[CodigoRelacionamentoCondutor2]
      ,A.[VersaoCalculo],A.[CodigoSeguradora],A.[CodigoRegiaoVistoriada],A.[CodigoTipoSeguro],A.[TipoSeguro], A.[TP]--,[RANK]
FROM [dbo].[AUTOVARIAVEL_TIPO4_SRG_TMP] A
  INNER JOIN Dados.Proposta PRP
  ON PRP.NumeroProposta = Cast(dbo.fn_TrataNumeroPropostaZeroExtra(A.[NumeroProposta]) as VARCHAR(20))
ORDER BY CODIGO
OPEN C

SET @I = 1
SET @TOTALROWS = @@CURSOR_ROWS

WHILE @I <= @TOTALROWS
BEGIN
  FETCH ABSOLUTE @I FROM C INTO @Codigo, @NomeArquivo, @DataArquivo, @NumeroProposta, @IDProposta, @DataHoraProcessamento,
                                @TipoArquivo, @CodigoVeiculo,@DescricaoVeiculo,@CodigoRegiao,@AnoFabricacao,
                                @AnoModelo, @Capacidade, @CodigoBonus, @CodigoSubProduto, @CodigoClasseFranquia, @ClasseFranquia,
                                @Cobertura, @DataInicioVigencia, @DataFimVigencia, @Combustivel,
                                @PlacaVeiculo, @CHASSIS, @NumeroApoliceAnterior, @QuantidadeParcelas,
                                @NomeCondutor1, @EstadoCivilCondutor1, @SexoCondutor1, @RGCondutor1,
                                @DataNascimentoCondutor1, @CNHCondutor1, @DataCNHCondutor1,
                                @CodigoRelacionamento, @NomeCondutor2, @EstadoCivilCondutor2,
                                @SexoCondutor2, @RGCondutor2, @DataNascimentoCondutor2, @CNHCondutor2,
                                @DataCNHCondutor2, @CodigoRelacionamentoCondutor2, @VersaoCalculo,
                                @CodigoSeguradora, @CodigoRegiaoVistoriada, @CodigoTipoSeguro,
                                @TipoSeguro, @TP
                                
--PRINT @Codigo     
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os veículos não encontrados e recebinos no arquivo AUTO VARIAVEL (PRPSASSE TP4)
    -----------------------------------------------------------------------------------------------------------------------
      
      ;MERGE INTO Dados.Veiculo AS T
	      USING (SELECT @CodigoVeiculo [CodigoVeiculo], @DescricaoVeiculo [DescricaoVeiculo]
	             WHERE @DescricaoVeiculo IS NOT NULL AND LTRIM(RTRIM(@DescricaoVeiculo)) <> ''
              ) X
         ON T.Nome = X.DescricaoVeiculo  
       WHEN NOT MATCHED
		          THEN INSERT (Nome, Codigo)
		               VALUES (X.[DescricaoVeiculo], X.[CodigoVeiculo]);
	-----------------------------------------------------------------------------------------------------------------------
	SET @LastValue = 1
	-----------------------------------------------------------------------------------------------------------------------
	--Carrega as variáveis que serão herdadas de registros anteriores e valida se o registro atual deve ou não ser o ATIVO (LastValue)
	-----------------------------------------------------------------------------------------------------------------------
	SELECT @LastValue = CASE WHEN PS.DataInicioVigencia IS NULL OR @DataInicioVigencia >= PS.DataInicioVigencia THEN 1 ELSE 0 END
	     /*	   --Removido pois pode mudar com o endosso / troca de veículo - Egler - 26/09/2013
		 , @CodigoClasseFranquia = CASE WHEN @CodigoClasseFranquia IS NULL OR
		                                     Cast(@CodigoClasseFranquia AS TINYINT) = 0 THEN ISNULL(
																			(SELECT TOP 1 IDClasseFranquia 
																			FROM Dados.PropostaAutomovel PA
																			WHERE PA.IDProposta = @IDProposta
																			AND LastValue = 1
																			--AND PA.IDClasseFranquia <> 0
																			--ORDER BY 	PA.[IDProposta] ASC,
																			--			PA.[DataArquivo] DESC
																			)
																		    , Cast(@CodigoClasseFranquia AS TINYINT)
																			)
				ELSE Cast(@CodigoClasseFranquia AS TINYINT)
		    END  	
		  
		  , @CodigoSeguradora = CASE WHEN @CodigoSeguradora IS NULL OR
		                                  Cast(@CodigoSeguradora AS INT) = 0 THEN ISNULL(
																			(SELECT TOP 1 CodigoSeguradora 
																			FROM Dados.PropostaAutomovel PA
																			WHERE PA.IDProposta = @IDProposta
																			AND LastValue = 1
																			--AND PA.CodigoSeguradora <> 0
																			--ORDER BY 	PA.[IDProposta] ASC,
																			--			PA.[DataArquivo] DESC
																			)
																		    , Cast(@CodigoSeguradora AS INT)
																			)
				ELSE Cast(@CodigoSeguradora AS INT)
		    END
			, @QuantidadeParcelas = CASE WHEN @QuantidadeParcelas IS NULL OR
			                                  Cast(@QuantidadeParcelas AS TINYINT) = 0 THEN ISNULL(
																(SELECT TOP 1 QuantidadeParcelas 
																FROM Dados.PropostaAutomovel PA
																WHERE PA.IDProposta = @IDProposta
																AND LastValue = 1
																--AND PA.CodigoSeguradora <> 0
																--ORDER BY 	PA.[IDProposta] ASC,
																--			PA.[DataArquivo] DESC
																)
																, Cast(@QuantidadeParcelas AS TINYINT)
																)
			ELSE Cast(@QuantidadeParcelas AS INT)
			END   */
    FROM Dados.PropostaAutomovel PS
    WHERE PS.IDProposta = @IDProposta 
      AND PS.LastValue = 1
	-----------------------------------------------------------------------------------------------------------------------


	




	IF (@LastValue = 1)
	BEGIN	
		/*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição*/
		/*Egler - Data: 26/09/2013 */
		UPDATE Dados.PropostaAutomovel SET LastValue = 0
	   -- SELECT *
		FROM Dados.PropostaAutomovel PS
		WHERE PS.IDProposta = @IDProposta 
		  AND PS.LastValue = 1
		  AND (PS.DataInicioVigencia <= @DataInicioVigencia		
		    or PS.DataInicioVigencia IS NULL)
	END

     /***********************************************************************
       Carrega os detalhes da Proposta AUTO
     ***********************************************************************/             
    ;MERGE INTO Dados.PropostaAutomovel AS T
		USING (
     SELECT --@Codigo Codigo
           @NomeArquivo Arquivo
          , @DataArquivo DataArquivo
          , @IDProposta [IDProposta]
          --, @DataHoraProcessamento DataHoraProcessamento
          , @TipoArquivo + ' - ' + @TP [TipoDado]
          --, @CodigoVeiculo CodigoVeiculo
          , (SELECT ID FROM Dados.Veiculo V WHERE V.Nome = @DescricaoVeiculo) IDVeiculo
		  , (SELECT Codigo FROM Dados.Veiculo V WHERE V.Nome = @DescricaoVeiculo) CodigoVeiculo
          , @CodigoRegiao CodigoRegiao
          , @AnoFabricacao AnoFabricacao
          , @AnoModelo AnoModelo
          , @Capacidade Capacidade
          , @CodigoBonus CodigoBonus
          , @CodigoSubProduto CodigoSubProduto
          , @CodigoClasseFranquia CodigoClasseFranquia		 
          --, @ClasseFranquia ClasseFranquia
          , @Cobertura Cobertura
          , @DataInicioVigencia DataInicioVigencia
          , @DataFimVigencia DataFimVigencia
          , @Combustivel Combustivel
          , @PlacaVeiculo Placa
          , @CHASSIS CHASSIS
          , @NumeroApoliceAnterior NumeroApoliceAnterior
          , @QuantidadeParcelas QuantidadeParcelas
          , @NomeCondutor1 NomeCondutor1
          , @EstadoCivilCondutor1 EstadoCivilCondutor1
          , @SexoCondutor1 SexoCondutor1
          , @RGCondutor1 RGCondutor1
          , @DataNascimentoCondutor1  DataNascimentoCondutor1
          , @CNHCondutor1 CNHCondutor1
          , @DataCNHCondutor1 DataCNHCondutor1
          , @CodigoRelacionamento CodigoRelacionamento
          , @NomeCondutor2 NomeCondutor2
          , @EstadoCivilCondutor2 EstadoCivilCondutor2
          , @SexoCondutor2 SexoCondutor2
          , @RGCondutor2 RGCondutor2
          , @DataNascimentoCondutor2 DataNascimentoCondutor2
          , @CNHCondutor2 CNHCondutor2
          , @DataCNHCondutor2 DataCNHCondutor2
          , @CodigoRelacionamentoCondutor2 CodigoRelacionamentoCondutor2
          --, @VersaoCalculo VersaoCalculo
          , @CodigoSeguradora CodigoSeguradora
          --, @CodigoRegiaoVistoriada CodigoRegiaoVistoriada
          , Cast(@CodigoTipoSeguro as TINYINT) CodigoTipoSeguro
          --, @TipoSeguro               
		  , @LastValue LastValue
      ) X
  ON    X.IDProposta = T.IDProposta  
   --AND X.DataArquivo = T.DataArquivo
    AND ISNULL(ISNULL(X.Chassis, T.Chassis),'NÃO FORNECIDO') = ISNULL(ISNULL(T.Chassis, X.Chassis), 'NÃO FORNECIDO')
   WHEN MATCHED AND (X.DataInicioVigencia >= T.DataInicioVigencia OR T.DataInicioVigencia IS NULL)
		THEN UPDATE
		     SET Arquivo = COALESCE(X.[Arquivo], T.[Arquivo])
               , DataArquivo = COALESCE(X.[DataArquivo], T.[DataArquivo])
               --, IDProposta = COALESCE(X.[IDProposta], T.[IDProposta])
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
               , IDTipoSeguro = COALESCE(X.[CodigoTipoSeguro], T.[IDTipoSeguro])
               , IDVeiculo = CASE WHEN X.CodigoVeiculo <> 0 THEN COALESCE(X.[IDVeiculo], T.[IDVeiculo])	ELSE COALESCE(T.[IDVeiculo], X.[IDVeiculo]) END
               , AnoFabricacao = COALESCE(X.[AnoFabricacao], T.[AnoFabricacao])
               , AnoModelo = COALESCE(X.[AnoModelo], T.[AnoModelo])
               , Capacidade = COALESCE(X.[Capacidade], T.[Capacidade])
               , IDClasseBonus = COALESCE(X.[CodigoBonus], T.[IDClasseBonus])
               , IDClasseFranquia =  COALESCE(X.[CodigoClasseFranquia], T.[IDClasseFranquia])
               , DataInicioVigencia = COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
               , DataFimVigencia = COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])
               , Combustivel = COALESCE(X.[Combustivel], T.[Combustivel])
               , Placa = COALESCE(X.[Placa], T.[Placa])
               , CHASSIS = COALESCE(X.[CHASSIS], T.[CHASSIS])
               , CodigoSubProduto = COALESCE(X.[CodigoSubProduto], T.[CodigoSubProduto])
               , NumeroApoliceAnterior = COALESCE(X.[NumeroApoliceAnterior], T.[NumeroApoliceAnterior])
               , QuantidadeParcelas =  CASE WHEN T.QuantidadeParcelas = 0 AND X.QuantidadeParcelas > 0 THEN COALESCE(X.QuantidadeParcelas, T.QuantidadeParcelas)	ELSE COALESCE(T.QuantidadeParcelas, X.QuantidadeParcelas) END
               , NomeCondutor1 = COALESCE(X.[NomeCondutor1], T.[NomeCondutor1])
               , EstadoCivilCondutor1 = COALESCE(X.[EstadoCivilCondutor1], T.[EstadoCivilCondutor1])
               , SexoCondutor1 = COALESCE(X.[SexoCondutor1], T.[SexoCondutor1])
               , RGCondutor1 = COALESCE(X.[RGCondutor1], T.[RGCondutor1])
               , DataNascimentoCondutor1 = COALESCE(X.[DataNascimentoCondutor1], T.[DataNascimentoCondutor1])
               , CNHCondutor1 = COALESCE(X.[CNHCondutor1], T.[CNHCondutor1])
               , DataCNHCondutor1 = COALESCE(X.[DataCNHCondutor1], T.[DataCNHCondutor1])
               , CodigoRelacionamento = COALESCE(X.[CodigoRelacionamento], T.[CodigoRelacionamento])
               , NomeCondutor2 = COALESCE(X.[NomeCondutor2], T.[NomeCondutor2])
               , EstadoCivilCondutor2 = COALESCE(X.[EstadoCivilCondutor2], T.[EstadoCivilCondutor2])
               , SexoCondutor2 = COALESCE(X.[SexoCondutor2], T.[SexoCondutor2])
               , RGCondutor2 = COALESCE(X.[RGCondutor2], T.[RGCondutor2])
               , DataNascimentoCondutor2 = COALESCE(X.[DataNascimentoCondutor2], T.[DataNascimentoCondutor2])
               , CNHCondutor2 = COALESCE(X.[CNHCondutor2], T.[CNHCondutor2])
               , DataCNHCondutor2 = COALESCE(X.[DataCNHCondutor2], T.[DataCNHCondutor2])
               , CodigoRelacionamentoCondutor2 = COALESCE(X.[CodigoRelacionamentoCondutor2], T.[CodigoRelacionamentoCondutor2])
               , CodigoSeguradora = COALESCE(X.[CodigoSeguradora], T.[CodigoSeguradora])
			   , LastValue = X.LastValue
               --, CodigoRegiaoVistoriada = COALESCE(X.[CodigoRegiaoVistoriada], T.[CodigoRegiaoVistoriada])
    WHEN NOT MATCHED
		THEN INSERT          
              (   Arquivo
                 ,DataArquivo
                 ,IDProposta
                 ,TipoDado
                 ,IDVeiculo
                 --,@CodigoRegiao CodigoRegiao
                 ,AnoFabricacao
                 ,AnoModelo
                 ,Capacidade
                 ,IDClasseBonus
                 ,CodigoSubProduto 
                 ,IDClasseFranquia
                 ,IDTipoSeguro
                 --,@Cobertura Cobertura
                 ,DataInicioVigencia
                 ,DataFimVigencia
                 ,Combustivel
                 ,Placa
                 ,CHASSIS
                 ,NumeroApoliceAnterior
                 ,QuantidadeParcelas
                 ,NomeCondutor1
                 ,EstadoCivilCondutor1
                 ,SexoCondutor1
                 ,RGCondutor1
                 ,DataNascimentoCondutor1
                 ,CNHCondutor1
                 ,DataCNHCondutor1
                 ,CodigoRelacionamento
                 ,NomeCondutor2
                 ,EstadoCivilCondutor2
                 ,SexoCondutor2
                 ,RGCondutor2
                 ,DataNascimentoCondutor2
                 ,CNHCondutor2
                 ,DataCNHCondutor2
                 ,CodigoRelacionamentoCondutor2
                 ,CodigoSeguradora
				 ,LastValue
                 --,CodigoRegiaoVistoriada
                 )
          VALUES (
                  X.Arquivo
                 ,X.DataArquivo
                 ,X.IDProposta
                 ,X.TipoDado
                 ,X.IDVeiculo
                 --,X.@CodigoRegiao CodigoRegiao
                 ,X.AnoFabricacao
                 ,X.AnoModelo
                 ,X.Capacidade
                 ,X.CodigoBonus
                 ,X.CodigoSubProduto
                 ,X.CodigoClasseFranquia
                 ,X.[CodigoTipoSeguro]
                 --,X.@Cobertura Cobertura
                 ,X.DataInicioVigencia
                 ,X.DataFimVigencia
                 ,X.Combustivel
                 ,X.Placa
                 ,X.CHASSIS
                 ,X.NumeroApoliceAnterior
                 ,X.QuantidadeParcelas
                 ,X.NomeCondutor1
                 ,X.EstadoCivilCondutor1
                 ,X.SexoCondutor1
                 ,X.RGCondutor1
                 ,X.DataNascimentoCondutor1
                 ,X.CNHCondutor1
                 ,X.DataCNHCondutor1
                 ,X.CodigoRelacionamento
                 ,X.NomeCondutor2
                 ,X.EstadoCivilCondutor2
                 ,X.SexoCondutor2
                 ,X.RGCondutor2
                 ,X.DataNascimentoCondutor2
                 ,X.CNHCondutor2
                 ,X.DataCNHCondutor2
                 ,X.CodigoRelacionamentoCondutor2
                 ,X.CodigoSeguradora
				 ,X.LastValue
                 --,X.CodigoRegiaoVistoriada
                 ); 

   SET @I += 1
END
CLOSE C
            
DEALLOCATE C

-- Atualiza o valor da primeira parcela do automóvel, Calculando o premio / QuantidadeParcelas
-- Egler Vieira / Luan Moreno
-- Última alteração: 04/11/2013 - Egler (Inclusão da cláulula WHERE no final E SOMA DO PremioLiquido com o IOF para calcular o valor da primeira parcela
UPDATE Dados.PropostaAutomovel  
	SET ValorPrimeiraParcela = PE.Valor--CAST(ROUND(ValorPremioLiquido+ISNULL(ValorIOF,0)/CASE WHEN QuantidadeParcelas = 0 THEN 1 ELSE QuantidadeParcelas END,2,1) AS DECIMAL(19,2))
FROM --Dados.PropostaEndosso AS PE	 --Alterado. Constatou-se que o valor da parcela, no caso do auto, é igual ao campo [Valor] da tabela Proposta, quando é a proposta com valor original (Endosso ZERO). 
                                     --Eventualmente pode acontecer de haver endosso no mesmo dia da proposta original. Nesses casos, pode-se atualizar o valor atravez do Premio que chegar na EMISSÃO (Dados.Endosso.ValorPremioBruto / Dados.Endosso.QuantidadeDeParcelas), quando o Endosso = 0.
									 --Alterado em 04/11/2013 - Egler
       Dados.Proposta PE
INNER JOIN Dados.PropostaAutomovel AS PA
--ON PE.IDProposta = PA.IDProposta
ON PE.ID = PA.IDProposta
AND PE.DataInicioVigencia = PA.DataInicioVigencia
WHERE PA.IDProposta = @IDProposta
AND (PA.ValorPrimeiraParcela IS NULL OR	PA.ValorPrimeiraParcela = 0)


--  Transporta o Valor da Classe de Franquia (recebida apenas no endosso original) para os lançamentos subsequentes da tabela proposta automóvel para a cada proposta
-- Egler Vieira: 04/11/2013
;WITH CTE
AS
(
SELECT  PA.ID, PA.IDProposta, PA.IDClasseBonus, PA.IDClasseFranquia, PA.DataInicioVigencia, PA.DataArquivo
      , ROW_NUMBER() OVER (PARTITION BY PA.IDProposta ORDER BY PA.DataInicioVigencia, PA.DataArquivo) [RowNumber] 
FROM Dados.PropostaAutomovel PA
WHERE IDProposta = @IDProposta
)
--SELECT *
UPDATE Dados.PropostaAutomovel SET IDClasseFranquia = A.IDClasseFranquia  --Atualização da classe de franquia
FROM  Dados.PropostaAutomovel PA
CROSS APPLY (SELECT A.ID, A.IDProposta, A.IDClasseFranquia
			 FROM CTE A
			 WHERE PA.IDProposta = A.IDProposta	  
				AND EXISTS (SELECT *
							  FROM CTE B
							  WHERE	B.RowNumber > 1
							  AND B.IDProposta = A.IDProposta)
				AND A.RowNumber = 1
			)  A
WHERE A.ID <> PA.ID;



END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     