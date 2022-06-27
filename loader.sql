COPY paper (paper_id, title, abstract, year)
FROM '/home/pranav/SEM_IV/DBMS-II/hw2/group7_assign2/paper.csv'
DELIMITER E'\u0007'
CSV HEADER encoding 'UTF8';

COPY author (auth_id, first, last)
FROM '/home/pranav/SEM_IV/DBMS-II/hw2/group7_assign2/author.csv'
DELIMITER E'\u0007'
CSV HEADER encoding 'UTF8';

COPY citations (paper_id_1, citationspaper_id_2)
FROM '/home/pranav/SEM_IV/DBMS-II/hw2/group7_assign2/citations.csv'
DELIMITER E'\u0007'
CSV HEADER encoding 'UTF8';

COPY venue (v_name, paper_id)
FROM '/home/pranav/SEM_IV/DBMS-II/hw2/group7_assign2/venue.csv'
DELIMITER E'\u0007'
CSV HEADER encoding 'UTF8';

COPY written_by (auth_id, paper_id, rank)
FROM '/home/pranav/SEM_IV/DBMS-II/hw2/group7_assign2/written_by.csv'
DELIMITER E'\u0007'
CSV HEADER encoding 'UTF8';
