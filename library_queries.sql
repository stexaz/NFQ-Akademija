-- Išrinimas
-- -- kurios bibliotekos lentynos yra laisvos;
SELECT shelf FROM shelves s LEFT JOIN BookExamplar e ON (e.shelfId = s.shelfId) WHERE e.bookId IS NULL;
-- -- kurio autoriaus knyga išleista seniausiai;
SELECT name, year FROM Authors a
INNER JOIN BookAuthors ba ON a.authorId = ba.authorId
INNER JOIN Books b ON b.bookId = ba.bookId
ORDER BY year
LIMIT 1;
-- -- kurių žanrų knygų neturime;
SELECT genre FROM genres g
LEFT JOIN BookGenre bg ON g.genreId = bg.genreId
WHERE bg.bookId IS NULL;
-- -- kuris autorius atstovauja daugiausiai žanrų;
SELECT a.name as Author, COUNT(a.authorId) as Books FROM genres g
JOIN BookGenre bg ON g.genreId = bg.genreId
JOIN Books b ON bg.bookId = b.bookId
JOIN BookAuthors ba ON ba.bookId = b.bookId
JOIN Authors a ON a.authorId = ba.authorId
GROUP BY (g.genreId)
LIMIT 1;
-- -- kas veluoja gražinti knygas
SELECT r.name as Reader FROM Readers r
JOIN reservations re ON re.readerId = r.readerId
WHERE re.returnAt > NOW() AND status = 'reading';
-- -- kuri knyga populiariausia
SELECT b.title, COUNT(r.reservationId) as Reservations FROM Books b
JOIN BookExamplar be ON be.bookId = b.bookId
Join reservations r ON r.examplarId = be.examplarId
GROUP BY (b.bookId)
ORDER BY (Reservations) DESC
LIMIT 1;
-- -- kokio autoriaus knygu turime daugiausia
SELECT a.name, COUNT(b.bookId) as Books FROM Books b
JOIN BookAuthors ba ON ba.bookId = b.bookId
JOIN Authors a ON a.authorId = ba.authorId
GROUP BY (a.authorId)
ORDER BY (Books) DESC
LIMIT 1
-- -- kuriu autoriau knygu neturime bibliotekoje
SELECT a.name FROM Authors a
JOIN BookAuthors ba ON ba.authorId = a.authorId
JOIN BookExamplar be ON be.bookId = ba.bookId
JOIN reservations r ON r.examplarId = be.examplarId
WHERE r.status != 'returned'
GROUP BY (a.authorId);
-- -- koks zanras populiariausias
SELECT genre, COUNT(r.reservationId) AS Reservations FROM genres g
JOIN BookGenre bg ON g.genreId = bg.genreId
JOIN BookExamplar be ON be.bookId = bg.bookId
JOIN reservations r ON r.examplarId = be.examplarId
GROUP BY (g.genreId)
ORDER BY Reservations DESC
LIMIT 1;
-- -- kuris autorius populiariausias
SELECT name as Author, COUNT(r.reservationId) AS Reservations FROM Authors a
JOIN BookAuthors ba ON ba.authorId = a.authorId
JOIN BookExamplar be ON be.bookId = ba.bookId
JOIN reservations r ON r.examplarId = be.examplarId
GROUP BY (a.authorId)
ORDER BY Reservations DESC
LIMIT 1;

-- Trinimas
-- -- Negražino knygos metus. Pavogė? Šalinam lauk.
DELETE r, re FROM Readers r, reservations re WHERE re.status !='returned' AND re.readerId = r.readerId AND returnAt > DATE_SUB(NOW(), INTERVAL 1 YEAR);
-- -- Autorius Juozas Šalna pareikalavopanaikinti visas jo knygas iš bibliotekos
DELETE a, ba, b FROM Authors a, BookAuthors ba, Books b 
WHERE a.authorId = ba.authorId AND ba.bookId = b.bookId AND a.name = 'Juozas Šalna';
-- Atnaujinimas
-- -- Knygą perkėlė į kitą lentyną
UPDATE shelves s, BookExamplar be SET be.shelfId = 5 WHERE s.shelfId = be.shelfId AND be.examplarId = 3;
-- -- Petras Petraitis gražino visas turėtas knygas
UPDATE Readers r, reservations re SET re.status = 'returned' WHERE r.readerId  = re.readerId AND r.name = 'Petras Petraitis';
