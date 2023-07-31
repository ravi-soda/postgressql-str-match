select count(id), "lastName" , "firstName"  from hackathon_auto_screen_borrower.public.suspended_users su;

/* enable fuzzystrmatch */
create extension fuzzystrmatch;

CREATE INDEX lastname_soundex ON hackathon_auto_screen_borrower.public.suspended_users (soundex(suspended_users."lastName" ));

/* do a levenshtein metch on the indexed column */
WITH q AS (
  SELECT 'si' AS qfn, 'Timlee' AS qln
)
SELECT
  levenshtein(lower(concat(suspended_users."lastName" ,suspended_users."firstName")),lower(concat(qln, qfn))) AS leven,
  hackathon_auto_screen_borrower.public.suspended_users.*
FROM hackathon_auto_screen_borrower.public.suspended_users, q
WHERE soundex(suspended_users."lastName") = soundex(qln)
AND levenshtein(lower(concat(suspended_users."lastName",suspended_users."firstName")),lower(concat(qln, qfn))) < 100


WITH q AS (
  SELECT 'Jon' AS qfn, 'Jam' AS qln
)
SELECT
  levenshtein(lower(suspended_users."lastName"),lower(qln)) AS leven,
  hackathon_auto_screen_borrower.public.suspended_users.*
FROM hackathon_auto_screen_borrower.public.suspended_users, q
WHERE soundex(suspended_users."lastName") = soundex(qln)
AND levenshtein(lower(suspended_users."lastName"),lower(qln)) < 5

/* fuzzy str match */
select * from hackathon_auto_screen_borrower.public.suspended_users SU 
where 
	SU."source" = 'GSA' and 
	SOUNDEX(concat(su."firstName", su."lastName")) = SOUNDEX('Si Tomlee')
	
CREATE EXTENSION pg_trgm;
	
/* METHAPHORE */
SELECT
	*
FROM hackathon_auto_screen_borrower.public.suspended_users SU
WHERE SU."source" = 'GSA'
ORDER BY SIMILARITY(
	METAPHONE(concat(su."firstName", su."lastName"),10),
    METAPHONE('Si Tomlee',10)
    ) DESC
LIMIT 5;
