SELECT
    "stationid",
    dt."trucktype",
    SUM(ft."Wastecollected") AS total_waste_collected
FROM
    "FactTrips" ft
LEFT JOIN
    "DimTruck" dt ON ft."truckid" = dt."truckid"
GROUP BY
    GROUPING SETS (
        ("stationid"),
        (dt."trucktype"),
        ("stationid", dt."trucktype")
    );

SELECT
    dd."Year",
    ds."city",
    ft."stationid",
    SUM(ft."Wastecollected") AS total_waste_collected
FROM
    "FactTrips" ft
LEFT JOIN
    "DimDate" dd ON ft."dateid" = dd."dateid"
LEFT JOIN
    "DimStation" ds ON ft."stationid" = ds."stationid"
GROUP BY
    ROLLUP (dd."Year", ds."city", ft."stationid");


SELECT
    dd."Year",
    ds."city",
    ft."stationid",
    AVG(ft."Wastecollected") AS avg_waste_collected
FROM
    "FactTrips" ft
LEFT JOIN
    "DimDate" dd ON ft."dateid" = dd."dateid"
LEFT JOIN
    "DimStation" ds ON ft."stationid" = ds."stationid"
GROUP BY
    CUBE (dd."Year", ds."city", ft."stationid");


CREATE MATERIALIZED VIEW max_waste_stats AS
SELECT
    ds."city",
    ft."stationid",
    dt."trucktype",
    MAX(ft."Wastecollected") AS max_waste_collected
FROM
    "FactTrips" ft
LEFT JOIN
    "DimStation" ds ON ft."stationid" = ds."stationid"
LEFT JOIN
    "DimTruck" dt ON ft."truckid" = dt."truckid"
GROUP BY
    ds."city", ft."stationid", dt."trucktype";
