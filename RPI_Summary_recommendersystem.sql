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

--- Altering the movies table to specify it to Summary
ALTER TABLE movies ADD lexemesSummary tsvector;

UPDATE movies SET lexemesSummary = to_tsvector(title);

--- Add a ranking in the table
ALTER TABLE movies ADD rank float4;

---  Change the ranking variable to focus on the Summary of my favorite movie
UPDATE movies
SET rank = ts_rank(lexemesSummary,plainto_tsquery(
(
 SELECT Summary FROM movies WHERE url='the-wolf-of-wall-street'
 )
 ));

--- Since the results were so minimum, I changed the rank to -1 to get 50 results
 CREATE TABLE recommendationsBasedOnSummaryField50 AS
 SELECT url, rank FROM movies WHERE rank > -1 ORDER BY rank DESC LIMIT 50;
 
 --- Copying the results to a csv file
 \copy (SELECT * FROM recommendationsBasedOnSummaryField50) to '/home/pi/RSL/Summary_top50recommendations10_SummaryField.csv' WITH csv;
 
