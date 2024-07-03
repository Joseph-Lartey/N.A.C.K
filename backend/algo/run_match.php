<?php
$userId = 5; 
$command = escapeshellcmd("python3 match_users.py $userId");
$output = shell_exec($command);

$matches = json_decode($output, true);

if ($matches === null) {
    echo "Error processing matches";
} else {
    foreach ($matches as $match) {
        echo "User 1 ID: " . $match['userId_1'] . "<br>";
        echo "User 2 ID: " . $match['userId_2'] . "<br>";
        echo "Similarity: " . $match['similarity'] . "<br><br>";
    }
}
?>
