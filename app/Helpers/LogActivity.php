<?php

namespace App\Helpers;

use Illuminate\Support\Facades\DB;

class LogActivity
{
    public static function log($userId, $aksi, $deskripsi)
    {
        try {
            DB::table('tb_log_activity')->insert([
                'id_user' => $userId,
                'role_user' => 'admin',
                'aksi' => $aksi,
                'deskripsi' => $deskripsi,
                'ip_address' => request()->ip(),
                'user_agent' => request()->userAgent(),
                'created_at' => now()
            ]);
        } catch (\Exception $e) {
            // Silent fail
        }
    }
}