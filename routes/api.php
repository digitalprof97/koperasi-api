<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\PinjamanController;
use App\Http\Controllers\API\ProdukPinjamanController;
use App\Http\Controllers\API\MetodeBayarController;
use App\Http\Controllers\API\LaporanController;
use App\Http\Controllers\API\JemaatController;
use App\Http\Controllers\API\PengaturanController;
use App\Http\Controllers\API\RiwayatController;
use App\Http\Controllers\API\JemaatAuthController;
use App\Http\Controllers\API\AngsuranController;
use App\Http\Controllers\API\SimpananController;
use App\Http\Controllers\API\IuranController;
use Illuminate\Support\Facades\Route;

// Public routes
Route::post('/login', [AuthController::class, 'login']);

// ============ ROUTE UNTUK ADMIN ============
Route::prefix('admin')->group(function () {
    
    // Profil Admin
    Route::get('/profil', [AuthController::class, 'profil']);
    Route::post('/profil/update', [AuthController::class, 'updateProfil']);
    Route::post('/profil/ganti-password', [AuthController::class, 'gantiPassword']);
    Route::post('/profil/upload-foto', [AuthController::class, 'uploadFoto']);
    
    // Pinjaman
    Route::get('/pinjaman', [PinjamanController::class, 'index']);
    Route::get('/pinjaman/{id}', [PinjamanController::class, 'show']);
    Route::put('/pinjaman/{id}/status', [PinjamanController::class, 'updateStatus']);
    
    // Produk Pinjaman
    Route::get('/produk-pinjaman', [ProdukPinjamanController::class, 'index']);
    Route::get('/produk-pinjaman/{id}', [ProdukPinjamanController::class, 'show']);
    Route::post('/produk-pinjaman', [ProdukPinjamanController::class, 'store']);
    Route::match(['put', 'post'], '/produk-pinjaman/{id}', [ProdukPinjamanController::class, 'update']);
    Route::delete('/produk-pinjaman/{id}', [ProdukPinjamanController::class, 'destroy']);
    
    // Metode Bayar
    Route::get('/metode-bayar', [MetodeBayarController::class, 'index']);
    Route::get('/metode-bayar/{id}', [MetodeBayarController::class, 'show']);
    Route::post('/metode-bayar', [MetodeBayarController::class, 'store']);
    Route::match(['put', 'post'], '/metode-bayar/{id}', [MetodeBayarController::class, 'update']);
    Route::delete('/metode-bayar/{id}', [MetodeBayarController::class, 'destroy']);
    
    // Jemaat
    Route::get('/jemaat', [JemaatController::class, 'index']);
    Route::get('/jemaat/{id}', [JemaatController::class, 'show']);
    Route::post('/jemaat', [JemaatController::class, 'store']);
    Route::match(['put', 'post'], '/jemaat/{id}', [JemaatController::class, 'update']);
    Route::delete('/jemaat/{id}', [JemaatController::class, 'destroy']);
    
    // Laporan
    Route::get('/laporan/dashboard', [LaporanController::class, 'dashboard']);
    Route::get('/laporan/pinjaman', [LaporanController::class, 'laporanPinjaman']);
    Route::get('/laporan/simpanan', [LaporanController::class, 'laporanSimpanan']);
    Route::get('/laporan/angsuran', [LaporanController::class, 'laporanAngsuran']);
    
    // Pengaturan
    Route::get('/pengaturan', [PengaturanController::class, 'index']);
    Route::post('/pengaturan', [PengaturanController::class, 'update']);
    Route::post('/pengaturan/upload-logo', [PengaturanController::class, 'uploadLogo']);
    
    // Riwayat
    Route::get('/riwayat/aktivitas', [RiwayatController::class, 'aktivitas']);
    Route::get('/riwayat/pinjaman', [RiwayatController::class, 'semuaPinjaman']);
    Route::get('/riwayat/simpanan', [RiwayatController::class, 'semuaSimpanan']);
    
    // Angsuran Verifikasi
    Route::get('/angsuran/menunggu-verifikasi', [AngsuranController::class, 'menungguVerifikasi']);
    Route::post('/angsuran/{idAngsuran}/verifikasi', [AngsuranController::class, 'verifikasi']);
    
    // 🔥 SIMPANAN (TAMBAHKAN INI) 🔥
    Route::get('/simpanan', [SimpananController::class, 'semuaSimpanan']);
    Route::post('/simpanan', [SimpananController::class, 'tambahSimpanan']);
    Route::get('/jenis-simpanan', [SimpananController::class, 'getJenisSimpanan']);

    // 🔥 IURAN (VERIFIKASI ADMIN) 🔥
    Route::get('/iuran', [IuranController::class, 'semuaIuran']);
    Route::get('/iuran/statistik', [IuranController::class, 'statistik']);
    Route::post('/iuran/{idIuran}/verifikasi', [IuranController::class, 'verifikasi']);
});

// ============ ROUTE UNTUK JEMAAT ============
Route::prefix('jemaat')->group(function () {
    Route::get('/profil', [JemaatAuthController::class, 'profil']);
    Route::post('/profil/ganti-password', [JemaatAuthController::class, 'gantiPassword']);
    Route::post('/profil/update', [JemaatAuthController::class, 'updateProfil']);
    Route::post('/profil/upload-foto', [JemaatAuthController::class, 'uploadFoto']);
    Route::get('/pinjaman', [JemaatAuthController::class, 'pinjamanSaya']);
    Route::get('/simpanan', [JemaatAuthController::class, 'simpananSaya']);
    Route::post('/pinjaman/ajukan', [JemaatAuthController::class, 'ajukanPinjaman']);
    Route::get('/angsuran/{idPinjaman}', [JemaatAuthController::class, 'angsuranByPinjaman']);
    Route::post('/angsuran/{idAngsuran}/upload-bukti', [JemaatAuthController::class, 'uploadBuktiAngsuran']);

    // 🔥 IURAN (BAYAR IURAN) 🔥
    Route::get('/iuran', [IuranController::class, 'iuranSaya']);
    Route::post('/iuran/{idIuran}/upload-bukti', [IuranController::class, 'uploadBukti']);
});

// Logout
Route::post('/logout', [AuthController::class, 'logout']);
