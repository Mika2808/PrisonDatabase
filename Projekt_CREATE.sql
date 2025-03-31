USE Prison;

--tabele s�ownikowe
CREATE TABLE DniTygodnia (
    ID INT PRIMARY KEY,
    Nazwa VARCHAR(50) UNIQUE
);

CREATE TABLE Zaj�ciaTabela (
    ID INT PRIMARY KEY,
    Nazwa VARCHAR(50) UNIQUE
);

CREATE TABLE S�dyKarne (
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
	Imi� varchar(255) CHECK (dbo.ISGOOD(Imi�) = 1),
	Nazwisko varchar(255) CHECK (dbo.ISGOOD(Nazwisko) = 1),
	DataRozpocz�cia DATE NOT NULL,
	DataZako�czenia DATE NOT NULL,
	GodzinaRozpocz�cia TIME NOT NULL,
	GodzinaZako�czenia TIME NOT NULL
);

CREATE TABLE Przepustka(
	ID int PRIMARY KEY	CHECK (ID > 0),
	DataWyj�cia DATE NOT NULL,
	DataPowrotu DATE NOT NULL,
	GodzinaWyj�cia TIME NOT NULL,
	GodzinaPowrotu TIME,
	Przyczyna TEXT,
	OdsiadkaID int FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Wyrok(
	ID INT FOREIGN KEY REFERENCES S�dyKarne(ID),
	NumerWyroku INT NOT NULL,
	Info TEXT,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE ,
	PRIMARY KEY(ID,NumerWyroku)
);

CREATE TABLE BlokWi�zienny(
	ID INT PRIMARY KEY,
	Stopie�Rygoru INT CHECK (Stopie�Rygoru >= 0 AND Stopie�Rygoru < 4) NOT NULL,
	Funkcjonalno�� VARCHAR(55)
);

CREATE TABLE Cela(
	ID INT PRIMARY KEY,
	Ilo��Pryczy INT NOT NULL,
	Ilo��Zaj�tychMiejsc INT,
	BlokID INT FOREIGN KEY REFERENCES BlokWi�zienny(ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE RejestrCel(
	ID INT PRIMARY KEY,
	DataRozpocz�cia DATE NOT NULL,
	DataZako�czenia DATE,	
	CelaID INT FOREIGN KEY REFERENCES Cela(ID) ON UPDATE CASCADE ON DELETE CASCADE,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Zaj�cia(
	ID INT PRIMARY KEY FOREIGN KEY REFERENCES Zaj�ciaTabela(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	Imi� varchar(255) CHECK (dbo.ISGOOD(Imi�) = 1),
	Nazwisko varchar(255) CHECK (dbo.ISGOOD(Nazwisko) = 1),
	NumerKontaktowy varchar(20) NOT NULL,
	Dzie�Tygodnia INT FOREIGN KEY REFERENCES DniTygodnia(ID) ON UPDATE CASCADE,
	GodzinaRozpocz�cia TIME NOT NULL,
	GodzinaZako�czenia TIME NOT NULL,	
	Powtarzalno�� VARCHAR(255),
	Miejsce VARCHAR(255)
);

CREATE TABLE Zapisy(
	ID INT PRIMARY KEY,
	DataZapisu DATE NOT NULL,
	GodzinaZapisu TIME NOT NULL,
	Zaj�ciaID INT FOREIGN KEY REFERENCES Zaj�cia(ID) ON DELETE CASCADE ON UPDATE CASCADE ,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Obecno��(
	ID INT PRIMARY KEY,
	DataZaj�� DATE NOT NULL,
	Zaj�ciaID INT FOREIGN KEY REFERENCES Zaj�cia(ID) ON DELETE CASCADE ON UPDATE CASCADE ,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Odwiedzaj�cy(
	ID INT PRIMARY KEY,
	Imi� varchar(255) CHECK (dbo.ISGOOD(Imi�) = 1),
	Nazwisko varchar(255) CHECK (dbo.ISGOOD(Nazwisko) = 1),	
	NumerKontaktowy varchar(20),
	Relacja TEXT,
);

CREATE TABLE Odwiedza(
	Odwiedzaj�cyID INT FOREIGN KEY REFERENCES Odwiedzaj�cy(ID) ON UPDATE CASCADE ,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON UPDATE CASCADE ON DELETE CASCADE
	PRIMARY KEY(Odwiedzaj�cyID,OdsiadkaID)
);

CREATE TABLE Odwiedziny(
	ID INT PRIMARY KEY,
	DataOdwiedzin DATE NOT NULL,
	GodzinaRopocz�cia TIME NOT NULL,
	GodzinaZako�czenia TIME NOT NULL,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Przychodzi(
	Odwiedzaj�cyID INT FOREIGN KEY REFERENCES Odwiedzaj�cy(ID) ON DELETE CASCADE ON UPDATE CASCADE ,
	OdwiedzinyID INT FOREIGN KEY REFERENCES Odwiedziny(ID) ON DELETE CASCADE ON UPDATE CASCADE 
	PRIMARY KEY(Odwiedzaj�cyID,OdwiedzinyID) 
);

CREATE TABLE Badania(
	ID INT PRIMARY KEY,
	DataBadania DATE NOT NULL,
	GodzinaBadania TIME NOT NULL,
	Imi� varchar(255) CHECK (dbo.ISGOOD(Imi�) = 1),
	Nazwisko varchar(255) CHECK (dbo.ISGOOD(Nazwisko) = 1),
	NumerKontaktowy varchar(20) NOT NULL,
	Opis TEXT,
	OdsiadkaID INT FOREIGN KEY REFERENCES Odsiadka(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);
