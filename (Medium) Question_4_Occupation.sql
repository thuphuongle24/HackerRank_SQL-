/*
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. 

The output should consist of four columns (Doctor, Professor, Singer, and Actor) in that specific order, with their respective names listed alphabetically under each column.

Note: Print NULL when there are no more names corresponding to an occupation.

*/

-- STEP 1: Rank all the Occupation
WITH Ranked AS
(
    SELECT
        Name,
        Occupation,
        ROW_NUMBER() OVER(PARTITION BY Occupation ORDER BY Name) AS row_num
    FROM OCCUPATIONS
)

-- STEP 2: Use MAX to get the name of each fill in the table
SELECT 
    MAX(CASE WHEN Occupation = "Doctor" THEN Name END) AS Doctor_list,
    MAX(CASE WHEN Occupation = "Professor" THEN Name END) AS Professor_list,
    MAX(CASE WHEN Occupation = "Singer" THEN Name END) AS Singer_list,
    MAX(CASE WHEN Occupation = "Actor" THEN Name END) AS Actor_list
FROM Ranked
GROUP BY row_num
ORDER BY row_num ASC
;
    
    
    
    
    
    
    
    
    