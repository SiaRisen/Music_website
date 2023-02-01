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