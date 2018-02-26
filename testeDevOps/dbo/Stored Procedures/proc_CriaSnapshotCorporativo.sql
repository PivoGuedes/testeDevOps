


 
CREATE PROCEDURE [dbo].[proc_CriaSnapshotCorporativo]  
 @pacoteExecutado VARCHAR(20)  
AS  

/*
	Data: 15/08/2011
	Luti: que proc é essa?
	TODO: escrever de forma decente. Usar o CleansingKit.dbo.Proc_CriaSnapshot como modelo.
*/
  
DECLARE @diretorio1 NVARCHAR(250),  
		@diretorio2 NVARCHAR(250),
		@diretorio3 NVARCHAR(250),
		@diretorio4 NVARCHAR(250),
		@lfile1 NVARCHAR(250),  
		@lfile2 NVARCHAR(250),  
		@lfile3 NVARCHAR(250),  
		@lfile4 NVARCHAR(250),  
		@nomeArquivo NVARCHAR(250)  
  
SET @nomeArquivo = 'Corporativo_' + CONVERT(VARCHAR(10), GETDATE(), 112) + REPLACE(CONVERT(VARCHAR(10), GETDATE(), 108), ':', '') + '_' + @pacoteExecutado;  
  
SELECT  @diretorio1 =SUBSTRING(physical_name,1,14)+@nomeArquivo+'_'+name+'.MDF',@lfile1=name FROM Corporativo.sys.database_files WHERE file_id = 1  
SELECT  @diretorio2 =SUBSTRING(physical_name,1,14)+@nomeArquivo+'_'+name+'.NDF',@lfile2=name FROM Corporativo.sys.database_files WHERE file_id = 3  
;;SELECT  @diretorio3 =SUBSTRING(physical_name,1,14)+@nomeArquivo+'_'+name+'.NDF',@lfile3=name FROM Corporativo.sys.database_files WHERE file_id = 4  
--SELECT  @diretorio4 =SUBSTRING(physical_name,1,14)+@nomeArquivo+'_'+name+'.NDF',@lfile4=name FROM FENAE.sys.database_files WHERE file_id = 5  

  
exec (N'CREATE DATABASE ' + @nomeArquivo + ' ON  
   (NAME='''+@lfile1+''',  FILENAME='''+@diretorio1+'''),  
   (NAME='''+@lfile2+''',  FILENAME='''+@diretorio2+''') AS SNAPSHOT OF Corporativo') 


