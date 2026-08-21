<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Helpers\LogActivity;

class JemaatController extends Controller
{
    // GET semua jemaat
    public function index()
    {
        try {
            $jemaat = DB::table('tb_jemaat')
                ->select(
                    'id_jemaat',
                    'no_anggota',
                    'nama_lengkap',
                    'nik',
                    'tempat_lahir',
                    'tanggal_lahir',
                    'email',
                    'no_hp',
                    'alamat',
                    'lingkungan',
                    'saldo_simpanan_pokok',
                    'saldo_simpanan_wajib',
                    'saldo_simpanan_sukarela',
                    'is_active',
                    'tgl_bergabung'
                )
                ->orderBy('id_jemaat', 'desc')
                ->get();

            return response()->json([
                'status' => true,
                'data' => $jemaat
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // GET detail jemaat
    public function show($id)
    {
        try {
            $jemaat = DB::table('tb_jemaat')
                ->where('id_jemaat', $id)
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
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // CREATE jemaat (Menambahkan NIK, Tempat Lahir, dan Tanggal Lahir agar tersimpan sempurna)
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nama_lengkap' => 'required|string|max:100',
                'nik' => 'nullable|string|max:20',
                'tempat_lahir' => 'nullable|string|max:100',
                'tanggal_lahir' => 'nullable|date',
                'email' => 'nullable|email|max:100',
                'no_hp' => 'nullable|string|max:15',
                'alamat' => 'nullable|string',
                'lingkungan' => 'nullable|string|max:50',
                'tgl_bergabung' => 'nullable|date',
                'password' => 'nullable|string',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Ambil no_anggota terbesar secara numerik
            $maxNoAnggota = DB::table('tb_jemaat')->max(DB::raw('CAST(no_anggota AS UNSIGNED)'));
            $nextNoAnggota = $maxNoAnggota ? ($maxNoAnggota + 1) : 1;

            $id = DB::table('tb_jemaat')->insertGetId([
                'no_anggota' => (string)$nextNoAnggota,
                'nama_lengkap' => $request->nama_lengkap,
                'nik' => $request->nik,
                'tempat_lahir' => $request->tempat_lahir,
                'tanggal_lahir' => $request->tanggal_lahir,
                'email' => $request->email,
                'no_hp' => $request->no_hp,
                'alamat' => $request->alamat,
                'lingkungan' => $request->lingkungan,
                'tgl_bergabung' => $request->tgl_bergabung ?? date('Y-m-d'),
                'password_hash' => $request->password ?? '123456',
                'is_active' => 1,
                'created_at' => now(),
            ]);

            LogActivity::log(1, 'Tambah Jemaat', 'Menambah jemaat: ' . $request->nama_lengkap . ' (No Anggota: ' . $nextNoAnggota . ')');

            return response()->json([
                'status' => true,
                'message' => 'Jemaat berhasil ditambahkan',
                'id' => $id,
                'no_anggota' => (string)$nextNoAnggota
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // UPDATE jemaat
    public function update(Request $request, $id)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nama_lengkap' => 'required|string|max:100',
                'nik' => 'nullable|string|max:20',
                'tempat_lahir' => 'nullable|string|max:100',
                'tanggal_lahir' => 'nullable|date',
                'email' => 'nullable|email|max:100',
                'no_hp' => 'nullable|string|max:15',
                'alamat' => 'nullable|string',
                'lingkungan' => 'nullable|string|max:50',
                'is_active' => 'nullable|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $exists = DB::table('tb_jemaat')
                ->where('id_jemaat', $id)
                ->exists();

            if (!$exists) {
                return response()->json([
                    'status' => false,
                    'message' => 'Jemaat tidak ditemukan'
                ], 404);
            }

            $updateData = [
                'nama_lengkap' => $request->nama_lengkap,
                'nik' => $request->nik,
                'tempat_lahir' => $request->tempat_lahir,
                'tanggal_lahir' => $request->tanggal_lahir,
                'email' => $request->email,
                'no_hp' => $request->no_hp,
                'alamat' => $request->alamat,
                'lingkungan' => $request->lingkungan,
                'is_active' => $request->is_active ?? 1,
                'updated_at' => now(),
            ];

            if ($request->filled('password')) {
                $updateData['password_hash'] = $request->password;
            }

            DB::table('tb_jemaat')
                ->where('id_jemaat', $id)
                ->update($updateData);

            LogActivity::log(1, 'Edit Jemaat', 'Mengedit jemaat ID: ' . $id . ' - ' . $request->nama_lengkap);

            return response()->json([
                'status' => true,
                'message' => 'Jemaat berhasil diupdate'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // DELETE jemaat
    public function destroy($id)
    {
        try {
            $exists = DB::table('tb_jemaat')
                ->where('id_jemaat', $id)
                ->exists();

            if (!$exists) {
                return response()->json([
                    'status' => false,
                    'message' => 'Jemaat tidak ditemukan'
                ], 404);
            }

            $hasActiveLoan = DB::table('tb_pinjaman')
                ->where('id_jemaat', $id)
                ->whereNotIn('status', ['lunas', 'ditolak'])
                ->exists();

            if ($hasActiveLoan) {
                return response()->json([
                    'status' => false,
                    'message' => 'Jemaat tidak bisa dihapus karena memiliki pinjaman aktif'
                ], 400);
            }

            DB::table('tb_jemaat')
                ->where('id_jemaat', $id)
                ->delete();

            LogActivity::log(1, 'Hapus Jemaat', 'Menghapus jemaat ID: ' . $id);

            return response()->json([
                'status' => true,
                'message' => 'Jemaat berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}