USE Prison;

--ZAPYTANIA
--1.Dnia XXX a godzinie XXX podczas odwiedzin dosz³o do jakiegoœ incydentu.
--Sporz¹dŸ listê Wszystkich odwiedzaj¹cych wraz z ich numerami telefonu, którzy byli
--w wiêzieniu w tym czasie
CREATE VIEW OstatniOdwiedzaj¹cy AS
SELECT  O.ID, O.Imiê, O.Nazwisko, O.NumerKontaktowy
FROM Odwiedzaj¹cy O
JOIN Przychodzi Z ON O.ID = Z.Odwiedzaj¹cyID
JOIN Odwiedziny V ON Z.OdwiedzinyID = V.ID
WHERE (V.DataOdwiedzin = '1993-09-12') 
AND ('15:00' BETWEEN V.GodzinaRopoczêcia AND V.GodzinaZakoñczenia);

SELECT * FROM OstatniOdwiedzaj¹cy;

DROP VIEW OstatniOdwiedzaj¹cy;

--2. Pewien wiêzieñ zaatakowa³ stra¿nika i ma zostaæ przeniesiony do izolatki o wy¿szym
--rygorze. Sporz¹dŸ zestawienie, które bêdzie zawieraæ ID celi o stopniu rygoru XX z
--iloœci¹ pryczy równ¹ 1 i iloœci¹ zajêtych miejsc równ¹ 0.

CREATE VIEW Izolatka AS
SELECT O.ID AS NumerCeli
FROM Cela O
JOIN BlokWiêzienny Z ON Z.ID = O.BlokID
WHERE (Z.StopieñRygoru = 3) 
AND (O.IloœæPryczy = 1) 
AND (O.IloœæZajêtychMiejsc = 0);

SELECT * FROM Izolatka;

DROP VIEW Izolatka

--3. Wiêzienie chce sprawdziæ, którzy wiêŸniowie najczêœciej uczestnicz¹ w zajêciach
--resocjalizacyjnych. Utwórz zestawienie 5 wiêŸniów (5 odsiadek), którzy byli obecni
--na najwiêkszej iloœci zajêæ. Zestawienie posortuj malej¹ce wed³ug liczby obecnoœci

CREATE VIEW Zajecia AS 
SELECT TOP 5 O.ID, O.Imiê, O.Nazwisko, COUNT(*) AS IloœæWyst¹pieñ
FROM Odsiadka O
JOIN Obecnoœæ Ob ON O.ID = Ob.OdsiadkaID
GROUP BY O.ID, O.Imiê, O.Nazwisko
ORDER BY IloœæWyst¹pieñ DESC

SELECT * FROM Zajecia

DROP VIEW Zajecia

--1. Nied³ugo po odbyciu odwiedzin, przy osadzonym X znaleziono kontrabandê. ZnajdŸ
--numer kontaktowy, imiê i nazwisko ostatniego odwiedzaj¹cego.

CREATE VIEW Kontrabanda AS
SELECT O.NumerKontaktowy, O.Imiê, O.Nazwisko, MAX(V.DataOdwiedzin) AS DataOstatnichDwiedzin
FROM Odwiedzaj¹cy O
JOIN Przychodzi Z ON O.ID = Z.Odwiedzaj¹cyID
JOIN Odwiedziny V ON Z.OdwiedzinyID = V.ID
JOIN Odwiedzaj¹cy X ON X.ID = Z.Odwiedzaj¹cyID
WHERE V.OdsiadkaID = 1
GROUP BY O.NumerKontaktowy, O.Imiê, O.Nazwisko, V.DataOdwiedzin


SELECT * FROM Kontrabanda K

DROP VIEW Kontrabanda;

--2. O wprowadzenie do wiêzienia kontrabandy s¹ pos¹dzani nowi osadzeni. Sporz¹dŸ
--zestawienie osadzonych, którzy zostali osadzeni miesi¹c przed dniem XXXX
--(odnalezienia kontrabandy) i póŸniej, ale przed YYYY (dniem znalezienia
--kontrabandy)
CREATE VIEW NOWI AS
SELECT  O.ID, O.Imiê, O.Nazwisko, O.DataRozpoczêcia
FROM Odsiadka O
WHERE (O.DataRozpoczêcia BETWEEN '1988-03-01' AND '1988-04-01');

SELECT * FROM NOWI

DROP VIEW NOWI

--3. W zwi¹zku z tym ¿e osadzony X chce wyjœæ na przepustkê, ale limit wyjœæ w
--miesi¹cu dla jego stopnia rygoru to trzy razy w miesi¹cu. Sporz¹dŸ zestawienie
--przepustek osaczonego X dla roku Y i miesi¹ca Z

CREATE VIEW PRZEPUSTKI AS
SELECT O.ID, O.Imiê, O.Nazwisko, COUNT(*) AS IloœæPrzepustek
FROM Przepustka P
JOIN Odsiadka O ON O.ID = P.OdsiadkaID
WHERE O.ID = 2
GROUP BY O.ID, O.Imiê, O.Nazwisko

SELECT * FROM PRZEPUSTKI

DROP VIEW PRZEPUSTKI


--Lekarz wiêzienny wieczorem po powrocie do domu przegl¹da³ zarejstrowane badania.
--Zauwa¿y³, ¿e badanie X wskazuje na chorobê zakaŸn¹. Sporz¹dŸ listê wszystkich 
--wiêŸniów wraz z ich obecn¹ cel¹ znajduj¹ siê w clei z chorym celi z przebadanym wiêŸniem.

CREATE VIEW HistoriaCel AS
SELECT R.OdsiadkaID, r.DataRozpoczêcia, R.DataZakoñczenia, C.ID AS NumerCeli, B.DataBadania AS DataBadania
FROM RejestrCel R
JOIN Odsiadka O ON O.ID = R.OdsiadkaID
JOIN Badania B ON B.OdsiadkaID = O.ID
JOIN Cela C ON C.ID = R.CelaID
WHERE (B.ID = 1)
AND (B.DataBadania BETWEEN R.DataRozpoczêcia AND R.DataZakoñczenia)

SELECT * FROM HistoriaCel

SELECT *
FROM RejestrCel R
WHERE EXISTS (
    SELECT *
    FROM HistoriaCel H
    WHERE H.DataBadania BETWEEN R.DataRozpoczêcia AND R.DataZakoñczenia
	and h.OdsiadkaID != r.OdsiadkaID
);

DROP VIEW	HistoriaCel
