# Lua MST
This module provides a way of calculating the `Minimal Spanning Tree` within Lua. It currently supports `Kruskal's algorithm` but support for others can also be added.

This is mainly designed within Roblox but can be adapted within other "Lua versions"

## CalculateScores
You saw this function and it referenced this. You may be wondering why I looped the way I did. Look at the table below
```
                1 1
1 2 
1 3 
1 4 
1 5 

        2 1 
                2 2
2 3 
2 4 
2 5 

        3 1 
        3 2 
                3 3
3 4 
3 5 

        4 1 
        4 2 
        4 3 
                4 4
4 5 

        5 1 
        5 2 
        5 3 
        5 4 
                5 5
```

The first column are all of the unique possible combinations.
The second column are the duplicate combinations that collide with the first column.
The last column are all of the nodes with themselves, we don't want these - useless.

You can see a pattern where the first column gradually decreases by 1 each time. By following this pattern, we can optimise the function.
Additionally, nothing happens within the 5th so we can simply ignore that.