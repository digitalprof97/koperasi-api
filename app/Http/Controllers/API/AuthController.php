<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use App\Helpers\LogActivity;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        // Otomatis ubah role ke lowercase (misal 'ADMIN' jadi 'admin')
        $role = strtolower((string) $request->input('role', ''));
        $request->merge(['role' => $role]);

        $request->validate([
            'username' => 'required',
            'password' => 'required',
            'role'     => 'required|in:jemaat,admin'
        ]);

        if ($role === 'jemaat') {
            $user = DB::table('tb_jemaat')
                ->where('no_anggota', $request->username)
                ->orWhere('email', $request->username)
                ->first();
            
            if ($user && $request->password == $user->password_hash) {
                // Token sederhana tanpa sanctum model
                $token = $user->id_jemaat . '|' . bin2hex(random_bytes(32));
                
                return response()->json([
                    'status'  => true,
                    'role'    => 'jemaat',
                    'user'    => $user,
                    'token'   => $token,
                    'message' => 'Login berhasil'
                ]);
            }
        } 
        else {
            $user = DB::table('tb_admin')
                ->where('username', $request->username)
                ->first();
            
            if ($user && $request->password == $user->password_hash) {
                // Token sederhana tanpa sanctum model
                $token = $user->id_admin . '|' . bin2hex(random_bytes(32));
                
                try {
                    if (class_exists(LogActivity::class)) {
                        LogActivity::log($user->id_admin, 'Login', 'Admin login ke sistem');
                    }
                } catch (\Throwable $e) {
                    Log::warning('LogActivity error: ' . $e->getMessage());
                }
                
                return response()->json([
                    'status'  => true,
                    'role'    => 'admin',
                    'user'    => $user,
                    'token'   => $token,
                    'message' => 'Login berhasil'
                ]);
            }
        }

        return response()->json([
            'status'  => false,
            'message' => 'Username atau password salah'
        ], 401);
    }

    public function profil(Request $request)
    {
        try {
            // Ambil token dari header
            $token = $request->bearerToken();
            if (!$token) {
                return response()->json([
                    'status'  => false,
                    'message' => 'Token tidak ditemukan'
                ], 401);
            }
            
            // Extract id_admin dari token (format: id|random)
            $parts = explode('|', $token);
            $adminId = $parts[0] ?? 0;
            
            $admin = DB::table('tb_admin')
                ->where('id_admin', $adminId)
                ->select('id_admin', 'username', 'nama_lengkap', 'email', 'no_hp', 'foto_profil', 'created_at')
                ->first();

            if (!$admin) {
                return response()->json([
                    'status'  => false,
                    'message' => 'Admin tidak ditemukan'
                ], 404);
            }

            return response()->json([
                'status' => true,
                'data'   => $admin
            ]);
        } catch (\Exception $e) {
            Log::error('Profil error: ' . $e->getMessage());
            return response()->json([
                'status'  => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function updateProfil(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'nama_lengkap' => 'required|string|max:100',
                'email'        => 'nullable|email|max:100',
                'no_hp'        => 'nullable|string|max:15',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status'  => false,
                    'message' => 'Validasi gagal',
                    'errors'  => $validator->errors()
                ], 422);
            }

            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $adminId = $parts[0] ?? 0;

            DB::table('tb_admin')
                ->where('id_admin', $adminId)
                ->update([
                    'nama_lengkap' => $request->nama_lengkap,
                    'email'        => $request->email,
                    'no_hp'        => $request->no_hp,
                    'updated_at'   => now(),
                ]);

            try {
                if (class_exists(LogActivity::class)) {
                    LogActivity::log($adminId, 'Update Profil', 'Admin mengupdate profil');
                }
            } catch (\Throwable $e) {
                Log::warning('LogActivity error: ' . $e->getMessage());
            }

            return response()->json([
                'status'  => true,
                'message' => 'Profil berhasil diupdate'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status'  => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function gantiPassword(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'password_lama'       => 'required|string',
                'password_baru'       => 'required|string|min:4',
                'konfirmasi_password' => 'required|same:password_baru',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status'  => false,
                    'message' => 'Validasi gagal',
                    'errors'  => $validator->errors()
                ], 422);
            }

            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $adminId = $parts[0] ?? 0;

            $admin = DB::table('tb_admin')
                ->where('id_admin', $adminId)
                ->first();

            if (!$admin || $request->password_lama != $admin->password_hash) {
                return response()->json([
                    'status'  => false,
                    'message' => 'Password lama salah'
                ], 401);
            }

            DB::table('tb_admin')
                ->where('id_admin', $adminId)
                ->update([
                    'password_hash' => $request->password_baru,
                    'updated_at'    => now(),
                ]);

            try {
                if (class_exists(LogActivity::class)) {
                    LogActivity::log($adminId, 'Ganti Password', 'Admin mengganti password');
                }
            } catch (\Throwable $e) {
                Log::warning('LogActivity error: ' . $e->getMessage());
            }

            return response()->json([
                'status'  => true,
                'message' => 'Password berhasil diganti'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status'  => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function uploadFoto(Request $request)
    {
        try {
            if (!$request->hasFile('foto')) {
                return response()->json([
                    'status'  => false,
                    'message' => 'Tidak ada file yang diupload'
                ], 400);
            }
            
            $file = $request->file('foto');
            
            $validator = Validator::make($request->all(), [
                'foto' => 'required|image|mimes:jpeg,png,jpg|max:2048'
            ]);
            
            if ($validator->fails()) {
                return response()->json([
                    'status'  => false,
                    'message' => $validator->errors()->first()
                ], 422);
            }
            
            if (!Storage::exists('public/admin_foto')) {
                Storage::makeDirectory('public/admin_foto');
            }
            
            $filename = 'admin_' . time() . '_' . rand(1000, 9999) . '.' . $file->getClientOriginalExtension();
            $path = $file->storeAs('public/admin_foto', $filename);
            $url = '/storage/admin_foto/' . $filename;
            
            $token = $request->bearerToken();
            $parts = explode('|', $token);
            $adminId = $parts[0] ?? 1;
            
            // Hapus foto lama
            $oldFoto = DB::table('tb_admin')->where('id_admin', $adminId)->value('foto_profil');
            if ($oldFoto && $oldFoto != '') {
                $oldPath = str_replace('/storage/', 'public/', $oldFoto);
                if (Storage::exists($oldPath)) {
                    Storage::delete($oldPath);
                }
            }
            
            DB::table('tb_admin')
                ->where('id_admin', $adminId)
                ->update([
                    'foto_profil' => $url,
                    'updated_at'  => now(),
                ]);
            
            return response()->json([
                'status'  => true,
                'message' => 'Foto profil berhasil diupload',
                'url'     => $url
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status'  => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function logout(Request $request)
    {
        return response()->json([
            'status'  => true,
            'message' => 'Logout berhasil'
        ]);
    }
}
