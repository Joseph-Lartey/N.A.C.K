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

    // Setup the user's profile with bio and username
    public function updateProfile($id, $username, $bio, $gender){
        $sql = "UPDATE {$this->table} SET username = :username, bio = :bio, gender = :gender WHERE userId = :id";
    
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute([
                    'id' => $id,
                    'username' => $username,
                    'bio' => $bio,
                    'gender' => $gender
                ]);
    }

    // update password
    public function resetPassword($email, $newPassword)
    {
        $password_hash = password_hash($newPassword, PASSWORD_DEFAULT);
        $sql = "UPDATE {$this->table} SET password = :password WHERE email = :email";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute(['password' => $password_hash, 'email' => $email]);
    }

    public function changePassword($userId, $oldPassword, $newPassword)
    {
        $user = $this->findById($userId);
        
        if ($user && password_verify($oldPassword, $user['password'])) {
            $password_hash = password_hash($newPassword, PASSWORD_DEFAULT);
            $sql = "UPDATE {$this->table} SET password = :password WHERE userId = :userId";
            $stmt = $this->pdo->prepare($sql);
            return $stmt->execute(['password' => $password_hash, 'userId' => $userId]);
        } else {
            return false; // Invalid current password
        }
    }
    
    public function findById($userId)
    {
        $sql = "SELECT * FROM {$this->table} WHERE userId = :userId";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['userId' => $userId]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    
}
?>
