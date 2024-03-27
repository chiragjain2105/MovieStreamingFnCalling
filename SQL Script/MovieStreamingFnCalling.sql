use moviestremingdb;
CREATE TABLE MovieStreams (
    id INT,
    date DATE,
    movie VARCHAR(255),
    director VARCHAR(255),
    number_of_streams INT
);

INSERT INTO MovieStreams (id, date, movie, director, number_of_streams) VALUES
(1, '2022-04-01', 'Fargo', 'Coen brothers', 495),
(2, '2022-04-01', 'The Big Lebowski', 'Coen brothers', 512),
(3, '2022-04-01', 'No Country for Old Men', 'Coen brothers', 270),
(4, '2022-04-01', 'Dogtooth', 'Yorgos Lanthimos', 157),
(5, '2022-04-01', 'The Lobster', 'Yorgos Lanthimos', 247),
(6, '2022-04-01', 'The Killing of a Sacred Deer', 'Yorgos Lanthimos', 320),
(7, '2022-04-02', 'Fargo', 'Coen brothers', 321),
(8, '2022-04-02', 'The Big Lebowski', 'Coen brothers', 905),
(9, '2022-04-02', 'No Country for Old Men', 'Coen brothers', 308),
(10, '2022-04-02', 'Dogtooth', 'Yorgos Lanthimos', 233),
(11, '2022-04-02', 'The Lobster', 'Yorgos Lanthimos', 405),
(12, '2022-04-02', 'The Killing of a Sacred Deer', 'Yorgos Lanthimos', 109);



DELIMITER //

CREATE PROCEDURE GetStreamingData(
    IN p_date DATE,
    IN p_movie VARCHAR(255),
    IN p_director VARCHAR(255),
    IN p_operation VARCHAR(10)
)
BEGIN
	DECLARE p_result DECIMAL(3,2);
    IF p_operation = 'SUM' THEN
        SET @sql_query = CONCAT('SELECT SUM(number_of_streams) FROM MovieStreams');
    ELSEIF p_operation = 'AVG' THEN
        SET @sql_query = CONCAT('SELECT AVG(number_of_streams) FROM MovieStreams');
    ELSEIF p_operation = 'MAX' THEN
        SET @sql_query = CONCAT('SELECT MAX(number_of_streams) FROM MovieStreams');
    ELSEIF p_operation = 'MIN' THEN
        SET @sql_query = CONCAT('SELECT MIN(number_of_streams) FROM MovieStreams');
    ELSE
        -- Invalid operation, set result to NULL
        SET p_result = NULL;
 
    END IF;
    SET @sql_query = CONCAT(@sql_query, ' WHERE 1=1');

    IF p_date IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND date = "', p_date, '"');
    END IF;

    IF p_movie IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND movie = "', p_movie, '"');
    END IF;

    IF p_director IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND director = "', p_director, '"');
    END IF;



    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;



-- Call the procedure with appropriate input parameters
CALL GetStreamingData(NULL, 'Fargo', NULL, 'SUM');



