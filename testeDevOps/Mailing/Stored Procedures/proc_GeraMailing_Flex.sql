
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*******************************************************************************
Nome: CORPORATIVO.Mailing.proc_GeraMailing_Flex

Nome: Egler Vieira
Data de Criação: 2014-09-11

Descrição: 
		
Parâmetros de Entrada:

Retorno:
	Dados XML 
*******************************************************************************/
CREATE PROCEDURE [Mailing].[proc_GeraMailing_Flex](@DataMailing DATE)
AS

--declare @DataMailing date = '2015-05-08'

 DECLARE @SomaDia TINYINT = CASE datename(dw,@DataMailing) WHEN 'Monday' THEN 2
                                                        ELSE 0 END 
SELECT 
	 NOME_CAMPANHA,              
	 CODIGO_CAMPANHA,			
	 CODIGO_MAILING,				
	 NOME_CLIENTE,               
	 CPF_CNPJ_CLIENTE,			
	 DDD1,	     				
	 FONE1,					    
	 DDD2,				        
	 FONE2,					    
	 DDD3,				        
	 FONE3,					    
	 DDD4,				        
	 FONE4,		            
	 TIPO_CLIENTE,				
	 ORIGEM_CLIENTE,			    
	 Convert(varchar(10), DATA_CONTATO_CS, 103) DATA_CONTATO_CS,			
	 Convert(varchar(10), DATA_COTACAO_CS, 103) DATA_COTACAO_CS,			
	 MODELO_VEICULO,			    
	 PLACA_VEICULO,			    
	 VALOR_PREMIO_BRUTO,			
	 MOTIVO_RECUSA,           	
	 TIPO_SEGURO,				
	  Convert(varchar(10), DATA_INICIO_VIGENCIA, 103) DATA_INICIO_VIGENCIA,		
	 AGENCIA_COTACAO_CS,		    
	 NUMERO_COTACAO_CS,		    
	 VALOR_FIPE,					
	 TIPO_PESSOA,				
	 SEXO,						
	 [BONUS_ANTERIOR], 			
	 [CEP],																					 
	 CASE WHEN ESTADO_CIVIL IS NULL OR ESTADO_CIVIL = '' THEN 'N/A' ELSE ESTADO_CIVIL END ESTADO_CIVIL,																			 
	 [E_MAIL] [E-MAIL],																				 
	 CASE WHEN [RELACAO_COND_SEGURADO] IS NULL OR [RELACAO_COND_SEGURADO] = '' THEN 'N/A' ELSE [RELACAO_COND_SEGURADO] END [RELACAO_COND_SEGURADO],																	 
	 ISNULL(Convert(varchar(10), DATA_NASC, 103),'N/A') DATA_NASC,																			 
	 ANO_MODELO,																			 
	 COD_FIPE,																				 
	 USO_VEICULO,																			 
	 ISNULL(BLINDADO,'N/A') BLINDADO,																				 
	 CHASSI,																				 
	 [FORMA_CONTRATACAO] [FORMA_CONTRATAÇÃO],																	 
	 FRANQUIA,																		 
	 DANOS_MATERIAIS,																		 
	 DANOS_MORAIS,																			 
	 DANOS_CORPORAIS,																		 
	 ASSIS_24_HRS,																			 
	 CARRO_RESERVA,																		 
	 CASE WHEN GARANTIA_CARRO_RESERVA IS NULL OR GARANTIA_CARRO_RESERVA = '' THEN 'N/A' ELSE GARANTIA_CARRO_RESERVA END GARANTIA_CARRO_RESERVA,																 
	 APP_PASSAGEIRO,																		 
	 DESP_MEDICO_HOSP,																		 
	 LANT_FAROIS_RETROVIS,																	 
	 VIDROS,																				 
	 [DESP_EXTRAORDINÁRIAS],																	 
	 [ESTENDER_COB_PARA_MENORES]
FROM OBERON.COL_MULTISEGURADORA.DBO.Tabela_Mailing_Diario_MS MS
WHERE 
	MS.Data_inclusao_Calculo>= DATEADD(DD, -@SomaDia, @DataMailing) AND MS.Data_inclusao_Calculo <= @DataMailing
	AND EXISTS (	-- Este trecho de código filtra os registros marcados para o mailing atendente.
					SELECT * 
					FROM Mailing.MailingAutoMS AS M
					WHERE M.DataRefMailing=MS.Data_inclusao_Calculo AND M.CPF=MS.CPF_CNPJ_CLIENTE COLLATE Latin1_General_CI_AS AND M.MailingAtendente=1
					AND M.Nome_Campanha='AQUISICAO_SEGURO AUTO_MS'
				)
and MS.SITUACAO = '2' 
AND NOT  EXISTS (SELECT *
			 FROM OBERON.[COL_MULTISEGURADORA].[dbo].[Tabela_Mailing_Diario_MS] B
			 WHERE B.Data_inclusao_Calculo IS NULL)



--EXEC  Mailing.proc_GeraMailing_Flex '2014-08-27'



