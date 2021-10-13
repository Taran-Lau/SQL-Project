Write up 2

Write up regarding SQL Chinook project
This will focus on the more questions section of the project
I will show results of scripts and then do some analysis on the results
===============================================================================
                              MORE QUESTIONS 1
===============================================================================
How frequent are bulk buys( > $10)?
    64 occurrences
    15.53% of purchases

How frequent are single song purchases ( < $1)?
    55 occurrences
    13.35% of purchases

How frequent are normal purchases(Between $1 and $10)?
    293 occurrences
    71.12% of purchases
    
===============================================================================
                              MORE QUESTIONS 2
===============================================================================
Revenue from bulk buys?
    $942.32
    40.47% of total revenue

Revenue from single purchases?
    $54.45
    2.24% of total revenue

Revenue from normal purchases?
    $1331.83
    57.19% of total revenue

===============================================================================
                              MORE QUESTIONS 3
===============================================================================
Print out tables for genre preferences of bulk, single and normal buys


|     Bulk Buys      |       |           |
|--------------------|-------|-----------|
| Genre              | Count | Frequency |
| Rock               | 318   | 0.3664    |
| Latin              | 149   | 0.1717    |
| Metal              | 75    | 0.0864    |
| Alternative & Punk | 66    | 0.076     |
| TV Shows           | 39    | 0.0449    |
| Jazz               | 36    | 0.0415    |
| Drama              | 25    | 0.0288    |
| Reggae             | 15    | 0.0173    |
| Soundtrack         | 13    | 0.015     |
| World              | 13    | 0.015     |
| R&B/Soul           | 13    | 0.015     |
| Alternative        | 13    | 0.015     |
| Heavy Metal        | 11    | 0.0127    |
| Classical          | 11    | 0.0127    |
| Blues              | 10    | 0.0115    |
| Pop                | 10    | 0.0115    |
| Easy Listening     | 10    | 0.0115    |
| Sci Fi & Fantasy   | 8     | 0.0092    |
| Hip Hop/Rap        | 7     | 0.0081    |
| Rock And Roll      | 6     | 0.0069    |
| Science Fiction    | 6     | 0.0069    |
| Electronica/Dance  | 6     | 0.0069    |
| Comedy             | 5     | 0.0058    |
| Bossa Nova         | 3     | 0.0035    |







|     Single Buy     |       |           |
|--------------------|-------|-----------|
| Name               | Count | Frequency |
| Rock               | 16    | 0.2909    |
| Latin              | 12    | 0.2182    |
| Metal              | 9     | 0.1636    |
| Alternative & Punk | 8     | 0.1455    |
| Jazz               | 3     | 0.0545    |
| R&B/Soul           | 2     | 0.0364    |
| Alternative        | 1     | 0.0182    |
| Blues              | 1     | 0.0182    |
| Bossa Nova         | 1     | 0.0182    |
| Classical          | 1     | 0.0182    |
| Hip Hop/Rap        | 1     | 0.0182    |








|    Normal Buys     |       |           |
|--------------------|-------|-----------|
| Genre              | Count | Frequency |
| Rock               | 501   | 0.3804    |
| Latin              | 225   | 0.1708    |
| Metal              | 180   | 0.1367    |
| Alternative & Punk | 170   | 0.1291    |
| Blues              | 50    | 0.038     |
| Jazz               | 41    | 0.0311    |
| Classical          | 29    | 0.022     |
| R&B/Soul           | 26    | 0.0197    |
| Pop                | 18    | 0.0137    |
| Reggae             | 15    | 0.0114    |
| Sci Fi & Fantasy   | 12    | 0.0091    |
| Bossa Nova         | 11    | 0.0084    |
| Hip Hop/Rap        | 9     | 0.0068    |
| TV Shows           | 8     | 0.0061    |
| Soundtrack         | 7     | 0.0053    |
| Electronica/Dance  | 6     | 0.0046    |
| Drama              | 4     | 0.003     |
| Comedy             | 4     | 0.003     |
| Heavy Metal        | 1     | 0.0008    |






===============================================================================
                              Analysis of MORE QUESTIONS 1-3
===============================================================================
Recall from Section 2 that the average a customer spends at the checkout is $5.45
Although bulk buys only represent 15% of purchases, they account for 40% of total revenue.
Although single purchases represent 13% of purchases, they only account for 2% of revenue.
Our biggest profit generators are the bulk buys, it might be possible to generate more profit if we were able to change the buying habits of customers to increase the number of bulk buys rather than single purchases.
Although it appears that the genre preferences between the three groups remains largely the same with Rock and Latin being the lion's share of buy count, perhaps if we could discern some differences if we used more advanced tools.
