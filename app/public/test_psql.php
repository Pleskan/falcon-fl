<?php
    $connection = pg_connect ("host=postgresql dbname=mydb user=myuser password=my_password");
    if($connection) {
	           echo 'connected';
		       } else {
			        echo 'there has been an error connecting';
				           } 
?>

