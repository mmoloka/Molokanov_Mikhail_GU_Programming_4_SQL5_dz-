CREATE DATABASE seminar5_dz;
USE seminar5_dz;

CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

SET GLOBAL local_infile = true;
SHOW VARIABLES LIKE "local_infile";
SHOW VARIABLES LIKE "secure-file-priv";                       
LOAD DATA INFILE "C:\\tmp\\cars.csv" INTO TABLE cars  # Error Code 2068 устраняем убрав "LOCAL" из "LOAD DATA"
FIELDS TERMINATED BY ','                              # Возникает Error Code 1290 - в файле C:\ProgramData\MySQL\MySQL Server 8.0\my.ini
ENCLOSED BY '"'                                       # меняем значение переменной secure-file-priv=""      
LINES TERMINATED BY '\n'                              # Возникает Error Code 29 - из-за того, что при скачивании файла в его названии отается ".csv"  
IGNORE 1 ROWS;                                        # после смены названия таблица наконец-то заполнилась

SELECT * FROM cars;

-- Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов
CREATE VIEW view_1 AS
SELECT * FROM cars
WHERE cost < 25000;
SELECT * FROM view_1;

-- Изменить в существующем представлении порог для стоимости: пусть цена будет до 
-- 30 000 долларов (используя оператор ALTER VIEW)
ALTER VIEW view_1 AS
SELECT * FROM cars
WHERE cost < 30000;
SELECT * FROM view_1;

--  Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
CREATE VIEW view_2 AS
SELECT * FROM cars
WHERE name IN ('Skoda ', 'Audi ');  #была проблема с пробелом в конце имени марки из файла csv
SELECT * FROM view_2;

CREATE TABLE stations
(
train_id INT NOT NULL,
station varchar(20) NOT NULL,
station_time TIME NOT NULL
);

INSERT stations(train_id, station, station_time)
VALUES (110, "SanFrancisco", "10:00:00"),
(110, "Redwood Sity", "10:54:00"),
(110, "Palo Alto", "11:02:00"),
(110, "San Jose", "12:35:00"),
(120, "SanFrancisco", "11:00:00"),
(120, "Palo Alto", "12:49:00"),
(120, "San Jose", "13:30:00");

/*Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это значение, мы вычитаем время станций для пар
смежных станций. Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. Проще это 
сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить
результат. В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее. */
CREATE VIEW view_3 AS
SELECT train_id, station, station_time,
subtime(LEAD(station_time) OVER(PARTITION BY train_id), station_time) AS time_to_next_station
FROM stations;



