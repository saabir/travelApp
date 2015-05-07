<?php
require("config.php");

	#This script selects data from country and currency table
	
	mysql_connect($host,$user,$pass);

	#connect to databse
	@mysql_select_db($db_name) or die("uff unable to find database");
	
	#create query
	$myquery="select x.name,x.short_code,x.conversion_factor from country c, currency_has_country m, currency x where c.iso_code=m.country_iso_code ;";
	$myresult=mysql_query($myquery) or die(mysql_error("error"));
	$totalnumber=mysql_numrows($myresult);
	mysql_close();
	$rows = array();
	while($item = mysql_fetch_assoc($myresult)){
		$rows[]=$item;
	}
	echo json_encode($rows);
?>