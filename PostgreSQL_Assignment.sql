-- Active: 1748654107880@@127.0.0.1@5432@conservation_db
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(255) NOT NULL,
    scientific_name VARCHAR(255),
    discovery_date DATE,
    conservation_status VARCHAR(15)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers (ranger_id),
    species_id INTEGER REFERENCES species (species_id),
    sighting_time TIMESTAMP without time zone,
    location VARCHAR(255),
    notes VARCHAR(255)
);

INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        null
    );

SELECT * FROM rangers;

SELECT * FROM species;

SELECT * FROM sightings;

--Problem 1
--Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

--Problem 2
--Count unique species ever sighted.

SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

--Problem 3
--Find all sightings where the location includes "Pass".

SELECT * FROM sightings
WHERE location LIKE '%Pass%';

--Problem 4
--List each ranger's name and their total number of sightings.

SELECT name,COUNT(s.ranger_id) AS total_sightings 
FROM rangers AS r
JOIN sightings AS s USING (ranger_id)
GROUP BY name;

--Problem 5
--List species that have never been sighted.

SELECT common_name FROM species
WHERE species_id NOT IN (
    SELECT DISTINCT species_id FROM sightings
);

--Problem 6
-- Show the most recent 2 sightings.

SELECT common_name, sighting_time, name
FROM sightings
JOIN species USING(species_id)
JOIN rangers USING(ranger_id)
ORDER BY sighting_time DESC
LIMIT 2;

SELECT common_name, sighting_time, name
FROM sightings s, species sp,rangers r
WHERE s.species_id = sp.species_id
AND s.ranger_id = r.ranger_id
ORDER BY sighting_time DESC
LIMIT 2;

--Problem 7
--Update all species discovered before year 1800 to have status 'Historic'.

UPDATE species
SET conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;

--Problem 8
--Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

SELECT sighting_id, sighting_time, 
CASE 
    WHEN EXTRACT(HOUR from sighting_time) BETWEEN 5 AND 12 THEN 'Morning'
    WHEN EXTRACT(HOUR from sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN EXTRACT(HOUR from sighting_time) BETWEEN 17 AND 19 THEN 'Evening'
    ELSE 'Night'
    END AS time_of_day
FROM sightings;

--Problem 9
--Delete rangers who have never sighted any species

DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);

