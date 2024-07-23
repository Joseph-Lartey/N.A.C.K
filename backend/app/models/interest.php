<?php

class Interest extends Model
{
    protected $table = 'interests';

    public function getAllInterests()
    {
        return $this->all();
    }
}
