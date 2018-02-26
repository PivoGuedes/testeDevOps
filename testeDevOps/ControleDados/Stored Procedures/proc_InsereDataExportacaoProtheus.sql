
CREATE PROCEDURE [ControleDados].[proc_InsereDataExportacaoProtheus] @DataRecibo DATE, @DataCompetencia DATE, @NumeroRecibo BIGINT, @IDEmpresa smallint
AS
  /*************************************************************************************/
  /*INSERE O DIA PARA CONTROLE DE EXPORTAÇÃO DE FATURAMENTO PARA A BASE INTERMEDIÁRIA */
  /*************************************************************************************/
  ;MERGE INTO ControleDados.ExportacaoFaturamento AS T
	  USING (
        SELECT @DataCompetencia DataCompetencia, @DataRecibo DataRecibo, @NumeroRecibo NumeroRecibo, @IDEmpresa IDEmpresa 
          ) AS X
    ON  X.DataRecibo = T.DataRecibo
    AND X.DataCompetencia = T.DataCompetencia
    AND X.NumeroRecibo = T.NumeroRecibo
	AND X.IDEmpresa = T.IDEmpresa
       WHEN NOT MATCHED  
		      THEN INSERT          
              (   
               DataRecibo, NumeroRecibo, DataCompetencia, IDEmpresa
              )
          VALUES (   
                  X.DataRecibo, X.NumeroRecibo, X.DataCompetencia, X.IDEmpresa);  
   

