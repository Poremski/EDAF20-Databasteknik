--	---------------------
--	EDAF20 – Laboration 1
--	---------------------

-- (a)
SELECT firstName, lastName FROM Students;

-- (b)
SELECT firstName, lastName from Students ORDER BY lastName, firstName;

-- (c)
SELECT firstName, lastName FROM Students WHERE pNbr LIKE '75%';

-- (d)
SELECT * FROM Students WHERE mod(substr(pNbr,10,1),2) = 0;

-- (e)
SELECT COUNT(*) FROM Students;

-- (f)
SELECT * FROM Courses WHERE courseCode LIKE 'FMA%';

-- (g)
SELECT * FROM Courses WHERE credits > 5;

-- (h)
SELECT courseCode FROM TakenCourses WHERE pNbr = '790101-1234';

-- (i)
SELECT courseCode, courseName, credits FROM courses WHERE courseCode IN (
	SELECT courseCode FROM TakenCourses WHERE pNbr = '790101-1234'
);

-- (j)
SELECT COUNT(courseCode), SUM(credits) FROM courses WHERE courseCode IN (
	SELECT courseCode FROM TakenCourses WHERE pNbr = '790101-1234'
);

-- (k)
SELECT AVG(grade) FROM TakenCourses WHERE pNbr = '790101-1234';

-- (l) --> (h)
SELECT courseCode FROM TakenCourses WHERE pNbr IN (
	SELECT pNbr FROM Students WHERE firstName = 'Eva' AND lastName = 'Alm'
);

-- (l) --> (i)
SELECT courseCode, courseName, credits FROM courses WHERE courseCode IN (
	SELECT courseCode FROM TakenCourses WHERE pNbr IN (
		SELECT pNbr FROM Students WHERE firstName = 'Eva' AND lastName = 'Alm'
	)
);

-- (l) --> (j)
SELECT COUNT(courseCode), SUM(credits) FROM courses WHERE courseCode IN (
	SELECT courseCode FROM TakenCourses WHERE pNbr IN (
		SELECT pNbr FROM Students WHERE firstName = 'Eva' AND lastName = 'Alm'
	)
);

-- (l) --> (k)
SELECT AVG(grade) FROM TakenCourses WHERE pNbr IN (
	SELECT pNbr FROM Students WHERE firstName = 'Eva' AND lastName = 'Alm'
);

-- (m)
SELECT * FROM Students WHERE pNbr NOT IN (
	SELECT pNbr FROM TakenCourses
);

-- (n)
CREATE OR REPLACE VIEW view_avgGrade (pNbr, avgGrade) AS 
	SELECT pNbr, AVG(grade) FROM TakenCourses 
	GROUP BY pNbr ORDER BY AVG(grade) desc;
SELECT * FROM view_avgGrade WHERE avgGrade = (SELECT MAX(avgGrade) FROM view_avgGrade);

-- (o)
SELECT Students.pNbr, IFNULL(SUM(credits), 0) AS Credits FROM (
	Students LEFT JOIN TakenCourses ON Students.pNbr = TakenCourses.pNbr
) LEFT JOIN Courses ON TakenCourses.courseCode = Courses.courseCode GROUP BY Students.pNbr;

-- (p)
SELECT firstName, lastName, IFNULL(SUM(credits), 0) AS Credits FROM (
	Students LEFT JOIN TakenCourses ON Students.pNbr = TakenCourses.pNbr
) LEFT JOIN Courses ON TakenCourses.courseCode = Courses.courseCode 
	GROUP BY Students.pNbr ORDER BY lastName, firstName;

-- (q)
SELECT * FROM Students WHERE (firstName, lastName) IN (
	SELECT firstName, lastName FROM Students GROUP BY firstName, lastName HAVING COUNT(*) > 1
) ORDER BY lastName, firstName;
