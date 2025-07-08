-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA

select count(*)
from spotify
;

select count(distinct artist)
from spotify
;

select count(distinct album)
from spotify
;

select distinct album_type
from spotify
;

-- To see the max and minimum duration of the songs
select max(duration_min), min(duration_min)
from spotify
;

-- See all the songs wwhich have 0 min duration
select *
from spotify
where duration_min = 0
;

-- Delete the songs having 0 min duration
delete from spotify
where duration_min = 0
;

-- Checking again
select *
from spotify
where duration_min = 0
;

select count(*)
from spotify
;

-----------------------------------------------------
-- Data Analysis (Easy Category)
/*
1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where licensed = TRUE.
4. Find all tracks that belong to the album type single.
5. Count the total number of tracks by each artist.
*/


-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
select *
from spotify
where stream > 1000000000
;

-- 2. List all albums along with their respective artists.
select album, artist
from spotify
;


-- 3. Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comments
from spotify
where licensed = 'true'
;

-- 4. Find all tracks that belong to the album type single.
select *
from spotify
;

select *
from spotify
where album_type = 'single'
;

-- 5. Count the total number of tracks by each artist.
select 
		artist, ----------------------- 1
		count(*) as total_track ------- 2
from spotify
group by artist
order by 2 asc
;


-----------------------------------------------------
-- Data Analysis (Medium Category)

/*
1. Calculate the average danceability of tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List all tracks along with their views and likes where official_video = TRUE.
4. For each album, calculate the total views of all associated tracks.
5. Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

-- 1. Calculate the average danceability of tracks in each album.
select *
from spotify
;

select 
	album, ------------------------------------ 1
	avg(danceability) as avg_danceability ----- 2
from spotify
group by 1
;

-- 2. Find the top 5 tracks with the highest energy values.
select *
from spotify
;

select 
		track, ---------- 1 
		energy ---------- 2
from spotify
order by 2 desc
limit 5
;

-- 3. List all tracks along with their views and likes where official_video = TRUE.
select *
from spotify
;

select track, views, likes
from spotify
where official_video = true
;

-- 4. For each album, calculate the total views of all associated tracks.
select *
from spotify
;

select
	album, ---------- 1
	sum(views) ------ 2
from spotify
group by 1
order by 1
;

-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.
select *
from spotify
;

select track
from spotify
where most_played_on = 'Spotify'
;


