/****** Script do comando SelectTopNRows de SSMS  ******/

CREATE VIEW [Dados].[vw_CorrespondenteCCA]
AS

SELECT 
       A.[ID]
      ,[Matricula]
      ,[CPFCNPJ]
      ,[Nome]

      ,[IDUnidade]
	  ,C.Codigo
      ,[UF]
      ,[Cidade]
      ,[NomeArquivo]
      ,[DataArquivo]
      ,[MatriculaErrada]
      ,[Endereco]
      ,[Municipio]
      ,[Bairro]
      ,[Complemento]
      ,[Email]
      ,[CEP]
      ,[DDD]
      ,[Telefone]
      ,[DDDFAX]
      ,[FAX]
      ,[Equipe]
      ,[NomeEquipe]
      ,[RamoAtividade]
      ,[ICSituacao]
      ,[NUClasse]
      ,[TipoCorrespondente]
  FROM [Corporativo].[Dados].[Correspondente] A

   LEFT JOIN Corporativo.Dados.Unidade  C            ON (A.IDUnidade            = C.ID)
 WHERE [TipoCorrespondente] = 'CCA'


