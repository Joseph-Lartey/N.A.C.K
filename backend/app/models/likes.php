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

        $sql = "SELECT userId FROM {$this->table} WHERE userId = :liked_userId AND liked_userId = :userId";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['userId' => $data['userId'], 'liked_userId' => $data['liked_userId']]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Delete a like from the likes table due to the presence of a like
    public function deleteLike($data){

        $sql = "DELETE FROM {$this->table} WHERE userId = :liked_userId AND liked_userId = :userId";
        $stmt = $this->pdo->prepare($sql);
        
        return $stmt->execute(['userId' => $data['userId'], 'liked_userId' => $data['liked_userId']]);
    }

    

}
?>
