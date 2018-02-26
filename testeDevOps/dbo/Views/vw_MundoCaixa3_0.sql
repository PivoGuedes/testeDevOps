

CREATE VIEW [dbo].[vw_MundoCaixa3_0] AS
(
SELECT
       Nome
       ,Sexo
       ,DataNascimento
       ,Matricula
       ,CPF
       ,EmailCorporativo
       ,EstadoCivil
       ,Situação
       ,UF
       ,AssociadoFUNCEF
       ,Aposentado
       ,Pensionista
       ,MatriculaPensionista
       ,TelefoneComercial
       ,TelefoneCelular
       ,TelefonePessoal
       ,EmailPessoal
          ,LotacaoUF
          ,LotacaoCidade
       ,LotacaoFuncionario
       ,CodigoFuncaoParticipante
       ,DescricaoFuncao
       ,EnderecoCadastro
          ,IdCargo
          ,Cargo
          ,Municipio
          ,Bairro
          ,CEP
          ,ComplementoEndereco
          ,IDIndicadorArea
          --,IngressoFuncef
          --,PlanoFuncef
          --,EnderecoComercial
          --,TelefoneResidencial
          --,AreaAtuacao
          --,Formacao
          --,Escolaridade
          --,AssociadoFenae
          ,Empresa
          --,Apcef1
          --,Apcef2
FROM
(
       SELECT
                    Func.ID,
             Func.Nome,
                    Func.NomeArquivo,
             Sexo.Descricao Sexo,
             Func.DataNascimento,--Existe diferença entre sistemas...Propay(yyyy-mm-dd)....ssis_funcionarios(yyyy-dd-mm)
             Func.Matricula,
             Func.CPF,
             COALESCE(Func.Email,Mundo.EmailComercial) EmailCorporativo,--Talvez trocar por case instr('@caixa.gov.br') > 1
             EstCivil.Descricao EstadoCivil,
             COALESCE(SitFunc.DescricaoCompleta,SitFunc.Descricao) Situação,
             Func.UF,
             Mundo.IsAssociadoFUNCEF AssociadoFUNCEF,
             CASE--Precisamos conferir se a regra é válida
                WHEN SitFunc.Descricao = 'APOSENTADORIA EXCETO DOE/AC TR' OR SitFunc.Descricao = 'APOSENTADO' OR Mundo.IsAposentado = 1 THEN 1
                ELSE 0
             END Aposentado,
             Mundo.IsPensionista Pensionista,
             Mundo.Matricula MatriculaPensionista, -- Validar valor
             Mundo.TelefoneComercial,
             Mundo.TelefoneCelular,
             Mundo.TelefonePessoal,
             Mundo.EmailPessoal,
                    FuncHist.LotacaoUF, --incluido UF da Lotação  - Pessanha
                    FuncHist.LotacaoCidade, --incluido UF da Lotação - Pessanha
                    ISNULL(Lot.Descricao,Lot2.Descricao)LotacaoFuncionario, --Apresenta a segunda opçao somente se a primeira for nulo - Pessanha
             --Lot.Descricao LotacaoFuncionario,
             --Lot2.Descricao LotacaoFuncionario2,
             Funcao.Codigo CodigoFuncaoParticipante,
             Funcao.Descricao DescricaoFuncao,
             Cargo.Id IDCargo,
             Cargo.Cargo,
                    Func.Municipio, --Incluído o campo municipio/cidade  - Pessanha
             Func.Endereco EnderecoCadastro,
             Func.Bairro,
             Func.CEP,
             Func.ComplementoEndereco,
             Func.IdIndicadorArea,
                    --FuncMundoCaixa.IngressoFuncef,
                    --FuncMundoCaixa.PlanoFuncef,
                    --FuncMundoCaixa.EnderecoComercial,
                    --FuncMundoCaixa.TelefoneResidencial,
                    --FuncMundoCaixa.AreaAtuacao,
                    --FuncMundoCaixa.Formacao,
                    --FuncMundoCaixa.Escolaridade,
                    --FuncMundoCaixa.AssociadoFenae,
                    CASE
                           WHEN Emp.ID = 1 THEN 'CAIXA'
                           WHEN Emp.ID = 2 THEN 'Caixa Seguradora'
                           WHEN Emp.ID IN (3,7,15,16,17,23,27,28) THEN 'WIZ'
                           ELSE Emp.Nome
                    END Empresa,
                    --Emp.Nome Empresa,
                    --FuncMundoCaixa.Apcef1,
                    --FuncMundoCaixa.Apcef2,
             ROW_NUMBER() OVER(PARTITION BY Func.CPF ORDER BY Func.DataArquivo DESC) Linha
       FROM
             [Marketing].[PontosMundoCaixa] Pontos
             LEFT JOIN [Dados].[Funcionario] Func--Possui duplicados...Solução 1 pegar maior DataSistema
             ON Pontos.IdFuncionario = Func.Id
                    LEFT JOIN [Dados].[FuncionarioHistorico] FuncHist --incluido JOIN - Pessanha
                    ON FuncHist.IDFuncionario = Func.ID
                    LEFT JOIN [Dados].[Empresa] Emp
                    ON Func.IDEmpresa = Emp.ID
             LEFT JOIN [Marketing].[FuncionarioMundoCaixa] Mundo
             ON Mundo.CPF = Func.CPF 
             LEFT JOIN [Dados].[Sexo] Sexo
             ON Sexo.Id = Func.IDSexo
             LEFT JOIN [Dados].[EstadoCivil] EstCivil
             ON EstCivil.Id = Func.IDEstadoCivil
             LEFT JOIN [Dados].[SituacaoFuncionario] SitFunc
             ON SitFunc.Id = Func.IDUltimaSituacaoFuncionario
             LEFT JOIN [Marketing].[UnidadeLotacao] Lot
             ON Lot.ID = Mundo.IDUnidadeLotacao       
             LEFT JOIN [Dados].[Funcao] Funcao
             ON Funcao.Id = Func.IDUltimaFuncao
             LEFT JOIN [Dados].[Lotacao] Lot2
             ON Lot2.Id = Func.IDLotacao
             LEFT JOIN [Dados].[Cargo] Cargo
             ON Cargo.Id = Func.IDCargo
                    --LEFT JOIN [Dados].[FuncionarioMundoCaixa] FuncMundoCaixa
                    --ON FuncMundoCaixa.IdFuncionario = Func.ID
)res
WHERE
       Linha = 1
)

