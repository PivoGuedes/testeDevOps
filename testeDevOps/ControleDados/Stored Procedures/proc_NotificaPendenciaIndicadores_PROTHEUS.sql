
/*
	Autor: Egler Vieira
	Data Criação: 23/02/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.ControleDados.proc_NotificaPendenciaIndicadores_PROTHEUS
	Descrição: Procedimento que realiza a notificação, via e-mail, dos lotes de indicadores abertos no PROTHEUS .
		
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/

CREATE PROCEDURE ControleDados.proc_NotificaPendenciaIndicadores_PROTHEUS as

--1 - lote sem itens
--2 - lote não calculado
--3 - lote calculado
--4 - lote em crítica
--5 - aguardando aprovação
--6 - em finalização
--7 - lote encerrado
--8 - lote reprovado

DECLARE @TOTAL INT = 0
DECLARE @I     INT
DECLARE @ANO NVARCHAR(4)
DECLARE @MES NVARCHAR(2)
DECLARE @LOTE NVARCHAR(10)
DECLARE @TEXTO NVARCHAR(4000)
DECLARE @ASSUNTO NVARCHAR(300)
DECLARE @DESTINATARIOS NVARCHAR(500)
--DECLARE @COMANDO NVARCHAR(4000)

DECLARE C CURSOR
LOCAL SCROLL STATIC
FOR

--SELECT ZB2_CODIGO, ZB2_ANO, ZB2_MES
--FROM [SCASE].[RBDF27].[dbo].[ZB2010] Z
--WHERE Z.D_E_L_E_T_ = ''
--AND ZB2_STATUS IN ('3','4','5','6')
--ORDER BY ZB2_CODIGO

SELECT Codigo, Ano, Mes
FROM ControleDados.LoteProtheus
WHERE Tipo = 'I'
  AND [Status] IN ('3','4','5','6')
ORDER BY Codigo

OPEN C

SET @TOTAL = @@CURSOR_ROWS

IF @TOTAL > 0

BEGIN


SELECT @DESTINATARIOS = email, @ASSUNTO = [Desc] 
FROM ControleDados.EmailList WHERE ID = 2 -- INDICADORES

SET @I = 1
--SET @ASSUNTO = 'ALERTA - Finalização de lote de pagamento de indicadores'
SET @TEXTO =
'Caro operador,

Observamos no sistema Protheus, pendências relacionadas ao processo de pagamento de indicadores.

Favor finalizar o(s) lote(s) de número(s): ' + CHAR(13) + CHAR(13)

WHILE @I <= @TOTAL
BEGIN
	FETCH ABSOLUTE @I FROM C INTO @LOTE, @ANO, @MES
    
	SET @TEXTO = @TEXTO +  N'Lote: ' +  @LOTE + ' - ' +  @ANO + '/' + @MES + CHAR(13)


	--EXEC @COMANDO

	SET @I+=1
END

set @TEXTO = @TEXTO + CHAR(13) + 
'Att,

Gerência de Tecnologia da Informação
PAR CORRETORA DE SEGUROS
www.parcorretora.com.br
'
--print @TEXTO
--print @ASSUNTO

exec [dbo].[Dados_SendDBMail] @recipients = @DESTINATARIOS,
							  @body = @TEXTO,
							  @subject = @ASSUNTO
END
