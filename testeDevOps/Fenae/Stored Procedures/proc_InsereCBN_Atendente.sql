create procedure Fenae.proc_InsereCBN_Atendente
(
	@DataArquivo	date = null
)
as

if (@DataArquivo is null) begin
	-- Se não tiver a data do arquivo, realiza uma carga full.
	truncate table Fenae.DC0701_CBN_Atendente
	
	insert into Fenae.DC0701_CBN_Atendente
	select * from OBERON.Fenae.dbo.DC0701_CBN_Atendente
end
else begin
	-- Se tiver a data, realiza uma NOVA carga do período em questão, eliminando a anterior (se houver). 
	delete from Fenae.DC0701_CBN_Atendente
	where
		DataArquivo = @DataArquivo

	insert into Fenae.DC0701_CBN_Atendente
	select * from OBERON.Fenae.dbo.DC0701_CBN_Atendente
	where
		DataArquivo = @DataArquivo
end