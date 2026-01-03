/* 
Julia conducted a 15-day SQL contest from March 1, 2016 to March 15, 2016.
For each contest day, we want:
- total number of unique hackers who submitted every day since March 1
- hacker_id + name of hacker with maximum submissions that day
(If tie, choose lowest hacker_id)
*/

-- OPTION 1: USING CTE
-- STEP 1: Count submissions per hacker per day
WITH daily_submissions AS (
    SELECT
        submission_date,
        hacker_id,
        COUNT(*) AS submissions_count
    FROM Submissions
    GROUP BY submission_date, hacker_id
),

-- STEP 2A: Compute cumulative submission info per hacker
hacker_day_stats AS (
    SELECT
        submission_date,
        hacker_id,
        -- cumulative number of distinct days submitted
        COUNT(DISTINCT submission_date) OVER (
            PARTITION BY hacker_id
            ORDER BY submission_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS day_submitted,
        -- which day of the contest it is
        DATEDIFF(day, '2016-03-01', submission_date) + 1 AS contest_day
    FROM Submissions
),

-- STEP 2B: Keep only hackers who submitted every day so far
consistent_hackers AS (
    SELECT
        submission_date,
        COUNT(DISTINCT hacker_id) AS unique_hacker
    FROM hacker_day_stats
    WHERE day_submitted = contest_day
    GROUP BY submission_date
),

-- STEP 3: Find hacker with max submissions per day (tie: lowest hacker_id)
top_hacker_per_day AS (
    SELECT
        submission_date,
        hacker_id,
        ROW_NUMBER() OVER (
            PARTITION BY submission_date
            ORDER BY submissions_count DESC, hacker_id ASC
        ) AS hacker_rank
    FROM daily_submissions
)

-- STEP 4: Final result
SELECT
    c.submission_date,
    c.unique_hacker,
    t.hacker_id,
    h.name
FROM consistent_hackers c
JOIN top_hacker_per_day t
    ON c.submission_date = t.submission_date
    AND t.hacker_rank = 1
JOIN Hackers h
    ON h.hacker_id = t.hacker_id
ORDER BY c.submission_date;


-- OPTION 2: USE Sub-query
SELECT
  t1.submission_date,
  t1.c,
  t2.hacker_id,
  t2.name
FROM
  (
    SELECT DISTINCT
      submission_date,
      COUNT(*) as c
    FROM
      (
        SELECT DISTINCT
        submission_date,
        hacker_id,
        (
          SELECT COUNT(DISTINCT s2.submission_date)
          FROM submissions s2
          WHERE s2.hacker_id = s1.hacker_id
            AND s2.submission_date <= s1.submission_date
        ) AS n
        FROM submissions s1
        HAVING DAY(submission_date) = n
      ) AS t
    group by submission_date
  ) t1
JOIN
  (
    SELECT
      s.submission_date,
      s.hacker_id,
      h.name
    FROM
      (
        SELECT DISTINCT
          submission_date,
          (
            SELECT
              hacker_id
              -- count(*) as c
            FROM
              submissions s2
            WHERE
              s2.submission_date = s1.submission_date
            GROUP BY
              hacker_id
            ORDER BY
              COUNT(*) DESC,
              hacker_id
            LIMIT 1
          ) AS hacker_id
        FROM
          submissions s1
      ) s
    JOIN
      hackers h
    ON
      s.hacker_id = h.hacker_id
    ORDER BY
      s.submission_date
  ) t2
ON
  t1.submission_date = t2.submission_date
ORDER BY
  t1.submission_date;