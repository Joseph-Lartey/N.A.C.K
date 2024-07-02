<?php

require_once __DIR__ . '/../models/likes.php';

class LikeController
{
    protected $likeModel;

    public function __construct($pdo)
    {
        $this->likeModel = new Like($pdo);
    }

    // handle the current user liking another user
    public function likeUser($data)
    {
        try {
            $isLiked = $this->likeModel->isLiked($data);

            if (!$isLiked)
            {
                $this->likeModel->insertLike($data);
                return ["success" => true, "message" => "Like has been inserted"];

            } else {

                //TODO: Add match controller to create a match

            }
        } catch (\Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            $errors = ["success" => false, "error" => $e->getMessage()];
            return $errors;
        }
    }
}

?>