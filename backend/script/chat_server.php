<?php

use Ratchet\App;
use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;
require_once __DIR__ . '/../config/database.php';

class ChatServer implements MessageComponentInterface {

    protected $clients;
    protected $users;
    protected $pdo;

    public function __construct(PDO $pdo)
    {

        $this->clients = new \SplObjectStorage;
        $this->users = [];
        $this->pdo = $pdo;
    }

    // Create a connection to be added to clients
    public function onOpen(ConnectionInterface $conn)
    {
        // store the new connection
        $this->clients->attach($conn);
    }

    // What happens when a message is sent through the connection
    public function onMessage(ConnectionInterface $from, $msg)
    {
        $data = json_decode($msg, true);

        if(isset($data['token'])){

            $userId = $this->validateToken($data['token']);

            // Check if user exists and take action accordingly
            if(isset($userId)){
                $this->users[$userId] = $from;
                $from->send(json_encode(['status' => 'success']));
            }
            else {
                $from->send(json_encode(['status' => 'error', 'message' => 'Invalid token']));
                $from->close();
            }
        } elseif(isset($data['userId']) && array_key_exists($data['userId'], $this->users)){ // check if user is authorized

            $fromUserId = $data['userId'];
            $toUserId = $data['toUserId'];
            $message = $data['message'];
    
            // save the message to the database
            $sql = "INSERT INTO messages (matchId, senderId, messageText) VALUES (:toUserId, :fromUserId, :messageSent)";
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute(['toUserId' => $toUserId, 'fromUserId' => $fromUserId, 'messageSent' => $message]);
    
            if (isset($this->users[$toUserId])) {
                $this->users[$toUserId]->send(json_encode([
                    'from_user_id' => $fromUserId,
                    'message' => $message,
                ]));
            }
        } else {
            $from->send(json_encode(['status' => 'error', 'message' => 'Unauthorized']));
            $from->close();
        }
    }

    // Handle the closing of a connection
    public function onClose(ConnectionInterface $conn)
    {
        // Close the connection of a specific user
        foreach ($this->users as $userId => $userConn) {
            if ($userConn === $conn) {
                unset($this->users[$userId]);
                break;
            }
        }
        $this->clients->detach($conn);
    }

    // Handle error pop ups
    public function onError(ConnectionInterface $conn, Exception $e)
    {
        echo "error: {$e->getMessage()}";
        $conn->close();
    }

    // Validate token sent by request
    public function validateToken($token){
        
        $sql = "SELECT userId FROM tokens WHERE token = :token";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['token' => $token]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        return $result ? $result['userId']: false ;
    }

}

// Create database object
$database = new Database();
$pdo = $database->getPdo();

// Run server
$app = new App('localhost', 8080);
$app->route('/chat', new ChatServer($pdo), ['*']);
$app->run();

?>