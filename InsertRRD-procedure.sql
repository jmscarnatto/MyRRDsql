# myDB.rrd_table fields : sequence_id (integer key) , value (varchar) , tstamp (timestamp)

DELIMITER $$
DROP PROCEDURE IF EXISTS `myDB`.`InsertIntoRRD` $$
CREATE PROCEDURE `myDB`.`InsertIntoRRD`(IN xValue VARCHAR(30))
BEGIN
	SET @table_size = (SELECT COUNT(*) as table_size FROM myDB.rrd_table);
	SET @next_sequence_id = (SELECT ((`sequence_id` % @table_size)+1) as next_sequence_id
	  FROM myDB.rrd_table
	  ORDER BY tstamp DESC LIMIT 1);
  INSERT INTO myDB.rrd_table (sequence_id,value,tstamp) VALUES (@next_sequence_id,xValue,now())
  ON DUPLICATE KEY UPDATE value=xValue,tstamp=now();
END $$
DELIMITER ;
