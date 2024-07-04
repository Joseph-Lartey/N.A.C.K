<?php

    require __DIR__ . '/model.php';

    class Chat extends Model {
        
        protected $table = "messages";

        // insert the message sent into the database
        public function saveMessage($fromUserId, $toUserId, $message){

            $sql = "INSERT INTO {$this->table} (match_id, sender_id, message_text) VALUES (:toUserId, :fromUserId, :messageSent)";
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute(['toUserId' => $toUserId, 'fromUserId' => $fromUserId, 'messageSent' => $message]);

        }

        //get the messages between individuals
        public function getMessages($toUserId, $fromUserId){

            $sql = "SELECT * FROM {$this->table} WHERE (match_id = :toUserId AND sender_id = :fromUserId) or (match_id = :fromUserId AND sender_id = :toUserId)";
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([
                'toUserId' => $toUserId, 'fromUserId' => $fromUserId
            ]);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        }


    }
?>