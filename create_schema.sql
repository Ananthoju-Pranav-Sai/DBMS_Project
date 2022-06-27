CREATE TABLE paper
(
  title VARCHAR(1200) NOT NULL,
  abstract VARCHAR(50000),
  paper_id INT NOT NULL,
  year INT NOT NULL,
  PRIMARY KEY (paper_id)
);

CREATE TABLE author
(
  first VARCHAR(500),
  last VARCHAR(500),
  auth_id INT NOT NULL,
  PRIMARY KEY (auth_id)
);

CREATE TABLE venue
(
  v_name VARCHAR(500),
  paper_id INT NOT NULL,
  FOREIGN KEY (paper_id) REFERENCES paper(paper_id)
);

CREATE TABLE written_by
(
  rank INT NOT NULL,
  auth_id INT NOT NULL,
  paper_id INT NOT NULL,
  PRIMARY KEY (auth_id, paper_id),
  FOREIGN KEY (auth_id) REFERENCES author(auth_id),
  FOREIGN KEY (paper_id) REFERENCES paper(paper_id)
);

CREATE TABLE citations
(
  paper_id_1 INT NOT NULL,
  citationspaper_id_2 INT NOT NULL,
  PRIMARY KEY (paper_id_1, citationspaper_id_2),
  FOREIGN KEY (paper_id_1) REFERENCES paper(paper_id),
  FOREIGN KEY (citationspaper_id_2) REFERENCES paper(paper_id),
  CHECK(paper_id_1 <> citationspaper_id_2) 
);

