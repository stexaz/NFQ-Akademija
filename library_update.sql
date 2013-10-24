ALTER TABLE Books DROP genre;
create table genres (genreId int auto_increment, genre varchar(100), PRIMARY KEY (genreId));
CREATE TABLE BookGenre (genreId int, bookId int, PRIMARY KEY (genreId, bookId));
CREATE TABLE BookExamplar (examplarId int auto_increment, bookId int, shelfId int, PRIMARY KEY (examplarId));
CREATE TABLE shelves (shelfId int auto_increment, shelf varchar(100), PRIMARY KEY (shelfId));
CREATE TABLE Readers (readerId int auto_increment, name varchar(100), PRIMARY KEY (readerId));
CREATE TABLE reservations (reservationId int auto_increment, readerId int, examplarId int, givenAt datetime, returnAt datetime, returnedAt datetime, status varchar(20), PRIMARY KEY (reservationId));
