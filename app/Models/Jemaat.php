<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class Jemaat extends Authenticatable
{
    use HasApiTokens, HasFactory;

    protected $table = 'tb_jemaat';
    protected $primaryKey = 'id_jemaat';
    public $timestamps = false;

    protected $fillable = [
        'no_anggota', 
        'nama_lengkap', 
        'email', 
        'no_hp', 
        'password_hash', 
        'foto_profil',
        'is_active'
    ];

    protected $hidden = [
        'password_hash',
    ];

    public function getAuthPassword()
    {
        return $this->password_hash;
    }
}