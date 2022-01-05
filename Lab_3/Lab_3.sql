CREATE DATABASE IF NOT EXISTS Lab_3;
USE Lab_3;

CREATE TABLE challenge1 (
student_ID BIGINT,
score BIGINT
);

INSERT INTO challenge1 (student_ID, score) VALUES ('1', '91');
INSERT INTO challenge1 (student_ID, score) VALUES ('2', '72');
INSERT INTO challenge1 (student_ID, score) VALUES ('3', '98');
INSERT INTO challenge1 (student_ID, score) VALUES ('4', '62');
INSERT INTO challenge1 (student_ID, score) VALUES ('5', '62');
INSERT INTO challenge1 (student_ID, score) VALUES ('6', '95');
INSERT INTO challenge1 (student_ID, score) VALUES ('7', '83');
INSERT INTO challenge1 (student_ID, score) VALUES ('8', '86');
INSERT INTO challenge1 (student_ID, score) VALUES ('9', '56');
INSERT INTO challenge1 (student_ID, score) VALUES ('10', '97');
INSERT INTO challenge1 (student_ID, score) VALUES ('11', '58');
INSERT INTO challenge1 (student_ID, score) VALUES ('12', '71');
INSERT INTO challenge1 (student_ID, score) VALUES ('13', '87');
INSERT INTO challenge1 (student_ID, score) VALUES ('14', '83');
INSERT INTO challenge1 (student_ID, score) VALUES ('15', '98');

SELECT avg(score) FROM challenge1;
SELECT sum(score) FROM challenge1;
SELECT score, count(*) orderCount FROM challenge1 GROUP BY score;
SELECT STD(score) FROM challenge1;
SELECT  VARIANCE(score) FROM challenge1;
SELECT  MIN(score) FROM challenge1;
SELECT  MAX(score) FROM challenge1;
