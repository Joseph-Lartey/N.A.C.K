<?php

class Interest extends Model
{
    protected $table = 'Interests';

    public function getAllInterests()
    {
        return $this->all();
    }

    public function insertInterest($data)
    {
        return $this->insert($data);
    }

    public function findInterest($col, $val)
    {
        return $this->find($col, $val);
    }

    
}
