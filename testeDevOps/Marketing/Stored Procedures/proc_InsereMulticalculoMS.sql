CREATE PROCEDURE Marketing.proc_InsereMulticalculoMS
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.MultiCalculoMS_TEMP') AND type in (N'U'))
		DROP TABLE dbo.MultiCalculoMS_TEMP;

	CREATE TABLE MultiCalculoMS_TEMP
	(
		Codigo BigINT
		,Calculo INT
		,DataCalculo Date
		,Cliente BigINT
		,Nome varchar(200)
		,CGC_CPF VARCHAR(20)
		,Sexo VARCHAR(1)
		,DataNascimento Date
		,Estado_Civil VARCHAR(10)
		,Telefone VARCHAR(10)
		,Telefone_cel varchar(10)
		,Telefone_Com varchar(10)
		,e_mail varchar(200)
		,Estado varchar(10)
		,Cidade varchar(100)
		,CodigoProduto int
		,NomeProduto varchar(100)
		,ProdutoEfetivado varchar(100)
		,PremioTotal decimal(18,2)
		,PremioTotal_II decimal(18,2)
		,Franquia decimal(18,2)
		,Franquia_II decimal(18,2)
		,DanosMateriais decimal(18,2)
		,DanosCorporais decimal(18,2)
		,APP_Morte decimal(18,2)
		,App_Invalidez decimal(18,2)
		,DanosMorais decimal(18,2)
		,Assitencia int
		,DanosVidros int
		,CarroReserva int
		,ExtensaoReboque int
		,Situacao varchar(1)
		,ZeroKm varchar(1)
		,CodigoFipe INT
		,Modelo varchar(200)
		,Combustivel varchar(50)
		,Placa varchar(10)
		,UFPlaca varchar(2)
		,AnoFabricacao int
		,AnoModelo int
		,Chassi varchar(200)
		,TipoSeguro varchar(50)
		,NomeOperador VARCHAR(200)
		,GrupoProducao int
		,InicioVigencia Date
		,FinalVigencia Date
		,Tipo_Cobertura int
		,Cobertura int
		,Padrao int
		,PadraoDescricao VARCHAR(200)
		,CEPResidencia varchar(10)
		,ChassiRemarcado int
		,Antifurto int
		,VeiculosResidencia int
		,QuilometroMes int
		,CoberturaBlindagem int
		,KitGas int
		,TipoCalculo int
		,TipoSeguro_II int
		,PrincipalCondutorConsiderado int
		,PrincipalCondutorEstuda int
		,PrincipalCondutorTipoResidencia int
		,PrincipalCondutorRoubo2Anos int
		,PessoasResidentesConduzirVeiculo int
		,OutrasPessoasConduzir int
		,KmVeiculoCirculaMes int
		,UtilizacaoVeiculo int
		,RelacaoPrincipalCondutorcomSegurado int
		,CPFPRincipalCondutor varchar(20)
		,NomePrincipalCondutor varchar(200)
		,SexoPrincipalCondutor varchar(1)
		,DataNascimentoPrincipalCondutor date
		,EstadoCivilPrincipalCondutor varchar(1)
		,TempoHabilitacaoPrincipalCondutor int
		,RelacaoPessoaComCondutor int
		,PessoaResideComCondutor int
		,PessoaPossuiVeiculo int
		,PessoaConduzVeiculo int
		,Acessorios varchar(1)
		,ValorRadioAM_FM decimal(18,2)
		,ValorCDPlayer decimal(18,2)
		,ValorDVDPlayer decimal(18,2)
		,ValorBlindagem decimal(18,2)
		,ValorKitGas decimal(18,2)
		,ValorRodaEspeciais decimal(18,2)
		,ValorRodaLigaLeve decimal(18,2)
		,ValorAutoFalantes decimal(18,2)
		,AirBagMotorista varchar(1)
		,FreiosAbs varchar(1)
		,VidrosEletricos varchar(1)
		,DirecaoHidraulica varchar(1)
		,ArCondicionado varchar(1)
		,TetoSolar varchar(1)
		,BancosCouro varchar(1)
		,CambioAutomaticoHidraulico varchar(1)
		,TravasEletricasPortas varchar(1)
		,QtdeSinistroApoliceAnterior int
		,PercAjusteTabelaFIPE int
		,GuardaVeiculoGaragemColegioFaculdadePosgraduacao int
		,GuardaVeiculoGaragemTrabalho int
		,ClasseBonusApoliceAnterior int
		,FinalVigenciaApoliceAnterior date
		,ModalidadeVR_VD int
		,DespesasExtras int
		,IsencaoFranquia varchar(1)
		,DespesasLocomocao varchar(1)
		,HigienizacaoVeiculo varchar(1)
		,NomeFraqnuia_1 varchar(50)
		,NomeFranquia_2 varchar(100)
		,MensagemFranquia_1 varchar(max)
		,MensagemFranquia_2 varchar(max)
		,Franquiaescolhida varchar(100)
		,PremioEscolhido decimal(18,2)
		,ValorFranquiaEscolhido decimal(18,2)
		CONSTRAINT PK_MultiCalculoMS_TEMP PRIMARY KEY CLUSTERED(codigo)
	)
	--Definir ponto parada correto
	set @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='MultiCalculoMS')
	SET @Comando = 'Insert into MultiCalculoMS_TEMP (
								Codigo
								,Calculo
								,DataCalculo
								,Cliente
								,Nome
								,CGC_CPF
								,Sexo
								,DataNascimento
								,Estado_Civil
								,Telefone
								,Telefone_cel
								,Telefone_Com
								,e_mail
								,Estado
								,Cidade
								,CodigoProduto
								,NomeProduto
								,ProdutoEfetivado
								,PremioTotal
								,PremioTotal_II
								,Franquia
								,Franquia_II
								,DanosMateriais
								,DanosCorporais
								,APP_Morte
								,App_Invalidez
								,DanosMorais
								,Assitencia
								,DanosVidros
								,CarroReserva
								,ExtensaoReboque
								,Situacao
								,ZeroKm
								,CodigoFipe
								,Modelo
								,Combustivel
								,Placa
								,UFPlaca
								,AnoFabricacao
								,AnoModelo
								,Chassi
								,TipoSeguro
								,NomeOperador
								,GrupoProducao
								,InicioVigencia
								,FinalVigencia
								,Tipo_Cobertura
								,Cobertura
								,Padrao
								,PadraoDescricao
								,CEPResidencia
								,ChassiRemarcado
								,Antifurto
								,VeiculosResidencia
								,QuilometroMes
								,CoberturaBlindagem
								,KitGas
								,TipoCalculo
								,TipoSeguro_II
								,PrincipalCondutorConsiderado
								,PrincipalCondutorEstuda
								,PrincipalCondutorTipoResidencia
								,PrincipalCondutorRoubo2Anos
								,PessoasResidentesConduzirVeiculo
								,OutrasPessoasConduzir
								,KmVeiculoCirculaMes
								,UtilizacaoVeiculo
								,RelacaoPrincipalCondutorcomSegurado
								,CPFPRincipalCondutor
								,NomePrincipalCondutor
								,SexoPrincipalCondutor
								,DataNascimentoPrincipalCondutor
								,EstadoCivilPrincipalCondutor
								,TempoHabilitacaoPrincipalCondutor
								,RelacaoPessoaComCondutor
								,PessoaResideComCondutor
								,PessoaPossuiVeiculo
								,PessoaConduzVeiculo
								,Acessorios
								,ValorRadioAM_FM
								,ValorCDPlayer
								,ValorDVDPlayer
								,ValorBlindagem
								,ValorKitGas
								,ValorRodaEspeciais
								,ValorRodaLigaLeve
								,ValorAutoFalantes
								,AirBagMotorista
								,FreiosAbs
								,VidrosEletricos
								,DirecaoHidraulica
								,ArCondicionado
								,TetoSolar
								,BancosCouro
								,CambioAutomaticoHidraulico
								,TravasEletricasPortas
								,QtdeSinistroApoliceAnterior
								,PercAjusteTabelaFIPE
								,GuardaVeiculoGaragemColegioFaculdadePosgraduacao
								,GuardaVeiculoGaragemTrabalho
								,ClasseBonusApoliceAnterior
								,FinalVigenciaApoliceAnterior
								,ModalidadeVR_VD
								,DespesasExtras
								,IsencaoFranquia
								,DespesasLocomocao
								,HigienizacaoVeiculo
								,NomeFraqnuia_1
								,NomeFranquia_2
								,MensagemFranquia_1
								,MensagemFranquia_2
								,Franquiaescolhida
								,PremioEscolhido
								,ValorFranquiaEscolhido
					)
					SELECT  Codigo
								,Calculo
								,DataCalculo
								,Cliente
								,Nome
								,CGC_CPF
								,Sexo
								,DataNascimento
								,Estado_Civil
								,Telefone
								,Telefone_cel
								,Telefone_Com
								,e_mail
								,Estado
								,Cidade
								,CodigoProduto
								,NomeProduto
								,ProdutoEfetivado
								,PremioTotal
								,PremioTotal_II
								,Franquia
								,Franquia_II
								,DanosMateriais
								,DanosCorporais
								,APP_Morte
								,App_Invalidez
								,DanosMorais
								,Assitencia
								,DanosVidros
								,CarroReserva
								,ExtensaoReboque
								,Situacao
								,ZeroKm
								,CodigoFipe
								,Modelo
								,Combustivel
								,Placa
								,UFPlaca
								,AnoFabricacao
								,AnoModelo
								,Chassi
								,TipoSeguro
								,NomeOperador
								,GrupoProducao
								,InicioVigencia
								,FinalVigencia
								,Tipo_Cobertura
								,Cobertura
								,Padrao
								,PadraoDescricao
								,CEPResidencia
								,ChassiRemarcado
								,Antifurto
								,VeiculosResidencia
								,QuilometroMes
								,CoberturaBlindagem
								,KitGas
								,TipoCalculo
								,TipoSeguro_II
								,PrincipalCondutorConsiderado
								,PrincipalCondutorEstuda
								,PrincipalCondutorTipoResidencia
								,PrincipalCondutorRoubo2Anos
								,PessoasResidentesConduzirVeiculo
								,OutrasPessoasConduzir
								,KmVeiculoCirculaMes
								,UtilizacaoVeiculo
								,RelacaoPrincipalCondutorcomSegurado
								,CPFPRincipalCondutor
								,NomePrincipalCondutor
								,SexoPrincipalCondutor
								,DataNascimentoPrincipalCondutor
								,EstadoCivilPrincipalCondutor
								,TempoHabilitacaoPrincipalCondutor
								,RelacaoPessoaComCondutor
								,PessoaResideComCondutor
								,PessoaPossuiVeiculo
								,PessoaConduzVeiculo
								,Acessorios
								,ValorRadioAM_FM
								,ValorCDPlayer
								,ValorDVDPlayer
								,ValorBlindagem
								,ValorKitGas
								,ValorRodaEspeciais
								,ValorRodaLigaLeve
								,ValorAutoFalantes
								,AirBagMotorista
								,FreiosAbs
								,VidrosEletricos
								,DirecaoHidraulica
								,ArCondicionado
								,TetoSolar
								,BancosCouro
								,CambioAutomaticoHidraulico
								,TravasEletricasPortas
								,QtdeSinistroApoliceAnterior
								,PercAjusteTabelaFIPE
								,GuardaVeiculoGaragemColegioFaculdadePosgraduacao
								,GuardaVeiculoGaragemTrabalho
								,ClasseBonusApoliceAnterior
								,FinalVigenciaApoliceAnterior
								,ModalidadeVR_VD
								,DespesasExtras
								,IsencaoFranquia
								,DespesasLocomocao
								,HigienizacaoVeiculo
								,NomeFraqnuia_1
								,NomeFranquia_2
								,MensagemFranquia_1
								,MensagemFranquia_2
								,Franquiaescolhida
								,PremioEscolhido
								,ValorFranquiaEscolhido
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_RelatorioMultiCalculoMS ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from MultiCalculoMS_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		--Cadastra os dados na Tabela Retenção Auto
		MERGE INTO Marketing.RelatorioMulticalculoMS AS C USING
		(
			select Distinct 
					s.Id IdSexo
					,ss.Id IdSexoPrincipalcondutor
					,Calculo
								,DataCalculo
								,Cliente
								,Nome
								,CGC_CPF
								,DataNascimento
								,Estado_Civil
								,Telefone
								,Telefone_cel
								,Telefone_Com
								,e_mail
								,Estado
								,Cidade
								,CodigoProduto
								,NomeProduto
								,ProdutoEfetivado
								,PremioTotal
								,PremioTotal_II
								,Franquia
								,Franquia_II
								,DanosMateriais
								,DanosCorporais
								,APP_Morte
								,App_Invalidez
								,DanosMorais
								,Assitencia
								,DanosVidros
								,CarroReserva
								,ExtensaoReboque
								,Situacao
								,ZeroKm
								,CodigoFipe
								,Modelo
								,Combustivel
								,Placa
								,UFPlaca
								,AnoFabricacao
								,AnoModelo
								,Chassi
								,TipoSeguro
								,NomeOperador
								,GrupoProducao
								,InicioVigencia
								,FinalVigencia
								,Tipo_Cobertura
								,Cobertura
								,Padrao
								,PadraoDescricao
								,CEPResidencia
								,ChassiRemarcado
								,Antifurto
								,VeiculosResidencia
								,QuilometroMes
								,CoberturaBlindagem
								,KitGas
								,TipoCalculo
								,TipoSeguro_II
								,PrincipalCondutorConsiderado
								,PrincipalCondutorEstuda
								,PrincipalCondutorTipoResidencia
								,PrincipalCondutorRoubo2Anos
								,PessoasResidentesConduzirVeiculo
								,OutrasPessoasConduzir
								,KmVeiculoCirculaMes
								,UtilizacaoVeiculo
								,RelacaoPrincipalCondutorcomSegurado
								,CPFPRincipalCondutor
								,NomePrincipalCondutor
								,DataNascimentoPrincipalCondutor
								,EstadoCivilPrincipalCondutor
								,TempoHabilitacaoPrincipalCondutor
								,RelacaoPessoaComCondutor
								,PessoaResideComCondutor
								,PessoaPossuiVeiculo
								,PessoaConduzVeiculo
								,Acessorios
								,ValorRadioAM_FM
								,ValorCDPlayer
								,ValorDVDPlayer
								,ValorBlindagem
								,ValorKitGas
								,ValorRodaEspeciais
								,ValorRodaLigaLeve
								,ValorAutoFalantes
								,AirBagMotorista
								,FreiosAbs
								,VidrosEletricos
								,DirecaoHidraulica
								,ArCondicionado
								,TetoSolar
								,BancosCouro
								,CambioAutomaticoHidraulico
								,TravasEletricasPortas
								,QtdeSinistroApoliceAnterior
								,PercAjusteTabelaFIPE
								,GuardaVeiculoGaragemColegioFaculdadePosgraduacao
								,GuardaVeiculoGaragemTrabalho
								,ClasseBonusApoliceAnterior
								,FinalVigenciaApoliceAnterior
								,ModalidadeVR_VD
								,DespesasExtras
								,IsencaoFranquia
								,DespesasLocomocao
								,HigienizacaoVeiculo
								,NomeFraqnuia_1
								,NomeFranquia_2
								,MensagemFranquia_1
								,MensagemFranquia_2
								,Franquiaescolhida
								,PremioEscolhido
								,ValorFranquiaEscolhido
			from MultiCalculoMS_TEMP l
			inner join Dados.Sexo s
			on s.Sigla=l.Sexo
			inner join Dados.Sexo ss
			on ss.sigla=l.SexoPrincipalCondutor
		)
		AS T
		ON C.CGC_CPF = T.CGC_CPF
		AND ISNULL(C.NomeProduto,'') = ISNULL(T.NomeProduto,'')
		AND C.PremioTotal_II = T.PremioTotal_II
		WHEN NOT MATCHED THEN INSERT(IdSexo,IdSexoPrincipalcondutor,Calculo,DataCalculo,Cliente,Nome,CGC_CPF,DataNascimento,Estado_Civil
,Telefone,Telefone_cel,Telefone_Com,e_mail,Estado,Cidade,CodigoProduto,NomeProduto,ProdutoEfetivado,PremioTotal,PremioTotal_II,Franquia,Franquia_II
,DanosMateriais,DanosCorporais,APP_Morte,App_Invalidez,DanosMorais,Assitencia,DanosVidros,CarroReserva,ExtensaoReboque,Situacao,ZeroKm,CodigoFipe,Modelo
,Combustivel,Placa,UFPlaca,AnoFabricacao,AnoModelo,Chassi,TipoSeguro,NomeOperador,GrupoProducao,InicioVigencia,FinalVigencia,Tipo_Cobertura,Cobertura,Padrao
,PadraoDescricao,CEPResidencia,ChassiRemarcado,Antifurto,VeiculosResidencia,QuilometroMes,CoberturaBlindagem,KitGas,TipoCalculo,TipoSeguro_II
,PrincipalCondutorConsiderado,PrincipalCondutorEstuda,PrincipalCondutorTipoResidencia,PrincipalCondutorRoubo2Anos,PessoasResidentesConduzirVeiculo
,OutrasPessoasConduzir,KmVeiculoCirculaMes,UtilizacaoVeiculo,RelacaoPrincipalCondutorcomSegurado,CPFPRincipalCondutor,NomePrincipalCondutor
,DataNascimentoPrincipalCondutor,EstadoCivilPrincipalCondutor,TempoHabilitacaoPrincipalCondutor,RelacaoPessoaComCondutor,PessoaResideComCondutor
,PessoaPossuiVeiculo,PessoaConduzVeiculo,Acessorios,ValorRadioAM_FM,ValorCDPlayer,ValorDVDPlayer,ValorBlindagem,ValorKitGas,ValorRodaEspeciais,ValorRodaLigaLeve
,ValorAutoFalantes,AirBagMotorista,FreiosAbs,VidrosEletricos,DirecaoHidraulica,ArCondicionado,TetoSolar,BancosCouro,CambioAutomaticoHidraulico
,TravasEletricasPortas,QtdeSinistroApoliceAnterior,PercAjusteTabelaFIPE,GuardaVeiculoGaragemColegioFaculdadePosgraduacao,GuardaVeiculoGaragemTrabalho
,ClasseBonusApoliceAnterior,FinalVigenciaApoliceAnterior,ModalidadeVR_VD,DespesasExtras,IsencaoFranquia,DespesasLocomocao,HigienizacaoVeiculo
,NomeFraqnuia_1,NomeFranquia_2,MensagemFranquia_1,MensagemFranquia_2,Franquiaescolhida,PremioEscolhido,ValorFranquiaEscolhido)
			VALUES (IdSexo,IdSexoPrincipalcondutor,Calculo,DataCalculo,Cliente,Nome,CGC_CPF,DataNascimento,Estado_Civil
,Telefone,Telefone_cel,Telefone_Com,e_mail,Estado,Cidade,CodigoProduto,NomeProduto,ProdutoEfetivado,PremioTotal,PremioTotal_II,Franquia,Franquia_II
,DanosMateriais,DanosCorporais,APP_Morte,App_Invalidez,DanosMorais,Assitencia,DanosVidros,CarroReserva,ExtensaoReboque,Situacao,ZeroKm,CodigoFipe,Modelo
,Combustivel,Placa,UFPlaca,AnoFabricacao,AnoModelo,Chassi,TipoSeguro,NomeOperador,GrupoProducao,InicioVigencia,FinalVigencia,Tipo_Cobertura,Cobertura,Padrao
,PadraoDescricao,CEPResidencia,ChassiRemarcado,Antifurto,VeiculosResidencia,QuilometroMes,CoberturaBlindagem,KitGas,TipoCalculo,TipoSeguro_II
,PrincipalCondutorConsiderado,PrincipalCondutorEstuda,PrincipalCondutorTipoResidencia,PrincipalCondutorRoubo2Anos,PessoasResidentesConduzirVeiculo
,OutrasPessoasConduzir,KmVeiculoCirculaMes,UtilizacaoVeiculo,RelacaoPrincipalCondutorcomSegurado,CPFPRincipalCondutor,NomePrincipalCondutor
,DataNascimentoPrincipalCondutor,EstadoCivilPrincipalCondutor,TempoHabilitacaoPrincipalCondutor,RelacaoPessoaComCondutor,PessoaResideComCondutor
,PessoaPossuiVeiculo,PessoaConduzVeiculo,Acessorios,ValorRadioAM_FM,ValorCDPlayer,ValorDVDPlayer,ValorBlindagem,ValorKitGas,ValorRodaEspeciais,ValorRodaLigaLeve
,ValorAutoFalantes,AirBagMotorista,FreiosAbs,VidrosEletricos,DirecaoHidraulica,ArCondicionado,TetoSolar,BancosCouro,CambioAutomaticoHidraulico
,TravasEletricasPortas,QtdeSinistroApoliceAnterior,PercAjusteTabelaFIPE,GuardaVeiculoGaragemColegioFaculdadePosgraduacao,GuardaVeiculoGaragemTrabalho
,ClasseBonusApoliceAnterior,FinalVigenciaApoliceAnterior,ModalidadeVR_VD,DespesasExtras,IsencaoFranquia,DespesasLocomocao,HigienizacaoVeiculo
,NomeFraqnuia_1,NomeFranquia_2,MensagemFranquia_1,MensagemFranquia_2,Franquiaescolhida,PremioEscolhido,ValorFranquiaEscolhido)
		;

		truncate table MultiCalculoMS_TEMP;
		
		SET @Comando = 'Insert into MultiCalculoMS_TEMP (
								Codigo
								,Calculo
								,DataCalculo
								,Cliente
								,Nome
								,CGC_CPF
								,Sexo
								,DataNascimento
								,Estado_Civil
								,Telefone
								,Telefone_cel
								,Telefone_Com
								,e_mail
								,Estado
								,Cidade
								,CodigoProduto
								,NomeProduto
								,ProdutoEfetivado
								,PremioTotal
								,PremioTotal_II
								,Franquia
								,Franquia_II
								,DanosMateriais
								,DanosCorporais
								,APP_Morte
								,App_Invalidez
								,DanosMorais
								,Assitencia
								,DanosVidros
								,CarroReserva
								,ExtensaoReboque
								,Situacao
								,ZeroKm
								,CodigoFipe
								,Modelo
								,Combustivel
								,Placa
								,UFPlaca
								,AnoFabricacao
								,AnoModelo
								,Chassi
								,TipoSeguro
								,NomeOperador
								,GrupoProducao
								,InicioVigencia
								,FinalVigencia
								,Tipo_Cobertura
								,Cobertura
								,Padrao
								,PadraoDescricao
								,CEPResidencia
								,ChassiRemarcado
								,Antifurto
								,VeiculosResidencia
								,QuilometroMes
								,CoberturaBlindagem
								,KitGas
								,TipoCalculo
								,TipoSeguro_II
								,PrincipalCondutorConsiderado
								,PrincipalCondutorEstuda
								,PrincipalCondutorTipoResidencia
								,PrincipalCondutorRoubo2Anos
								,PessoasResidentesConduzirVeiculo
								,OutrasPessoasConduzir
								,KmVeiculoCirculaMes
								,UtilizacaoVeiculo
								,RelacaoPrincipalCondutorcomSegurado
								,CPFPRincipalCondutor
								,NomePrincipalCondutor
								,SexoPrincipalCondutor
								,DataNascimentoPrincipalCondutor
								,EstadoCivilPrincipalCondutor
								,TempoHabilitacaoPrincipalCondutor
								,RelacaoPessoaComCondutor
								,PessoaResideComCondutor
								,PessoaPossuiVeiculo
								,PessoaConduzVeiculo
								,Acessorios
								,ValorRadioAM_FM
								,ValorCDPlayer
								,ValorDVDPlayer
								,ValorBlindagem
								,ValorKitGas
								,ValorRodaEspeciais
								,ValorRodaLigaLeve
								,ValorAutoFalantes
								,AirBagMotorista
								,FreiosAbs
								,VidrosEletricos
								,DirecaoHidraulica
								,ArCondicionado
								,TetoSolar
								,BancosCouro
								,CambioAutomaticoHidraulico
								,TravasEletricasPortas
								,QtdeSinistroApoliceAnterior
								,PercAjusteTabelaFIPE
								,GuardaVeiculoGaragemColegioFaculdadePosgraduacao
								,GuardaVeiculoGaragemTrabalho
								,ClasseBonusApoliceAnterior
								,FinalVigenciaApoliceAnterior
								,ModalidadeVR_VD
								,DespesasExtras
								,IsencaoFranquia
								,DespesasLocomocao
								,HigienizacaoVeiculo
								,NomeFraqnuia_1
								,NomeFranquia_2
								,MensagemFranquia_1
								,MensagemFranquia_2
								,Franquiaescolhida
								,PremioEscolhido
								,ValorFranquiaEscolhido
					)
					SELECT  Codigo
								,Calculo
								,DataCalculo
								,Cliente
								,Nome
								,CGC_CPF
								,Sexo
								,DataNascimento
								,Estado_Civil
								,Telefone
								,Telefone_cel
								,Telefone_Com
								,e_mail
								,Estado
								,Cidade
								,CodigoProduto
								,NomeProduto
								,ProdutoEfetivado
								,PremioTotal
								,PremioTotal_II
								,Franquia
								,Franquia_II
								,DanosMateriais
								,DanosCorporais
								,APP_Morte
								,App_Invalidez
								,DanosMorais
								,Assitencia
								,DanosVidros
								,CarroReserva
								,ExtensaoReboque
								,Situacao
								,ZeroKm
								,CodigoFipe
								,Modelo
								,Combustivel
								,Placa
								,UFPlaca
								,AnoFabricacao
								,AnoModelo
								,Chassi
								,TipoSeguro
								,NomeOperador
								,GrupoProducao
								,InicioVigencia
								,FinalVigencia
								,Tipo_Cobertura
								,Cobertura
								,Padrao
								,PadraoDescricao
								,CEPResidencia
								,ChassiRemarcado
								,Antifurto
								,VeiculosResidencia
								,QuilometroMes
								,CoberturaBlindagem
								,KitGas
								,TipoCalculo
								,TipoSeguro_II
								,PrincipalCondutorConsiderado
								,PrincipalCondutorEstuda
								,PrincipalCondutorTipoResidencia
								,PrincipalCondutorRoubo2Anos
								,PessoasResidentesConduzirVeiculo
								,OutrasPessoasConduzir
								,KmVeiculoCirculaMes
								,UtilizacaoVeiculo
								,RelacaoPrincipalCondutorcomSegurado
								,CPFPRincipalCondutor
								,NomePrincipalCondutor
								,SexoPrincipalCondutor
								,DataNascimentoPrincipalCondutor
								,EstadoCivilPrincipalCondutor
								,TempoHabilitacaoPrincipalCondutor
								,RelacaoPessoaComCondutor
								,PessoaResideComCondutor
								,PessoaPossuiVeiculo
								,PessoaConduzVeiculo
								,Acessorios
								,ValorRadioAM_FM
								,ValorCDPlayer
								,ValorDVDPlayer
								,ValorBlindagem
								,ValorKitGas
								,ValorRodaEspeciais
								,ValorRodaLigaLeve
								,ValorAutoFalantes
								,AirBagMotorista
								,FreiosAbs
								,VidrosEletricos
								,DirecaoHidraulica
								,ArCondicionado
								,TetoSolar
								,BancosCouro
								,CambioAutomaticoHidraulico
								,TravasEletricasPortas
								,QtdeSinistroApoliceAnterior
								,PercAjusteTabelaFIPE
								,GuardaVeiculoGaragemColegioFaculdadePosgraduacao
								,GuardaVeiculoGaragemTrabalho
								,ClasseBonusApoliceAnterior
								,FinalVigenciaApoliceAnterior
								,ModalidadeVR_VD
								,DespesasExtras
								,IsencaoFranquia
								,DespesasLocomocao
								,HigienizacaoVeiculo
								,NomeFraqnuia_1
								,NomeFranquia_2
								,MensagemFranquia_1
								,MensagemFranquia_2
								,Franquiaescolhida
								,PremioEscolhido
								,ValorFranquiaEscolhido
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_RelatorioMultiCalculoMS ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(Codigo)
		from MultiCalculoMS_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

		print @PontoParada
	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='MultiCalculoMS'
	
	--DROP Data tabela temporária
	DROP TABLE MultiCalculoMS_TEMP;
	Commit;
END TRY                
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereMulticalculoMS

--select * from ControleDados.PontoParada where nomeentidade='MultiCalculoMS'
--insert into ControleDados.PontoParada values ('MultiCalculoMS',0)