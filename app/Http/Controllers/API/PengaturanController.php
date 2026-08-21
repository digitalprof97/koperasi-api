<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class PengaturanController extends Controller
{
    public function index()
    {
        try {
            $settings = DB::table('tb_pengaturan_umum')->get();
            
            $data = [];
            foreach ($settings as $setting) {
                $value = $setting->nilai_setting;
                
                if ($setting->tipe_data == 'integer') {
                    $value = (int) $value;
                } elseif ($setting->tipe_data == 'decimal') {
                    $value = (float) $value;
                } elseif ($setting->tipe_data == 'boolean') {
                    $value = $value == 'true' || $value == '1';
                }
                
                $data[$setting->kode_setting] = $value;
            }
            
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

    public function update(Request $request)
    {
        try {
            $settings = $request->all();
            
            $validKeys = [
                'KOPERASI_NAME', 'KOPERASI_LOGO', 'DEFAULT_BUNGA_PINJAMAN',
                'MAKSIMAL_TENOR_BULAN', 'DENDA_PER_HARI_PERSEN',
                'AUTO_SIMPAN_WAJIB', 'KOPERASI_ALAMAT', 'KOPERASI_TELP',
                'KOPERASI_EMAIL', 'KOPERASI_DESKRIPSI'
            ];
            
            foreach ($settings as $key => $value) {
                if (!in_array($key, $validKeys)) continue;
                
                $tipeData = 'string';
                $stringValue = (string) $value;
                
                if (is_numeric($value)) {
                    $tipeData = strpos((string)$value, '.') !== false ? 'decimal' : 'integer';
                } elseif (is_bool($value)) {
                    $tipeData = 'boolean';
                    $stringValue = $value ? 'true' : 'false';
                }
                
                DB::table('tb_pengaturan_umum')
                    ->where('kode_setting', $key)
                    ->update([
                        'nilai_setting' => $stringValue,
                        'tipe_data' => $tipeData,
                        'updated_at' => now()
                    ]);
            }
            
            return response()->json([
                'status' => true,
                'message' => 'Pengaturan berhasil disimpan'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function uploadLogo(Request $request)
    {
        try {
            if (!$request->hasFile('logo')) {
                return response()->json([
                    'status' => false,
                    'message' => 'File logo tidak ditemukan'
                ], 400);
            }
            
            $file = $request->file('logo');
            $filename = 'logo_' . time() . '.' . $file->getClientOriginalExtension();
            $path = $file->storeAs('public/logo', $filename);
            $url = '/storage/logo/' . $filename;
            
            DB::table('tb_pengaturan_umum')
                ->where('kode_setting', 'KOPERASI_LOGO')
                ->update([
                    'nilai_setting' => $url,
                    'updated_at' => now()
                ]);
            
            return response()->json([
                'status' => true,
                'message' => 'Logo berhasil diupload',
                'url' => $url
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}