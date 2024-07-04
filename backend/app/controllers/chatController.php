<?php

    require_once __DIR__ . '/../models/chat.php';

    class ChatController {

        protected $chatModel;

        public function __construct($pdo){
            $this->chatModel = new Chat($pdo);
        }

        // get all the chats between two users
        public function getChatHistory($userId1, $userId2){

            $messages = $this->chatModel->getMessages($userId1, $userId2);
            return ['success' => true, "data" => $messages];
        }

    }

?>