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

---Then copied the data from a csv in the tale movies
\copy movies FROM 'home/pi/RSL/moviesFromMetacritic.csv' delimiter ';' csv header;

--- Altering the movies table to specify it to Titles
ALTER TABLE movies ADD lexemestitle tsvector;

UPDATE movies SET lexemestitle = to_tsvector(title);

--- Add a ranking in the table
ALTER TABLE movies ADD rank float4;

---  Change the ranking variable to focus on the title of my favorite movie
UPDATE movies
SET rank = ts_rank(lexemestitle,plainto_tsquery(
(
 SELECT title FROM movies WHERE url='the-wolf-of-wall-street'
 )
 ));

--- Since the results were so minimum, I changed the rank to -1 to get 50 results
 CREATE TABLE recommendationsBasedOntitleField80 AS
 SELECT url, rank FROM movies WHERE rank > -1 ORDER BY rank DESC LIMIT 50;
 
 --- Copying the results to a csv file
 \copy (SELECT * FROM recommendationsBasedOntitleField80) to '/home/pi/RSL1/title_top50recommendations20_TitleField.csv' WITH csv;
