--	+------------+                  +-------------+
--  |    USERS   |                  |    SHOWS    |                     +----------+
--	+============+                  +=============+                     | THEATERS |
--	| _username_ | 0…*   book   0_* | _movieName_ | 0…*   show-in   0…* +==========+
--	| address    |—————————+————————+ _day_       +———————––––––––––––––+ _name_   |
--	| phoneNbr   |         :        | freeSeats   |                     | seats    |
--	| name       |         :        |             |                     +----------+
--	+------------+         :        +-------------+
--	                       :
--                  +--------------+
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
	movieName VARCHAR(50) NOT NULL UNIQUE,
	day DATE NOT NULL,
	freeSeats INT NOT NULL,
	theaterName VARCHAR(20) NOT NULL UNIQUE,
	PRIMARY KEY (movieName, day),
	FOREIGN KEY (theaterName) REFERENCES Theater(name)
);

DROP TABLE IF EXISTS Reservations;
CREATE TABLE Reservations (
	nbr INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(20) NOT NULL UNIQUE,
	movieName VARCHAR(50) NOT NULL UNIQUE,
	theaterName VARCHAR(20) NOT NULL UNIQUE,
	day DATE NOT NULL,
	PRIMARY KEY (nbr),
	FOREIGN KEY (username) REFERENCES Users(username),
	FOREIGN KEY (movieName, day) REFERENCES Shows(movieName, day),
	FOREIGN KEY (theaterName) REFERENCES Theaters(name)
);

SET foreign_key_checks = 1;

INSERT INTO Users(username, name, phoneNbr, address) VALUES
("kalle", "Kalle Kallesson", "070-123 456 78", "ABC"),
("nisse", "Nils Nilsson", "072-123 456 78", NULL),
("pelle", "Per Persson", "073-123 456 78", NULL),
("olle", "Olof Olofsson", "076-123 456 78", NULL),
("bibbi", "Birgitta Birgitsson", "079-123 456 78", NULL);

--



