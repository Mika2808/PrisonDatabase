USE Prison;

--1) ON UPDATE CASCADE

--1.1
select * from Odsiadka where ID = 1;

UPDATE Odsiadka
SET Nazwisko = 'Mi³ecki'
WHERE ID = 1;

select * from Odsiadka where ID = 1;

--1.2
select*from RejestrCel where CelaID = 101;

UPDATE RejestrCel
SET DataRozpoczêcia = '2000-03-09'
WHERE ID = 1;

select*from RejestrCel where CelaID = 101;

--1.2
select * from ZajêciaTabela;

UPDATE ZajêciaTabela
SET Nazwa = 'PI£KA NO¯NA'
WHERE ID = 1;

select * from ZajêciaTabela;

--1.3 
select * from DniTygodnia;
select * from Zajêcia where DzieñTygodnia = 1;
select * from Zajêcia where DzieñTygodnia = 7;

UPDATE Zajêcia
SET DzieñTygodnia = 7
WHERE ID = 1;

select * from Zajêcia where DzieñTygodnia = 1;
select * from Zajêcia where DzieñTygodnia = 7;

--2) ON DELETE CASCADE

--2.1
SELECT * FROM BlokWiêzienny WHERE Funkcjonalnoœæ = 'Cela wiêzienna';
SELECT * FROM Cela;

DELETE FROM BlokWiêzienny
WHERE ID>7 AND Funkcjonalnoœæ = 'Cela wiêzienna';

SELECT * FROM BlokWiêzienny WHERE Funkcjonalnoœæ = 'Cela wiêzienna';
SELECT * FROM Cela;

--2.2
select * from ZajêciaTabela;
select * from Zajêcia WHERE ID = 1;

DELETE FROM ZajêciaTabela
WHERE ID = 1;

select * from ZajêciaTabela;
select * from Zajêcia;

--2.3
select * from Odsiadka;
select * from RejestrCel where OdsiadkaID = 1;
select * from Badania where OdsiadkaID = 1;

DELETE FROM  Odsiadka
WHERE ID=1;

select * from Odsiadka;
select * from RejestrCel;
select * from Badania;
