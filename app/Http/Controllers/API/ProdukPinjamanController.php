<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ProdukPinjamanController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $produk = DB::table('tb_produk_pinjaman')
                ->orderBy('id_produk_pinjaman', 'desc')
                ->get();

            return response()->json([
                'status' => true,
                'message' => 'Data produk pinjaman berhasil diambil',
                'data' => $produk
            ]);
        } catch (\Exception $e) {
            Log::error('Error get produk: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            Log::info('Store produk request: ' . json_encode($request->all()));

            $validator = validator($request->all(), [
                'nama_produk' => 'required|string|max:100',
                'tenor_min' => 'required|integer|min:1',
                'tenor_max' => 'required|integer|min:1',
                'tenor_default' => 'required|integer|min:1',
                'bunga_persen' => 'required|numeric|min:0',
                'biaya_admin' => 'required|numeric|min:0',
                'denda_perhari_persen' => 'required|numeric|min:0',
                'maksimal_pinjaman' => 'required|numeric|min:0',
                'minimal_pinjaman' => 'required|numeric|min:0',
                'is_active' => 'required|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $id = DB::table('tb_produk_pinjaman')->insertGetId([
                'nama_produk' => $request->nama_produk,
                'tenor_min' => $request->tenor_min,
                'tenor_max' => $request->tenor_max,
                'tenor_default' => $request->tenor_default,
                'bunga_persen' => $request->bunga_persen,
                'biaya_admin' => $request->biaya_admin,
                'denda_perhari_persen' => $request->denda_perhari_persen,
                'maksimal_pinjaman' => $request->maksimal_pinjaman,
                'minimal_pinjaman' => $request->minimal_pinjaman,
                'is_active' => $request->is_active,
                'created_at' => now(),
            ]);

            Log::info('Produk created with ID: ' . $id);

            return response()->json([
                'status' => true,
                'message' => 'Produk pinjaman berhasil ditambahkan',
                'id' => $id
            ]);
        } catch (\Exception $e) {
            Log::error('Error store produk: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        try {
            $produk = DB::table('tb_produk_pinjaman')
                ->where('id_produk_pinjaman', $id)
                ->first();

            if (!$produk) {
                return response()->json([
                    'status' => false,
                    'message' => 'Produk tidak ditemukan'
                ], 404);
            }

            return response()->json([
                'status' => true,
                'message' => 'Data produk ditemukan',
                'data' => $produk
            ]);
        } catch (\Exception $e) {
            Log::error('Error show produk: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        try {
            Log::info('Update produk ID: ' . $id);
            Log::info('Update produk request: ' . json_encode($request->all()));

            $validator = validator($request->all(), [
                'nama_produk' => 'required|string|max:100',
                'tenor_min' => 'required|integer|min:1',
                'tenor_max' => 'required|integer|min:1',
                'tenor_default' => 'required|integer|min:1',
                'bunga_persen' => 'required|numeric|min:0',
                'biaya_admin' => 'required|numeric|min:0',
                'denda_perhari_persen' => 'required|numeric|min:0',
                'maksimal_pinjaman' => 'required|numeric|min:0',
                'minimal_pinjaman' => 'required|numeric|min:0',
                'is_active' => 'required|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $exists = DB::table('tb_produk_pinjaman')
                ->where('id_produk_pinjaman', $id)
                ->exists();

            if (!$exists) {
                return response()->json([
                    'status' => false,
                    'message' => 'Produk tidak ditemukan'
                ], 404);
            }

            $updated = DB::table('tb_produk_pinjaman')
                ->where('id_produk_pinjaman', $id)
                ->update([
                    'nama_produk' => $request->nama_produk,
                    'tenor_min' => $request->tenor_min,
                    'tenor_max' => $request->tenor_max,
                    'tenor_default' => $request->tenor_default,
                    'bunga_persen' => $request->bunga_persen,
                    'biaya_admin' => $request->biaya_admin,
                    'denda_perhari_persen' => $request->denda_perhari_persen,
                    'maksimal_pinjaman' => $request->maksimal_pinjaman,
                    'minimal_pinjaman' => $request->minimal_pinjaman,
                    'is_active' => $request->is_active,
                ]);

            Log::info('Update result: ' . ($updated ? 'success' : 'failed'));

            return response()->json([
                'status' => true,
                'message' => 'Produk pinjaman berhasil diupdate'
            ]);
        } catch (\Exception $e) {
            Log::error('Error update produk: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            Log::info('Delete produk ID: ' . $id);

            $exists = DB::table('tb_produk_pinjaman')
                ->where('id_produk_pinjaman', $id)
                ->exists();

            if (!$exists) {
                return response()->json([
                    'status' => false,
                    'message' => 'Produk tidak ditemukan'
                ], 404);
            }

            // Cek apakah produk sedang digunakan di pinjaman
            $usedInPinjaman = DB::table('tb_pinjaman')
                ->where('id_produk_pinjaman', $id)
                ->exists();

            if ($usedInPinjaman) {
                // Jika sudah digunakan, hanya nonaktifkan, jangan hapus
                DB::table('tb_produk_pinjaman')
                    ->where('id_produk_pinjaman', $id)
                    ->update([
                        'is_active' => 0,
                        'updated_at' => now()
                    ]);

                return response()->json([
                    'status' => true,
                    'message' => 'Produk dinonaktifkan karena sudah digunakan di pinjaman'
                ]);
            }

            // Jika belum pernah digunakan, hapus permanen
            DB::table('tb_produk_pinjaman')
                ->where('id_produk_pinjaman', $id)
                ->delete();

            Log::info('Produk deleted ID: ' . $id);

            return response()->json([
                'status' => true,
                'message' => 'Produk pinjaman berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            Log::error('Error delete produk: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Aktifkan/Nonaktifkan produk
     */
    public function toggleStatus($id)
    {
        try {
            $produk = DB::table('tb_produk_pinjaman')
                ->where('id_produk_pinjaman', $id)
                ->first();

            if (!$produk) {
                return response()->json([
                    'status' => false,
                    'message' => 'Produk tidak ditemukan'
                ], 404);
            }

            $newStatus = $produk->is_active == 1 ? 0 : 1;

            DB::table('tb_produk_pinjaman')
                ->where('id_produk_pinjaman', $id)
                ->update([
                    'is_active' => $newStatus,
                    'updated_at' => now()
                ]);

            return response()->json([
                'status' => true,
                'message' => 'Status produk berhasil diubah',
                'is_active' => $newStatus
            ]);
        } catch (\Exception $e) {
            Log::error('Error toggle status: ' . $e->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }
}