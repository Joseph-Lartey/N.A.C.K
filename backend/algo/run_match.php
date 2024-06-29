<?php
$userId = 5; 

$command = escapeshellcmd("python ./match_users.py $userId");
exec($command);
?>
