<?php
require_once __DIR__ . '/model.php';

/// Class to represent the Users database
class User extends Model
{
    protected $table = 'users';
    protected $otherTable = 'tokens';

    // Create single user
    public function createUser($firstname, $lastname, $email, $password, $dob)
    {
        $password_hash = password_hash($password, PASSWORD_DEFAULT);
        $verified = true;
        $data = [
            'firstName' => $firstname,
            'lastName' => $lastname,
            'username' => $firstname,
            'email' => $email,
            'password' => $password_hash,
            'dob' => $dob,
            'verified' => $verified,
        ];

        return $this->insert($data);
    }

    // Find a user by their email address
    public function findByEmail($email)
    {
        $result = $this->find("email", $email);
        return $result;
    }

    // Fetch all users in the system with a specific set of column details (attributes)
    public function fetchAll()
    {
        $sql = "SELECT userId, firstName, lastName, username, bio, profile_Image
                FROM {$this->table}";

        $stmt = $this->pdo->query($sql);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Find a user by their id
    public function findProfileById($id)
    {
        $sql = "SELECT userId,username, firstname, lastname, profile_Image, bio, email FROM " . $this->table . " WHERE userId = :id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['id' => $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Update user profile image
    public function updateProfileImage($id, $imagePath){
        $sql = "UPDATE {$this->table} SET profile_Image = :profile_Image WHERE userId = :id";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute(['profile_Image' => $imagePath, 'id' => $id]);
    }

    // Store the user's login token in the database
    public function storeToken($id, $token){
        $sql = "INSERT INTO {$this->otherTable} (userId, token) VALUES (:id, :token)
            ON DUPLICATE KEY UPDATE
            token = VALUES(token)";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['id' => $id, 'token' => $token]);
    }
}
?>
