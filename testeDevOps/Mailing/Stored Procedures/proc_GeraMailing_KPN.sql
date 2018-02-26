
/*
	Autor: Egler Vieira
	Data Criação: 2014/09/02

	Descrição: 
	
	Última alteração :                                                                                        
*/

/*******************************************************************************
	Nome: CORPORATIVO.Mailing.proc_GeraMailing_KPN
	Descrição: Procedimento que realiza da lista do mailing que deve ser enviado a KPN.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/  
CREATE PROCEDURE Mailing.proc_GeraMailing_KPN (@DataCalculo DATE, @CodCampanha AS VARCHAR(50), @CodigoProduto AS VARCHAR(5), @DiasQuarentena int, @NomeCampanha varchar(50), @ProdutoOferta varchar(50), @DataArquivo date)
WITH RECOMPILE
AS


--DECLARE @DataCalculo DATE = '2014-08-26', @CodCampanha AS VARCHAR(50) = 'QUALQUER', @CodigoProduto AS VARCHAR(5) = '3176', @DiasQuarentena int = 60, @NomeCampanha AS VARCHAR(50) = 'AQUISIÇÃO AUTO - SIMULADOR 1 SEMANA', @ProdutoOferta AS VARCHAR(50) = 'SEGURO TRANQUILO AUTO '
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON
    --DECLARE @DataCalculo DATE = '2014-10-06', @CodCampanha AS VARCHAR(50) = 'QUALQUER', @CodigoProduto AS VARCHAR(5) = '3176', @DiasQuarentena int = 60, @NomeCampanha AS VARCHAR(50) = 'AQUISIÇÃO AUTO - SIMULADOR 1 SEMANA', @ProdutoOferta AS VARCHAR(50) = 'SEGURO TRANQUILO AUTO ', @DataArquivo date = '2014-09-18'
		

IF NOT EXISTS (SELECT * FROM [Mailing].[MailingAutoKPN] M WHERE M.DataRefMailing = @DataArquivo )
BEGIN

 --DECLARE @DataCalculo DATE = '2014-10-07', @CodCampanha AS VARCHAR(50) = 'QUALQUER', @CodigoProduto AS VARCHAR(5) = '3176', @DiasQuarentena int = 60, @NomeCampanha AS VARCHAR(50) = 'AQUISIÇÃO AUTO - SIMULADOR 1 SEMANA', @ProdutoOferta AS VARCHAR(50) = 'SEGURO TRANQUILO AUTO ', @DataArquivo date = '2014-10-06'
		
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MailingKPN_TMP]') AND type in (N'U') )
 BEGIN
  DROP TABLE dbo.MailingKPN_TMP;
 END

 DECLARE @SomaDia TINYINT = CASE datename(dw,@DataArquivo) WHEN 'Monday' THEN 3
                                                        ELSE 0 END 
 
 CREATE TABLE [dbo].[MailingKPN_TMP](
  [CPFCNPJ]                         [varchar](19) NULL,                
  [NomeCliente]                     [varchar](150) NULL,     
  [CodigoBloco]                     [varchar](2) NULL,     
  [NomeBloco]                       [varchar](100) NULL,     
  [CodCampanha]                     [varchar](50) NULL,     
  [NomeCampanha]                    [varchar](50) NOT NULL,    
  [CodMailing]                      [varchar](58) NULL,     
  [IDTipoCliente]                   [tinyint] NULL,     
  [ProdutoOferta]                   [varchar](50) NULL,
  [Telefone]                        [varchar](20) NULL,     
  [OrdemTelefone]                   [int] NOT NULL,      
  [CPFCNPJ_NOFORMAT]                [varchar](8000) NULL,     
  [Email]                           [varchar](70) NULL,     
  [DataNascimento]                  [date] NULL,       
  [IDIndicador]                     [int] NULL,       
  [IDAgenciaIndicacao]              [smallint] NULL,      
  [IDAgenciaCliente]                [smallint] NULL,      
  [DataCalculo]                     [date] NULL,       
  [IDVeiculo]                       [int] NULL,       
  [LINHATE]                         [bigint] NULL,      
  [LINHAPRODUTO]                    [bigint] NULL,      
  [Produto]                         [varchar](100) NULL     
 );
 
 
 ;WITH CTE
 AS
 (
  SELECT SA.CPFCNPJ, SA.NomeCliente, SA.DataNascimento, SA.Email, COUNT(*) QuantidadeCalculos,  MAX(SA.DataCalculo) DataCalculo, SA.IDTipoCliente-- TC.Codigo [TipoCliente]
    , CASE WHEN SA.DDDTelefoneContato = '' OR SA.DDDTelefoneContato IS NULL THEN '0' ELSE REPLACE(REPLACE(SA.DDDTelefoneContato, '-', ''), ' ','') END [DDDTelefone]   
    , CASE WHEN SA.TelefoneContato = '' OR SA.TelefoneContato IS NULL THEN '0' ELSE REPLACE(REPLACE(SA.TelefoneContato, '-', ''), ' ','') END Telefone
    , SA.CPFCNPJ_NOFORMAT, SA.CPFCNPJ_BIGINT, SA.IDAgenciaVenda [IDAgenciaIndicacao], SA.IDIndicador, SA.IDVeiculo--, SA.IDSituacaoCalculo
  FROM Dados.SimuladorAuto SA WITH(NOLOCK) 
  --GROUP BY SA.CPFCNPJ, SA.NomeCliente, SA.DataNascimento, SA.Email, SA.DDDTelefoneContato, SA.TelefoneContato, SA.IDIndicador, SA.CPFCNPJ_NOFORMAT, SA.CPFCNPJ_BIGINT, SA.IDAgenciaVenda, SA.IDVeiculo,  SA.IDTipoCliente --, SA.IDSituacaoCalculo
  WHERE
  
    NOT EXISTS 
     (
      SELECT *
      FROM DW.FABRICA_CAMP.DBO.MAILING_ENVIADO_KIPANY M WITH(NOLOCK)
      WHERE M.CPF = SA.CPFCNPJ COLLATE SQL_Latin1_General_CP1_CI_AI
        AND M.Data_Mailing >= DATEADD(DD, ABS(@DiasQuarentena + @SomaDia) * -1, @DataCalculo)
      )
 AND NOT EXISTS 
     (
      SELECT *
      FROM DW.DBM_MKT.DBO.BASE_VIPS_NOVO V WITH(NOLOCK)
      WHERE V.CPF_NOFORMAT = SA.CPFCNPJ_BIGINT --COLLATE SQL_Latin1_General_CP1_CI_AI
     )
 AND NOT EXISTS 
     (
      SELECT *
      FROM [Mailing].[MailingAutoKPN] V WITH(NOLOCK)
      WHERE V.CPF = SA.CPFCNPJ_NOFORMAT
	    AND V.DataRefMailing >= DATEADD(DD, ABS(@DiasQuarentena + @SomaDia) * -1, @DataCalculo)
      )
  --AND SA.DataCalculo >= DATEADD(MM, -2, GETDATE())
  AND NOT EXISTS 
	 (
		SELECT *
		FROM Dados.SimuladorAuto SA1 WITH(NOLOCK)
		WHERE SA.CPFCNPJ = SA1.CPFCNPJ
		AND SA1.IDSituacaoCalculo = 4
		AND SA.DataCalculo >= DATEADD(DD, ABS(@DiasQuarentena + @SomaDia) * -1, @DataCalculo)
	 )
  AND SA.TipoPessoa = 'F'  
  AND SA.DataCalculo >= DATEADD(DD, -@SomaDia, @DataCalculo) AND SA.DataCalculo <= @DataCalculo
  AND SA.IDTipoSeguro NOT IN (18)
  GROUP BY SA.CPFCNPJ, SA.NomeCliente, SA.DataNascimento, SA.Email, SA.DDDTelefoneContato, SA.TelefoneContato, SA.IDIndicador, SA.CPFCNPJ_NOFORMAT, SA.CPFCNPJ_BIGINT, SA.IDAgenciaVenda, SA.IDVeiculo,  SA.IDTipoCliente --, SA.IDSituacaoCalculo
 )
 ,  
 CTE1
 AS
 (
  SELECT DISTINCT PC.Nome, PC.CPFCNPJ, RP.Codigo [CodigoBloco], RP.Nome [NomeBloco], PC.Email, PC.DataNascimento, PRP.IDAgenciaVenda [IDAgenciaCliente], PRP.IDProduto
  , CASE WHEN PC.DDDTelefone = '' OR PC.DDDTelefone IS NULL THEN '0' ELSE REPLACE(REPLACE(PC.DDDTelefone, '-', ''), ' ', '') END DDDTelefone
  , CASE WHEN PC.Telefone = '' OR PC.Telefone IS NULL THEN '0' ELSE  REPLACE(REPLACE(PC.Telefone, '-', ''), ' ', '') END Telefone
  , B.CPFCNPJ_NOFORMAT, B.NomeCliente, B.IDIndicador, B.[IDAgenciaIndicacao], B.DataCalculo, B.IDVeiculo, B.IDTipoCliente
  FROM 
     (
       SELECT PC.IDProposta, PC.Nome, PC.CPFCNPJ, PC.DataNascimento, COALESCE(PC.Email, PC.Emailcomercial) Email, PC.DDDResidencial [DDDTelefone], PC.TelefoneResidencial [Telefone]
       FROM Dados.PropostaCliente PC WITH(NOLOCK) 
       WHERE EXISTS (SELECT * FROM CTE CTE WHERE  PC.CPFCNPJ = CTE.CPFCNPJ)

       UNION ALL 
       SELECT PC.IDProposta, PC.Nome, PC.CPFCNPJ, PC.DataNascimento, COALESCE(PC.Emailcomercial, PC.Email) Email, PC.DDDComercial [DDDTelefone], PC.TelefoneComercial [Telefone] 
       FROM Dados.PropostaCliente PC WITH(NOLOCK)  --WHERE TelefoneResidencial LIKE '%2242438%'
       WHERE EXISTS (SELECT * FROM CTE CTE WHERE  PC.CPFCNPJ = CTE.CPFCNPJ)
    
       UNION ALL
       SELECT  PC.IDProposta, PC.Nome, PC.CPFCNPJ, PC.DataNascimento, NULL Email, PC.DDDFax [DDDTelefone], PC.TelefoneFax [Telefone] 
       FROM Dados.PropostaCliente PC WITH(NOLOCK) 
       WHERE EXISTS (SELECT * FROM CTE CTE WHERE  PC.CPFCNPJ = CTE.CPFCNPJ)
     
       UNION ALL
       SELECT  PC.IDProposta, PC.Nome, PC.CPFCNPJ, PC.DataNascimento, NULL Email, PC.DDDCelular [DDDTelefone], PC.TelefoneCelular [Telefone] 
       FROM Dados.PropostaCliente PC WITH(NOLOCK)
       WHERE EXISTS (SELECT * FROM CTE CTE WHERE  PC.CPFCNPJ = CTE.CPFCNPJ)
     
       UNION ALL


       SELECT NULL IDProposta, MC.Nome COLLATE SQL_Latin1_General_CP1_CI_AI Nome, [CPFCNPJ] COLLATE SQL_Latin1_General_CP1_CI_AI [CPFCNPJ], MC.DataNascimento, [EmailPessoal] COLLATE SQL_Latin1_General_CP1_CI_AI [EmailPessoal], Cast(Cast([DDDResidencial] as int) as varchar(3)) COLLATE SQL_Latin1_General_CP1_CI_AI [DDDResidencial], Cast(Cast([TelefoneResidencial] as bigint) as varchar(10)) COLLATE SQL_Latin1_General_CP1_CI_AI [TelefoneResidencial]   
       FROM DW.[DBM_MKT].[dbo].[MUNDO_CAIXA] MC WITH(NOLOCK)
       WHERE EXISTS (SELECT * FROM CTE CTE WHERE  MC.CPFCNPJ COLLATE SQL_Latin1_General_CP1_CI_AI = CTE.CPFCNPJ)

       UNION ALL
	   SELECT NULL IDProposta,  MC.Nome COLLATE SQL_Latin1_General_CP1_CI_AI Nome, [CPFCNPJ] COLLATE SQL_Latin1_General_CP1_CI_AI [CPFCNPJ], MC.DataNascimento, [EmailPessoal] COLLATE SQL_Latin1_General_CP1_CI_AI [EmailPessoal], Cast(Cast([DDDResidencial] as int) as varchar(3)) COLLATE SQL_Latin1_General_CP1_CI_AI [DDDResidencial], Cast(Cast([TelefoneResidencial] as bigint) as varchar(10))  COLLATE SQL_Latin1_General_CP1_CI_AI [TelefoneResidencial]    
	   FROM DW.[DBM_MKT].[dbo].[MUNDO_CAIXA] MC WITH(NOLOCK)
	   WHERE EXISTS (SELECT * FROM CTE CTE WHERE  MC.CPFCNPJ COLLATE SQL_Latin1_General_CP1_CI_AI = CTE.CPFCNPJ)

	   UNION ALL
	   SELECT NULL IDProposta,  MC.Nome COLLATE SQL_Latin1_General_CP1_CI_AI Nome, [CPFCNPJ] COLLATE SQL_Latin1_General_CP1_CI_AI [CPFCNPJ], MC.DataNascimento, [EmailPessoal] COLLATE SQL_Latin1_General_CP1_CI_AI [EmailPessoal], Cast(Cast([DDDResidencial] as int) as varchar(3)) COLLATE SQL_Latin1_General_CP1_CI_AI [DDDResidencial], Cast(Cast([TelefoneResidencial] as bigint) as varchar(10))   COLLATE SQL_Latin1_General_CP1_CI_AI [TelefoneResidencial]   
	   FROM DW.[DBM_MKT].[dbo].[MUNDO_CAIXA] MC WITH(NOLOCK)
	   WHERE EXISTS (SELECT * FROM CTE CTE WHERE  MC.CPFCNPJ COLLATE SQL_Latin1_General_CP1_CI_AI = CTE.CPFCNPJ)

	   UNION ALL
	   SELECT NULL IDProposta,  MC.Nome COLLATE SQL_Latin1_General_CP1_CI_AI Nome, [CPFCNPJ] COLLATE SQL_Latin1_General_CP1_CI_AI [CPFCNPJ], MC.DataNascimento, [EmailPessoal] COLLATE SQL_Latin1_General_CP1_CI_AI [EmailPessoal], Cast(Cast([DDDResidencial] as int) as varchar(3)) COLLATE SQL_Latin1_General_CP1_CI_AI [DDDResidencial], Cast(Cast([TelefoneResidencial] as bigint) as varchar(10))   COLLATE SQL_Latin1_General_CP1_CI_AI [TelefoneResidencial]  
	   FROM DW.[DBM_MKT].[dbo].[MUNDO_CAIXA] MC WITH(NOLOCK)
	   WHERE EXISTS (SELECT * FROM CTE CTE WHERE  MC.CPFCNPJ COLLATE SQL_Latin1_General_CP1_CI_AI = CTE.CPFCNPJ)

		UNION ALL
    SELECT NULL IDProposta, B.NomeCliente, B.CPFCNPJ, B.DataNascimento, B.Email, B.[DDDTelefone], B.[Telefone] 
    FROM CTE B WITH(NOLOCK)              
       --UNION ALL

       --SELECT NULL IDProposta, MC.Nome COLLATE SQL_Latin1_General_CP1_CI_AI, B.CPFCNPJ [CPFCNPJ], MC.DataNascimento, MC.EmailPessoal COLLATE SQL_Latin1_General_CP1_CI_AI, [DDDResidencial], [TelefoneResidencial]
       --FROM  DW.[DBM_MKT].[dbo].[MUNDO_CAIXA] MC
       --INNER JOIN CTE B
       --ON B.CPFCNPJ_BIGINT = Cast(MC.CPFCNPJ as bigint)
    ) PC 
   INNER JOIN CTE B WITH(NOLOCK)
   ON B.CPFCNPJ = PC.CPFCNPJ
   LEFT JOIN Dados.Proposta PRP WITH(NOLOCK)
   ON PRP.ID = PC.IDProposta
   LEFT JOIN Dados.Produto PRD WITH(NOLOCK)
   ON PRP.IDProduto = PRD.ID
   LEFT JOIN Dados.RamoPAR RP WITH(NOLOCK)
   ON RP.ID = PRD.IDRamoPAR
  
 ) 
 INSERT INTO dbo.MailingKPN_TMP
  (    
     [CPFCNPJ],            
     [NomeCliente],        
     [CodigoBloco],        
     [NomeBloco],          
     [CodCampanha],        
     [NomeCampanha],       
     [CodMailing],         
     [IDTipoCliente],        
     [ProdutoOferta],
     [Telefone],           
     [OrdemTelefone],      
     [CPFCNPJ_NOFORMAT],   
     [Email],              
     [DataNascimento],     
     [IDIndicador],        
     [IDAgenciaIndicacao], 
     [IDAgenciaCliente],   
     [DataCalculo],        
     [IDVeiculo],          
     [LINHATE],            
     [LINHAPRODUTO],       
     [Produto]            
  )
 SELECT CTE1.CPFCNPJ, CTE1.NomeCliente, CTE1.CodigoBloco, CTE1.NomeBloco
    , @CodCampanha [CodCampanha], @NomeCampanha [NomeCampanha] 
    , @CodCampanha + '_' + Cast(YEAR(getDate()) as varchar(4)) + RIGHT('00' +Cast(MONTH(getDate()) as varchar(2)),2) + RIGHT('00' + Cast(DAY(getDate()) as varchar(2)),2) [CodMailing]
    , CTE1.[IDTipoCliente], @ProdutoOferta [ProdutoOferta]
    , [Dados].[fn_TrataNumeroTelefone](CTE1.DDDTelefone, CTE1.Telefone) Telefone
    , Case WHEN LEFT(Cast(Cast(CASE WHEN CTE1.Telefone = '' OR CTE1.Telefone IS NULL THEN 0 ELSE REPLACE(CTE1.Telefone, '-', '') END as bigint) as varchar(10)),1) IN (1,2,3,4,5,6) THEN 1 ELSE 2 END [OrdemTelefone]
    , CTE1.CPFCNPJ_NOFORMAT, CTE1.Email, CTE1.DataNascimento, CTE1.IDIndicador, CTE1.[IDAgenciaIndicacao],  CTE1.[IDAgenciaIndicacao] [IDAgenciaCliente], CTE1.DataCalculo, CTE1.IDVeiculo
   
   -- , ROW_NUMBER() OVER (PARTITION BY CTE.CPFCNPJ ORDER BY DDDTelefoneContato, TelefoneContato) [LINHADDD]
    , ROW_NUMBER() OVER (PARTITION BY CTE1.CPFCNPJ ORDER BY Case WHEN LEFT(Cast(Cast(CASE WHEN CTE1.Telefone = '' OR CTE1.Telefone IS NULL THEN 0 ELSE REPLACE(CTE1.Telefone, '-', '') END as bigint) as varchar(10)),1) IN (1,2,3,4,5,6) THEN 1 ELSE 2 END, CTE1.Telefone) [LINHATE]
    , ROW_NUMBER() OVER (PARTITION BY  CTE1.CPFCNPJ ORDER BY RM.Nome ASC ) [LINHAPRODUTO]
    , RM.Nome [Produto]
   -- SC.Descricao [SituacaoCalculo],
 --INTO dbo.MailingKPN_TMP
 FROM CTE1 WITH(NOLOCK)
 LEFT JOIN Dados.Produto P WITH(NOLOCK)
 ON P.ID = CTE1.IDProduto
 OUTER APPLY (SELECT * FROM Dados.fn_RecuperaRamoPAR_Mestre(P.IDRamoPAR) RM) RM

 ;
 
--DECLARE @DataCalculo DATE = '2014-09-18', @CodCampanha AS VARCHAR(50) = 'QUALQUER', @CodigoProduto AS VARCHAR(5) = '3176', @DiasQuarentena int = 60, @NomeCampanha AS VARCHAR(50) = 'AQUISIÇÃO AUTO - SIMULADOR 1 SEMANA', @ProdutoOferta AS VARCHAR(50) = 'SEGURO TRANQUILO AUTO ', @DataArquivo date = '2014-09-19'
--		DELETE FROM [Mailing].[MailingAutoKPN] WHERE [DataRefMailing] = '2014-09-19'
-- SELECT * FROM [Mailing].[MailingAutoKPN] 
 INSERT INTO [Mailing].[MailingAutoKPN]
       (
        [CodCampanha]
       ,[NomeCampanha]
       ,[CodMailing]
       ,[Produto]
       ,[Objetivo]
       ,[CPF]
       ,[Nome]
       ,[Telefone1]
       ,[TipoTelefone1]
       ,[Telefone2]
       ,[TipoTelefone2]
       ,[Telefone3]
       ,[TipoTelefone3]
       ,[Telefone4]
       ,[TipoTelefone4]
       ,[Email]
       ,[DataNascimento]
       ,[ProdutoOferta]
       ,[Produtos GCS]
       ,[TipoCliente]
       ,[CodigoAgenciaIndicacao]
       ,[CodigoAgenciaCliente]
       ,[IndicadorCaixa]
       ,[ASVENIndicacao]
       ,[RegionalPar]
       ,[TerminoVigenciaAtual]
       ,[SuperintendenciaRegional]
       ,[DataCalculo]
       ,[Veiculo]
       ,[CampoX3]
       ,[CampoX4]
       ,[CampoX5]
       ,[CampoX6]
       ,[CampoX7]
       ,[CampoX8]
       ,[CampoX9]
       ,[CampoX10]
       ,[CampoX11]
       ,[CampoX12]
       ,[CampoX13]
       ,[CampoX14]
       ,[CampoX15]
       ,[CampoX16]
       ,[CampoX17]
       ,[CampoX18]
       ,[CampoX19]
       ,[CampoX20]
       ,[CampoX21]
       ,[CampoX22]
       ,[CampoX23]
       ,[CampoX24]
       ,[CampoX25]
       ,[CampoX26]
       ,[CampoX27]
       ,[CampoX28]
       ,[CampoX29]
       ,[CampoX30]
       ,[CampoX31]
       ,[CampoX32]
       ,[CampoX33]
       ,[CampoX34]
       ,[CampoX35]
       ,[CampoX36]
       ,[CampoX37]
       ,[CampoX38]
       ,[CampoX39]
       ,[CampoX40]
       ,[CampoX41]
       ,[CampoX42]
       ,[DataRefMailing]
       )
 SELECT  [CodCampanha]
    , [NomeCampanha]
    , [CodMailing]
    ,'AUTO' [Produto] 
    ,'AQUISIÇÃO' [Objetivo]
    , A.CPFCNPJ_NOFORMAT [CPF]
    , MAX(A.NomeCliente) [Nome]
    --, DDDTelefone
    --, Telefone
    , ISNULL(A1.Telefone, '') Telefone1
    , ISNULL(A1.TipoTelefone, '') TipoTelefone1  
    , ISNULL(A2.Telefone, '') Telefone2
    , ISNULL(A2.TipoTelefone, '') TipoTelefone2   
    , ISNULL(A3.Telefone, '') Telefone3  
    , ISNULL(A3.TipoTelefone, '') TipoTelefone3
    , ISNULL(A4.Telefone, '') Telefone4  
    , ISNULL(A4.TipoTelefone, '') TipoTelefone4
    , ISNULL(A.Email, '') Email
    , A.DataNascimento
    , A.[ProdutoOferta]
    , REPLACE(ISNULL(RM1.Produto1 + ',','') +  ISNULL(RM2.Produto2 + ',','')  +  ISNULL(RM3.Produto3  + ',','')  +  ISNULL(RM4.Produto4 + ',' ,'') +  ISNULL(RM5.Produto5 + ',','') + ISNULL(RM6.Produto6 + ',' ,'') + ' ', ', ', '') [Produtos GCS]
    , TC.Codigo [TipoCliente]
    , ISNULL(U.Codigo, '') [CodigoAgenciaIndicacao]
    , ISNULL(U.Codigo, '') [CodigoAgenciaCliente]
    , F.Matricula [IndicadorCaixa]
    , AI.[ASVEN_INDICADOR] ASVENIndicacao
    , FP.Nome [RegionalPar]
    , 'N/A' TerminoVigenciaAtual
    , SR.Codigo [SuperintendenciaRegional]
    , A.DataCalculo
    , V.Nome Veiculo
    , '' CampoX3
    , '' CampoX4
    , '' CampoX5
    , '' CampoX6
    , '' CampoX7
    , '' CampoX8
    , '' CampoX9
    , '' CampoX10
    , '' CampoX11
    , '' CampoX12
    , '' CampoX13
    , '' CampoX14
    , '' CampoX15
    , '' CampoX16
    , '' CampoX17
    , '' CampoX18
    , '' CampoX19
    , '' CampoX20
    , '' CampoX21
    , '' CampoX22
    , '' CampoX23
    , '' CampoX24
    , '' CampoX25
    , '' CampoX26
    , '' CampoX27
    , '' CampoX28
    , '' CampoX29
    , '' CampoX30
    , '' CampoX31
    , '' CampoX32
    , '' CampoX33
    , '' CampoX34
    , '' CampoX35
    , '' CampoX36
    , '' CampoX37
    , '' CampoX38
    , '' CampoX39
    , '' CampoX40
    , '' CampoX41
    , '' CampoX42
    , DATEADD(DD, 1, @DataCalculo) [DataRefMailing]

 FROM MailingKPN_TMP A
 INNER JOIN Dados.TipoCliente TC
 ON A.IDTipoCliente = TC.ID
 LEFT JOIN Dados.Veiculo V WITH(NOLOCK)
 on V.ID = A.IDVeiculo
 --OUTER APPLY (SELECT TOP 1 * FROM Dados.fn_RecuperaUnidade_PointInTime(A.[IDAgenciaIndicacao], A.DataCalculo)) U
 LEFT JOIN Dados.Unidade U WITH(NOLOCK)
 ON U.ID = A.[IDAgenciaCliente]
 OUTER APPLY (SELECT TOP 1 ISNULL(UD.NmAsVen,-1) [ASVEN_INDICADOR] FROM DW.DW.[dados].[DimUnidadeDinamica] UD WHERE UD.[PVCodigo] = U.Codigo) AI 
 LEFT JOIN Dados.Funcionario F WITH(NOLOCK)
 on F.ID = A.IDIndicador
 --OUTER APPLY (SELECT PRD.Descricao [ProdutoOferta] FROM Dados.Produto PRD WHERE PRD.CodigoComercializado = @CodigoProduto)  P
 OUTER APPLY (SELECT Codigo, IDFilialPARCorretora FROM Dados.fn_RecuperaSR(U.Codigo)) SR
 LEFT JOIN Dados.FilialPARCorretora FP WITH(NOLOCK)
 ON FP.ID = SR.IDFilialPARCorretora
 OUTER APPLY (SELECT TOP 1  A1.Telefone Telefone, ISNULL(A1.LINHATE,0) LINHATE
     ,CASE WHEN  A1.Telefone IS NULL THEN NULL 
        ELSE 
         CASE WHEN  A1.OrdemTelefone = 1 THEN 'FIXO' 
           ELSE 'MÓVEL'
         END 
       END TipoTelefone
     FROM MailingKPN_TMP A1
     WHERE A1.CPFCNPJ = A.CPFCNPJ
       --AND A1.LINHATE = 1
       AND 
       A1.OrdemTelefone = 1 
       AND A1.Telefone IS NOT NULL
     ORDER BY A1.OrdemTelefone, A1.LINHATE, A1.Telefone) A1
 OUTER APPLY (SELECT TOP 1 A2.Telefone Telefone, A2.LINHATE
     ,CASE WHEN  A2.Telefone IS NULL THEN NULL 
        ELSE 
         CASE WHEN  A2.OrdemTelefone = 1 THEN 'FIXO' 
           ELSE 'MÓVEL'
         END 
       END TipoTelefone

     FROM MailingKPN_TMP A2
     WHERE A2.CPFCNPJ = A.CPFCNPJ
       --AND A2.LINHATE = 2
       AND ISNULL(A2.LINHATE,1) > ISNULL(A1.LINHATE,0)
       AND ISNULL(A2.Telefone,0) <> ISNULL(A1.Telefone,0)
       AND A2.Telefone IS NOT NULL      
    ORDER BY A2.OrdemTelefone, A2.LINHATE, A2.Telefone
     ) A2
 OUTER APPLY (SELECT TOP 1 A3.Telefone Telefone, A2.LINHATE
     ,CASE WHEN  A3.Telefone IS NULL THEN NULL 
        ELSE 
         CASE WHEN  A3.OrdemTelefone = 1 THEN 'FIXO' 
           ELSE 'MÓVEL'
         END 
       END TipoTelefone
     FROM MailingKPN_TMP A3
     WHERE A3.CPFCNPJ = A.CPFCNPJ
       --AND A2.LINHATE = 2
       AND ISNULL(A3.LINHATE,1) > ISNULL(A2.LINHATE,0)      
       AND ISNULL(A3.Telefone,0) <> ISNULL(A1.Telefone,0)
       AND ISNULL(A3.Telefone,0) <> ISNULL(A2.Telefone,0)
       AND A3.Telefone IS NOT NULL      
     ORDER BY A3.OrdemTelefone, A3.LINHATE, A3.Telefone
     ) A3
OUTER APPLY (SELECT TOP 1 A4.Telefone Telefone, A4.LINHATE
    ,CASE WHEN  A4.Telefone IS NULL THEN NULL 
      ELSE 
       CASE WHEN  A4.OrdemTelefone = 1 THEN 'FIXO' 
        ELSE 'MÓVEL'
       END 
      END TipoTelefone
    FROM MailingKPN_TMP A4
    WHERE A4.CPFCNPJ = A.CPFCNPJ
    --AND T2.LINHATE = 2
    AND ISNULL(A4.LINHATE,1) > ISNULL(A3.LINHATE,0)      
    AND ISNULL(A4.Telefone,0) <> ISNULL(A1.Telefone,0)
    AND ISNULL(A4.Telefone,0) <> ISNULL(A2.Telefone,0)
    AND ISNULL(A4.Telefone,0) <> ISNULL(A3.Telefone,0)
    AND A4.Telefone IS NOT NULL      
    ORDER BY A4.OrdemTelefone, A4.LINHATE, A4.Telefone
    ) A4
 OUTER APPLY (SELECT TOP 1 A1.Produto [Produto1], A1.[LINHAPRODUTO]
     FROM MailingKPN_TMP A1
     WHERE A1.CPFCNPJ = A.CPFCNPJ
       AND A1.Produto IS NOT NULL
     ORDER BY [LINHAPRODUTO]
     ) RM1
 OUTER APPLY (SELECT TOP 1 A2.Produto [Produto2], A2.[LINHAPRODUTO]
     FROM MailingKPN_TMP A2
     WHERE A2.CPFCNPJ = A.CPFCNPJ
       AND A2.Produto IS NOT NULL
       --AND A2.LINHAPRODUTO = 2
       AND A2.[LINHAPRODUTO] > RM1.[LINHAPRODUTO]
       AND A2.Produto <> RM1.Produto1
       ) RM2
 OUTER APPLY (SELECT TOP 1 A3.Produto [Produto3], A3.[LINHAPRODUTO]
     FROM MailingKPN_TMP A3
     WHERE A3.CPFCNPJ = A.CPFCNPJ
       AND A3.Produto IS NOT NULL
       --AND A3.LINHAPRODUTO = 3
       AND A3.[LINHAPRODUTO] > RM2.[LINHAPRODUTO]
       AND A3.Produto <> RM2.Produto2
      ORDER BY [LINHAPRODUTO]
       ) RM3
 OUTER APPLY (SELECT TOP 1 A4.Produto [Produto4], A4.[LINHAPRODUTO]
     FROM MailingKPN_TMP A4
     WHERE A4.CPFCNPJ = A.CPFCNPJ
       AND A4.Produto IS NOT NULL
       --AND A4.LINHAPRODUTO = 4
       AND A4.[LINHAPRODUTO] > RM3.[LINHAPRODUTO]
       AND A4.Produto <> RM3.Produto3
      ORDER BY [LINHAPRODUTO]
       ) RM4
 OUTER APPLY (SELECT TOP 1 A5.Produto [Produto5], A5.[LINHAPRODUTO]
     FROM MailingKPN_TMP A5
     WHERE A5.CPFCNPJ = A.CPFCNPJ
       AND A5.Produto IS NOT NULL
       --AND A5.LINHAPRODUTO = 5
       AND A5.[LINHAPRODUTO] > RM4.[LINHAPRODUTO]
       AND A5.Produto <> RM4.Produto4
      ORDER BY [LINHAPRODUTO]
       ) RM5
 OUTER APPLY (SELECT TOP 1 A6.Produto [Produto6]
     FROM MailingKPN_TMP A6
     WHERE A6.CPFCNPJ = A.CPFCNPJ
       AND A6.Produto IS NOT NULL
       --AND A6.LINHAPRODUTO = 6
       AND A6.[LINHAPRODUTO] > RM5.[LINHAPRODUTO]
       AND A6.Produto <> RM5.Produto5
      ORDER BY [LINHAPRODUTO]
       ) RM6
 WHERE A.LINHATE = 1
 AND NOT (A1.Telefone IS NULL AND A2.Telefone IS NULL AND A3.Telefone IS NULL AND A4.Telefone IS NULL)
  GROUP BY A.CPFCNPJ_NOFORMAT
    , A1.Telefone 
    , A2.Telefone
    , A3.Telefone
 , A4.Telefone
    , A.Email
    , A.DataNascimento
    , REPLACE(ISNULL(RM1.Produto1 + ',','') +  ISNULL(RM2.Produto2 + ',','')  +  ISNULL(RM3.Produto3  + ',','')  +  ISNULL(RM4.Produto4 + ',' ,'') +  ISNULL(RM5.Produto5 + ',','') + ISNULL(RM6.Produto6 + ',' ,'') + ' ', ', ', '')
    , U.Codigo 
    , F.Matricula 
    , FP.Nome 
    , V.Nome 
    , A1.TipoTelefone
    , A2.TipoTelefone
    , A3.TipoTelefone
 , A4.TipoTelefone
    , SR.Codigo
    , A.DataCalculo
    , A.[CodCampanha]
    , A.[NomeCampanha]
    , A.[CodMailing]
    , TC.Codigo --.[TipoCliente]
    , A.[ProdutoOferta]
 , AI.[ASVEN_INDICADOR]
    --,A1.LINHATE
    --,A2.LINHATE
 
END

--EXEC Mailing.proc_GeraMailing_KPN '2014-08-28', 'CAMPANHA', '3177', 60, 'AQUISIÇÃO AUTO - SIMULADOR 1 SEMANA', 'SEGURO TRANQUILO AUTO'
