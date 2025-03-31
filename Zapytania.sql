USE Prison;

--ZAPYTANIA
--1.Dnia XXX a godzinie XXX podczas odwiedzin dosz�o do jakiego� incydentu.
--Sporz�d� list� Wszystkich odwiedzaj�cych wraz z ich numerami telefonu, kt�rzy byli
--w wi�zieniu w tym czasie
CREATE VIEW OstatniOdwiedzaj�cy AS
SELECT  O.ID, O.Imi�, O.Nazwisko, O.NumerKontaktowy
FROM Odwiedzaj�cy O
JOIN Przychodzi Z ON O.ID = Z.Odwiedzaj�cyID
JOIN Odwiedziny V ON Z.OdwiedzinyID = V.ID
WHERE (V.DataOdwiedzin = '1993-09-12') 
AND ('15:00' BETWEEN V.GodzinaRopocz�cia AND V.GodzinaZako�czenia);

SELECT * FROM OstatniOdwiedzaj�cy;

DROP VIEW OstatniOdwiedzaj�cy;

--2. Pewien wi�zie� zaatakowa� stra�nika i ma zosta� przeniesiony do izolatki o wy�szym
--rygorze. Sporz�d� zestawienie, kt�re b�dzie zawiera� ID celi o stopniu rygoru XX z
--ilo�ci� pryczy r�wn� 1 i ilo�ci� zaj�tych miejsc r�wn� 0.

CREATE VIEW Izolatka AS
SELECT O.ID AS NumerCeli
FROM Cela O
JOIN BlokWi�zienny Z ON Z.ID = O.BlokID
WHERE (Z.Stopie�Rygoru = 3) 
AND (O.Ilo��Pryczy = 1) 
AND (O.Ilo��Zaj�tychMiejsc = 0);

SELECT * FROM Izolatka;

DROP VIEW Izolatka

--3. Wi�zienie chce sprawdzi�, kt�rzy wi�niowie najcz�ciej uczestnicz� w zaj�ciach
--resocjalizacyjnych. Utw�rz zestawienie 5 wi�ni�w (5 odsiadek), kt�rzy byli obecni
--na najwi�kszej ilo�ci zaj��. Zestawienie posortuj malej�ce wed�ug liczby obecno�ci

CREATE VIEW Zajecia AS 
SELECT TOP 5 O.ID, O.Imi�, O.Nazwisko, COUNT(*) AS Ilo��Wyst�pie�
FROM Odsiadka O
JOIN Obecno�� Ob ON O.ID = Ob.OdsiadkaID
GROUP BY O.ID, O.Imi�, O.Nazwisko
ORDER BY Ilo��Wyst�pie� DESC

SELECT * FROM Zajecia

DROP VIEW Zajecia

--1. Nied�ugo po odbyciu odwiedzin, przy osadzonym X znaleziono kontraband�. Znajd�
--numer kontaktowy, imi� i nazwisko ostatniego odwiedzaj�cego.

CREATE VIEW Kontrabanda AS
SELECT O.NumerKontaktowy, O.Imi�, O.Nazwisko, MAX(V.DataOdwiedzin) AS DataOstatnichDwiedzin
FROM Odwiedzaj�cy O
JOIN Przychodzi Z ON O.ID = Z.Odwiedzaj�cyID
JOIN Odwiedziny V ON Z.OdwiedzinyID = V.ID
JOIN Odwiedzaj�cy X ON X.ID = Z.Odwiedzaj�cyID
WHERE V.OdsiadkaID = 1
GROUP BY O.NumerKontaktowy, O.Imi�, O.Nazwisko, V.DataOdwiedzin


SELECT * FROM Kontrabanda K

DROP VIEW Kontrabanda;

--2. O wprowadzenie do wi�zienia kontrabandy s� pos�dzani nowi osadzeni. Sporz�d�
--zestawienie osadzonych, kt�rzy zostali osadzeni miesi�c przed dniem XXXX
--(odnalezienia kontrabandy) i p�niej, ale przed YYYY (dniem znalezienia
--kontrabandy)
CREATE VIEW NOWI AS
SELECT  O.ID, O.Imi�, O.Nazwisko, O.DataRozpocz�cia
FROM Odsiadka O
WHERE (O.DataRozpocz�cia BETWEEN '1988-03-01' AND '1988-04-01');

SELECT * FROM NOWI

DROP VIEW NOWI

--3. W zwi�zku z tym �e osadzony X chce wyj�� na przepustk�, ale limit wyj�� w
--miesi�cu dla jego stopnia rygoru to trzy razy w miesi�cu. Sporz�d� zestawienie
--przepustek osaczonego X dla roku Y i miesi�ca Z

CREATE VIEW PRZEPUSTKI AS
SELECT O.ID, O.Imi�, O.Nazwisko, COUNT(*) AS Ilo��Przepustek
FROM Przepustka P
JOIN Odsiadka O ON O.ID = P.OdsiadkaID
WHERE O.ID = 2
GROUP BY O.ID, O.Imi�, O.Nazwisko

SELECT * FROM PRZEPUSTKI

DROP VIEW PRZEPUSTKI


--Lekarz wi�zienny wieczorem po powrocie do domu przegl�da� zarejstrowane badania.
--Zauwa�y�, �e badanie X wskazuje na chorob� zaka�n�. Sporz�d� list� wszystkich 
--wi�ni�w wraz z ich obecn� cel� znajduj� si� w clei z chorym celi z przebadanym wi�niem.

CREATE VIEW HistoriaCel AS
SELECT R.OdsiadkaID, r.DataRozpocz�cia, R.DataZako�czenia, C.ID AS NumerCeli, B.DataBadania AS DataBadania
FROM RejestrCel R
JOIN Odsiadka O ON O.ID = R.OdsiadkaID
JOIN Badania B ON B.OdsiadkaID = O.ID
JOIN Cela C ON C.ID = R.CelaID
WHERE (B.ID = 1)
AND (B.DataBadania BETWEEN R.DataRozpocz�cia AND R.DataZako�czenia)

SELECT * FROM HistoriaCel

SELECT *
FROM RejestrCel R
WHERE EXISTS (
    SELECT *
    FROM HistoriaCel H
    WHERE H.DataBadania BETWEEN R.DataRozpocz�cia AND R.DataZako�czenia
	and h.OdsiadkaID != r.OdsiadkaID
);

DROP VIEW	HistoriaCel
