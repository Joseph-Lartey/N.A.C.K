<?php
class UserInterest extends Model
{
    protected $table = 'UserInterests';

    public function getUserInterests($userId)
    {
        $sql = "SELECT Interests.interestName
                FROM {$this->table}
                JOIN Interests ON {$this->table}.interestId = Interests.interestId
                WHERE {$this->table}.userId = :userId";

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['userId' => $userId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function insertUserInterest($data)
    {
        return $this->insert($data);
    }

    public function deleteUserInterest($userId, $interestId)
    {
        $sql = "DELETE FROM {$this->table} WHERE userId = :userId AND interestId = :interestId";
        $stmt = $this->pdo->prepare($sql);

        return $stmt->execute(['userId' => $userId, 'interestId' => $interestId]);
    }
}
