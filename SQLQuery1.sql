use school;

--1
select Cno, Cname from Courses
where Studyear = 1
order by Cname;

--2
select count (*) as liczba from Students
where Students.Sname LIKE 'A%';

--3
select Students.City, COUNT(*) as liczba
from Students
group by City

--4
Select DISTINCT T.Tno, T.Title, T.Tname, C.Cno, C.Cname 
from Teachers T
join TSC TS ON TS.Tno = T.Tno
join Courses C On TS.Cno = C.Cno

--5
Select DISTINCT T.Tno
from Teachers T
join TSC TS ON TS.Tno = T.Tno
join Courses C On TS.Cno = C.Cno
where C.Studyear != 1

--6
SELECT top 1 C.Studyear, COUNT(*) as liczba 
FROM Courses C
group by c.Studyear

SELECT top 1 Studyear
FROM Courses
GROUP BY Studyear
ORDER BY COUNT(*) DESC

--w egzaminu jakieœ
SELECT * FROM TEACHERS
WHERE NOT EXISTS(SELECT * FROM TSC 
WHERE Teachers.Tno =TSC.Tno)

--7
SELECT top 1 Studyear
FROM Courses C
JOIN TSC T ON T.Cno = C.Cno
GROUP BY Studyear
ORDER BY AVG(T.Grade) DESC

--8
SELECT COUNT(*) AS TeachersWithNoClasses
FROM Teachers T 
WHERE T.Tno NOT IN ( Select TSC.Tno FROM TSC)

--9
SELECT C.Studyear, SUM(T.Hours) AS IloscGodzin
FROM Courses C
JOIN TSC T ON T.Cno = C.Cno
GROUP BY C.Studyear
ORDER BY C.Studyear

--10
SELECT S.Sno, S.Sname 
FROM Students S 
JOIN TSC T ON T.Sno = S.Sno
GROUP BY S.Sno, S.Sname
ORDER BY AVG(T.Grade) DESC
