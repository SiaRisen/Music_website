-- CREATE

CREATE TABLE IF NOT EXISTS Genre (
	genre_id SERIAL PRIMARY KEY,
	name_genre      VARCHAR(60) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Performers (
	performer_id SERIAL PRIMARY KEY,
	name                VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS Albums (
	album_id SERIAL PRIMARY KEY, 
	name_album      VARCHAR(60) NOT NULL,
	date_release    INTEGER     NOT NULL
	                CHECK (date_release > 2000)
);

CREATE TABLE IF NOT EXISTS Tracks (
	track_id SERIAL PRIMARY KEY,
	name_track      VARCHAR(60) NOT NULL,
	duration_track  INTEGER     NOT NULL
	                CHECK (duration_track > 60),
	album_id        INTEGER     NOT NULL 
	                REFERENCES Albums(album_id)
);

CREATE TABLE IF NOT EXISTS Collections (
	collection_id SERIAL PRIMARY KEY,
	name_collection      VARCHAR(60) NOT NULL,
	date_release         INTEGER     NOT NULL
	                     CHECK (date_release > 2000)
);

CREATE TABLE IF NOT EXISTS Performer_genre (
	genre_id       INTEGER
	               REFERENCES Genre(genre_id),
	performer_id   INTEGER
	               REFERENCES Performers(performer_id),
	               CONSTRAINT p_g PRIMARY KEY (genre_id, performer_id)
);

CREATE TABLE IF NOT EXISTS Performers_albums (
	performer_id   INTEGER
	               REFERENCES Performers(performer_id),
	album_id       INTEGER
                   REFERENCES Albums(album_id),                
	               CONSTRAINT p_a PRIMARY KEY (performer_id, album_id)
);

CREATE TABLE IF NOT EXISTS Tracks_collections (
	track_id       INTEGER
	               REFERENCES Tracks(track_id),
	collection_id  INTEGER
                   REFERENCES Collections(collection_id),
                   CONSTRAINT t_c PRIMARY KEY (track_id, collection_id)
);


-- INSERT

INSERT INTO Genre (name_genre)
VALUES ('Pop'),
       ('R&B'),
       ('Hip-hop'),
       ('Rap'),
       ('Soul'),
       ('Country'),
       ('Acoustic');
       
INSERT INTO Performers (name)
VALUES ('The Weeknd'),
       ('Billie Eilish'),
       ('Ed Sheeran'),
       ('Taylor Swift'),
       ('Dua Lipa'),
       ('Sam Smith'),
       ('Adele'),
       ('Post Malone'),
       ('Demi Lovato');
      
INSERT INTO Albums (name_album, date_release)
VALUES ('Beauty Behind the Madness', 2015),
       ('When We All Fall Asleep, Where Do We Go?', 2019),
       ('Divide', 2017),
       ('Lover', 2018),
       ('Dua Lipa', 2017),
       ('The Thrill of It All', 2017),
       ('25', 2015),
       ('Hollywood’s Bleeding', 2018),
       ('Dancing with the Devil...The Art of Starting Over', 2021);
      
INSERT INTO Tracks (name_track, duration_track, album_id)
VALUES ('The Hills', 242, 1),
       ('Often', 249, 1),
       ('Bad Guy', 194, 2),
       ('My 17', 173, 2),
       ('Shape of You', 233, 3),
       ('Perfect', 263, 3),
       ('London Boy', 190, 4),
       ('Afterglow', 223, 4),
       ('New Rules', 212, 5),
       ('Garden', 227, 5),
       ('Palace', 187, 6),
       ('Pray', 221, 6),
       ('Million Years Ago', 227, 7),
       ('Water Under the Bridge', 240, 7),
       ('Allergic', 235, 8),
       ('Take What You Want', 230, 8),
       ('Anyone', 228, 9),
       ('I am Ready', 200, 9);
      
INSERT INTO Collections (name_collection, date_release)
VALUES ('Pop Stars', 2021),
       ('Dance', 2020),
       ('The Best', 2017),
       ('Chill Your Mind', 2019),
       ('Empower', 2018),
       ('Night Out', 2020),
       ('Running and Singing', 2021),
       ('Karaoke Hits', 2019);
      
INSERT INTO Performer_genre (genre_id, performer_id)
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (1, 4),
       (1, 5),
       (1, 6),
       (1, 7),
       (1, 9),
       (2, 1),
       (2, 5),
       (2, 6),
       (2, 7),
       (2, 9),
       (3, 8),
       (4, 8),
       (5, 6),
       (5, 7),
       (6, 4),
       (7, 3);
      
INSERT INTO Performers_albums (album_id, performer_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (6, 6),
       (7, 7),
       (8, 8),
       (9, 9);
      
INSERT INTO Tracks_collections (track_id, collection_id)
VALUES (1, 8),
       (2, 2),
       (3, 1),
       (4, 7),
       (5, 4),
       (6, 2),
       (7, 4),
       (8, 6),
       (9, 8),
       (10, 1),
       (11, 3),
       (12, 5),
       (13, 3),
       (14, 3),
       (15, 7),
       (16, 8),
       (17, 1),
       (18, 2);

      
-- SELECT      
      
-- название и год выхода альбомов, вышедших в 2018 году
SELECT name_album, date_release FROM Albums
 WHERE date_release = 2018;
 
-- название и продолжительность самого длительного трека
SELECT name_track, duration_track FROM Tracks
 ORDER BY duration_track DESC
 LIMIT 1;
 
 -- название треков, продолжительность которых не менее 3,5 минуты
SELECT name_track FROM Tracks 
 WHERE duration_track >= 210;
 
--названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT name_collection FROM Collections
 WHERE date_release BETWEEN 2018 AND 2020;
 
-- исполнители, чье имя состоит из 1 слова
SELECT name FROM Performers
 WHERE NOT name LIKE '% %';
 
-- название треков, которые содержат слово "мой"/"my"
SELECT name_track FROM Tracks
 WHERE name_track LIKE '%My %';

-- количество исполнителей в каждом жанре
SELECT name_genre, COUNT(name) perf_q FROM Genre AS g
JOIN Performer_genre AS pg ON g.genre_id = pg.genre_id
JOIN Performers AS p ON pg.performer_id = p.performer_id
GROUP BY name_genre
ORDER BY perf_q DESC;

-- количество треков, вошедших в альбомы 2019-2020 годов
SELECT date_release, COUNT(name_track) track_q FROM Albums a
JOIN Tracks t ON t.album_id = a.album_id
WHERE date_release BETWEEN 2019 AND 2020
GROUP BY date_release
ORDER BY track_q;
    
-- средняя продолжительность треков по каждому альбому
SELECT name_album, AVG(duration_track) mid_sec FROM Albums a
JOIN Tracks t ON t.album_id = a.album_id
GROUP BY name_album
ORDER BY mid_sec DESC;
 
-- все исполнители, которые не выпустили альбомы в 2020 году
SELECT name FROM Performers p
WHERE name NOT IN (SELECT name FROM Performers p
JOIN Performers_albums pa ON p.performer_id = pa.performer_id
JOIN Albums a ON a.album_id = pa.album_id
WHERE date_release = 2020)
ORDER BY name;

-- названия сборников, в которых присутствует конкретный исполнитель ('Ed Sheeran')
SELECT name_collection FROM Collections c
JOIN Tracks_collections tc ON c.collection_id = tc.collection_id
JOIN Tracks t ON t.track_id = tc.track_id 
JOIN Albums a ON a.album_id = t.album_id 
JOIN Performers_albums pa ON pa.album_id = a.album_id 
JOIN Performers p ON p.performer_id = pa.performer_id 
WHERE name LIKE '%Ed Sheeran%'
ORDER BY name_collection;
 
-- название альбомов, в которых присутствуют исполнители более 1 жанра
SELECT name_album FROM Albums a
JOIN Performers_albums pa ON a.album_id = pa.album_id 
JOIN Performers p ON p.performer_id = pa.performer_id 
JOIN Performer_genre pg ON p.performer_id = pg.performer_id 
JOIN Genre g ON g.genre_id = pg.genre_id 
GROUP BY name_album
HAVING COUNT(DISTINCT name_genre) > 1
ORDER BY name_album;
 
-- наименование треков, которые не входят в сборники
INSERT INTO Albums (name_album, date_release)
VALUES('After Hours', 2020);
 
INSERT INTO Tracks (name_track, duration_track, album_id)
VALUES('Blinding Lights', 202, 10);

INSERT INTO Performers_albums (album_id, performer_id)
VALUES (10, 1);
 
SELECT name_track FROM Tracks t
LEFT JOIN Tracks_collections tc ON t.track_id = tc.track_id 
WHERE tc.track_id IS NULL;
 
-- исполнителя(-ей), написавшего самый короткий по продолжительности трек
SELECT name, duration_track FROM Tracks t
JOIN Albums a ON a.album_id = t.album_id 
JOIN Performers_albums pa ON pa.album_id = a.album_id 
JOIN Performers p ON p.performer_id = pa.performer_id 
GROUP BY name, duration_track
HAVING duration_track = (SELECT MIN(duration_track) FROM Tracks);
 
-- название альбомов, содержащих наименьшее количество треков
SELECT name_album FROM Albums a
JOIN Tracks t ON t.album_id = a.album_id 
WHERE t.album_id IN (SELECT album_id FROM Tracks
GROUP BY album_id
HAVING COUNT(album_id) = (SELECT COUNT(album_id) FROM Tracks
GROUP BY album_id
ORDER BY COUNT
LIMIT 1))
ORDER BY name_album;  