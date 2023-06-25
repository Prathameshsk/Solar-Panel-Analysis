-- Create a database
CREATE DATABASE solar_analysis;

-- Switch to the newly created database
USE solar_analysis;

-- Create DustDeposition table
CREATE TABLE DustDeposition (
  id INT PRIMARY KEY,
  date DATE,
  time TIME,
  dust_amount DECIMAL(10, 2),
  CONSTRAINT ck_dust_amount CHECK (dust_amount >= 0)
);

-- Create SolarPanelData table
CREATE TABLE SolarPanelData (
  id INT PRIMARY KEY,
  date DATE,
  time TIME,
  solar_rays DECIMAL(10, 2),
  CONSTRAINT ck_solar_rays CHECK (solar_rays >= 0)
);

-- Create OutputPower table
CREATE TABLE OutputPower (
  id INT PRIMARY KEY,
  date DATE,
  time TIME,
  power DECIMAL(10, 2),
  CONSTRAINT ck_power CHECK (power >= 0)
);

-- Insert sample data into DustDeposition table
INSERT INTO DustDeposition (id, date, time, dust_amount)
VALUES
  (1, '2023-06-12', '09:00:00', 0.05),
  (2, '2023-06-12', '10:00:00', 0.08),
  (3, '2023-06-12', '11:00:00', 0.07),
  (4, '2023-06-12', '12:00:00', 0.09),
  (5, '2023-06-12', '13:00:00', 0.06),
  (6, '2023-06-12', '14:00:00', 0.04),
  (7, '2023-06-12', '15:00:00', 0.03),
  (8, '2023-06-12', '16:00:00', 0.05),
  (9, '2023-06-12', '17:00:00', 0.07),
  (10, '2023-06-12', '18:00:00', 0.08);

-- Insert sample data into SolarPanelData table
INSERT INTO SolarPanelData (id, date, time, solar_rays)
VALUES
  (1, '2023-06-12', '09:00:00', 150),
  (2, '2023-06-12', '10:00:00', 200),
  (3, '2023-06-12', '11:00:00', 180),
  (4, '2023-06-12', '12:00:00', 190),
  (5, '2023-06-12', '13:00:00', 220),
  (6, '2023-06-12', '14:00:00', 250),
  (7, '2023-06-12', '15:00:00', 230),
  (8, '2023-06-12', '16:00:00', 210),
  (9, '2023-06-12', '17:00:00', 190),
  (10, '2023-06-12', '18:00:00', 170);

-- Insert sample data into OutputPower table
INSERT INTO OutputPower (id, date, time, power)
VALUES
  (1, '2023-06-12', '09:00:00', 120),
  (2, '2023-06-12', '10:00:00', 180),
  (3, '2023-06-12', '11:00:00', 160),
  (4, '2023-06-12', '12:00:00', 170),
  (5, '2023-06-12', '13:00:00', 200),
  (6, '2023-06-12', '14:00:00', 230),
  (7, '2023-06-12', '15:00:00', 210),
  (8, '2023-06-12', '16:00:00', 190),
  (9, '2023-06-12', '17:00:00', 170),
  (10, '2023-06-12', '18:00:00', 150);

-- Query 1: Get the average dust deposition, solar rays, and output power for each hour of the day
SELECT
  HOUR(time) AS hour,
  AVG(dust_amount) AS avg_dust_deposition,
  AVG(solar_rays) AS avg_solar_rays,
  AVG(power) AS avg_output_power
FROM
  DustDeposition
JOIN
  SolarPanelData ON DustDeposition.date = SolarPanelData.date
  AND DustDeposition.time = SolarPanelData.time
JOIN
  OutputPower ON DustDeposition.date = OutputPower.date
  AND DustDeposition.time = OutputPower.time
GROUP BY
  HOUR(time)
ORDER BY
  HOUR(time);

-- Query 2: Get the total dust deposition, solar rays, and output power for each day
SELECT
  date,
  SUM(dust_amount) AS total_dust_deposition,
  SUM(solar_rays) AS total_solar_rays,
  SUM(power) AS total_output_power
FROM
  DustDeposition
JOIN
  SolarPanelData ON DustDeposition.date = SolarPanelData.date
  AND DustDeposition.time = SolarPanelData.time
JOIN
  OutputPower ON DustDeposition.date = OutputPower.date
  AND DustDeposition.time = OutputPower.time
GROUP BY
  date;

-- Query 3: Find the time when the maximum amount of dust was deposited
SELECT
  DustDeposition.date,
  DustDeposition.time,
  dust_amount
FROM
  DustDeposition
WHERE
  dust_amount = (
    SELECT
      MAX(dust_amount)
    FROM
      DustDeposition
  );

-- Query 4: Calculate the average dust sensor value, solar panel voltage, and output power
SELECT
  AVG(dust_amount) AS avg_dust_sensor_value,
  AVG(solar_rays) AS avg_solar_panel_voltage,
  AVG(power) AS avg_output_power
FROM
  DustDeposition
JOIN
  SolarPanelData ON DustDeposition.date = SolarPanelData.date
  AND DustDeposition.time = SolarPanelData.time
JOIN
  OutputPower ON DustDeposition.date = OutputPower.date
  AND DustDeposition.time = OutputPower.time;

-- Query 5: Get the top 5 dates with the highest total dust deposition
SELECT
  date,
  SUM(dust_amount) AS total_dust_deposition
FROM
  DustDeposition
GROUP BY
  date
ORDER BY
  total_dust_deposition DESC
LIMIT 5;

-- Export the total dust deposition, solar rays, and output power data to a CSV file using SELECT INTO OUTFILE
SELECT
  DustDeposition.date,
  SUM(dust_amount) AS total_dust_deposition,
  SUM(solar_rays) AS total_solar_rays,
  SUM(power) AS total_output_power
FROM
  DustDeposition
JOIN
  SolarPanelData ON DustDeposition.date = SolarPanelData.date
  AND DustDeposition.time = SolarPanelData.time
JOIN
  OutputPower ON DustDeposition.date = OutputPower.date
  AND DustDeposition.time = OutputPower.time
GROUP BY
  DustDeposition.date
INTO OUTFILE 'C:\Users\DS_USER\Desktop\Sql.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
