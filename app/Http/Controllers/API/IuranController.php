<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Helpers\LogActivity;

class IuranController extends Controller
{
    /**
     * Nama bulan untuk keterangan transaksi simpanan
     */
    private function namaBulan($bulan)
    {
        $namaBulan = [
            1 => 'Januari', 2 => 'Februari', 3 => 'Maret', 4 => 'April',
            5 => 'Mei', 6 => 'Juni', 7 => 'Juli', 8 => 'Agustus',
            9 => 'September', 10 => 'Oktober', 11 => 'November', 12 => 'Desember'
        ];
        return $namaBulan[$bulan] ?? $bulan;
    }

    /**
     * ============ JEMAAT ============
     * Get daftar iuran milik jemaat yang login
     */
    public function iuranSaya(Request $request)
    {
        try {
            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = $parts[0] ?? 1;

            $iuran = DB::table('tb_iuran as a')
                ->leftJoin('tb_metode_pembayaran as m', 'a.id_metode_bayar', '=', 'm.id_metode')
                ->select(
                    'a.id_iuran',
                    'a.id_jemaat',
                    'a.jenis_iuran',
                    'a.bulan',
                    'a.tahun',
                    'a.nominal',
                    'a.status',
                    'a.tgl_jatuh_tempo',
                    'a.tgl_bayar',
                    'a.bukti_bayar',
                    'a.id_metode_bayar',
                    'a.keterangan',
                    'm.nama_metode'
                )
                ->where('a.id_jemaat', $jemaatId)
                ->orderBy('a.tahun', 'asc')
                ->orderBy('a.bulan', 'asc')
                ->get();

            return response()->json([
                'status' => true,
                'data' => $iuran
            ]);
        } catch (\Exception $e) {
            Log::error('Iuran saya error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ============ JEMAAT ============
     * Upload bukti bayar iuran oleh jemaat
     */
    public function uploadBukti(Request $request, $idIuran)
    {
        try {
            Log::info('Upload bukti iuran dipanggil untuk ID: ' . $idIuran);

            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = intval($parts[0] ?? 1);

            $iuran = DB::table('tb_iuran')
                ->where('id_iuran', $idIuran)
                ->first();

            if (!$iuran) {
                return response()->json([
                    'status' => false,
                    'message' => 'Data iuran tidak ditemukan'
                ], 404);
            }

            $urlBukti = null;
            $targetDir = storage_path('app/public/bukti_iuran');

            if (!file_exists($targetDir)) {
                @mkdir($targetDir, 0777, true);
            }

            // 1. Cek pengiriman file via Laravel Request / Multipart
            if ($request->hasFile('bukti_bayar') || $request->hasFile('bukti') || $request->hasFile('file')) {
                $file = $request->file('bukti_bayar') ?? $request->file('bukti') ?? $request->file('file');
                if ($file && $file->isValid()) {
                    $filename = 'iuran_' . $idIuran . '_' . time() . '_' . rand(100, 999) . '.' . $file->getClientOriginalExtension();
                    $file->move($targetDir, $filename);
                    $urlBukti = '/storage/bukti_iuran/' . $filename;
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

                        $filename = 'iuran_' . $idIuran . '_' . time() . '_' . rand(100, 999) . '.' . $ext;
                        $destination = $targetDir . '/' . $filename;

                        if (@move_uploaded_file($fileData['tmp_name'], $destination) || @copy($fileData['tmp_name'], $destination)) {
                            $urlBukti = '/storage/bukti_iuran/' . $filename;
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
                        $filename = 'iuran_' . $idIuran . '_' . time() . '_' . rand(100, 999) . '.' . $ext;
                        file_put_contents($targetDir . '/' . $filename, $imageData);
                        $urlBukti = '/storage/bukti_iuran/' . $filename;
                    }
                }
            }

            // Ambil id_metode_bayar secara fleksibel
            $idMetodeBayar = $request->input('id_metode_bayar') ?? $request->input('id_metode') ?? 1;

            $updateData = [
                'id_metode_bayar' => intval($idMetodeBayar),
                'tgl_bayar' => date('Y-m-d'),
                'status' => 'menunggu_verifikasi',
                'keterangan' => 'Menunggu verifikasi admin',
                'updated_at' => now(),
            ];

            if ($urlBukti) {
                $updateData['bukti_bayar'] = $urlBukti;
            }

            // Iuran sukarela: nominal ditentukan sendiri oleh jemaat saat bayar
            $nominalInput = $request->input('nominal');
            if ($nominalInput !== null && is_numeric($nominalInput) && floatval($nominalInput) > 0) {
                $updateData['nominal'] = floatval($nominalInput);
            }

            DB::table('tb_iuran')
                ->where('id_iuran', $idIuran)
                ->update($updateData);

            return response()->json([
                'status' => true,
                'message' => 'Bukti pembayaran berhasil diupload dan menunggu verifikasi admin',
                'bukti_bayar' => $urlBukti
            ], 200);

        } catch (\Throwable $e) {
            Log::error('Upload bukti iuran error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan server: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * ============ ADMIN ============
     * Get semua data iuran (untuk verifikasi admin) dengan filter tepat:
     * 1. Menunggu verifikasi (kapanpun bulannya) -> Muncul
     * 2. Sudah lunas -> Muncul
     * 3. Belum bayar -> Hanya muncul jika bulannya <= bulan berjalan (bulan ini/sebelumnya)
     */
    public function semuaIuran(Request $request)
    {
        try {
            $currentYear = intval(date('Y'));
            $currentMonth = intval(date('n'));

            $query = DB::table('tb_iuran as a')
                ->join('tb_jemaat as j', 'a.id_jemaat', '=', 'j.id_jemaat')
                ->leftJoin('tb_metode_pembayaran as m', 'a.id_metode_bayar', '=', 'm.id_metode')
                ->select(
                    'a.id_iuran',
                    'a.id_jemaat',
                    'a.jenis_iuran',
                    'a.bulan',
                    'a.tahun',
                    'a.nominal',
                    'a.status',
                    'a.tgl_jatuh_tempo',
                    'a.tgl_bayar',
                    'a.bukti_bayar',
                    'a.id_metode_bayar',
                    'a.keterangan',
                    'j.nama_lengkap',
                    'j.no_anggota',
                    'm.nama_metode'
                );

            if ($request->filled('bulan')) {
                $query->where('a.bulan', $request->bulan);
            }
            if ($request->filled('tahun')) {
                $query->where('a.tahun', $request->tahun);
            }
            if ($request->filled('status')) {
                $query->where('a.status', $request->status);
            }

            // ATURAN ATURAN LOGIKA BISNIS:
            // Sembunyikan 'belum_bayar' yang belum masuk bulannya (bulan depan / tahun depan)
            $query->where(function ($q) use ($currentYear, $currentMonth) {
                $q->where('a.status', '!=', 'belum_bayar')
                  ->orWhere(function ($q2) use ($currentYear, $currentMonth) {
                      $q2->where('a.tahun', '<', $currentYear)
                         ->orWhere(function ($q3) use ($currentYear, $currentMonth) {
                             $q3->where('a.tahun', '=', $currentYear)
                                ->where('a.bulan', '<=', $currentMonth);
                         });
                  });
            });

            // Urutkan agar 'menunggu_verifikasi' selalu berada di paling atas
            $iuran = $query->orderByRaw("FIELD(a.status,'menunggu_verifikasi','belum_bayar','ditolak','lunas')")
                ->orderBy('a.updated_at', 'desc')
                ->get();

            return response()->json([
                'status' => true,
                'data' => $iuran
            ]);
        } catch (\Exception $e) {
            Log::error('Semua iuran error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ============ ADMIN ============
     * Statistik iuran (total, lunas, menunggu, belum bayar)
     */
    public function statistik(Request $request)
    {
        try {
            $currentYear = intval(date('Y'));
            $currentMonth = intval(date('n'));

            $query = DB::table('tb_iuran');

            if ($request->filled('bulan')) {
                $query->where('bulan', $request->bulan);
            }
            if ($request->filled('tahun')) {
                $query->where('tahun', $request->tahun);
            }

            // Sembunyikan 'belum_bayar' yang belum masuk bulannya
            $query->where(function ($q) use ($currentYear, $currentMonth) {
                $q->where('status', '!=', 'belum_bayar')
                  ->orWhere(function ($q2) use ($currentYear, $currentMonth) {
                      $q2->where('tahun', '<', $currentYear)
                         ->orWhere(function ($q3) use ($currentYear, $currentMonth) {
                             $q3->where('tahun', '=', $currentYear)
                                ->where('bulan', '<=', $currentMonth);
                         });
                  });
            });

            $total = (clone $query)->count();
            $lunas = (clone $query)->where('status', 'lunas')->count();
            $menunggu = (clone $query)->where('status', 'menunggu_verifikasi')->count();
            $belumBayar = (clone $query)->whereIn('status', ['belum_bayar', 'ditolak'])->count();

            return response()->json([
                'status' => true,
                'data' => [
                    'total_iuran' => $total,
                    'lunas' => $lunas,
                    'menunggu' => $menunggu,
                    'belum_bayar' => $belumBayar,
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Statistik iuran error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ============ ADMIN ============
     * Verifikasi bukti pembayaran iuran.
     */
    public function verifikasi(Request $request, $idIuran)
    {
        try {
            Log::info('Verifikasi iuran dipanggil');
            Log::info('ID Iuran: ' . $idIuran);

            $request->validate([
                'action' => 'required|in:verified,rejected',
                'catatan' => 'nullable|string'
            ]);

            $iuran = DB::table('tb_iuran')
                ->where('id_iuran', $idIuran)
                ->first();

            if (!$iuran) {
                return response()->json([
                    'status' => false,
                    'message' => 'Iuran tidak ditemukan'
                ], 404);
            }

            if ($iuran->status != 'menunggu_verifikasi') {
                return response()->json([
                    'status' => false,
                    'message' => 'Iuran sudah diproses sebelumnya'
                ], 400);
            }

            if ($request->action == 'verified') {
                // VERIFIKASI SUKSES - ubah status iuran menjadi lunas
                DB::table('tb_iuran')
                    ->where('id_iuran', $idIuran)
                    ->update([
                        'status' => 'lunas',
                        'tgl_bayar' => $iuran->tgl_bayar ?? date('Y-m-d'),
                        'keterangan' => $request->catatan ?? 'Pembayaran diverifikasi',
                        'updated_at' => now(),
                    ]);

                // OTOMATIS TAMBAH SIMPANAN JEMAAT
                $idJenisSimpanan = $iuran->jenis_iuran == 'wajib' ? 2 : 3;
                $nominalSimpanan = floatval($iuran->nominal);

                if ($nominalSimpanan > 0) {
                    DB::table('tb_transaksi_simpanan')->insert([
                        'id_jemaat' => $iuran->id_jemaat,
                        'id_jenis_simpanan' => $idJenisSimpanan,
                        'id_metode' => $iuran->id_metode_bayar ?? 1,
                        'id_admin' => $request->user()->id_admin ?? 1,
                        'jumlah' => $nominalSimpanan,
                        'kode_transaksi' => 'IUR' . date('Ymd') . rand(100, 999),
                        'status' => 'sukses',
                        'catatan' => 'Iuran ' . ucfirst($iuran->jenis_iuran) . ' - ' . $this->namaBulan($iuran->bulan) . ' ' . $iuran->tahun,
                        'tgl_transaksi' => date('Y-m-d'),
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }

                $message = 'Iuran ' . $iuran->jenis_iuran . ' bulan ' . $this->namaBulan($iuran->bulan) . ' ' . $iuran->tahun . ' telah diverifikasi dan simpanan otomatis bertambah';

            } else {
                // TOLAK PEMBAYARAN - kembalikan ke status belum bayar
                DB::table('tb_iuran')
                    ->where('id_iuran', $idIuran)
                    ->update([
                        'status' => 'belum_bayar',
                        'keterangan' => $request->catatan ?? 'Bukti transfer tidak valid, silakan upload ulang',
                        'updated_at' => now(),
                    ]);

                $message = 'Pembayaran iuran bulan ' . $this->namaBulan($iuran->bulan) . ' ' . $iuran->tahun . ' ditolak';
            }

            LogActivity::log(
                $request->user()->id_admin ?? 1,
                'Verifikasi Iuran',
                $message . ' - ID Iuran: ' . $idIuran
            );

            return response()->json([
                'status' => true,
                'message' => $message
            ]);
        } catch (\Exception $e) {
            Log::error('Verifikasi iuran error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}