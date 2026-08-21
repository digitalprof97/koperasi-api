<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RiwayatController extends Controller
{
    // Riwayat Aktivitas Admin
    public function aktivitas(Request $request)
    {
        try {
            $query = DB::table('tb_log_activity as l')
                ->leftJoin('tb_admin as a', 'l.id_user', '=', 'a.id_admin')
                ->select(
                    'l.*',
                    'a.nama_lengkap as admin_nama',
                    'a.username'
                )
                ->where('l.role_user', 'admin')
                ->orderBy('l.created_at', 'desc');
            
            // Filter tanggal
            if ($request->filled('start_date')) {
                $query->whereDate('l.created_at', '>=', $request->start_date);
            }
            if ($request->filled('end_date')) {
                $query->whereDate('l.created_at', '<=', $request->end_date);
            }
            
            $data = $query->paginate(20);
            
            return response()->json([
                'status' => true,
                'data' => $data
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    // Riwayat Semua Pinjaman
    public function semuaPinjaman(Request $request)
    {
        try {
            $query = DB::table('tb_pinjaman as p')
                ->leftJoin('tb_jemaat as j', 'p.id_jemaat', '=', 'j.id_jemaat')
                ->leftJoin('tb_admin as a', 'p.id_admin_approve', '=', 'a.id_admin')
                ->select(
                    'p.*',
                    'j.nama_lengkap as jemaat_nama',
                    'j.no_anggota',
                    'a.nama_lengkap as admin_nama'
                )
                ->orderBy('p.created_at', 'desc');
            
            // Filter status
            if ($request->filled('status')) {
                $query->where('p.status', $request->status);
            }
            
            // Filter tanggal
            if ($request->filled('start_date')) {
                $query->whereDate('p.created_at', '>=', $request->start_date);
            }
            if ($request->filled('end_date')) {
                $query->whereDate('p.created_at', '<=', $request->end_date);
            }
            
            $data = $query->paginate(20);
            
            return response()->json([
                'status' => true,
                'data' => $data
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    // Riwayat Semua Simpanan
    public function semuaSimpanan(Request $request)
    {
        try {
            $query = DB::table('tb_transaksi_simpanan as s')
                ->leftJoin('tb_jemaat as j', 's.id_jemaat', '=', 'j.id_jemaat')
                ->leftJoin('tb_jenis_simpanan as js', 's.id_jenis_simpanan', '=', 'js.id_jenis_simpanan')
                ->leftJoin('tb_admin as a', 's.id_admin', '=', 'a.id_admin')
                ->select(
                    's.*',
                    'j.nama_lengkap as jemaat_nama',
                    'j.no_anggota',
                    'js.nama_simpanan',
                    'a.nama_lengkap as admin_nama'
                )
                ->orderBy('s.created_at', 'desc');
            
            // Filter jenis simpanan
            if ($request->filled('jenis')) {
                $query->where('s.id_jenis_simpanan', $request->jenis);
            }
            
            // Filter tanggal
            if ($request->filled('start_date')) {
                $query->whereDate('s.created_at', '>=', $request->start_date);
            }
            if ($request->filled('end_date')) {
                $query->whereDate('s.created_at', '<=', $request->end_date);
            }
            
            $data = $query->paginate(20);
            
            return response()->json([
                'status' => true,
                'data' => $data
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    // Log aktivitas (simpan saat admin melakukan sesuatu)
    public function logActivity($userId, $aksi, $deskripsi)
    {
        DB::table('tb_log_activity')->insert([
            'id_user' => $userId,
            'role_user' => 'admin',
            'aksi' => $aksi,
            'deskripsi' => $deskripsi,
            'ip_address' => request()->ip(),
            'user_agent' => request()->userAgent(),
            'created_at' => now()
        ]);
    }
}