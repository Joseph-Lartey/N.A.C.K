<?php

class Interest extends Model
{
    protected $table = 'Interests';

    public function getAllInterests()
    {
        return $this->all();
    }
}
