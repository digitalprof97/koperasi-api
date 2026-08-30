<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use App\Helpers\LogActivity;

class MetodeBayarController extends Controller
{
    // GET semua metode
    public function index()
    {
        try {
            $metode = DB::table('tb_metode_pembayaran')
                ->orderBy('urutan', 'asc')
                ->get();
            
            // Generate QR code untuk yang is_qris = 1
            foreach ($metode as $m) {
                if ($m->is_qris) {
                    $m->qr_code_url = $this->generateQRCodeUrl($m);
                }
            }
            
            return response()->json([
                'status' => true,
                'data' => $metode
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // GET detail metode
    public function show($id)
    {
        try {
            $metode = DB::table('tb_metode_pembayaran')
                ->where('id_metode', $id)
                ->first();
            
            if (!$metode) {
                return response()->json([
                    'status' => false,
                    'message' => 'Metode tidak ditemukan'
                ], 404);
            }
            
            if ($metode->is_qris) {
                $metode->qr_code_url = $this->generateQRCodeUrl($metode);
            }
            
            return response()->json([
                'status' => true,
                'data' => $metode
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // CREATE metode
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nama_metode' => 'required|string|max:50|unique:tb_metode_pembayaran,nama_metode',
                'kode_metode' => 'required|string|max:20',
                'biaya_admin_persen' => 'required|numeric|min:0',
                'is_active' => 'nullable',
                'urutan' => 'required|integer|min:0',
                'atas_nama' => 'nullable|string|max:100',
                'nomor_rekening' => 'nullable|string|max:50',
                'bank_nama' => 'nullable|string|max:50',
                'is_qris' => 'nullable',
                'qr_code_data' => 'nullable|string',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => $validator->errors()->first(),
                    'errors' => $validator->errors()
                ], 422);
            }

            $isActive = filter_var($request->input('is_active', true), FILTER_VALIDATE_BOOLEAN) ? 1 : 0;
            $isQris = filter_var($request->input('is_qris', false), FILTER_VALIDATE_BOOLEAN) ? 1 : 0;

            $id = DB::table('tb_metode_pembayaran')->insertGetId([
                'nama_metode' => $request->nama_metode,
                'kode_metode' => $request->kode_metode,
                'biaya_admin_persen' => $request->biaya_admin_persen,
                'is_active' => $isActive,
                'urutan' => $request->urutan,
                'atas_nama' => $request->atas_nama,
                'nomor_rekening' => $request->nomor_rekening,
                'bank_nama' => $request->bank_nama,
                'is_qris' => $isQris,
                'qr_code_data' => $request->qr_code_data,
            ]);

            try {
                if (class_exists('App\Helpers\LogActivity')) {
                    LogActivity::log(1, 'Tambah Metode Bayar', 'Menambah metode pembayaran: ' . $request->nama_metode . ' (' . $request->kode_metode . ')');
                }
            } catch (\Exception $logEx) {}

            return response()->json([
                'status' => true,
                'message' => 'Metode pembayaran berhasil ditambahkan',
                'id' => $id
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // UPDATE metode
    public function update(Request $request, $id)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nama_metode' => 'required|string|max:50',
                'kode_metode' => 'required|string|max:20',
                'biaya_admin_persen' => 'required|numeric|min:0',
                'is_active' => 'nullable',
                'urutan' => 'required|integer|min:0',
                'atas_nama' => 'nullable|string|max:100',
                'nomor_rekening' => 'nullable|string|max:50',
                'bank_nama' => 'nullable|string|max:50',
                'is_qris' => 'nullable',
                'qr_code_data' => 'nullable|string',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => $validator->errors()->first(),
                    'errors' => $validator->errors()
                ], 422);
            }

            $exists = DB::table('tb_metode_pembayaran')
                ->where('id_metode', $id)
                ->exists();

            if (!$exists) {
                return response()->json([
                    'status' => false,
                    'message' => 'Metode tidak ditemukan'
                ], 404);
            }

            $metodeLama = DB::table('tb_metode_pembayaran')
                ->where('id_metode', $id)
                ->first();

            $isActive = filter_var($request->input('is_active', true), FILTER_VALIDATE_BOOLEAN) ? 1 : 0;
            $isQris = filter_var($request->input('is_qris', false), FILTER_VALIDATE_BOOLEAN) ? 1 : 0;

            DB::table('tb_metode_pembayaran')
                ->where('id_metode', $id)
                ->update([
                    'nama_metode' => $request->nama_metode,
                    'kode_metode' => $request->kode_metode,
                    'biaya_admin_persen' => $request->biaya_admin_persen,
                    'is_active' => $isActive,
                    'urutan' => $request->urutan,
                    'atas_nama' => $request->atas_nama,
                    'nomor_rekening' => $request->nomor_rekening,
                    'bank_nama' => $request->bank_nama,
                    'is_qris' => $isQris,
                    'qr_code_data' => $request->qr_code_data,
                ]);

            try {
                if (class_exists('App\Helpers\LogActivity')) {
                    LogActivity::log(1, 'Edit Metode Bayar', 'Mengedit metode pembayaran ID: ' . $id . ' dari "' . ($metodeLama->nama_metode ?? '') . '" menjadi "' . $request->nama_metode . '"');
                }
            } catch (\Exception $logEx) {}

            return response()->json([
                'status' => true,
                'message' => 'Metode pembayaran berhasil diupdate'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // DELETE metode
    public function destroy($id)
    {
        try {
            $exists = DB::table('tb_metode_pembayaran')
                ->where('id_metode', $id)
                ->exists();

            if (!$exists) {
                return response()->json([
                    'status' => false,
                    'message' => 'Metode tidak ditemukan'
                ], 404);
            }

            $metode = DB::table('tb_metode_pembayaran')
                ->where('id_metode', $id)
                ->first();

            DB::table('tb_metode_pembayaran')
                ->where('id_metode', $id)
                ->delete();

            try {
                if (class_exists('App\Helpers\LogActivity')) {
                    LogActivity::log(1, 'Hapus Metode Bayar', 'Menghapus metode pembayaran: ' . ($metode->nama_metode ?? 'ID: ' . $id));
                }
            } catch (\Exception $logEx) {}

            return response()->json([
                'status' => true,
                'message' => 'Metode pembayaran berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // Generate QR Code URL
    private function generateQRCodeUrl($metode)
    {
        $data = json_encode([
            'bank' => $metode->bank_nama ?? $metode->nama_metode,
            'norek' => $metode->nomor_rekening ?? '',
            'an' => $metode->atas_nama ?? 'Koperasi Gereja',
            'nama_koperasi' => 'Koperasi Gereja Kasih'
        ]);
        
        return 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=' . urlencode($data);
    }
}
