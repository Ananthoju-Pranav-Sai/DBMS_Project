------- view —---------
CREATE or REPLACE VIEW details as SELECT P.paper_id, title, abstract, v_name, year, STRING_AGG( A.first || ' ' || A.last,', ' order by A.first, A.last) author
FROM paper P INNER JOIN venue V ON P.paper_id=V.paper_id 
INNER JOIN written_by W ON P.paper_id=W.paper_id 
INNER JOIN author A ON W.auth_id=A.auth_id 
GROUP BY P.paper_id, title, abstract, v_name, year
ORDER BY paper_id;

------- view —---------
CREATE or REPLACE VIEW cites as SELECT W1.auth_id as X_id, W2.auth_id as Y_id, count(*)
FROM citations C INNER JOIN written_by W1 on C.paper_id_1 = W1.paper_id 
INNER JOIN written_by W2 ON W2.paper_id = C.citationspaper_id_2
GROUP BY W1.auth_id, W2.auth_id
HAVING W1.auth_id <> W2.auth_id;

--------------q1—--------------
select C.citationspaper_id_2 as paper_id, D.paper_id as citating_paper_id, D.title, D.abstract, D.abstract, D.v_name as venue, D.year, D.author from citations C inner join details D on paper_id_1=paper_id order by citationspaper_id_2;

--------------q2—--------------
select C.paper_id_1 as paper_id, D.paper_id as citated_paper_id, D.title, D.abstract, D.abstract, D.v_name as venue, D.year, D.author from citations C inner join details D on citationspaper_id_2=paper_id order by paper_id_1;

--------------q3—--------------
select lvl0.paper_id_1 Z, lvl1.citationspaper_id_2 X, title, abstract, v_name, year, author from (citations lvl0 inner join citations lvl1 on lvl0.citationspaper_id_2=lvl1.paper_id_1) inner join details on lvl1.citationspaper_id_2=paper_id order by X;

--------------q4—--------------
select * from details where paper_id in (select citationspaper_id_2 from citations group by citationspaper_id_2 order by count(*) desc limit 20);

--------------q5—--------------
select auth1.first as a1_first, auth1.last as a1_last, auth2.first as a2_first, auth2.last as a2_last from (
                 select auth1.auth_id id1, auth2.auth_id id2
                 from written_by auth1
                          inner join written_by auth2
                                     on auth1.paper_id = auth2.paper_id and auth1.auth_id <> auth2.auth_id
                 group by (id1, id2)
                 having count(*) > 1
)  co_auth inner join author auth1 on id1=auth1.auth_id inner join author auth2 on id2=auth2.auth_id;

--------------q6—--------------
SELECT T2.x_id, A1.first as x_first, A1.last as x_last, T2.y_id, A2.first as y_first, A2.last as y_last, T2.z_id, A3.first as z_first, A3.last as z_last, T2._count_
FROM
(SELECT x_id, y_id, z_id, sum(_count_) AS _count_ FROM
(SELECT C1.x_id as x_id ,
CASE WHEN (C2.x_id < C3.x_id)
THEN
C2.x_id
ELSE C3.x_id
END AS y_id ,
CASE WHEN (C2.x_id < C3.x_id)
THEN C3.x_id
ELSE C2.x_id
END AS z_id, LEAST(C1.count, C2.count, C3.count) AS _count_  FROM cites C1 INNER JOIN cites C2 ON C1.y_id = C2.x_id 
INNER JOIN cites C3 on C3.x_id = C2.y_id 
WHERE C3.y_id = C1.x_id and C1.x_id < C2.x_id and C1.x_id < C3.x_id
ORDER BY C1.x_id) T
GROUP BY x_id, y_id, z_id 
ORDER BY x_id) T2
INNER JOIN author A1 on A1.auth_id = x_id
INNER JOIN author A2 on A2.auth_id = y_id
INNER JOIN author A3 on A3.auth_id = z_id
WHERE A1.first is NOT NULL and A2.first is NOT NULL and A3.first is NOT NULL
ORDER BY T2.x_id, T2.y_id, T2.z_id;
