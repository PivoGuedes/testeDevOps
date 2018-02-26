


/*
	Autor: Pedro Guedes
	Data Criação: 10/02/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: [Corporativo].[Dados].[proc_InsereOdonto_ODS]
	
	Descrição: Procedimento que realiza a inserção das propostas Odonto no ODS

	Parâmetros de entrada:
	
SELECT * FROM dbo.DmSegmento					
	Retorno:


*******************************************************************************/
CREATE  PROCEDURE [Dados].[proc_InsereEmpregadoCAIXA_ODS]
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpregadoCAIXA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[EmpregadoCAIXA_TEMP];
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE dbo.EmpregadoCAIXA_TEMP
(Id bigint ,--identity(1,1) constraint PK_ID_FuncionarioCAIXA primary key,
cUsuario varchar(7) not null,
cMatricula varchar(6) not null,
cMatricula_Digito_Verificador varchar(1) not null,
[vNome_Empregado] varchar(150),
iCGC_Lotacao int not null,
iCGC_Lotacao_Fisica int not null,
dData_Nascimento date null,
dData_Admissao date not null,
iCodigo_Funcao_Comissionada int,
vNome_Funcao_Comissionada varchar(150) null,
iAinda_Nao_Sei smallint,
cE_Funcionario_Desligado char(1),
[dData_Desligamento] date,
      [cE_Marcado_Absenteismo_Cedido] char(1),
      [NomeArquivo] varchar(100) not null,
      [DataArquivo] date not null
)


 /*Cria Índices*/  

CREATE NONCLUSTERED INDEX idx_ConsignadoCPFSegurado_TEMP ON [dbo].[EmpregadoCAIXA_TEMP] ([cUsuario] ASC)  


/*********************************************************************************************************************/               
/*Recupera ponto de parada*/
/*********************************************************************************************************************/

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada 
WHERE NomeEntidade = 'EmpregadoCAIXA'


/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[EmpregadoCAIXA_TEMP]
				(    [Id]
      ,[cUsuario]
      ,[cMatricula]
      ,[cMatricula_Digito_Verificador]
      ,[vNome_Empregado]
      ,[iCGC_Lotacao]
      ,[iCGC_Lotacao_Fisica]
      ,[dData_Nascimento]
      ,[dData_Admissao]
      ,[iCodigo_Funcao_Comissionada]
      ,[vNome_Funcao_Comissionada]
      ,[iAinda_Nao_Sei]
      ,[cE_Funcionario_Desligado]
      ,[dData_Desligamento]
      ,[cE_Marcado_Absenteismo_Cedido]
      ,[NomeArquivo]
      ,[DataArquivo]

				)
				SELECT 
					[Id]
      ,[cUsuario]
      ,[cMatricula]
      ,[cMatricula_Digito_Verificador]
      ,[vNome_Empregado]
      ,[iCGC_Lotacao]
      ,[iCGC_Lotacao_Fisica]
      ,[dData_Nascimento]
      ,[dData_Admissao]
      ,[iCodigo_Funcao_Comissionada]
      ,[vNome_Funcao_Comissionada]
      ,[iAinda_Nao_Sei]
      ,[cE_Funcionario_Desligado]
      ,[dData_Desligamento]
      ,[cE_Marcado_Absenteismo_Cedido]
      ,[NomeArquivo]
      ,[DataArquivo]
	FROM OPENQUERY ([OBERON], ''EXEC [FENAE].[Corporativo].[proc_RecuperaEmpregadoCAIXA] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[EmpregadoCAIXA_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
/**********************************************************************
Inserção dos Dados - PropostaEndereco  -- select cusuario from Dados.FuncionarioCAIXA group by cusuario having count(cusuario) > 1
***********************************************************************/ 
MERGE INTO Dados.FuncionarioCAIXA as T USING
(
	 SELECT [cUsuario]
      ,[cMatricula]
      ,[cMatricula_Digito_Verificador]
      ,[vNome_Empregado]
      ,[iCGC_Lotacao]
      ,[iCGC_Lotacao_Fisica]
      ,[dData_Nascimento]
      ,[dData_Admissao]
      ,[iCodigo_Funcao_Comissionada]
      ,[vNome_Funcao_Comissionada]
      ,[iAinda_Nao_Sei]
      ,[cE_Funcionario_Desligado]
      ,[dData_Desligamento]
      ,[cE_Marcado_Absenteismo_Cedido]
      ,[NomeArquivo]
      ,[DataArquivo]
	  FROM [dbo].[EmpregadoCAIXA_TEMP]
) as S
ON S.cUsuario = T.cUsuario
	AND S.DataArquivo = T.DataArquivo
WHEN NOT MATCHED THEN INSERT ([cUsuario],[cMatricula],[cMatricula_Digito_Verificador],[vNome_Empregado],[iCGC_Lotacao],[iCGC_Lotacao_Fisica],[dData_Nascimento]
							,[dData_Admissao],[iCodigo_Funcao_Comissionada],[vNome_Funcao_Comissionada],[iAinda_Nao_Sei],[cE_Funcionario_Desligado],[dData_Desligamento]
							,[cE_Marcado_Absenteismo_Cedido],[NomeArquivo],[DataArquivo])
		VALUES (S.[cUsuario],S.[cMatricula],S.[cMatricula_Digito_Verificador],S.[vNome_Empregado],S.[iCGC_Lotacao],S.[iCGC_Lotacao_Fisica],S.[dData_Nascimento]
							,S.[dData_Admissao],S.[iCodigo_Funcao_Comissionada],S.[vNome_Funcao_Comissionada],S.[iAinda_Nao_Sei],S.[cE_Funcionario_Desligado],S.[dData_Desligamento]
							,S.[cE_Marcado_Absenteismo_Cedido],S.[NomeArquivo],S.[DataArquivo]);







							



/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/

SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'EmpregadoCAIXA'

TRUNCATE TABLE [dbo].[EmpregadoCAIXA_TEMP]

    
/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[EmpregadoCAIXA_TEMP]
				(    [Id]
      ,[cUsuario]
      ,[cMatricula]
      ,[cMatricula_Digito_Verificador]
      ,[vNome_Empregado]
      ,[iCGC_Lotacao]
      ,[iCGC_Lotacao_Fisica]
      ,[dData_Nascimento]
      ,[dData_Admissao]
      ,[iCodigo_Funcao_Comissionada]
      ,[vNome_Funcao_Comissionada]
      ,[iAinda_Nao_Sei]
      ,[cE_Funcionario_Desligado]
      ,[dData_Desligamento]
      ,[cE_Marcado_Absenteismo_Cedido]
      ,[NomeArquivo]
      ,[DataArquivo]

				)
				SELECT 
					[Id]
      ,[cUsuario]
      ,[cMatricula]
      ,[cMatricula_Digito_Verificador]
      ,[vNome_Empregado]
      ,[iCGC_Lotacao]
      ,[iCGC_Lotacao_Fisica]
      ,[dData_Nascimento]
      ,[dData_Admissao]
      ,[iCodigo_Funcao_Comissionada]
      ,[vNome_Funcao_Comissionada]
      ,[iAinda_Nao_Sei]
      ,[cE_Funcionario_Desligado]
      ,[dData_Desligamento]
      ,[cE_Marcado_Absenteismo_Cedido]
      ,[NomeArquivo]
      ,[DataArquivo]
	FROM OPENQUERY ([OBERON], ''EXEC [FENAE].[Corporativo].[proc_RecuperaEmpregadoCAIXA] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[EmpregadoCAIXA_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpregadoCAIXA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[EmpregadoCAIXA_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

