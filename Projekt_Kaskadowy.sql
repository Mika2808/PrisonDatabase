USE Prison;

--1) ON UPDATE CASCADE

--1.1
select * from Odsiadka where ID = 1;

UPDATE Odsiadka
SET Nazwisko = 'Mi�ecki'
WHERE ID = 1;

select * from Odsiadka where ID = 1;

--1.2
select*from RejestrCel where CelaID = 101;

UPDATE RejestrCel
SET DataRozpocz�cia = '2000-03-09'
WHERE ID = 1;

select*from RejestrCel where CelaID = 101;

--1.2
select * from Zaj�ciaTabela;

UPDATE Zaj�ciaTabela
SET Nazwa = 'PI�KA NO�NA'
WHERE ID = 1;

select * from Zaj�ciaTabela;

--1.3 
select * from DniTygodnia;
select * from Zaj�cia where Dzie�Tygodnia = 1;
select * from Zaj�cia where Dzie�Tygodnia = 7;

UPDATE Zaj�cia
SET Dzie�Tygodnia = 7
WHERE ID = 1;

select * from Zaj�cia where Dzie�Tygodnia = 1;
select * from Zaj�cia where Dzie�Tygodnia = 7;

--2) ON DELETE CASCADE

--2.1
SELECT * FROM BlokWi�zienny WHERE Funkcjonalno�� = 'Cela wi�zienna';
SELECT * FROM Cela;

DELETE FROM BlokWi�zienny
WHERE ID>7 AND Funkcjonalno�� = 'Cela wi�zienna';

SELECT * FROM BlokWi�zienny WHERE Funkcjonalno�� = 'Cela wi�zienna';
SELECT * FROM Cela;

--2.2
select * from Zaj�ciaTabela;
select * from Zaj�cia WHERE ID = 1;

DELETE FROM Zaj�ciaTabela
WHERE ID = 1;

select * from Zaj�ciaTabela;
select * from Zaj�cia;

--2.3
select * from Odsiadka;
select * from RejestrCel where OdsiadkaID = 1;
select * from Badania where OdsiadkaID = 1;

DELETE FROM  Odsiadka
WHERE ID=1;

select * from Odsiadka;
select * from RejestrCel;
select * from Badania;
