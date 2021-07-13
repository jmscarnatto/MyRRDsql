# MyRRDsql
A RRD (round robin database) approach in Mysql

This is a simple Mysql procedure to implement a RRD table. This is helpful for projects where storage space is limited or transitory data are suitable to be disposed

## Create an empty table with the desired number of rows

```
CREATE TABLE  `dbanme`.`rrd_tablename` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sequence_id` int(10) unsigned NOT NULL,
  `value` varchar(30),
  `tstamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO rrd_tablename (sequence_id) VALUES (1,2,3,4,..,n) // n being the final size of your table
```

## Now the Magic!

```
DELIMITER $$
DROP PROCEDURE IF EXISTS `dbanme`.`InsertIntoRRD` $$
CREATE PROCEDURE `myDB`.`InsertIntoRRD`(IN xValue VARCHAR(30))
BEGIN
	SET @table_size = (SELECT COUNT(*) as table_size FROM dbanme.rrd_tablename);
	SET @next_sequence_id = (SELECT ((`sequence_id` % @table_size)+1) as next_sequence_id
	  FROM dbanme.rrd_tablename
	  ORDER BY tstamp DESC LIMIT 1);
  INSERT INTO dbanme.rrd_tablename (sequence_id,value,tstamp) VALUES (@next_sequence_id,xValue,now())
  ON DUPLICATE KEY UPDATE value=xValue,tstamp=now();
END $$
DELIMITER ;
```

### Explanation

```
SET @table_size = (SELECT COUNT(*) as table_size FROM dbanme.rrd_tablename);
```
This get the total number of a row.







