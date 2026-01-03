/*
P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

* * * * * 
* * * * 
* * * 
* * 
*
Write a query to print the pattern P(20).
*/

/*
1. How to Think Like an Analyst
When an analyst sees a pattern like this, they don't just see stars; they see variables and loops. 

Here is the mental framework:
- Identify the Variables:
+ What is changing? The number of stars per row.
+ What is the range? It starts at 20 and ends at 1.

- Define the Relationship:This is a linear decrement. For every new row (n), the count of stars is CurrentRow - 1$.

- Determine the Output Format: 
+ The stars are separated by spaces.
+ Each set of stars must be on a new line.

- Evaluate Tool Constraints:
Standard SQL is designed for data retrieval, not "drawing.
"Since MySQL doesn't have a simple FOR loop in a basic SELECT statement, an analyst looks for Recursive Common Table Expressions (CTEs) or Information Schema tricks to generate a sequence of numbers.

*/

-- SOLUTION: Using the Recursive CTE
WITH RECURSIVE CTE_Sequence AS
(
    -- Anchor Query
    SELECT 
    20 AS n
    
    -- Substract 1 until we get 1
    UNION ALL
    
    SELECT 
    n - 1
    FROM CTE_Sequence
    WHERE n > 1
)
-- Main Query
SELECT 
    REPEAT("* ", n)
FROM CTE_Sequence
;