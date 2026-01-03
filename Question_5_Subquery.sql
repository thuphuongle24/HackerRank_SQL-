/*
Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. Exclude the contest from the result if all four sums are 0.

Note: A specific contest can be used to screen candidates at more than one college, but each college only holds 1 screening contest.

Print:
contest_id
hacker_id
name
sum (total_submissions)
total_accepted_submissions
total_views
total_unique_views

Tables:
The following tables hold interview data:

1. Contests: The contest_id is the id of the contest, hacker_id is the id of the hacker who created the contest, and name is the name of the hacker.

2. Colleges: The college_id is the id of the college, and contest_id is the id of the contest that Samantha used to screen the candidates.

3. Challenges: The challenge_id is the id of the challenge that belongs to one of the contests whose contest_id Samantha forgot, and college_id is the id of the college where the challenge was given to candidates.

4. View_Stats: The challenge_id is the id of the challenge, total_views is the number of times the challenge was viewed by candidates, and total_unique_views is the number of times the challenge was viewed by unique candidates.

5. Submission_Stats: The challenge_id is the id of the challenge, total_submissions is the number of submissions for the challenge, and total_accepted_submission is the number of submissions that achieved full scores.

*/


-- OPTION 1: Use CTE

-- STEP 1:  Aggregate the Stats Tables
WITH Aggregated_Submissions AS (
    SELECT 
        challenge_id,
        SUM(total_submissions) AS TotalSubmissions,
        SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM Submission_Stats
    GROUP BY challenge_id
)
, Aggregated_Views AS (
    SELECT 
        challenge_id,
        SUM(total_views) AS TotalViews,
        SUM(total_unique_views) AS TotalUniqueViews
    FROM View_Stats
    GROUP BY challenge_id   
)

-- Main Query
-- STEP 2: Create the Base Table (The "Backbone")
SELECT 
    ct.contest_id, 
    ct.hacker_id, 
    ct.name,
    sub.TotalSubmissions,
    sub.total_accepted_submissions,
    view.TotalViews,
    view.TotalUniqueViews
FROM Contests ct
JOIN Colleges cg 
    ON ct.contest_id = cg.contest_id
JOIN Challenges ch 
    ON cg.college_id = ch.college_id

-- STEP 3: Left Join the Aggregated Stats
LEFT JOIN Aggregated_Submissions sub 
    ON ch.challenge_id = sub.challenge_id
LEFT JOIN Aggregated_Views view 
    ON ch.challenge_id = view.challenge_id

-- STEP 4: Final Aggregation and Filtering
GROUP BY ct.contest_id, ct.hacker_id, ct.name
HAVING (SUM(sub.sum_ts) + SUM(sub.sum_tas) + SUM(view.sum_tv) + SUM(view.sum_tuv)) > 0
ORDER BY ct.contest_id;

-- OPTION 2: Use sub-query
SELECT 
    ct.contest_id,
    ct.hacker_id,
    ct.name,
    SUM(COALESCE(ss.total_submissions, 0)) AS total_submissions,
    SUM(COALESCE(ss.total_accepted_submissions, 0)) AS total_accepted_submissions,
    SUM(COALESCE(vs.total_views, 0)) AS total_views,
    SUM(COALESCE(vs.total_unique_views, 0)) AS total_unique_views
FROM Contests ct
JOIN Colleges cg 
    ON ct.contest_id = cg.contest_id
JOIN Challenges ch 
    ON cg.college_id = ch.college_id

-- STEP 1: Join the submissions stats subquery
LEFT JOIN
(
    SELECT 
        challenge_id,
        SUM(total_submissions) AS total_submissions,
        SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM Submission_Stats
    GROUP BY challenge_id 
) AS ss 
    ON ch.challenge_id = ss.challenge_id

-- STEP 2: Join the stat_views subquery
LEFT JOIN
(
   SELECT 
        challenge_id,
        SUM(total_views) AS total_views,
        SUM(total_unique_views) AS total_unique_views
    FROM View_Stats
    GROUP BY challenge_id 
) AS vs
    ON ch.challenge_id = vs.challenge_id

-- STEP 3: Adding the conditions
GROUP BY ct.contest_id, ct.hacker_id, ct.name
HAVING 
       SUM(COALESCE(ss.total_submissions, 0)) > 0
    OR SUM(COALESCE(ss.total_accepted_submissions, 0)) > 0
    OR SUM(COALESCE(vs.total_views, 0)) > 0
    OR SUM(COALESCE(vs.total_unique_views, 0)) > 0
ORDER BY ct.contest_id;

;

-- OPTION 2: Use sub-query
SELECT 
    ct.contest_id,
    ct.hacker_id,
    ct.name,
    SUM(COALESCE(ss.total_submissions, 0)) AS total_submissions,
    SUM(COALESCE(ss.total_accepted_submissions, 0)) AS total_accepted_submissions,
    SUM(COALESCE(vs.total_views, 0)) AS total_views,
    SUM(COALESCE(vs.total_unique_views, 0)) AS total_unique_views
FROM Contests ct
JOIN Colleges cg 
    ON ct.contest_id = cg.contest_id
JOIN Challenges ch 
    ON cg.college_id = ch.college_id

-- STEP 1: Join the submissions stats subquery
LEFT JOIN
(
    SELECT 
        challenge_id,
        SUM(total_submissions) AS total_submissions,
        SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM Submission_Stats
    GROUP BY challenge_id 
) AS ss 
    ON ch.challenge_id = ss.challenge_id

-- STEP 2: Join the stat_views subquery
LEFT JOIN
(
   SELECT 
        challenge_id,
        SUM(total_views) AS total_views,
        SUM(total_unique_views) AS total_unique_views
    FROM View_Stats
    GROUP BY challenge_id 
) AS vs
    ON ch.challenge_id = vs.challenge_id

-- STEP 3: Adding the conditions
GROUP BY ct.contest_id, ct.hacker_id, ct.name
HAVING 
       SUM(COALESCE(ss.total_submissions, 0)) > 0
    OR SUM(COALESCE(ss.total_accepted_submissions, 0)) > 0
    OR SUM(COALESCE(vs.total_views, 0)) > 0
    OR SUM(COALESCE(vs.total_unique_views, 0)) > 0
ORDER BY ct.contest_id;

;


















