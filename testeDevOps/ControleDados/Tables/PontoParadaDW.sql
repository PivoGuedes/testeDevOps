CREATE TABLE [ControleDados].[PontoParadaDW] (
    [ID]              SMALLINT      IDENTITY (1, 1) NOT NULL,
    [Step]            VARCHAR (100) NULL,
    [PontoParada]     VARCHAR (400) NULL,
    [DataAtualização] DATETIME      NULL,
    CONSTRAINT [PK_PontoParadaDW_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE)
);


GO

-- =============================================
-- Author:		EglerVieira
-- Create date: 2014-05-21
-- Description:	Atualiza a data de modificação do registro
-- =============================================
CREATE TRIGGER ControleDados.TRG_PontoParadaUPDATE
   ON  ControleDados.PontoParadaDW
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE ControleDados.PontoParadaDW SET DataAtualização = GETDATE()
	FROM ControleDados.PontoParadaDW P
	INNER JOIN inserted I
	ON I.ID = P.ID
END
