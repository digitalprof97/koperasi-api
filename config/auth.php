<?php

return [

    'defaults' => [
        'guard' => 'web',
        'passwords' => 'users',
    ],

    'guards' => [
        'web' => [
            'driver' => 'session',
            'provider' => 'users',
        ],
        
        // TAMBAHKAN GUARD UNTUK API (SANCTUM)
        'api' => [
            'driver' => 'sanctum',
            'provider' => 'users',
        ],
        
        // TAMBAHKAN GUARD UNTUK ADMIN
        'admin' => [
            'driver' => 'sanctum',
            'provider' => 'admins',
        ],
        
        // TAMBAHKAN GUARD UNTUK JEMAAT
        'jemaat' => [
            'driver' => 'sanctum',
            'provider' => 'jemaats',
        ],
    ],

    'providers' => [
        'users' => [
            'driver' => 'eloquent',
            'model' => App\Models\User::class,
        ],
        
        // TAMBAHKAN PROVIDER UNTUK ADMIN
        'admins' => [
            'driver' => 'eloquent',
            'model' => App\Models\Admin::class,
        ],
        
        // TAMBAHKAN PROVIDER UNTUK JEMAAT
        'jemaats' => [
            'driver' => 'eloquent',
            'model' => App\Models\Jemaat::class,
        ],
    ],

    'passwords' => [
        'users' => [
            'provider' => 'users',
            'table' => 'password_resets',
            'expire' => 60,
            'throttle' => 60,
        ],
    ],

    'password_timeout' => 10800,

];