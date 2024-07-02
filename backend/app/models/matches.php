<?php

    require_once __DIR__.'/model.php';

    class Matches extends Model
    {
        protected $table = 'matches';

        // Insert a new row into the matches table
        public function insertMatch($data)
        {
            return $this->insert($data);
        }

        // Get all the matches in the matches table
        public function getMatches($id){
            $sql = " (SELECT match_id, userId_1 as userId FROM {$this->table} WHERE userId_2 = :id)
            UNION
            (SELECT match_id, userId_2 as userId FROM {$this->table} WHERE userId_1 = :id)";
            
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute(['id' => $id]);

            return $stmt->fetchAll(PDO::FETCH_ASSOC);

        }
    }

?>