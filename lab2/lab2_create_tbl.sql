--		+------------------+                +--------------+
--		|      «weak»      |                |     Users    |
--		|   Reservations   |                +--------------+
--		+------------------+                | _id_         |
--		| _reservationNbr_ | 0…*          1 | username (U) |
--		| _performanceId_  |----------------| name         |
--		| _userId_         |                | address      |
--		+------------------+                | phoneNbr     |
--		         | 0…*                      +--------------+
--		         |
--		         | 1
--		+---------------+
--		|     «weak»    |
--		|  Performances |               +----------+
--		+---------------+               |  Movies  |           +------------+
--		| _id_          | 0…*         1 +----------+           |  Theaters  |
--		| _movieId_     |---------------| _id_     |           +------------+
--		| _theaterId_   | 0…*           | name (U) |         1 | _id_       |
--		| day           |--------+      +----------+    +------| _name_ (U) |
--		+---------------+        |                      |      | nbrOfSeats |
--		                         +----------------------+      +------------+
--
--		Reservations(_reservationNbr_, _performanceId_, _userId_)
--		Users(_id_, username, name, address, phoneNbr)
--		Performances(_id_, _movieId_, _theaterId_, day)
--		Movies(_id_, name)
--		Theaters(_id_, _name_, nbrOfSeats)		

SET foreign_key_checks = 0;

DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	username VARCHAR(20) NOT NULL UNIQUE,
	name VARCHAR(20) NOT NULL,
	phoneNbr VARCHAR(20) NOT NULL,
	address VARCHAR(255)
);

DROP TABLE IF EXISTS Movies;
CREATE TABLE Movies (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS Theaters;
CREATE TABLE Theaters (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL UNIQUE,
	nbrOfSeats INT NOT NULL
);

DROP TABLE IF EXISTS Performances;
CREATE TABLE Performances (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	movieId INT NOT NULL,
	theaterId INT NOT NULL,
	day DATE NOT NULL,
	FOREIGN KEY (movieId) REFERENCES Movies(id),
	FOREIGN KEY (theaterId) REFERENCES Theaters(id),
	CONSTRAINT perDay UNIQUE (movieId, day)
);

DROP TABLE IF EXISTS Reservations;
CREATE TABLE Reservations (
	reservationNbr INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	performanceId INT NOT NULL,
	userId INT NOT NULL,
	FOREIGN KEY (performanceId) REFERENCES Performances(id),
	FOREIGN KEY (userId) REFERENCES Users(id),
	CONSTRAINT perPerformance UNIQUE (performanceId, userId)
);

SET foreign_key_checks = 1;

INSERT INTO Users(username, name, phoneNbr, address) VALUES
("userAB", "A B", "1701272223", "ABC"),
("userCD", "C D", "1701272224", NULL),
("userEF", "E F", "1701272225", NULL),
("userGH", "G H", "1701272226", "DEF"),
("userIJ", "I J", "1701272227", NULL),
("userKL", "K L", "1701272228", NULL),
("userMN", "M N", "1701272229", NULL),
("userOP", "O P", "1701272230", "GHI"),
("userQR", "Q R", "1701272231", NULL),
("userST", "S T", "1701272232", NULL),
("userUV", "U V", "1701272233", NULL),
("userWX", "W X", "1701272234", NULL),
("userYZ", "Y Z", "1701272235", "JKL"),
("userÅÄ", "Å Ä", "1701272236", "MNO"),
("userÖA", "Ö A", "1701272237", NULL);

INSERT INTO Movies(name) VALUES
("Agnus Dei"),
("Allied"),
("American Pastoral"),
("Aquarius"),
("Arrival"),
("Assassin's Creed"),
("Bamse och häxans dotter"),
("Bleed for this"),
("David Bowie is"),
("Den allvarsamma leken"),
("Doctor Strange"),
("Don't Breathe"),
("Efter stormen"),
("Elle"),
("En alldeles särskild dag"),
("En man som heter Ove"),
("Fantastiska vidunder"),
("Far och son"),
("Fifty Shades Darker"),
("Flykten till framtiden"),
("Fyren mellan haven"),
("Hacksaw Ridge"),
("Hundraettåringen"),
("Jackie"),
("Jag, Daniel Blake"),
("Jätten"),
("Kaabil"),
("Kvinnan på tåget"),
("La La Land"),
("The Lego Batman"),
("Lion"),
("Live by night"),
("Manchester by the sea"),
("Marcus & Martinus"),
("Mera monster Alfons"),
("Min arabsiak vår"),
("Min pappa Toni Erdmann"),
("Morran & Tobias"),
("Måste Gitt"),
("Mocturnal Animals"),
("Passengers"),
("Paterson"),
("Pettson & Finus"),
("Päron och lavendel"),
("Rogue One: A Star Wars Story"),
("Trolls"),
("Trubaduren"),
("Vaiana"),
("Vem lurar Alfons"),
("Why him?"),
("xXx: The return of Xander Cage");

INSERT INTO Theaters(name, nbrOfSeats) VALUES
("SF Stockholm", 500),
("SF Göteborg", 400),
("SF Malmö", 300),
("SF Alingsås", 50),
("SF Borlänge", 80),
("SF Borås", 70),
("SF Eskilstuna", 20),
("SF Falun", 10),
("SF Gävle", 60),
("SF Halmstad", 80),
("SF Helsingborg", 100),
("SF Hundiksvall", 70),
("SF Härnösand", 200),
("SF Jönköping", 110),
("SF Karlskrona", 140),
("SF Karlstad", 120),
("SF Katrineholm", 110),
("SF Kristianstad", 100),
("SF Kungsbacka", 100),
("SF Köping", 10),
("SF Landskrona", 50),
("SF Lindköping", 80),
("SF Luleå", 50),
("SF Lund", 200),
("SF Mariestad", 40),
("SF Mjölby", 10),
("SF Mora", 80),
("SF Motala", 100),
("SF Norrköping", 100),
("SF Norrtälje", 100),
("SF Nyköping", 100),
("SF Skara", 100),
("SF Skellefteå", 100),
("SF Skövde", 80),
("SF Strängnäs", 100),
("SF Sundsvall", 100),
("SF Sälen", 20),
("SF Söderhamn", 100),
("SF Uddevalla", 85),
("SF Umeå", 100),
("SF Uppsala", 20),
("SF Vetlanda", 30),
("SF Visby", 90),
("SF Vänersborg", 100),
("SF Värnamo", 50),
("SF Västervik", 100),
("SF Västerås", 100),
("SF Växjö", 100),
("SF Ystad", 120),
("SF Örebro", 110),
("SF Örnsköldsvik", 90),
("SF Östersund", 80);

INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-28' FROM Movies, Theaters
WHERE Movies.name = "Arrival" AND Theaters.name = "SF Helsingborg";
INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-28' FROM Movies, Theaters
WHERE Movies.name = "Aquarius" AND Theaters.name = "SF Helsingborg";
INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-28' FROM Movies, Theaters
WHERE Movies.name = "Doctor Strange" AND Theaters.name = "SF Helsingborg";
INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-28' FROM Movies, Theaters
WHERE Movies.name = "Don't Breathe" AND Theaters.name = "SF Lund";
INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-28' FROM Movies, Theaters
WHERE Movies.name = "Jackie" AND Theaters.name = "SF Lund";

INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-29' FROM Movies, Theaters
WHERE Movies.name = "Arrival" AND Theaters.name = "SF Lund";
INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-29' FROM Movies, Theaters
WHERE Movies.name = "Aquarius" AND Theaters.name = "SF Lund";
INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-29' FROM Movies, Theaters
WHERE Movies.name = "Doctor Strange" AND Theaters.name = "SF Lund";
INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-29' FROM Movies, Theaters
WHERE Movies.name = "Don't Breathe" AND Theaters.name = "SF Helsingborg";
INSERT INTO Performances(movieId, theaterId, day) SELECT Movies.id, Theaters.id, '2017-01-29' FROM Movies, Theaters
WHERE Movies.name = "Jackie" AND Theaters.name = "SF Helsingborg";


-- Create a reservation
INSERT INTO Reservations(performanceId, userId) SELECT Performances.id, Users.id
FROM Performances, Users, Movies WHERE Performances.day = "2017-01-28"
AND Performances.movieId = Movies.id AND Movies.name = "Arrival" AND Users.username = "userAB";

INSERT INTO Reservations(performanceId, userId) SELECT Performances.id, Users.id
FROM Performances, Users, Movies WHERE Performances.day = "2017-01-28"
AND Performances.movieId = Movies.id AND Movies.name = "Jackie" AND Users.username = "userÖA";

INSERT INTO Reservations(performanceId, userId) SELECT Performances.id, Users.id
FROM Performances, Users, Movies WHERE Performances.day = "2017-01-28"
AND Performances.movieId = Movies.id AND Movies.name = "Doctor Strange" AND Users.username = "userYZ";

INSERT INTO Reservations(performanceId, userId) SELECT Performances.id, Users.id
FROM Performances, Users, Movies WHERE Performances.day = "2017-01-29"
AND Performances.movieId = Movies.id AND Movies.name = "Aquarius" AND Users.username = "userÖA";

-- List all movies that are shown
SELECT p.movieId, p.day, m.name FROM Performances AS p INNER JOIN Movies AS m ON p.id = m.id;

