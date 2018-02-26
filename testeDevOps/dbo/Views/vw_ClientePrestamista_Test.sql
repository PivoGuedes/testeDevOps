
CREATE view [dbo].[vw_ClientePrestamista_Test]
as

select top 10
	Nome,
	CPF,
	DataNascimento
from
	Dados.Funcionario
where
	Nome is not null
