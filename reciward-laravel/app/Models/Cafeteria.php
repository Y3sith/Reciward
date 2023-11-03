<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cafeteria extends Model
{
    protected $fillable =["claveAcceso", "correoCafeteria", "contrasenaCafeteria"];
    public $timestamps = false;
    use HasFactory;

    public function entrega(){
        return $this->hasMany(Entrega::class, 'cafeteria_id', 'id');
    }
}
