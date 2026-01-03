/*

Write a query to print all prime numbers less than or equal to . Print your result on a single line, and use the ampersand (&) character as your separator (instead of a space).

For example, the output for all prime numbers  would be:

2&3&5&7
*/

WITH RECURSIVE CTE_Prime_Sequence AS
(
    -- Anchor Query: 2 is the first prime number
    SELECT 2 AS n   
    
    UNION ALL 
    
    -- Adding 1 till we get 1000
    SELECT n + 1
    FROM CTE_Prime_Sequence
    WHERE n < 1000
)

-- Main Query
SELECT
    -- Group concat all the prime numbers, separated by &
    GROUP_CONCAT(n SEPARATOR '&')

FROM CTE_Prime_Sequence c1

WHERE NOT EXISTS 
    (
        -- We check if any OTHER number (c2.n) divides our current number (c1.n)
        SELECT 1 
        FROM CTE_Prime_Sequence c2
        WHERE c2.n < c1.n           -- m has to be smaller than n
          AND c1.n % c2.n = 0       -- check for perfect divisibility
    )
    
;