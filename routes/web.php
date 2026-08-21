<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

/*
|--------------------------------------------------------------------------
| Fallback Storage File Route
|--------------------------------------------------------------------------
|
| Route ini dipakai sebagai cadangan untuk menyajikan file dari
| storage/app/public/{path} lewat URL /storage/{path}, TANPA butuh
| symbolic link (php artisan storage:link). Berguna kalau public/storage
| bukan symlink (misalnya karena project di-zip/di-copy manual), sehingga
| file baru (contoh: folder "jaminan") tetap bisa diakses tanpa perlu
| menghapus atau memindahkan file yang sudah ada di public/storage.
|
| Route ini hanya akan "nyala" untuk file yang memang belum ada secara
| fisik di public/storage (web server akan tetap memprioritaskan file
| fisik yang sudah ada di sana seperti biasa).
|
*/
Route::get('/storage/{path}', function (string $path) {
    // Cegah path traversal (../) demi keamanan
    $path = str_replace(['..\\', '../'], '', $path);

    if (!Storage::disk('public')->exists($path)) {
        abort(404, 'File tidak ditemukan: ' . $path);
    }

    // Pakai storage_path() bawaan Laravel & mapping ekstensi manual,
    // supaya tidak bergantung pada method path()/mimeType() yang
    // tidak terdaftar di contract Illuminate\Contracts\Filesystem\Filesystem,
    // dan tidak bergantung pada ekstensi PHP "fileinfo" (mime_content_type)
    // yang mungkin belum aktif di php.ini server.
    $fullPath = storage_path('app/public/' . $path);

    if (!is_file($fullPath)) {
        abort(404, 'File tidak ditemukan di disk: ' . $path);
    }

    $extension = strtolower(pathinfo($fullPath, PATHINFO_EXTENSION));
    $mimeMap = [
        'jpg'  => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'png'  => 'image/png',
        'gif'  => 'image/gif',
        'webp' => 'image/webp',
        'bmp'  => 'image/bmp',
        'svg'  => 'image/svg+xml',
        'pdf'  => 'application/pdf',
        'doc'  => 'application/msword',
        'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'xls'  => 'application/vnd.ms-excel',
        'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'txt'  => 'text/plain',
        'mp4'  => 'video/mp4',
    ];
    $mimeType = $mimeMap[$extension] ?? 'application/octet-stream';
    $fileSize = filesize($fullPath);

    return new StreamedResponse(function () use ($fullPath) {
        $stream = fopen($fullPath, 'rb');
        fpassthru($stream);
        fclose($stream);
    }, 200, [
        'Content-Type'   => $mimeType,
        'Content-Length' => $fileSize,
        'Cache-Control'  => 'public, max-age=31536000',
    ]);
})->where('path', '.*');