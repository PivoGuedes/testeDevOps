
CREATE PROCEDURE Dados.proc_AutorizaLotePremiacao_Indicadores @IDLote INT
as
	UPDATE [Dados].[RePremiacaoIndicadores] SET Autorizado = 1 WHERE IDLote = @IDLote
