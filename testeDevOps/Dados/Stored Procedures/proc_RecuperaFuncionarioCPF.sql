/****** Object:  StoredProcedure [Dados].[proc_RecuperaFuncionarioCPF]    Script Date: 7/28/2016 4:49:35 PM ******/
-- Validar Usuários Indique Aqui 

CREATE PROCEDURE [Dados].[proc_RecuperaFuncionarioCPF] 	
@cpf VARCHAR(14)

AS
SELECT Nome, CPF, Matricula
FROM [Dados].[Funcionario]
WHERE CPF = @cpf
