# Note to self

Let P_sd be the set of shortest paths between two given countries s and d. So, for each p element P, p_1 = s and p_n = d, where n = length(p).

Each country is element of a route zero or one times.
The function 'sorted' sorts the countries in a route (say on index).

Two routes (p, q element P) are equivalent iff sorted(p) == sorted(q). In which case we should count (the countries in) routes p and q only once.
