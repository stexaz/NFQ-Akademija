-- 1. Sukurkite duomenų bazę;
DROP DATABASE IF EXISTS nfq_sql1; 
CREATE DATABASE nfq_sql1; 
USE nfq_sql1; 
-- 2. Suimportuokite paruoštą duomenų bazės prototipą.
SOURCE ./Books.sql;
-- 3. Atlikite šiuos veiksmus:
-- -- a) Papildykite autorių lentelę įrašais.
INSERT INTO Authors(name) VALUES ('Balys Sruoga'), ('Vincas Mykolaitis-Putinas'), ('Jonas Biliunas'), ('Kristijonas Donelaitis'), ('Antanas Skema');
-- -- b) Papildykite knygų lentelę, įrašais apie knygas, kurių autorius įrašėte prieš tai.
INSERT INTO Books (authorId, title, year) 
SELECT authorId, 'Dievu miskas' as title, 1957 as year FROM Authors WHERE name='Balys Sruoga'
UNION SELECT authorId, 'Altoriu sesely' as title, 1933 as year FROM Authors WHERE name='Vincas Mykolaitis-Putinas'
UNION SELECT authorId, 'Liudna pasaka' as title, 1907 as year FROM Authors WHERE name='Jonas Biliunas'
UNION SELECT authorId, 'Metai' as title, 1970 as year FROM Authors WHERE name='Kristijonas Donelaitis'
UNION SELECT authorId, 'Balta drobule ' as title, 1958 as year FROM Authors WHERE name='Antanas Skema';
-- -- c) Išrinkite knygų informaciją prijungdami autorius iš autorių lentelės.
SELECT b.title as `Book Title`, IF (b.authorId IS NULL, 'Author is unknown', a.name) as Author, IF(b.year IS NULL, 'Unknown', b.year) as Year 
FROM Books b
LEFT JOIN Authors a ON a.authorId = b.authorId;
-- -- d) Pakeiskite vienos knygos autorių į kitą.
UPDATE Books b, Authors a SET b.authorId = a.authorId WHERE a.name = 'Balys Sruoga' AND b.title = 'Balta drobule';
-- -- e) Suskaičiuokite kiek knygų kiekvieno autoriaus yra duomenų bazėje (įtraukdami autorius kurie neturi knygų).
SELECT a.name as `Author name`, COUNT(b.title) as `Number of books` FROM Authors a 
LEFT JOIN Books b ON b.authorId = a.authorId
GROUP BY b.authorId
ORDER BY `Number of books` DESC;
-- -- e) Suskaičiuokite kiek knygų kiekvieno autoriaus yra duomenų bazėje (neįtraukdami autorių kurie neturi knygų).
SELECT a.name as `Author name`, COUNT(b.title) as `Number of books` FROM Authors a 
INNER JOIN Books b ON b.authorId = a.authorId
GROUP BY b.authorId
ORDER BY `Number of books` DESC;
-- -- f) Pašalinkite jūsų suvestus autorius.
DELETE FROM `Authors` WHERE name IN ('Balys Sruoga', 'Vincas Mykolaitis-Putinas', 'Jonas Biliunas', 'Kristijonas Donelaitis', 'Antanas Skema');
-- -- g) Pašalinkite knygas, kurios neturi autorių.
DELETE FROM Books WHERE authorId NOT IN (SELECT authorId FROM Authors) OR authorId IS NULL;
-- 4. Papildykite duomenų bazę kad būtų galima:
-- -- a) Suskirstyti knygas į žanrus.
ALTER TABLE Books ADD genre varchar(50);
-- -- b) Knygos gali turėti vieną ir daugiau autorių.
CREATE TABLE BookAuthors (authorId int, bookId int, PRIMARY KEY (authorId, bookId));
-- -- c) Sutvarkyti duomenų bazės duomenis, jei reikia papildykite naujais.
INSERT INTO BookAuthors SELECT authorId, bookId FROM Books;
ALTER TABLE Books DROP authorId;
INSERT INTO Authors(name) VALUES ('Jonas Blonskis'), ('Vytautas Buksnaitis');
INSERT INTO Books(title, year) VALUES ('Programavimo pradmenys', 2009);
INSERT INTO BookAuthors SELECT a.authorId, b.bookId FROM Books b, Authors a WHERE b.title = 'Programavimo pradmenys' AND a.name IN ('Jonas Blonskis', 'Vytautas Buksnaitis');
-- -- d) Išrinkite visas knygas su jų autoriais. (autorius, jei jų daugiau nei veinas atskirkite kableliais)
SELECT b.title as `Book title`, GROUP_CONCAT(DISTINCT a.name SEPARATOR ', ') as Author, year as Year FROM Books b
INNER JOIN BookAuthors ba ON ba.bookId = b.bookId
INNER JOIN Authors a ON a.authorId = ba.authorId
GROUP BY b.bookId;
-- -- e) Papildykite knygų lentelę, kad galetumėte išsaugoti orginalų knygos pavadinimą. (Pavadinime išsaugokite, lietuviškas raides kaip ą,ė,š ir pan.)
ALTER TABLE  `Books` CHANGE  `title`  `title` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_lithuanian_ci;
INSERT INTO Books (title, year) VALUES ('Dievų miškas', 1957), ('Altorių šesėly', 1933), ('Liūdna pasaka', 1907), ('Balta drobulė ', 1958);
-- 5. Paruoškite duomenų bazės kopiją.
-- mysqldump -u root -proot nfq_sql1 > books_backup.sql
