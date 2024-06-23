CREATE DATABASE edw;
\c edw


-- Dimension Tables

CREATE TABLE my_dim_date (
    date_id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    day INTEGER NOT NULL,
    weekday INTEGER NOT NULL,
    weekday_name VARCHAR(20) NOT NULL
);

CREATE TABLE my_dim_waste (
    waste_id SERIAL PRIMARY KEY,
    waste_type VARCHAR(50) NOT NULL
);

CREATE TABLE my_dim_zone (
    zone_id SERIAL PRIMARY KEY,
    zone VARCHAR(50) NOT NULL
);

CREATE TABLE my_dim_city (
    city_id SERIAL PRIMARY KEY,
    city VARCHAR(50) NOT NULL
);

-- Fact Tables

CREATE TABLE my_fact_trips (
    trip_id SERIAL PRIMARY KEY,
    date_id INTEGER NOT NULL,
    waste_id INTEGER NOT NULL,
    zone_id INTEGER NOT NULL,
    city_id INTEGER NOT NULL,
    waste_collected_tons DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (date_id) REFERENCES my_dim_date (date_id),
    FOREIGN KEY (waste_id) REFERENCES my_dim_waste (waste_id),
    FOREIGN KEY (zone_id) REFERENCES my_dim_zone (zone_id),
    FOREIGN KEY (city_id) REFERENCES my_dim_city (city_id)
);
