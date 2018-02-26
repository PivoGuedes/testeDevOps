    
    
/*******************************************************************************    
 Nome: Corporativo.Dados.fn_VendaNova_Fluxo    
 Descrição: Função auxiliar para calcular a separação VENDA NOVA / FLUXO PAR Corretora.    
  Data de Criação: 2013/02/26    
  Criador: Egler Vieira    
  Ultima atialização: -     
      
 Parâmetros de entrada:    
  @NumeroParcela VARCHAR(20)      
  @NumeroEndosso VARCHAR(5)    
  @IDOperacao VARCHAR(20)    
 Retorno:    
  VARCHAR(20): ID do canal de vendas    
     
 /*LEGENDA: 0 = Fluxo; 1 = VendaNova*/    
     
 Exemplo de utilização:    
  Vide fim deste arquivo para alguns exemplos simples de utilização.     
     
*******************************************************************************/     
    
CREATE FUNCTION Dados.fn_VendaNova_Fluxo (@NumeroParcela SMALLINT, @NumeroEndosso INT, @ValorBase DECIMAL(38,4), @IDOperacao TINYINT)    
RETURNS BIT    
AS    
BEGIN    
RETURN (    
 CASE WHEN @NumeroParcela = 1 AND @NumeroEndosso = 0 AND @ValorBase > 0.000000 THEN CAST(1 AS BIT)        --WHEN @NumeroEndosso < 2000 AND @NumeroParcela = 0 THEN 'Fluxo'     
    WHEN @NumeroParcela = 1 AND @NumeroEndosso > 2000 AND @ValorBase > 0.000000 THEN CAST(1 AS BIT)    
    WHEN @NumeroParcela = 0 AND @NumeroEndosso IN (0,1) AND @ValorBase > 0.000000 THEN CAST(1 AS BIT)    
    WHEN (@NumeroEndosso = 1 AND @NumeroParcela in (0))  THEN CAST(1 AS BIT)    
        
    WHEN (@NumeroEndosso = 1 AND @NumeroParcela in (1))  THEN CAST(0 AS BIT)        
    WHEN @NumeroParcela = 1 AND @NumeroEndosso = 0 AND @ValorBase < 0.000000 THEN CAST(0 AS BIT)       --WHEN @NumeroEndosso < 2000 AND @NumeroParcela = 0 THEN 'Fluxo'     
    WHEN @NumeroParcela = 1 AND @NumeroEndosso > 2000 AND @ValorBase < 0.000000 THEN CAST(0 AS BIT)    
    WHEN @NumeroParcela = 0 AND @NumeroEndosso IN (0,1) AND @ValorBase < 0.000000 THEN CAST(0 AS BIT)        
    WHEN @NumeroParcela = 0 AND @NumeroEndosso > 2000 THEN CAST(0 AS BIT)                
    WHEN (@NumeroEndosso > 1 AND @NumeroEndosso < 2000 )  THEN CAST(0 AS BIT)    
    
    WHEN @IDOperacao = 8 THEN CAST(0 AS BIT) /*ARREDONDAMENTO PAR*/    
    WHEN @IDOperacao in (9,10) THEN  CAST(0 AS BIT) /*LANÇAMENTO E ESTORNO DE LANÇAMENTO MANUAL*/    
    WHEN @NumeroParcela > 1 THEN CAST(0 AS BIT)    
    END )    
END    