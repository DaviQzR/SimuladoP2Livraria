/*
	Ter o privilegio para fazer altera��o
*/
USE master 
GO

/*
	Bot�o de Emerg�ncia
*/
DROP DATABASE ex9
GO

/*
	Cria��o do Banco de Dados
 */
 CREATE DATABASE ex9
 GO

/*
	Usar o Banco de Dados
*/
USE ex9
GO

--Cria��o de Tabelas
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO

CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO

--Inserindo Dados na tabela editora
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civiliza��o Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO

--Inserindo Dados na tabela autor
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Mar�lia Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matem�tica da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Ling��stica Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ci�ncias da Computac�o pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO

--Inserindo Dados na tabela estoque
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Pol�tica',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de F�sica I',26,68.00,4,104),
(10005,'Geometria Anal�tica',1,95.00,3,105),
(10006,'Gram�tica Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de F�sica III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO

--Inserindo dados na tabela compra
INSERT INTO compra VALUES
(15051,10003,2,158.00,'04/07/2021'),
(15051,10008,1,95.00,'04/07/2021'),
(15051,10004,1,68.00,'04/07/2021'),
(15051,10007,1,78.00,'04/07/2021'),
(15052,10006,1,49.00,'05/07/2021'),
(15052,10002,3,165.00,'05/07/2021'),
(15053,10001,1,108.00,'05/07/2021'),
(15054,10003,1,79.00,'06/08/2021'),
(15054,10008,1,95.00,'06/08/2021')

	
--1) Consultar nome, valor unit�rio, nome da editora e nome do autor dos livros do estoque que foram vendidos. N�o podem haver repeti��es.
SELECT DISTINCT est.nome AS livro, est.valor AS 'valor unit�rio', edi.nome AS 'nome da editora', aut.nome AS 'nome do autor'
FROM estoque est
JOIN editora edi ON est.codEditora = edi.codigo
JOIN autor aut ON est.codAutor = aut.codigo
JOIN compra comp ON est.codigo = comp.codEstoque

--2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051	
SELECT est.nome AS 'nome do livro', comp.qtdComprada AS 'quantidade comprada', comp.valor AS 'valor de compra'
FROM compra comp
JOIN estoque est ON comp.codEstoque = est.codigo
WHERE comp.codigo = 15051
--3) Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 d�gitos, remover o www.).	
SELECT est.nome AS 'Nome do livro',
	CASE
		WHEN LEN(edi.site) > 10 THEN REPLACE(edi.site,'www.', '')
		ELSE edi.site
	END AS 'Site da Editora'
FROM estoque est
JOIN editora edi ON est.codEditora = edi.codigo
WHERE edi.nome = 'Makron Books'

--4) Consultar nome do livro e Breve Biografia do David Halliday	
SELECT est.nome AS 'Nome do Livro', aut.biografia AS 'Breve Biografia'
FROM estoque est
JOIN autor aut ON est.codAutor = aut.codigo
WHERE aut.nome LIKE'% Halliday'

--5) Consultar c�digo de compra e quantidade comprada do livro Sistemas Operacionais Modernos	
SELECT comp.codigo AS 'c�digo de compra', comp.qtdComprada AS 'quantidade comprada', est.nome AS livro
FROM compra comp
JOIN estoque est ON comp.codEstoque = est.codigo
WHERE est.nome LIKE '% Modernos%'

--6) Consultar quais livros n�o foram vendidos	
SELECT est.nome AS 'Nome do Livro'
FROM estoque est
LEFT JOIN compra comp ON est.codigo = comp.codEstoque
WHERE comp.codigo IS NULL

--7) Consultar quais livros foram vendidos e n�o est�o cadastrados	
SELECT est.nome AS 'Nome do livro'
FROM estoque est
RIGHT JOIN compra comp ON est.codigo = comp.codEstoque
WHERE comp.codigo IS NULL

--8) Consultar Nome e site da editora que n�o tem Livros no estoque (Caso o site tenha mais de 10 d�gitos, remover o www.)	
SELECT edi.nome AS 'Nome da Editora', 
       CASE 
           WHEN LEN(edi.site) > 10 THEN REPLACE(edi.site, 'www.', '')
           ELSE edi.site 
       END AS 'Site da Editora'
FROM editora edi
LEFT JOIN estoque est ON edi.codigo = est.codEditora
WHERE est.codigo IS NULL

--9) Consultar Nome e biografia do autor que n�o tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)

SELECT aut.nome AS 'Nome do Autor',
       CASE 
           WHEN aut.biografia LIKE 'Doutorado%' THEN REPLACE(aut.biografia, 'Doutorado', 'Ph.D.')
           ELSE aut.biografia 
       END AS 'Biografia do Autor'
FROM autor aut
LEFT JOIN estoque e ON aut.codigo = e.codAutor
WHERE e.codigo IS NULL

--10) Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente	
SELECT aut.nome AS 'Nome do Autor'
--11) Consultar o c�digo da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por C�digo da Compra ascendente.

--12) Consultar o nome da editora e a m�dia de pre�os dos livros em estoque.Ordenar pela M�dia de Valores ascendente.

--13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora (Caso o site tenha mais de 10 d�gitos, remover o www.), criar uma coluna status onde:	

	--Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
	--Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	--Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	--A Ordena��o deve ser por Quantidade ascendente

--14) Para montar um relat�rio, � necess�rio montar uma consulta com a seguinte sa�da: C�digo do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros	
	--S� pode concatenar sites que n�o s�o nulos
--15) Consultar Codigo da compra, quantos dias da compra at� hoje e quantos meses da compra at� hoje	
--16) Consultar o c�digo da compra e a soma dos valores gastos das compras que somam mais de 200.00	

SELECT * FROM editora
SELECT * FROM autor
SELECT * FROM estoque
SELECT * FROM compra