# Dimension Tables

## my_dim_date

* date_id (primary_key)
* year
* month
* month_name
* day
* weekday
* weekday_name

## my_dim_waste

* waste_id (primary_key)
* waste_type


## my_dim_zone

* zone_id (primary_key)
* zone

## my_dim_city

* city_id (primary_key)
* city

# Fact Tables

## my_fact_trips

* trip_id (primary_key)
* date_id
* waste_id
* zone_id
* city_id
* waste_collected_tons
