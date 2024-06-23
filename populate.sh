#!/bin/bash

# Database connection details
DB_NAME="myDB"
DB_USER="postgres"
DB_HOST="localhost"

# URLs of the CSV files
DIM_DATE_URL="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0260EN-SkillsNetwork/labs/Final%20Assignment/DimDate.csv"
DIM_TRUCK_URL="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0260EN-SkillsNetwork/labs/Final%20Assignment/DimTruck.csv"
DIM_STATION_URL="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0260EN-SkillsNetwork/labs/Final%20Assignment/DimStation.csv"
FACT_TRIPS_URL="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0260EN-SkillsNetwork/labs/Final%20Assignment/FactTrips.csv"

# Download CSV files
echo "Downloading CSV files..."
wget -O DimDate.csv $DIM_DATE_URL
wget -O DimTruck.csv $DIM_TRUCK_URL
wget -O DimStation.csv $DIM_STATION_URL
wget -O FactTrips.csv $FACT_TRIPS_URL

# Create the database
echo "Creating the database..."
psql -U "$DB_USER" -h "$DB_HOST" -c "CREATE DATABASE \"$DB_NAME\";"

# Connect to PostgreSQL and create tables
echo "Creating tables in the database..."
psql -d "$DB_NAME" --username="$DB_USER" --host="$DB_HOST" -c "
CREATE TABLE IF NOT EXISTS \"DimDate\" (
    \"dateid\" SERIAL PRIMARY KEY,
    \"date\" DATE NOT NULL,
    \"Year\" INTEGER NOT NULL,
    \"Quarter\" INTEGER NOT NULL,
    \"QuarterName\" VARCHAR(20) NOT NULL,
    \"Month\" INTEGER NOT NULL,
    \"Monthname\" VARCHAR(20) NOT NULL,
    \"Day\" INTEGER NOT NULL,
    \"Weekday\" INTEGER NOT NULL,
    \"WeekdayName\" VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS \"DimTruck\" (
    \"truckid\" SERIAL PRIMARY KEY,
    \"trucktype\" VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS \"DimStation\" (
    \"stationid\" SERIAL PRIMARY KEY,
    \"city\" VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS \"FactTrips\" (
    \"tripid\" SERIAL PRIMARY KEY,
    \"dateid\" INTEGER NOT NULL,
    \"truckid\" INTEGER NOT NULL,
    \"stationid\" INTEGER NOT NULL,
    \"Wastecollected\" DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (\"dateid\") REFERENCES \"DimDate\" (\"dateid\"),
    FOREIGN KEY (\"truckid\") REFERENCES \"DimTruck\" (\"truckid\"),
    FOREIGN KEY (\"stationid\") REFERENCES \"DimStation\" (\"stationid\")
);
"

# Load data into tables
echo "Loading data into tables..."
psql -d "$DB_NAME" --username="$DB_USER" --host="$DB_HOST" -c "\COPY \"DimDate\" (\"dateid\",\"date\",\"Year\",\"Quarter\",\"QuarterName\",\"Month\",\"Monthname\",\"Day\",\"Weekday\",\"WeekdayName\") FROM 'DimDate.csv' DELIMITER ',' CSV HEADER;"
psql -d "$DB_NAME" --username="$DB_USER" --host="$DB_HOST" -c "\COPY \"DimTruck\" (\"truckid\",\"trucktype\") FROM 'DimTruck.csv' DELIMITER ',' CSV HEADER;"
psql -d "$DB_NAME" --username="$DB_USER" --host="$DB_HOST" -c "\COPY \"DimStation\" (\"stationid\",\"city\") FROM 'DimStation.csv' DELIMITER ',' CSV HEADER;"
psql -d "$DB_NAME" --username="$DB_USER" --host="$DB_HOST" -c "\COPY \"FactTrips\" (\"tripid\",\"dateid\",\"truckid\",\"stationid\",\"Wastecollected\") FROM 'FactTrips.csv' DELIMITER ',' CSV HEADER;"

# Verify data
echo "Verifying data in the tables..."
psql -d "$DB_NAME" --username="$DB_USER" --host="$DB_HOST" -c "SELECT * FROM \"DimDate\" LIMIT 5;"
psql -d "$DB_NAME" --username="$DB_USER" --host="$DB_HOST" -c "SELECT * FROM \"DimTruck\" LIMIT 5;"
psql -d "$DB_NAME" --username="$DB_USER" --host="$DB_HOST" -c "SELECT * FROM \"DimStation\" LIMIT 5;"
psql -d "$DB_NAME" --username="$DB_USER" --host="$DB_HOST" -c "SELECT * FROM \"FactTrips\" LIMIT 5;"

echo "Script completed successfully."
