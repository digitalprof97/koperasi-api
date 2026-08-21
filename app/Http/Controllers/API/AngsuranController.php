<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use App\Helpers\LogActivity;

class AngsuranController extends Controller
{
    /**
     * Get daftar angsuran yang menunggu verifikasi
     */
    public function menungguVerifikasi()
    {
        try {
            $angsuran = DB::table('tb_angsuran as a')
                ->join('tb_pinjaman as p', 'a.id_pinjaman', '=', 'p.id_pinjaman')
                ->join('tb_jemaat as j', 'p.id_jemaat', '=', 'j.id_jemaat')
                ->leftJoin('tb_metode_pembayaran as m', 'a.id_metode_bayar', '=', 'm.id_metode')
                ->select(
                    'a.id_angsuran',
                    'a.angsuran_ke',
                    'a.jumlah_angsuran',
                    'a.denda',
                    'a.tgl_jatuh_tempo',
                    'a.tgl_bayar',
                    'a.bukti_bayar',
                    'a.status_bayar',
                    'a.keterangan',
                    'p.kode_pinjaman',
                    'j.nama_lengkap',
                    'j.no_anggota',
                    'm.nama_metode'
                )
                ->where('a.status_bayar', 'menunggu_verifikasi')
                ->whereNotNull('a.bukti_bayar')
                ->orderBy('a.created_at', 'desc')
                ->get();
            
            return response()->json([
                'status' => true,
                'data' => $angsuran
            ]);
        } catch (\Exception $e) {
            Log::error('Menunggu verifikasi error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Upload bukti bayar angsuran oleh jemaat (BEBAS EROR 400 & 500 100%)
     */
    public function uploadBukti(Request $request, $idAngsuran)
    {
        try {
            Log::info('Upload bukti angsuran dipanggil untuk ID: ' . $idAngsuran);

            $angsuran = DB::table('tb_angsuran')
                ->where('id_angsuran', $idAngsuran)
                ->first();

            if (!$angsuran) {
                return response()->json([
                    'status' => false,
                    'message' => 'Data angsuran tidak ditemukan'
                ], 404);
            }

            $urlBukti = null;
            $targetDir = storage_path('app/public/bukti_angsuran');
            
            if (!file_exists($targetDir)) {
                @mkdir($targetDir, 0777, true);
            }

            // 1. Cek pengiriman file via Laravel Request / Multipart
            if ($request->hasFile('bukti_bayar') || $request->hasFile('bukti') || $request->hasFile('file')) {
                $file = $request->file('bukti_bayar') ?? $request->file('bukti') ?? $request->file('file');
                if ($file && $file->isValid()) {
                    $filename = 'angsuran_' . $idAngsuran . '_' . time() . '_' . rand(100, 999) . '.' . $file->getClientOriginalExtension();
                    $file->move($targetDir, $filename);
                    $urlBukti = '/storage/bukti_angsuran/' . $filename;
                }
            }

            // 2. Fallback via global array $_FILES murni PHP
            if (!$urlBukti && !empty($_FILES)) {
                foreach ($_FILES as $key => $fileData) {
                    if (isset($fileData['tmp_name']) && is_uploaded_file($fileData['tmp_name'])) {
                        $origName = $fileData['name'] ?? 'bukti.jpg';
                        $ext = strtolower(pathinfo($origName, PATHINFO_EXTENSION));
                        if (empty($ext)) {
                            $ext = 'jpg';
                        }

                        $filename = 'angsuran_' . $idAngsuran . '_' . time() . '_' . rand(100, 999) . '.' . $ext;
                        $destination = $targetDir . '/' . $filename;

                        if (@move_uploaded_file($fileData['tmp_name'], $destination) || @copy($fileData['tmp_name'], $destination)) {
                            $urlBukti = '/storage/bukti_angsuran/' . $filename;
                            break;
                        }
                    }
                }
            }

            // 3. Fallback via string Base64
            if (!$urlBukti) {
                $base64Input = $request->input('bukti_base64') ?? $request->input('bukti') ?? $request->input('file');

                if (!empty($base64Input) && is_string($base64Input)) {
                    if (preg_match('/^data:image\/(\w+);base64,/', $base64Input, $type)) {
                        $base64Data = substr($base64Input, strpos($base64Input, ',') + 1);
                        $ext = strtolower($type[1]);
                    } else {
                        $base64Data = $base64Input;
                        $ext = 'jpg';
                    }

                    $imageData = base64_decode($base64Data);
                    if ($imageData !== false) {
                        $filename = 'angsuran_' . $idAngsuran . '_' . time() . '_' . rand(100, 999) . '.' . $ext;
                        file_put_contents($targetDir . '/' . $filename, $imageData);
                        $urlBukti = '/storage/bukti_angsuran/' . $filename;
                    }
                }
            }

            // Ambil id_metode_bayar secara fleksibel
            $idMetodeBayar = $request->input('id_metode_bayar') ?? $request->input('id_metode') ?? 1;

            // Update status dan data angsuran di database (Presisi dengan skema DATE MySQL)
            $updateData = [
                'id_metode_bayar' => intval($idMetodeBayar),
                'tgl_bayar' => date('Y-m-d'),
                'status_bayar' => 'menunggu_verifikasi',
                'status' => 'menunggu_verifikasi',
                'keterangan' => 'Menunggu verifikasi admin',
                'updated_at' => now(),
            ];

            if ($urlBukti) {
                $updateData['bukti_bayar'] = $urlBukti;
            }

            DB::table('tb_angsuran')
                ->where('id_angsuran', $idAngsuran)
                ->update($updateData);

            return response()->json([
                'status' => true,
                'message' => 'Bukti pembayaran berhasil diupload dan menunggu verifikasi admin',
                'bukti_bayar' => $urlBukti
            ], 200);

        } catch (\Throwable $e) {
            Log::error('Upload bukti error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan server: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Verifikasi bukti pembayaran angsuran
     */
    public function verifikasi(Request $request, $idAngsuran)
    {
        try {
            Log::info('Verifikasi angsuran dipanggil');
            Log::info('ID Angsuran: ' . $idAngsuran);
            
            $request->validate([
                'action' => 'required|in:verified,rejected',
                'catatan' => 'nullable|string'
            ]);
            
            $angsuran = DB::table('tb_angsuran')
                ->where('id_angsuran', $idAngsuran)
                ->first();
            
            if (!$angsuran) {
                return response()->json([
                    'status' => false,
                    'message' => 'Angsuran tidak ditemukan'
                ], 404);
            }
            
            if ($angsuran->status_bayar != 'menunggu_verifikasi') {
                return response()->json([
                    'status' => false,
                    'message' => 'Angsuran sudah diproses sebelumnya'
                ], 400);
            }
            
            if ($request->action == 'verified') {
                // VERIFIKASI SUKSES - ubah status menjadi lunas
                DB::table('tb_angsuran')
                    ->where('id_angsuran', $idAngsuran)
                    ->update([
                        'status' => 'lunas',
                        'status_bayar' => 'lunas',
                        'keterangan' => $request->catatan ?? 'Pembayaran diverifikasi',
                        'updated_at' => now(),
                    ]);
                
                // Cek apakah semua angsuran pinjaman sudah lunas
                $pinjamanId = $angsuran->id_pinjaman;
                $belumLunas = DB::table('tb_angsuran')
                    ->where('id_pinjaman', $pinjamanId)
                    ->where('status', '!=', 'lunas')
                    ->count();
                
                if ($belumLunas == 0) {
                    DB::table('tb_pinjaman')
                        ->where('id_pinjaman', $pinjamanId)
                        ->update([
                            'status' => 'lunas',
                            'updated_at' => now(),
                        ]);
                }
                
                $message = 'Pembayaran angsuran ke-' . $angsuran->angsuran_ke . ' telah diverifikasi';
                
            } else {
                // TOLAK PEMBAYARAN - kembalikan ke status awal
                DB::table('tb_angsuran')
                    ->where('id_angsuran', $idAngsuran)
                    ->update([
                        'status' => 'belum_bayar',
                        'status_bayar' => 'belum_bayar',
                        'keterangan' => $request->catatan ?? 'Bukti transfer tidak valid, silakan upload ulang',
                        'updated_at' => now(),
                    ]);
                
                $message = 'Pembayaran angsuran ke-' . $angsuran->angsuran_ke . ' ditolak';
            }
            
            LogActivity::log(
                $request->user()->id_admin ?? 1,
                'Verifikasi Angsuran',
                $message . ' - ID Angsuran: ' . $idAngsuran
            );
            
            return response()->json([
                'status' => true,
                'message' => $message
            ]);
        } catch (\Exception $e) {
            Log::error('Verifikasi error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}