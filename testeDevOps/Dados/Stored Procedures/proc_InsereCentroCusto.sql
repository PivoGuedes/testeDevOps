
/*
	Autor: Egler Vieira
	Data Criação: 21/02/2014

	Descrição: 
	
	Última alteração : 	 
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereCentroCusto
	Descrição: Procedimento que realiza a inserção dos Centros de Custos vindos do PROTHEUS.
		
	Parâmetros de entrada: 	
					
	Retorno: 

OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereCentroCusto] as
BEGIN TRY
	
	MERGE INTO Corporativo.Dados.CentroCusto AS  CC
	USING 
	(
	--INSERT INTO PRODUCAO204.Corporativo.[dbo].[CCP_TMP]
		SELECT CTT.CTT_CUSTO, CTT.CTT_CCSUP, CTT.CTT_DESC01, CASE WHEN CTT.CTT_BLOQ = 2 THEN 0 WHEN CTT.CTT_BLOQ = 1 THEN 1 END CTT_BLOQ , CTT_CLASSE, CC.ID, CC1.ID IDCentroCustoMestre

		FROM SCASE.RBDF27.dbo.CTT010 CTT 
		LEFT JOIN Corporativo.Dados.CentroCusto CC
		ON CTT.CTT_CUSTO = CC.Codigo COLLATE Latin1_General_BIN
		LEFT JOIN Corporativo.Dados.CentroCusto CC1
		ON CTT.CTT_CCSUP = CC1.Codigo COLLATE Latin1_General_BIN
		WHERE  CTT.CTT_FILIAL = '' AND CTT.D_E_L_E_T_ = '' --and ctt_custo = '6112020008'
	) CCP
	ON CCP.CTT_CUSTO COLLATE Latin1_General_BIN = CC.Codigo 
	WHEN NOT MATCHED THEN
	  INSERT  (Codigo, Descricao, IDCentroCustoMestre, [IDClasse], [FL_Bloqueio])
	  VALUES (CCP.CTT_CUSTO, CCP.CTT_DESC01, CCP.IDCentroCustoMestre, CTT_CLASSE, CTT_BLOQ)
	WHEN MATCHED THEN
	  UPDATE SET Descricao = CCP.CTT_DESC01
			   , IDCentroCustoMestre = CCP.IDCentroCustoMestre
			   , [FL_Bloqueio] = CTT_BLOQ
			   , [IDClasse] = CTT_CLASSE;

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH