/*
N: node 
P: Parent of N
=> N is the child, and P is the parent.

1. If the node has no parents (P IS NULL) --> root
--> Root: The Starting Point
Logic: A Root node is the only node in the tree that has no parent.

2. If the node Node is not a parent of anyone --> Leaf 
--> Leaf: The End Points
--> Logic: A Leaf node is a node that is not a parent to anyone else.

3. If the node has both parents and children --> Inner
--> Inner: The Middle Men

*/

SELECT 
    N,
    CASE
        WHEN P IS NULL THEN "Root"
        WHEN N NOT IN (SELECT P FROM BST WHERE P IS NOT NULL) THEN "Leaf"
        ELSE "Inner"
    END AS Category
FROM BST
ORDER BY N
;
