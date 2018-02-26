CREATE PROCEDURE [Relatorio].[proc_RegistraLogRelatorio_ComissaoMR]
(

@NomeArquivo varchar(100)
, @QtdRegistros bigint
, @Requerente varchar(100)
, @DataArquivo date
, @DataProcessamento datetime
)
AS


--IF (@QtdREgistros > 0)
BEGIN

;MERGE INTO ControleDados.LogRelatorio AS L
USING 
(
SELECT 	@NomeArquivo AS NomeArquivo,
		@QtdRegistros AS QtdRegistros, 
		@Requerente AS Requerente,
		@DataArquivo AS DataArquivo,
		@DataProcessamento AS DataProcessamento 
) AS C

ON L.NomeArquivo = C.NomeArquivo
AND L.Requerente = C.Requerente
AND L.DataArquivo = C.DataArquivo

WHEN NOT MATCHED THEN 

INSERT (NomeArquivo, QtdRegistros, Requerente, DataArquivo, DataProcessamento, Enviado)
VALUES (C.NomeArquivo, C.QtdRegistros, C.Requerente, C.DataArquivo, C.DataProcessamento, 0);

END
