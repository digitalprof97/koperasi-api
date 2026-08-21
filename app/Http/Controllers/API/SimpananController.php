<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use App\Helpers\LogActivity;

class SimpananController extends Controller
{
    /**
     * Get riwayat simpanan untuk jemaat yang login
     */
    public function riwayatSaya(Request $request)
    {
        try {
            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $jemaatId = $parts[0] ?? 0;
            
            $riwayat = DB::table('tb_transaksi_simpanan as s')
                ->leftJoin('tb_jenis_simpanan as j', 's.id_jenis_simpanan', '=', 'j.id_jenis_simpanan')
                ->where('s.id_jemaat', $jemaatId)
                ->select('s.*', 'j.nama_simpanan')
                ->orderBy('s.created_at', 'desc')
                ->get();
            
            return response()->json([
                'status' => true,
                'data' => $riwayat
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Get semua transaksi simpanan (untuk admin)
     */
    public function semuaSimpanan(Request $request)
    {
        try {
            $simpanan = DB::table('tb_transaksi_simpanan as s')
                ->leftJoin('tb_jemaat as j', 's.id_jemaat', '=', 'j.id_jemaat')
                ->leftJoin('tb_jenis_simpanan as js', 's.id_jenis_simpanan', '=', 'js.id_jenis_simpanan')
                ->select(
                    's.*',
                    'j.nama_lengkap',
                    'j.no_anggota',
                    'js.nama_simpanan'
                )
                ->orderBy('s.created_at', 'desc')
                ->get();
            
            return response()->json([
                'status' => true,
                'data' => $simpanan
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Admin tambah simpanan manual (REVISI 2: Otomatis Menambah Saldo Simpanan Jemaat)
     */
    public function tambahSimpanan(Request $request)
    {
        try {
            $request->validate([
                'id_jemaat' => 'required|integer|exists:tb_jemaat,id_jemaat',
                'id_jenis_simpanan' => 'required|integer|exists:tb_jenis_simpanan,id_jenis_simpanan',
                'jumlah' => 'required|numeric|min:0',
                'keterangan' => 'nullable|string',
            ]);
            
            $id = DB::table('tb_transaksi_simpanan')->insertGetId([
                'id_jemaat' => $request->id_jemaat,
                'id_jenis_simpanan' => $request->id_jenis_simpanan,
                'id_metode' => 1, // Tunai
                'id_admin' => $request->user()->id_admin ?? 1,
                'jumlah' => $request->jumlah,
                'kode_transaksi' => 'SMP' . date('Ymd') . rand(100, 999),
                'status' => 'sukses',
                'catatan' => $request->keterangan,
                'tgl_transaksi' => date('Y-m-d'),
                'created_at' => now(),
            ]);
            
            // 🔥 REVISI 2: OTOMATIS TAMBAH SALDO SIMPANAN JEMAAT
            $jenisSimpanan = DB::table('tb_jenis_simpanan')
                ->where('id_jenis_simpanan', $request->id_jenis_simpanan)
                ->first();

            $kolomSaldo = 'saldo_simpanan_sukarela'; // Default ke sukarela

            if ($jenisSimpanan) {
                $nama = strtolower($jenisSimpanan->nama_simpanan ?? '');
                if (str_contains($nama, 'pokok') || $request->id_jenis_simpanan == 1) {
                    $kolomSaldo = 'saldo_simpanan_pokok';
                } else if (str_contains($nama, 'wajib') || $request->id_jenis_simpanan == 2) {
                    $kolomSaldo = 'saldo_simpanan_wajib';
                }
            }

            // Eksekusi penambahan saldo otomatis di tb_jemaat
            DB::table('tb_jemaat')
                ->where('id_jemaat', $request->id_jemaat)
                ->increment($kolomSaldo, $request->jumlah);

            LogActivity::log(
                $request->user()->id_admin ?? 1,
                'Tambah Simpanan',
                'Menambah simpanan untuk jemaat ID ' . $request->id_jemaat . ' sebesar Rp ' . number_format($request->jumlah, 0, ',', '.') . ' (Saldo Otomatis Bertambah)'
            );
            
            return response()->json([
                'status' => true,
                'message' => 'Simpanan berhasil ditambahkan dan saldo jemaat otomatis bertambah',
                'id' => $id
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Get jenis simpanan untuk dropdown
     */
    public function getJenisSimpanan()
    {
        $jenis = DB::table('tb_jenis_simpanan')
            ->where('is_active', 1)
            ->get();
        
        return response()->json([
            'status' => true,
            'data' => $jenis
        ]);
    }
}