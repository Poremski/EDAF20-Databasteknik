--	+------------+                  +-------------+
--	|    USERS   |                  |    SHOWS    |                     +----------+
--	+============+                  +=============+                     | THEATERS |
--	| _username_ | 0…*   book   0_* | _movieName_ | 0…*   show-in   0…* +==========+
--	| address    |—————————+————————+ _day_       +———————––––––––––––––+ _name_   |
--	| phoneNbr   |         :        | freeSeats   |                     | seats    |
--	| name       |         :        |             |                     +----------+
--	+------------+         :        +-------------+
--	                       :
--	                +--------------+
--	                | RESERVATIONS |
--	                +==============+
--	                | _nbr_        |
--	                +--------------+
--
-- Users(_username_, address, phoneNbr, name)
-- Shows(_movieName_, _day_, freeSeats, [FK]theaterName)
-- Theaters(_name_, seats)
-- Reservations(_nbr_, [FK]username, [FK]movieName, [FK]date)


SET foreign_key_checks = 0;

DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
	username VARCHAR(20) NOT NULL UNIQUE,
	name VARCHAR(20) NOT NULL,
	phoneNbr VARCHAR(20) NOT NULL,
	address VARCHAR(255),
	PRIMARY KEY (username)
);

DROP TABLE IF EXISTS Theaters;
CREATE TABLE Theaters (
	name VARCHAR(20) NOT NULL UNIQUE,
	seats INT NOT NULL,
	PRIMARY KEY (name)
);

DROP TABLE IF EXISTS Shows;
CREATE TABLE Shows (
	movieName VARCHAR(50) NOT NULL,
	day DATE NOT NULL,
	freeSeats INT NOT NULL,
	theaterName VARCHAR(20) NOT NULL,
	PRIMARY KEY (movieName, day),
	FOREIGN KEY (theaterName) REFERENCES Theaters(name),
	CONSTRAINT perDay UNIQUE (movieName, day)
);

DROP TABLE IF EXISTS Reservations;
CREATE TABLE Reservations (
	nbr INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(20) NOT NULL,
	movieName VARCHAR(50) NOT NULL,
	theaterName VARCHAR(20) NOT NULL,
	day DATE NOT NULL,
	PRIMARY KEY (nbr),
	FOREIGN KEY (username) REFERENCES Users(username),
	FOREIGN KEY (movieName, day) REFERENCES Shows(movieName, day),
	FOREIGN KEY (theaterName) REFERENCES Theaters(name),
	CONSTRAINT perPerformance UNIQUE (movieName, username)
);

SET foreign_key_checks = 1;

INSERT INTO Users(username, name, phoneNbr, address) VALUES
("kalle", "Kalle Kallesson", "070-123 456 78", "ABC"),
("nisse", "Nils Nilsson", "072-123 456 78", NULL),
("pelle", "Per Persson", "073-123 456 78", NULL),
("olle", "Olof Olofsson", "076-123 456 78", NULL),
("bibbi", "Birgitta Birgitsson", "079-123 456 78", NULL);

INSERT INTO Theaters(name, seats) VALUES
("SF Stockholm", 100),
("SF Göteborg", 80),
("SF Malmö", 60),
("SF Helsingborg", 40);

INSERT INTO Shows(movieName, day, freeSeats, theaterName) VALUES
("Aquarius", '2017-02-02', 100, "SF Stockholm"),
("Arrival", '2017-02-03', 100, "SF Stockholm"),
("Passengers", '2017-02-04', 100, "SF Stockholm"),
("Trolls", '2017-02-05', 100, "SF Stockholm"),

("Arrival", '2017-02-02', 80, "SF Göteborg"),
("Passengers", '2017-02-03', 80, "SF Göteborg"),
("Trolls", '2017-02-04', 80, "SF Göteborg"),
("Aquarius", '2017-02-05', 80, "SF Göteborg"),

("Passengers", '2017-02-02', 60, "SF Malmö"),
("Trolls", '2017-02-03', 60, "SF Malmö"),
("Aquarius", '2017-02-04', 60, "SF Malmö"),
("Arrival", '2017-02-05', 60, "SF Malmö"),

("Trolls", '2017-02-02', 40, "SF Helsingborg"),
("Aquarius", '2017-02-03', 40, "SF Helsingborg"),
("Arrival", '2017-02-04', 40, "SF Helsingborg"),
("Passengers", '2017-02-05', 40, "SF Helsingborg");

-- Create a reservation
INSERT INTO Reservations(username, movieName, theaterName, day) VALUES ("kalle", "Trolls", "SF Helsingborg", "2017-02-02");
INSERT INTO Reservations(username, movieName, theaterName, day) VALUES ("kalle", "Aquarius", "SF Stockholm", "2017-02-02");
INSERT INTO Reservations(username, movieName, theaterName, day) VALUES ("kalle", "Arrival", "SF Göteborg", "2017-02-02");

-- List all movies that are shown
SELECT * FROM Shows;

-- List dates when a movie is shown
SELECT * FROM Shows WHERE movieName = "Arrival";

--  Try to insert two movie theaters with the same name
INSERT INTO Theaters(name, seats) VALUES ("SF Stockholm", 100); -- Error: Duplicate entry.

-- Insert a movie show in a theater that is not in the database
INSERT INTO Shows(movieName, day, freeSeats, theaterName) VALUES
("Aquarius", '2017-02-06', 10, "SF Lund"); -- Error: foreign key constraint fails.


-- (9)
-- En biljettreservation utförs genom följande steg:
--	I.   Kontroll av tillgänglig plats.
--	II.  Om det råder tillgänglighet på platser, utförs en reservation.
--	III. Efter utförd reservation genomförs uppdatering av antalet tillgängliga platser.
-- Vilket problem kan uppstå vid sammankörning av dessa steg med flera användare?
--
-- Scenariot som uppstår är när det finnd 1 (en) plats kvar.
-- Användare A gör en reservation där kontroll av tillgängliga platser görs.
-- Eftersom det i punkt I finns ledig plats, går man över till punkt II.
-- I samma stund kommer anävndare B som väljer att lägga reservation.
-- Användaren B kommer i punkt I få en ledig plats och går vidare till punkt II.
-- Anändare A får sin reservation bokförd och tillgängligheten ändras till 0 (noll).
-- Användare B får sin reservation bokförd och tillgängliheten ändras till -1 (överförsäljning).
-- Vi kommer därmed få en s.k. "race hazard" eller "race condition".
--
-- (10)
-- DBM tillhandahåller olika former av isolering av sql-körning som gör att dessa konflikter förhindras.
-- Ett exempel vore att tillämpa "BEGIN TRANSACTION" föjt av SQL-koden varefter det avslutas med "COMMIT".

