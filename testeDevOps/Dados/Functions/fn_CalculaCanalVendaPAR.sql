

/*******************************************************************************
	Nome: Corporativo.Dados.fn_CalculaCanalVendaPAR
	Descrição: Função auxiliar para calcular o Canal de Vendas definido pela PAR Corretora.
  Data de Criação: 2013/01/25
  Criador: Egler Vieira
  Ultima atialização: - 
		
	Parâmetros de entrada:
		@NumeroProposta VARCHAR(20): número da proposta que será validada contra a regra definida nas tabelas Dados.CanalVendaPAR e Dados.CanalDigitoIdentificador.		 
		@CodigoProduto VARCHAR(5): número da matrícula que será validada contra a regra definida nas tabelas Dados.CanalVendaPAR e Dados.CanalProduto.		
		@CodigoMatricula VARCHAR(20): número da proposta que será validada contra a regra definida nas tabelas Dados.CanalVendaPAR e Dados.CanalMatricula.		 
	Retorno:
		VARCHAR(20): ID do canal de vendas
	
	Exemplo de utilização:
		Vide fim deste arquivo para alguns exemplos simples de utilização.
	
*******************************************************************************/ 

CREATE FUNCTION Dados.fn_CalculaCanalVendaPAR(@NumeroProposta varchar(20) = NULL, @CodigoProduto varchar(5) = NULL, @CodigoMatricula varchar(20) = NULL)
RETURNS smallint
AS
BEGIN
DECLARE @ID Smallint
  SET @NumeroProposta = CASE WHEN @NumeroProposta = 'INDEFINIDO' THEN NULL ELSE @NumeroProposta END
--DECLARE @NumeroProposta varchar(20) = '01201411000006' , @CodigoProduto varchar(5) = '9318', @CodigoMatricula varchar(20) = NULL
  SET @ID = (
            SELECT DISTINCT CVP.ID [IDCanalVenda]--, *
            FROM Corporativo.Dados.CanalVendaPAR CVP 
            LEFT JOIN Corporativo.Dados.CanalProduto CP
            ON CP.IDCanal = CVP.ID
            LEFT JOIN Corporativo.Dados.CanalDigitoIdentificador CDI
            ON CDI.IDCanal = CVP.ID
            LEFT JOIN Corporativo.Dados.CanalMatricula CM
            ON CM.IDCanal = CVP.ID
            LEFT JOIN Corporativo.Dados.Produto PRD
            ON PRD.ID = CP.IDProduto
            WHERE CVP.CanalVinculador = 1
            AND ((/*(@NumeroProposta IS NULL OR 1 = 1) AND*/ CVP.DigitoIdentificador = 0) OR (SUBSTRING(@NumeroProposta, CDI.Posicao, LEN(Cast(CDI.Digito as varchar(9)))) = CDI.Digito AND CVP.DigitoIdentificador = 1))
            AND ((/*(@CodigoProduto IS NULL OR 1 = 1) AND*/ CVP.ProdutoIdentificador = 0) OR (PRD.CodigoComercializado = @CodigoProduto AND CVP.ProdutoIdentificador = 1))
            AND ((/*(@CodigoMatricula IS NULL OR 1 = 1) AND*/ CVP.MatriculaVendedorIdentificadora = 0) OR (CM.Matricula = @CodigoMatricula AND CVP.MatriculaVendedorIdentificadora = 1))
            AND CVP.DataFim IS NULL
            )
            
  RETURN @ID
END

-- SELECT Dados.fn_CalculaCanalVendaPAR ('80002330131500' , '3173',  NULL)
