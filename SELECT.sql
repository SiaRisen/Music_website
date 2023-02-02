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