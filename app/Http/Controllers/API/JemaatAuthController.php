<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use App\Helpers\DendaHelper;

class JemaatAuthController extends Controller
{
    /**
     * Get profil jemaat yang login
     */
    public function profil(Request $request)
    {
        try {
            $token = $request->bearerToken();
            
            if (!$token) {
                $jemaat = DB::table('tb_jemaat')
                    ->where('id_jemaat', 1)
                    ->select(
                        'id_jemaat', 'no_anggota', 'nama_lengkap', 'email', 'no_hp', 'alamat',
                        'saldo_simpanan_pokok', 'saldo_simpanan_wajib', 'saldo_simpanan_sukarela',
                        'tgl_bergabung', 'foto_profil', 'is_active'
                    )
                    ->first();
                
                return response()->json([
                    'status' => true,
                    'data' => $jemaat
                ]);
            }
            
            $parts = explode('|', $token);
            $jemaatId = $parts[0] ?? 0;
            
            $jemaat = DB::table('tb_jemaat')
                ->where('id_jemaat', $jemaatId)
                ->select(
                    'id_jemaat', 'no_anggota', 'nama_lengkap', 'email', 'no_hp', 'alamat',
                    'saldo_simpanan_pokok', 'saldo_simpanan_wajib', 'saldo_simpanan_sukarela',
                    'tgl_bergabung', 'foto_profil', 'is_active'
                )
                ->first();
            
            if (!$jemaat) {
                return response()->json([
                    'status' => false,
                    'message' => 'Jemaat tidak ditemukan'
                ], 404);
            }
            
            return response()->json([
                'status' => true,
                'data' => $jemaat
            ]);
        } catch (\Exception $e) {
            Log::error('Profil error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Get pinjaman milik jemaat yang login
     */
    public function pinjamanSaya(Request $request)
    {
        try {
            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = $parts[0] ?? 1;
            
            $pinjaman = DB::table('tb_pinjaman')
                ->where('id_jemaat', $jemaatId)
                ->orderBy('id_pinjaman', 'desc')
                ->get();
            
            // Tambahkan kalkulasi dana resiko 1% dan dana diterima 99%
            foreach ($pinjaman as $p) {
                $jumlah = (float) $p->jumlah_pinjaman;
                $p->dana_resiko = round($jumlah * 0.01, 2);
                $p->dana_diterima = round($jumlah - $p->dana_resiko, 2);
                $p->keterangan_resiko = 'Dipotong 1% sebagai dana risiko pinjaman. Peminjam menerima 99% dari total pinjaman.';
            }

            return response()->json([
                'status' => true,
                'data' => $pinjaman
            ]);
        } catch (\Exception $e) {
            Log::error('Pinjaman saya error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Get simpanan milik jemaat yang login
     */
    public function simpananSaya(Request $request)
    {
        try {
            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = $parts[0] ?? 1;
            
            $simpanan = DB::table('tb_transaksi_simpanan')
                ->where('id_jemaat', $jemaatId)
                ->orderBy('created_at', 'desc')
                ->get();
            
            return response()->json([
                'status' => true,
                'data' => $simpanan
            ]);
        } catch (\Exception $e) {
            Log::error('Simpanan saya error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Ajukan pinjaman baru (DENGAN DANA RESIKO 1%, ATURAN TENOR & BUNGA MENURUN TIAP BULAN)
     */
    public function ajukanPinjaman(Request $request)
    {
        try {
            Log::info('Ajukan pinjaman dipanggil. All request: ' . json_encode($request->all()));

            $validator = Validator::make($request->all(), [
                'id_produk_pinjaman' => 'required|integer',
                'jumlah_pinjaman' => 'required|numeric|min:0',
                'tenor' => 'required|integer|min:1',
                'deskripsi_jaminan' => 'nullable|string',
            ]);
            
            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $jumlahPinjaman = (float) $request->jumlah_pinjaman;
            $tenor = (int) $request->tenor;

            // Validasi batas tenor: < 10 jt max 20 bulan, >= 10 jt max 60 bulan
            $maxTenor = ($jumlahPinjaman < 10000000) ? 20 : 60;
            if ($tenor > $maxTenor) {
                return response()->json([
                    'status' => false,
                    'message' => ($jumlahPinjaman < 10000000)
                        ? 'Pinjaman di bawah Rp 10.000.000 maksimal tenor 20 bulan'
                        : 'Pinjaman Rp 10.000.000 ke atas maksimal tenor 60 bulan'
                ], 400);
            }

            // Ambil ID jemaat dari token bearer secara aman
            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = intval($parts[0] ?? 1);
            if ($jemaatId <= 0) { $jemaatId = 1; }
            
            // Ambil produk pinjaman
            $produk = DB::table('tb_produk_pinjaman')
                ->where('id_produk_pinjaman', $request->id_produk_pinjaman)
                ->first();
                
            if (!$produk) {
                return response()->json([
                    'status' => false,
                    'message' => 'Produk pinjaman tidak ditemukan'
                ], 404);
            }
            
            // Validasi batas minimal dan maksimal produk
            if ($jumlahPinjaman < $produk->minimal_pinjaman) {
                return response()->json([
                    'status' => false,
                    'message' => 'Jumlah pinjaman minimal Rp ' . number_format($produk->minimal_pinjaman, 0, ',', '.')
                ], 400);
            }
            
            if ($jumlahPinjaman > $produk->maksimal_pinjaman) {
                return response()->json([
                    'status' => false,
                    'message' => 'Jumlah pinjaman maksimal Rp ' . number_format($produk->maksimal_pinjaman, 0, ',', '.')
                ], 400);
            }
            
            // Penanganan upload file jaminan
            $urlJaminan = null;
            $targetDir = storage_path('app/public/jaminan');
            if (!file_exists($targetDir)) {
                @mkdir($targetDir, 0777, true);
            }

            if ($request->hasFile('jaminan')) {
                $file = $request->file('jaminan');
                if ($file && $file->isValid()) {
                    $filename = 'jaminan_' . $jemaatId . '_' . time() . '_' . rand(100, 999) . '.' . $file->getClientOriginalExtension();
                    $file->move($targetDir, $filename);
                    $urlJaminan = '/storage/jaminan/' . $filename;
                }
            }

            if (!$urlJaminan && !empty($_FILES)) {
                foreach ($_FILES as $key => $fileData) {
                    if (isset($fileData['tmp_name']) && is_uploaded_file($fileData['tmp_name'])) {
                        $origName = $fileData['name'] ?? 'jaminan.jpg';
                        $ext = strtolower(pathinfo($origName, PATHINFO_EXTENSION));
                        if (empty($ext)) { $ext = 'jpg'; }

                        $filename = 'jaminan_' . $jemaatId . '_' . time() . '_' . rand(100, 999) . '.' . $ext;
                        $destination = $targetDir . '/' . $filename;

                        if (@move_uploaded_file($fileData['tmp_name'], $destination) || @copy($fileData['tmp_name'], $destination)) {
                            $urlJaminan = '/storage/jaminan/' . $filename;
                            break;
                        }
                    }
                }
            }

            // Perhitungan estimasi angsuran bulan ke-1 (Bunga 1.5% dari seluruh sisa pokok awal)
            $bungaPersen = 1.5;
            $pokokPerBulan = $jumlahPinjaman / $tenor;
            $bungaBulanPertama = $jumlahPinjaman * ($bungaPersen / 100);
            $angsuranBulanPertama = $pokokPerBulan + $bungaBulanPertama + ($produk->biaya_admin ?? 0);
            
            // Hitung Dana Risiko 1% dan Dana Bersih Diterima 99%
            $danaResiko = round($jumlahPinjaman * 0.01, 2);
            $danaDiterima = round($jumlahPinjaman - $danaResiko, 2);
            $keteranganResiko = 'Dipotong 1% (Rp ' . number_format($danaResiko, 0, ',', '.') . ') sebagai dana risiko pinjaman. Peminjam menerima 99% (Rp ' . number_format($danaDiterima, 0, ',', '.') . ') dari total pinjaman. Suku bunga menurun setiap bulan: 1.5% dari sisa pokok di awal, turun ke 1.25% setelah melewati 50% pembayaran.';

            // Buat kode pinjaman
            $kodePinjaman = 'PJM' . date('Ymd') . rand(100, 999);
            
            // Simpan ke database
            $id = DB::table('tb_pinjaman')->insertGetId([
                'id_jemaat' => $jemaatId,
                'id_produk_pinjaman' => $request->id_produk_pinjaman,
                'kode_pinjaman' => $kodePinjaman,
                'jumlah_pinjaman' => $jumlahPinjaman,
                'tenor' => $tenor,
                'bunga_persen' => $bungaPersen,
                'biaya_admin' => $produk->biaya_admin ?? 0,
                'biaya_asuransi' => 0.00,
                'angsuran_per_bulan' => $angsuranBulanPertama,
                'status' => 'diajukan',
                'tgl_pengajuan' => date('Y-m-d'),
                'jaminan' => $urlJaminan,
                'deskripsi_jaminan' => $request->deskripsi_jaminan,
                'catatan_internal' => $keteranganResiko,
                'created_at' => now(),
            ]);
            
            Log::info('Pinjaman berhasil diajukan ID: ' . $id);
            
            return response()->json([
                'status' => true,
                'message' => 'Pengajuan pinjaman berhasil',
                'data' => [
                    'id_pinjaman' => $id,
                    'dana_resiko' => $danaResiko,
                    'dana_diterima' => $danaDiterima,
                    'keterangan_resiko' => $keteranganResiko
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Ajukan pinjaman error: ' . $e->getMessage() . ' line: ' . $e->getLine());
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan server: ' . $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Get daftar angsuran untuk pinjaman tertentu
     */
    public function angsuranByPinjaman(Request $request, $idPinjaman)
    {
        try {
            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = $parts[0] ?? 0;
            
            $pinjaman = DB::table('tb_pinjaman')
                ->where('id_pinjaman', $idPinjaman)
                ->where('id_jemaat', $jemaatId)
                ->first();
            
            if (!$pinjaman) {
                return response()->json([
                    'status' => false,
                    'message' => 'Pinjaman tidak ditemukan'
                ], 404);
            }
            
            $angsuran = DB::table('tb_angsuran')
                ->where('id_pinjaman', $idPinjaman)
                ->orderBy('angsuran_ke', 'asc')
                ->get();

            // HITUNG & SINKRON DENDA KETERLAMBATAN DARI BUNGA
            foreach ($angsuran as $item) {
                if ($item->status !== 'lunas') {
                    $nominalBunga = (float) ($item->jumlah_bunga ?? 0);
                    $dendaBaru = DendaHelper::hitung($nominalBunga, $item->tgl_jatuh_tempo);
                    if ((float) $item->denda !== $dendaBaru) {
                        DB::table('tb_angsuran')
                            ->where('id_angsuran', $item->id_angsuran)
                            ->update(['denda' => $dendaBaru]);
                        $item->denda = $dendaBaru;
                    }
                }
            }
            
            return response()->json([
                'status' => true,
                'data' => $angsuran
            ]);
        } catch (\Exception $e) {
            Log::error('Angsuran by pinjaman error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Upload bukti pembayaran angsuran
     */
    public function uploadBuktiAngsuran(Request $request, $idAngsuran)
    {
        try {
            Log::info('Upload bukti angsuran dipanggil untuk ID: ' . $idAngsuran);

            $angsuran = DB::table('tb_angsuran')
                ->where('id_angsuran', $idAngsuran)
                ->first();
                
            if (!$angsuran) {
                return response()->json([
                    'status' => false,
                    'message' => 'Angsuran tidak ditemukan'
                ], 404);
            }
            
            if ($angsuran->status == 'lunas') {
                return response()->json([
                    'status' => false,
                    'message' => 'Angsuran sudah lunas, tidak bisa upload ulang'
                ], 400);
            }

            $urlBukti = null;
            $targetDir = storage_path('app/public/bukti_angsuran');
            
            if (!file_exists($targetDir)) {
                @mkdir($targetDir, 0777, true);
            }

            if (!empty($_FILES)) {
                foreach ($_FILES as $key => $fileData) {
                    if (isset($fileData['tmp_name']) && is_uploaded_file($fileData['tmp_name'])) {
                        $origName = $fileData['name'] ?? 'bukti.jpg';
                        $ext = strtolower(pathinfo($origName, PATHINFO_EXTENSION));
                        if (empty($ext)) { $ext = 'jpg'; }

                        $filename = 'angsuran_' . $idAngsuran . '_' . time() . '_' . rand(100, 999) . '.' . $ext;
                        $destination = $targetDir . '/' . $filename;

                        if (@move_uploaded_file($fileData['tmp_name'], $destination) || @copy($fileData['tmp_name'], $destination)) {
                            $urlBukti = '/storage/bukti_angsuran/' . $filename;
                            break;
                        }
                    }
                }
            }

            $idMetodeBayar = $request->input('id_metode_bayar') ?? 1;
            $tglBayarHariIni = date('Y-m-d');

            // KUNCI DENDA DI TANGGAL PEMBAYARAN DARI BUNGA
            $nominalBunga = (float) ($angsuran->jumlah_bunga ?? 0);
            $dendaFinal = DendaHelper::hitung($nominalBunga, $angsuran->tgl_jatuh_tempo, $tglBayarHariIni);

            $updateData = [
                'id_metode_bayar' => intval($idMetodeBayar),
                'tgl_bayar' => $tglBayarHariIni,
                'denda' => $dendaFinal,
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
                'message' => 'Bukti pembayaran berhasil diupload',
                'bukti_bayar' => $urlBukti,
                'denda' => $dendaFinal
            ], 200);

        } catch (\Exception $e) {
            Log::error('Upload error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update profil jemaat
     */
    public function updateProfil(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nama_lengkap' => 'required|string|max:100',
                'email' => 'nullable|email|max:100',
                'no_hp' => 'nullable|string|max:15',
                'alamat' => 'nullable|string',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = $parts[0] ?? 0;

            DB::table('tb_jemaat')
                ->where('id_jemaat', $jemaatId)
                ->update([
                    'nama_lengkap' => $request->nama_lengkap,
                    'email' => $request->email,
                    'no_hp' => $request->no_hp,
                    'alamat' => $request->alamat,
                    'updated_at' => now(),
                ]);

            return response()->json([
                'status' => true,
                'message' => 'Profil berhasil diupdate'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Upload foto profil jemaat
     */
    public function uploadFoto(Request $request)
    {
        try {
            if (!$request->hasFile('foto')) {
                return response()->json([
                    'status' => false,
                    'message' => 'Tidak ada file yang diupload'
                ], 400);
            }
            
            $file = $request->file('foto');
            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = $parts[0] ?? 0;
            
            if (!Storage::exists('public/jemaat_foto')) {
                Storage::makeDirectory('public/jemaat_foto');
            }
            
            $filename = 'jemaat_' . $jemaatId . '_' . time() . '.' . $file->getClientOriginalExtension();
            $file->storeAs('public/jemaat_foto', $filename);
            $url = '/storage/jemaat_foto/' . $filename;
            
            DB::table('tb_jemaat')
                ->where('id_jemaat', $jemaatId)
                ->update([
                    'foto_profil' => $url,
                    'updated_at' => now(),
                ]);
            
            return response()->json([
                'status' => true,
                'message' => 'Foto profil berhasil diupload',
                'url' => $url
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Ganti password jemaat
     */
    public function gantiPassword(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'password_lama' => 'required|string',
                'password_baru' => 'required|string|min:4',
                'konfirmasi_password' => 'required|same:password_baru',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = $parts[0] ?? 0;

            $jemaat = DB::table('tb_jemaat')
                ->where('id_jemaat', $jemaatId)
                ->first();

            if (!$jemaat) {
                return response()->json([
                    'status' => false,
                    'message' => 'Jemaat tidak ditemukan'
                ], 404);
            }

            DB::table('tb_jemaat')
                ->where('id_jemaat', $jemaatId)
                ->update([
                    'password_hash' => $request->password_baru,
                    'updated_at' => now(),
                ]);

            return response()->json([
                'status' => true,
                'message' => 'Password berhasil diganti'
            ]);
        } catch (\Exception $e) {
            Log::error('Ganti password error: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
