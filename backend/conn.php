<?php 

$config['db'] = array(
	
	'host' => 'localhost',
	'username' => 'sazbarb_hack',
	'password' => 'testing123',
	'dbname' => 'sazbarb_umass'
	
);

$db = new PDO('mysql:host='.$config['db']['host'].';dbname='.$config['db']['dbname'], $config['db']['username'], $config['db']['password']);


?>