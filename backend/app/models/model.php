<?php

class Model
{
    protected $table;
    protected $pdo;

    public function __construct($pdo)
    {
        $this->pdo = $pdo;
    }

    // Insert a new row into the table
    public function insert($data)
    {
        $columns = implode(",", array_keys($data));
        $value_placeholders = ":" . implode(", :", array_keys($data));

        $sql = "INSERT INTO {$this->table} ($columns) VALUES ($value_placeholders)";

        $stmt = $this->pdo->prepare($sql);


        return $stmt->execute($data);
    }

    // Find a specific row in the table
    public function find($col, $val)
    {
        $sql = "SELECT * FROM {$this->table} WHERE $col = :val";

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['val' => $val]);

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Update the column of a specific row in the table
    public function update($id, array $data)
    {
        $fields = ""; // Fields as a string to update

        foreach ($data as $column => $value) {
            $fields .= "$column = :$column, "; // use pdo placeholders to help with string
        }
        $fields = rtrim($fields, ", ");

        $sql = "UPDATE {$this->table} SET $fields WHERE id = :id"; // construct sql command
        $stmt = $this->pdo->prepare($sql);
        $data['id'] = $id; // Include id into data so that its value can be replaced with its placeholder

        return $stmt->execute($data);
    }

    // Delete an entire row
    public function delete($col, $val)
    {
        $sql = "DELETE FROM {$this->table} WHERE $col = :val";
        $stmt = $this->pdo->prepare($sql);

        return $stmt->execute(['val' => $val]);
    }

    // Get all the data of a table
    public function all()
    {
        $sql = "SELECT * FROM {$this->table}";
        $stmt = $this->pdo->query($sql);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}

