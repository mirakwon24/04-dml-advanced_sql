--1.количество исполнителей в каждом жанре;

select g.gengre_name, count(singer_id) from singersgenres sg
left join genres g on g.genre_id = sg.genre_id
group by g.gengre_name;


--2.количество треков, вошедших в альбомы 2019-2020 годов;
select count(*) Количество from tracks s
left join albums a on s.album = a.album_id
where DATE_PART('year', a.album_year_of_issue::date) between 2019 and 2020;

--3.средняя продолжительность треков по каждому альбому;

select a.album_name , avg(s.track_duration) from tracks s
left join albums a on s.album = a.album_id
group by a.album_name;

--4.все исполнители, которые не выпустили альбомы в 2020 году;
select s.singer_name from albums albums a
where s.singer_name not in (select s.singer_name from albums a 
left join singersalbums sa on sa.album_id = a.album_id
left join singers s on s.singer_id = sa.singer_id 
);
where not DATE_PART('year', a.album_year_of_issue::date) = 2020
group by s.singer_name;

--5.названия сборников, в которых присутствует конкретный исполнитель (выберите сами);

select distinct collection_name from collections c
left join collectionstracks cs on cs.collection_id = c.collection_id 
left join tracks s on cs.track_id = s.track_id 
left join albums a on s.album = a.album_id 
left join singersalbums sa on a.album_id = sa.album_id 
left join singers s2 on s2.singer_id = sa.singer_id
where s2.singer_name like 'T-Pain';

-- 6. название альбомов, в которых присутствуют исполнители более 1 жанра;
select distinct (a.album_name) from albums a
join singersalbums ae on a.album_id=ae.album_id
join singers e on ae.singer_id=e.singer_id
join singersgenres ge on e.singer_id=ge.singer_id
join genres g on ge.genre_id=g.genre_id
group by a.album_name, e.singer_id
having count(ge.genre_id)>1



/*select sg.singer_id, count(sg.genre_id) from albums a 
left join singersalbums sa on a.album_id = sa.album_id 
left join singers s on s.singer_id = sa.singer_id
left join singersgenres sg on sg.singer_id = s.singer_id 
group by sg.singer_id;

select a.album_name  from albums a
left join singersalbums sa on sa.album_id = a.album_id 
left join singers s on s.singer_id = sa.singer_id 
left join singersgenres sg on sg.singer_id = s.singer_id 
left join genres g on g.genre_id = sg.genre_id 
group by a.album_name 
having count(distinct g.gengre_name) > 1;*/

--7. наименование треков, которые не входят в сборники;
select s.track_name, c.collection_id  from tracks s 
left join collectionstracks c on c.track_id = s.track_id 
where c.collection_id is null;

--8. исполнителя(-ей), написавшего самый короткий по продолжительности трек ;
-- select min(track_duration) from tracks s

select s2.singer_name from tracks s
left join albums a on s.album = a.album_id 
left join singersalbums sa on a.album_id = sa.album_id 
left join singers s2 on s2.singer_id = sa.singer_id
where s.track_duration = (select min(track_duration) from tracks s
);

--9. название альбомов, содержащих наименьшее количество треков.
select a.album_name, count(*) from albums a
left join tracks s on s.album = a.album_id 
group by a.album_name
having count(*) = 
				(select count(*) from albums a
				left join tracks s on s.album = a.album_id 
				group by a.album_name
				order by count(*) 
				limit 1);
