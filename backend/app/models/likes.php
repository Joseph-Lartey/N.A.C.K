<?php
require_once __DIR__ . '/model.php';

/// Class to represent the Users database
class Like extends Model
{
    protected $table = 'likes';

    // Insert a new row into the table 
    public function insertLike($data)
    {
        return $this->insert($data);
    }

    // check if like exisits and return id of matched liked id or false
    public function isLiked($data){

        $sql = "SELECT userId FROM {$this->table} WHERE userId = :liker_id AND liked_userId = :id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['id' => $data['user'], 'liker_id' => $data['other_user']]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    

}
?>
