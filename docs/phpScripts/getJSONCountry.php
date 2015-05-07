<?php
require("config.php");

	#This script selects data from country table
	
	mysql_connect($host,$user,$pass);

	#connect to databse
	@mysql_select_db($db_name) or die("uff unable to find database");
	
	#create query
	$myquery="SELECT * FROM country";
	$myresult=mysql_query($myquery) or die(mysql_error("error"));
	$totalnumber=mysql_numrows($myresult);
	mysql_close();
	$rows = array();
	while($item = mysql_fetch_assoc($myresult)){
		$rows[]=$item;
	}
	echo json_encode($rows);
?>