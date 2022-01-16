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

--- Altering the movies table to specify it to Starring
ALTER TABLE movies ADD lexemesStarring tsvector;

UPDATE movies SET lexemesStarring = to_tsvector(Starring);

--- Add a ranking in the table
ALTER TABLE movies ADD rank float4;

---  Change the ranking variable to focus on the actors of my favorite movie
UPDATE movies
SET rank = ts_rank(lexemesStarring,plainto_tsquery(
(
 SELECT Starring FROM movies WHERE url='the-wolf-of-wall-street'
 )
 ));

--- Since the results were so minimum, I changed the rank to -1 to get 50 results
 CREATE TABLE recommendationsBasedOnStarringField70 AS
 SELECT url, rank FROM movies WHERE rank > -1 ORDER BY rank DESC LIMIT 50;
 
 --- Copying the results to a csv file
 \copy (SELECT * FROM recommendationsBasedOnStarringField70) to '/home/pi/RSL1/Starring_top50recommendations30_StarringField.csv' WITH csv;
