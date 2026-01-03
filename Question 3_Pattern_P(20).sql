/*
P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

* 
* * 
* * * 
* * * * 
* * * * *
Write a query to print the pattern P(20).
*/

WITH RECURSIVE CTE_Sequence AS
(
    -- Anchor Query
    SELECT
    1 AS n
    
    -- Loop: Add 1 in every line till we get 20
    UNION ALL
    SELECT 
    n + 1 
    FROM CTE_Sequence
    WHERE n < 20
)

-- Main Query
SELECT 
    REPEAT("* ", n)
FROM CTE_Sequence
;