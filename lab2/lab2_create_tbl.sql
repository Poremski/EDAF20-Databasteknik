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

INSERT INTO Reservations(username, movieName, theaterName, day) VALUES
("kalle", "Trolls", "SF Helsingborg", "2017-02-02"),
("kalle", "Aquarius", "SF Stockholm", "2017-02-02"),
("kalle", "Arrival", "SF Göteborg", "2017-02-02");

