---Drop the table 
DROP TABLE movies;

---First I created a table called movies
CREATE TABLE movies
(
    url text,
    title text,
    ReleaseDate text,
    Distributor text,
    Starring text,
    Summary text,
    Director text,
    Genre text,
    Rating text,
    Runtime text,
    Userscore text,
    Metascore text,
    scoreCounts text

);

---Then copied the data from a csv in the table movies
\copy movies FROM 'home/pi/RSL/moviesFromMetacritic.csv' delimiter ';' csv header;

--- Altering the movies table to specify it to Titles
ALTER TABLE movies ADD lexemestitle tsvector;

UPDATE movies SET lexemestitle = to_tsvector(title);

--- Add a ranking in the table
ALTER TABLE movies ADD rank float4;

--- Change it to make a ranking based on the titles of my movie
UPDATE movies
SET rank = ts_rank(lexemestitle,plainto_tsquery(
(
 SELECT title FROM movies WHERE url='the-wolf-of-wall-street'
 )
 ));

--- To get the right results (50) I changed the rank to -1 
 CREATE TABLE recommendationsBasedOntitleField80 AS
 SELECT url, rank FROM movies WHERE rank > -1 ORDER BY rank DESC LIMIT 50;
 
 --- Copying the results to a csv file
 \copy (SELECT * FROM recommendationsBasedOntitleField80) to '/home/pi/RSL/top50recommendations20.csv' WITH csv;
