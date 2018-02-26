
 
/*
	Autor: Pedro Guedes
	Data Criação:21/07/2016

	Descrição: 
	
	Última alteração :
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.[proc_InsereVincendosMensal]
	Descrição: Procedimento que garante a integridade de propostas vicendo de auto
		
	Parâmetros de entrada:


	Retorno:
	


	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereVincendosMensal]
AS

BEGIN TRY		
--set statistics io off
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VincendosMensal_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[VincendosMensal_TEMP];
--select * from [PRESTAMISTA_SIAPX_TEMP]
CREATE TABLE [dbo].[VincendosMensal_TEMP](
	[Codigo] [int] not null,
	[Agencia] [varchar](4) NOT NULL,
	[NomeAgencia] [varchar](60) NOT NULL,
	[Filial] [varchar](10)  NOT NULL,
	[NomeFilial] [varchar](60) NOT NULL,
	[Escrit] [varchar](10) NOT NULL,
	[NomeEscritorio] [varchar](60) NOT NULL,
	[Ter_Vig] [date] NOT NULL,
	[Apolice] [varchar](40) NOT NULL,
	[CGCCPF] [varchar](20) NOT NULL,
	[Segurado] [varchar](60) NOT NULL,
	[Endereco] [varchar](100) NOT NULL,
	[Bairro] [varchar](100) NOT NULL,
	[Cidade] [varchar](100) NOT NULL,
	[UF] [varchar](4) NOT NULL,
	[CEP] [varchar](10) NOT NULL,
	[DDD] [varchar](3) NOT NULL,
	[Fone] [varchar](15) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Veiculo] [varchar](100) NOT NULL,
	[AnoMod] [varchar](10) NOT NULL,
	[Placa] [varchar](10) NOT NULL,
	[Filler] [varchar](40) NOT NULL,
	[Chassi] [varchar](30) NOT NULL,
	[FormaCobr] [varchar](30) NOT NULL,
	[ContaDebito] [varchar](50) NOT NULL,
	[Produto] [varchar](60) NOT NULL,
	[CL_BONUS_A_CONCEDER] [varchar](30) NOT NULL,
	[APP] [varchar](30) NOT NULL,
	[RCDM] [varchar](30) NOT NULL,
	[RCDP] [varchar](30) NOT NULL,
	[VL_Mercado] [varchar](30) NOT NULL,
	[Economiario] [varchar](30) NOT NULL,
	[Matricula] [varchar](30) NOT NULL,
	[Fille2] [varchar](10) NOT NULL,
	[DDD_Unidade] [varchar](3) NOT NULL,
	[Fone_Unidade] [varchar](30) NOT NULL,
	[Tem_Sinistro] [varchar](5) NOT NULL,
	[TP_Franquia] [varchar](30) NOT NULL,
	[Tem_Endosso] [varchar](5) NOT NULL,
	[Tem_Parc_Pend] [varchar](5) NULL,
	[DDD_Celular] [varchar](5) NOT NULL,
	[Celular] [varchar](15) NOT NULL,
	[DDD_Comercial] [varchar](5) NOT NULL,
	[TEL_Comercial] [varchar](15) NOT NULL,
	[DataHoraSistema] [datetime2](7) NOT NULL,
	[NomeArquivo] [varchar](300) NOT NULL,
);



SELECT @PontoDeParada = PontoParada
FROM  ControleDados.PontoParada 
WHERE NomeEntidade = 'PRESTAMISTA_SIAPX'
SET @PontoDeParada = '0'

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
SET @COMANDO =
    N'  INSERT INTO dbo.VincendosMensal_TEMP
      (
	    [Codigo]
      ,[Agencia]
      ,[NomeAgencia]
      ,[Filial]
      ,[NomeFilial]
      ,[Escrit]
      ,[NomeEscritorio]
      ,[Ter_Vig]
      ,[Apolice]
      ,[CGCCPF]
      ,[Segurado]
      ,[Endereco]
      ,[Bairro]
      ,[Cidade]
      ,[UF]
      ,[CEP]
      ,[DDD]
      ,[Fone]
      ,[Email]
      ,[Veiculo]
      ,[AnoMod]
      ,[Placa]
      ,[Filler]
      ,[Chassi]
      ,[FormaCobr]
      ,[ContaDebito]
      ,[Produto]
      ,[CL_BONUS_A_CONCEDER]
      ,[APP]
      ,[RCDM]
      ,[RCDP]
      ,[VL_Mercado]
      ,[Economiario]
      ,[Matricula]
      ,[Fille2]
      ,[DDD_Unidade]
      ,[Fone_Unidade]
      ,[Tem_Sinistro]
      ,[TP_Franquia]
      ,[Tem_Endosso]
      ,[Tem_Parc_Pend]
      ,[DDD_Celular]
      ,[Celular]
      ,[DDD_Comercial]
      ,[TEL_Comercial]
	  ,NomeArquivo
	  ,DataHoraSistema
	  )
       SELECT 
	   [Codigo]
      ,[Agencia]
      ,[NomeAgencia]
      ,[Filial]
      ,[NomeFilial]
      ,[Escrit]
      ,[NomeEscritorio]
      ,[Ter_Vig]
      ,[Apolice]
      ,CpfTratado
      ,[Segurado]
      ,[Endereco]
      ,[Bairro]
      ,[Cidade]
      ,[UF]
      ,[CEP]
      ,[DDD]
      ,[Fone]
      ,[Email]
      ,[Veiculo]
      ,[AnoMod]
      ,[Placa]
      ,[Filler]
      ,[Chassi]
      ,[FormaCobr]
      ,[ContaDebito]
      ,[Produto]
      ,[CL_BONUS_A_CONCEDER]
      ,[APP]
      ,[RCDM]
      ,[RCDP]
      ,[VL_Mercado]
      ,[Economiario]
      ,[Matricula]
      ,[Fille2]
      ,[DDD_Unidade]
      ,[Fone_Unidade]
      ,[Tem_Sinistro]
      ,[TP_Franquia]
      ,[Tem_Endosso]
      ,[Tem_Parc_Pend]
      ,[DDD_Celular]
      ,[Celular]
      ,[DDD_Comercial]
      ,[TEL_Comercial]
	  ,NomeArquivo
	  ,DataHoraSistema
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaVincendosMensal] ''''' + @PontoDeParada + ''''''') PRP
         '
		 --print @COMANDO
	exec sp_executesql  @tsql  = @COMANDO

SELECT *-- @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.VincendosMensal_TEMP PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN


  /***********************************************************************
       Carrega a data de fim de vigência do contrato
     ***********************************************************************/                 
    ;MERGE INTO Dados.Contrato AS T
		USING (
				select Apolice,CGCCPF,c.ID,Ter_Vig
				from VincendosMensal_TEMP v
				inner join Dados.Contrato c on c.NumeroContrato = v.Apolice
          ) AS X
    ON X.ID = T.ID
       WHEN MATCHED
			    THEN UPDATE 
		     SET DataFimVigencia = COALESCE(X.ter_vig,T.DataFimVigencia);
  																	                     
				
   



     /***********************************************************************
       Carrega a data de fim de vigência da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.Proposta AS T
		USING (
				select p.ID,Ter_Vig
				from VincendosMensal_TEMP v
				inner join Dados.Contrato c on c.NumeroContrato = v.Apolice
				inner join Dados.Proposta p on p.ID = c.IDProposta
				          ) AS X
    ON X.ID = T.ID
       WHEN MATCHED
			    THEN UPDATE 
		     SET DataFimVigencia = COALESCE(X.ter_vig,T.DataFimVigencia);



    
      /***********************************************************************/
        
	UPDATE Dados.PropostaEndereco SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaEndereco PS
    WHERE PS.IDProposta IN ( 
	                       SELECT p.ID
							FROM dbo.VincendosMensal_TEMP PRP
							inner join Dados.Contrato c on c.NumeroContrato = PRP.Apolice
							inner join Dados.Proposta p on p.ID = c.IDProposta
							--where prp.DTA_CONCESSAO_CONTR >= '2016-05-06'
						
							  
					

                           )
           AND PS.LastValue = 1
		  
                      
     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaEndereco AS T
		USING (
				SELECT 
					 A. [IDProposta]
					,A.[IDTipoEndereco]
					,A.[Endereco]        
					,A.Bairro              
					,A.Cidade       
					,A.[UF]      
					,A.CEP    
					, 0 LastValue
					, A.[TipoDado]           
					, A.DataArquivo		
				FROM
				(
					SELECT   
						 p.ID [IDProposta]
						,2 [IDTipoEndereco] --Correspondecia
						,RTRIM(PRP.ENDERECO) Endereco
						--,PRT.COMPL_ENDERECO
						,PRP.CIDADE Cidade       
						,PRP.UF       
						,PRP.CEP CEP   
						,PRP.BAIRRO
						--CASE WHEN  
						,NomeArquivo [TipoDado]           
						,PRP.DataHoraSistema DataArquivo
						--,ROW_NUMBER() OVER (PARTITION BY PRP.NumeroPropostaInclusao /*IDProposta*/  ORDER BY PRP.DataArquivo DESC) NUMERADOR	   								
					 FROM dbo.VincendosMensal_TEMP PRP
					inner join Dados.Contrato C on c.NumeroContrato = prp.Apolice
					inner join Dados.Proposta P on  p.ID = c.IDProposta
					--where prp.DTA_CONCESSAO_CONTR >= '2016-05-06'
					

				) A 	
          ) AS X
    ON  X.IDProposta = T.IDProposta
    AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
    --AND X.[DataArquivo] >= T.[DataArquivo]
	AND X.[Endereco] = T.[Endereco]
       WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
		      UPDATE
				SET 
                 Endereco = COALESCE(X.[Endereco], T.[Endereco])
               , Bairro = COALESCE(X.[Bairro], T.[Bairro])
               , Cidade = COALESCE(X.[Cidade], T.[Cidade])
               , UF = COALESCE(X.[UF], T.[UF])
               , CEP = COALESCE(X.[CEP], T.[CEP])
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
			   , DataArquivo = X.DataArquivo
			   , LastValue = X.LastValue
    WHEN NOT MATCHED
			    THEN INSERT          
              ( IDProposta, IDTipoEndereco, Endereco,Bairro                                                                
              , Cidade, UF, CEP, TipoDado, DataArquivo, LastValue)                                            
          VALUES (
                  X.[IDProposta]   
                 ,X.[IDTipoEndereco]                                                
                 ,X.[Endereco]  
                 ,X.[Bairro]   
                 ,X.[Cidade]      
                 ,X.[UF] 
                 ,X.[CEP]            
                 ,X.[TipoDado]       
                 ,X.[DataArquivo]
				 ,X.LastValue   
                 );
		 
	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/ 
    UPDATE Dados.PropostaEndereco SET LastValue = 1
    FROM Dados.PropostaEndereco PE
	INNER JOIN ( 
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC) [ORDEM]
				FROM Dados.PropostaEndereco PS
				WHERE PS.IDProposta IN (
										
	                       select p.ID IDProposta  
							FROM dbo.VincendosMensal_TEMP PRP
							inner join Dados.Contrato C on c.NumeroContrato = prp.Apolice
							inner join Dados.Proposta P on  p.ID = c.IDProposta
						
                           ) 
						
					) A	
	 ON A.ID = PE.ID and IDTipoEndereco = 2 and A.ORDEM = 1





  /*************************************************************************************/
  /*Atualiza os dados na proposta Automóvel											   */ 
  /*************************************************************************************/ 
    ;MERGE INTO Dados.PropostaAutomovel AS T
		USING (       
            
				SELECT --top 10  
				   pa.IDProposta,prp.Placa,prp.Chassi,prp.AnoMod as AnoModelo
				--, ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta  ORDER BY PRP.[DataArquivo] DESC)  [ORDER]
			FROM dbo.VincendosMensal_TEMP PRP				
			inner join Dados.Contrato C on c.NumeroContrato = prp.Apolice
			inner join Dados.Proposta P on  p.ID = c.IDProposta
			inner join Dados.PropostaAutomovel pa on pa.IDProposta = p.ID and pa.LastValue = 1 
			--inner join dados.veiculo v on v.id = pa.idveiculo
	 
		
          ) AS X
    ON  X.[IDProposta] = T.[IDProposta]
	WHEN MATCHED THEN UPDATE SET Placa = COALESCE(X.Placa,T.Placa),
								Chassis = COALESCE(X.Chassi,T.Chassis),
								AnoModelo = COALESCE(X.AnoModelo,T.AnoModelo) ; 											  
     


/*************************************************************************************/
  /*Atualiza os dados na proposta cliente											   */ 
  /*************************************************************************************/ 
 --   ;MERGE INTO Dados.PropostaCliente AS T
	--	USING (      
            
	--			SELECT  case when ddd = '000' then NULL ELSE ddd end as DDDResidencial,case when Fone ='000000000' then null else Fone End as TalefoneResidencial,PRP.Email, 
	--						case when DDD_Celular= '000' then null else DDD_CELULAR END as DDDCelular,
	--							case when Celular ='000000000' then null else Celular end  as TelefoneCelular,
	--							replace(DDD_Comercial,'000',null) as DDDComercial,case when Tel_Comercial ='000000000' then null else Tel_Comercial end as TelefoneComercial,
	--			 *
	--			--, ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta  ORDER BY PRP.[DataArquivo] DESC)  [ORDER]
	--		FROM dbo.VincendosMensal_TEMP PRP				
	--		inner join Dados.Contrato C on c.NumeroContrato = prp.Apolice
	--		inner join Dados.Proposta P on  p.ID = c.IDProposta
	--		inner join Dados.PropostaCliente pc on pc.IDProposta = p.ID and pc.CPFCNPJ = prp.CGCCPF
	--		--inner join dados.veiculo v on v.id = pa.idveiculo
	-- --select top 1 * from dados.propostacliente
		
 --         ) AS X
 --   ON  X.[IDProposta] = T.[IDProposta]
	--WHEN MATCHED THEN UPDATE SET Placa = COALESCE(X.Placa,T.Placa),
	--							Chassis = COALESCE(X.Chassi,T.Chassis),
	--							AnoModelo = COALESCE(X.AnoModelo,T.AnoModelo) ; 											  
     

 
  
  
 /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @PontoDeParada
  WHERE NomeEntidade = 'PRESTAMISTA_SIAPX'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PRESTAMISTA_SIAPX_TEMP]
  
  /*********************************************************************************************************************/
           
SET @COMANDO =
    N'  INSERT INTO dbo.PRESTAMISTA_SIAPX_TEMP
      (
	     [UF]
      ,[CEP]
      ,[DDD]
      ,[MES_REFERENCIA_MOVIMENTO]
      ,[MES_GERACAO_ARQUIVO]
      ,[COD_PRODUTO]
      ,[COD_TIPO_REPASSE]
      ,[SUREG_CONCESSAO]
      ,[AGENCIA_CONCESSAO]
      ,[OPERACAO_APLICACAO]
      ,[NUM_CONTRATO]
      ,[NUM_DV_CONTRATO]
      ,[COD_MODALIDADE_OPER]
      ,[COD_CANAL]
      ,[NOME_CANAL]
      ,[NOME_CLIENTE]
      ,[DTA_CONCESSAO_CONTR]
      ,[DTA_TERMINO_CONTR]
      ,[VALOR_CONTRATO]
      ,[VALOR_SEGURO]
      ,[TIPO_PESSOA]
      ,[NUM_CPF_CGC]
      ,[TAXA_APLICADA]
      ,[COD_NAT_EMPRESA]
      ,[EST_CONTRATO_ORIGEM]
      ,[COD_NAT_PROFISSIONAL]
      ,[PRZ_VENC_CONTRATO]
      ,[DT_NASCIMENTO]
      ,[IDADE]
      ,[SEXO]
      ,[ESTADO_CIVIL]
      ,[ENDERECO]
      ,[COMPL_ENDERECO]
      ,[CIDADE]
      ,[TELEFONE]
      ,[EMAIL]
      ,[COD_MATRICULA]
      ,[TIPO_CORRESPONDENTE]
      ,[COD_CORRESPONDENTE]
      ,[DV_CORRESPONDENTE]
      ,[Column 40]
      ,[NomeArquivo]
      ,[DataArquivo]
      ,[ID]
	  ,[AgenciaInt]
	  )
       SELECT 
	    [UF]
      ,[CEP]
      ,[DDD]
      ,[MES_REFERENCIA_MOVIMENTO]
      ,[MES_GERACAO_ARQUIVO]
      ,[COD_PRODUTO]
      ,[COD_TIPO_REPASSE]
      ,[SUREG_CONCESSAO]
      ,[AGENCIA_CONCESSAO]
      ,[OPERACAO_APLICACAO]
      ,[NUM_CONTRATO]
      ,[NUM_DV_CONTRATO]
      ,[COD_MODALIDADE_OPER]
      ,[COD_CANAL]
      ,[NOME_CANAL]
      ,[NOME_CLIENTE]
      ,[DTA_CONCESSAO_CONTR]
      ,[DTA_TERMINO_CONTR]
      ,[VALOR_CONTRATO]
      ,[VALOR_SEGURO]
      ,[TIPO_PESSOA]
      ,[NUM_CPF_CGC]
      ,[TAXA_APLICADA]
      ,[COD_NAT_EMPRESA]
      ,[EST_CONTRATO_ORIGEM]
      ,[COD_NAT_PROFISSIONAL]
      ,[PRZ_VENC_CONTRATO]
      ,[DT_NASCIMENTO]
      ,[IDADE]
      ,[SEXO]
      ,[ESTADO_CIVIL]
      ,[ENDERECO]
      ,[COMPL_ENDERECO]
      ,[CIDADE]
      ,[TELEFONE]
      ,[EMAIL]
      ,[COD_MATRICULA]
      ,[TIPO_CORRESPONDENTE]
      ,[COD_CORRESPONDENTE]
      ,[DV_CORRESPONDENTE]
      ,[Column 40]
      ,[NomeArquivo]
      ,[DataArquivo]
      ,[ID]
	  ,[AgenciaInt]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaPrestamistaSIAPX] ''''' + @PontoDeParada + ''''''') PRP
         '
		 --print @COMANDO
        
	exec sp_executesql  @tsql  = @COMANDO

   SELECT @MaiorCodigo= MAX(PRP.ID)
   FROM dbo.PRESTAMISTA_SIAPX_TEMP PRP    
                    
update ControleDados.PontoParada  set PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'PRESTAMISTA_SIAPX'

  /*********************************************************************************************************************/
  
END

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRESTAMISTA_SIAPX_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRESTAMISTA_SIAPX_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     
--SELECT * FROM PRESTAMISTA_SIAPX_TEMP WHERE CONTRATO = '04000511034791190'
--SELECT * FROM DADOS.PROPOSTA P INNER JOIN DADOS.PROPOSTACLIENTE PC ON PC.IDProposta = P.id WHERE PC.CPFCNPJ = '030.362.981-93'    
--
--with prp as (
--select * from dados.proposta P 
--where numeroproposta like 'ps%' and p.tipodado like '%CXRELAT%' and dataproposta >= '2016-01-01'
--)select pf.NumeroContratoVinculado,cc.Contrato,* from prp p
--INNER JOIn dados.propostafinanceiro pf on pf.IDPRoposta =  p.ID 
--inner join dados.propostacliente pc on pc.IDProposta = p.ID
--left join Dados.ContratoConsignado cc on cc.contrato = pf.NumeroContratoVinculado
--where pc.CPFCNPJ = '144.546.294-04'

