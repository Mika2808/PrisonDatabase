USE Prison;

--tabele s³ownikowe
CREATE TABLE DniTygodnia (
    ID INT PRIMARY KEY,
    Nazwa VARCHAR(50) UNIQUE
);

CREATE TABLE ZajêciaTabela (
    ID INT PRIMARY KEY,
    Nazwa VARCHAR(50) UNIQUE
);

CREATE TABLE S¹dyKarne (
    ID INT PRIMARY KEY,
    Nazwa VARCHAR(50) UNIQUE,
	Adres VARCHAR(50) UNIQUE
);

--funkcje
GO
CREATE FUNCTION ISGOOD(@string VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 1;

    IF @string IS NULL
        SET @result = 0;
    ELSE
        SET @result = CASE WHEN @string NOT LIKE '%[^A-Za-z]%' THEN 1 ELSE 0 END;

    RETURN @result;
END;
GO

--z rdb
CREATE TABLE Odsiadka(
	ID INT PRIMARY KEY	CHECK (ID > 0),
	Imiê varchar(255) CHECK (dbo.ISGOOD(Imiê) = 1),
	Nazwisko varchar(255) CHECK (dbo.ISGOOD(Nazwisko) = 1),
	DataRozpoczêcia DATE NOT NULL,
	DataZakoñczenia DATE NOT NULL,
	GodzinaRozpoczêcia TIME NOT NULL,
	GodzinaZakoñczenia TIME NOT NULL
);

CREATE TABLE Przepustka(
	ID int PRIMARY KEY	CHECK (ID > 0),
	DataWyjœcia DATE NOT NULL,
	DataPowrotu DATE NOT NULL,
	GodzinaWyjœcia TIME NOT NULL,
	GodzinaPowrotu TIME,
	Przyczyna TEXT,
	OdsiadkaID int FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Wyrok(
	ID INT FOREIGN KEY REFERENCES S¹dyKarne(ID),
	NumerWyroku INT NOT NULL,
	Info TEXT,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE ,
	PRIMARY KEY(ID,NumerWyroku)
);

CREATE TABLE BlokWiêzienny(
	ID INT PRIMARY KEY,
	StopieñRygoru INT CHECK (StopieñRygoru >= 0 AND StopieñRygoru < 4) NOT NULL,
	Funkcjonalnoœæ VARCHAR(55)
);

CREATE TABLE Cela(
	ID INT PRIMARY KEY,
	IloœæPryczy INT NOT NULL,
	IloœæZajêtychMiejsc INT,
	BlokID INT FOREIGN KEY REFERENCES BlokWiêzienny(ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE RejestrCel(
	ID INT PRIMARY KEY,
	DataRozpoczêcia DATE NOT NULL,
	DataZakoñczenia DATE,	
	CelaID INT FOREIGN KEY REFERENCES Cela(ID) ON UPDATE CASCADE ON DELETE CASCADE,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Zajêcia(
	ID INT PRIMARY KEY FOREIGN KEY REFERENCES ZajêciaTabela(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	Imiê varchar(255) CHECK (dbo.ISGOOD(Imiê) = 1),
	Nazwisko varchar(255) CHECK (dbo.ISGOOD(Nazwisko) = 1),
	NumerKontaktowy varchar(20) NOT NULL,
	DzieñTygodnia INT FOREIGN KEY REFERENCES DniTygodnia(ID) ON UPDATE CASCADE,
	GodzinaRozpoczêcia TIME NOT NULL,
	GodzinaZakoñczenia TIME NOT NULL,	
	Powtarzalnoœæ VARCHAR(255),
	Miejsce VARCHAR(255)
);

CREATE TABLE Zapisy(
	ID INT PRIMARY KEY,
	DataZapisu DATE NOT NULL,
	GodzinaZapisu TIME NOT NULL,
	ZajêciaID INT FOREIGN KEY REFERENCES Zajêcia(ID) ON DELETE CASCADE ON UPDATE CASCADE ,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Obecnoœæ(
	ID INT PRIMARY KEY,
	DataZajêæ DATE NOT NULL,
	ZajêciaID INT FOREIGN KEY REFERENCES Zajêcia(ID) ON DELETE CASCADE ON UPDATE CASCADE ,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Odwiedzaj¹cy(
	ID INT PRIMARY KEY,
	Imiê varchar(255) CHECK (dbo.ISGOOD(Imiê) = 1),
	Nazwisko varchar(255) CHECK (dbo.ISGOOD(Nazwisko) = 1),	
	NumerKontaktowy varchar(20),
	Relacja TEXT,
);

CREATE TABLE Odwiedza(
	Odwiedzaj¹cyID INT FOREIGN KEY REFERENCES Odwiedzaj¹cy(ID) ON UPDATE CASCADE ,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON UPDATE CASCADE ON DELETE CASCADE
	PRIMARY KEY(Odwiedzaj¹cyID,OdsiadkaID)
);

CREATE TABLE Odwiedziny(
	ID INT PRIMARY KEY,
	DataOdwiedzin DATE NOT NULL,
	GodzinaRopoczêcia TIME NOT NULL,
	GodzinaZakoñczenia TIME NOT NULL,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Przychodzi(
	Odwiedzaj¹cyID INT FOREIGN KEY REFERENCES Odwiedzaj¹cy(ID) ON DELETE CASCADE ON UPDATE CASCADE ,
	OdwiedzinyID INT FOREIGN KEY REFERENCES Odwiedziny(ID) ON DELETE CASCADE ON UPDATE CASCADE 
	PRIMARY KEY(Odwiedzaj¹cyID,OdwiedzinyID) 
);

CREATE TABLE Badania(
	ID INT PRIMARY KEY,
	DataBadania DATE NOT NULL,
	GodzinaBadania TIME NOT NULL,
	Imiê varchar(255) CHECK (dbo.ISGOOD(Imiê) = 1),
	Nazwisko varchar(255) CHECK (dbo.ISGOOD(Nazwisko) = 1),
	NumerKontaktowy varchar(20) NOT NULL,
	Opis TEXT,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);
