<?php

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

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

        if(isset($data['userId'])){
            $this->users[$data['userId']] = $from;
        }

        $fromUserId = $data['userId'];
        $toUserId = $data['toUserId'];
        $message = $data['message'];

        // save the message to the database
        $sql = "INSERT INTO messages (match_id, sender_id, message_text) VALUES (:toUserId, :fromUserId, :messageSent)";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['toUserId' => $toUserId, 'fromUserId' => $fromUserId, 'messageSent' => $message]);

        if (isset($this->users[$toUserId])) {
            $this->users[$toUserId]->send(json_encode([
                'from_user_id' => $fromUserId,
                'message' => $message,
            ]));
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
        $conn->close();
    }

}

?>