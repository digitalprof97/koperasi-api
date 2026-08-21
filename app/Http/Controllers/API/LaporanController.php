<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LaporanController extends Controller
{
    /**
     * Laporan Ringkasan Dashboard (Otomatis Menambahkan Nominal Iuran Lunas ke Total Simpanan)
     */
    public function dashboard()
    {
        try {
            // Total Jemaat
            $totalJemaat = DB::table('tb_jemaat')->count();
            $totalJemaatAktif = DB::table('tb_jemaat')->where('is_active', 1)->count();
            
            // Total Pinjaman
            $totalPinjaman = DB::table('tb_pinjaman')->count();
            $totalPinjamanAktif = DB::table('tb_pinjaman')
                ->whereNotIn('status', ['lunas', 'ditolak'])
                ->count();
            $totalPinjamanCair = DB::table('tb_pinjaman')
                ->where('status', 'dicairkan')
                ->sum('jumlah_pinjaman');
            $totalBiayaAdmin = DB::table('tb_pinjaman')
                ->where('status', 'dicairkan')
                ->sum('biaya_admin');
            
            // Total Simpanan (Pokok, Wajib, Sukarela dari Jemaat)
            $totalSimpananPokok = DB::table('tb_jemaat')->sum('saldo_simpanan_pokok');
            $totalSimpananWajib = DB::table('tb_jemaat')->sum('saldo_simpanan_wajib');
            $totalSimpananSukarela = DB::table('tb_jemaat')->sum('saldo_simpanan_sukarela');
            
            // 🔥 TOTAL IURAN YANG SUDAH LUNAS (Menambah Total Simpanan)
            $totalIuranLunas = DB::table('tb_iuran')
                ->where('status', 'lunas')
                ->sum('nominal');

            // Jumlah Pinjaman per Status
            $pinjamanPerStatus = DB::table('tb_pinjaman')
                ->select('status', DB::raw('count(*) as total'))
                ->groupBy('status')
                ->get();
            
            // Kalkulasi Total Keseluruhan Simpanan + Total Iuran Lunas
            $totalSemuaSimpanan = (float) ($totalSimpananPokok + $totalSimpananWajib + $totalSimpananSukarela + $totalIuranLunas);

            return response()->json([
                'status' => true,
                'data' => [
                    'jemaat' => [
                        'total' => $totalJemaat,
                        'aktif' => $totalJemaatAktif,
                        'tidak_aktif' => $totalJemaat - $totalJemaatAktif,
                    ],
                    'pinjaman' => [
                        'total_pengajuan' => $totalPinjaman,
                        'aktif' => $totalPinjamanAktif,
                        'total_cair' => (float) $totalPinjamanCair,
                        'total_biaya_admin' => (float) $totalBiayaAdmin,
                        'per_status' => $pinjamanPerStatus,
                    ],
                    'simpanan' => [
                        'pokok' => (float) $totalSimpananPokok,
                        'wajib' => (float) $totalSimpananWajib,
                        'sukarela' => (float) $totalSimpananSukarela,
                        'iuran_lunas' => (float) $totalIuranLunas,
                        'total' => $totalSemuaSimpanan,
                    ],
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Laporan Pinjaman per Bulan
     */
    public function laporanPinjaman(Request $request)
    {
        try {
            $tahun = $request->get('tahun', date('Y'));
            
            $data = DB::table('tb_pinjaman')
                ->select(
                    DB::raw('MONTH(tgl_pengajuan) as bulan'),
                    DB::raw('COUNT(*) as jumlah_pengajuan'),
                    DB::raw('SUM(jumlah_pinjaman) as total_pinjaman'),
                    DB::raw('SUM(CASE WHEN status = "disetujui" THEN 1 ELSE 0 END) as disetujui'),
                    DB::raw('SUM(CASE WHEN status = "dicairkan" THEN 1 ELSE 0 END) as dicairkan'),
                    DB::raw('SUM(CASE WHEN status = "ditolak" THEN 1 ELSE 0 END) as ditolak')
                )
                ->whereYear('tgl_pengajuan', $tahun)
                ->groupBy(DB::raw('MONTH(tgl_pengajuan)'))
                ->orderBy('bulan', 'asc')
                ->get();
            
            $namaBulan = [
                1 => 'Januari', 2 => 'Februari', 3 => 'Maret', 4 => 'April',
                5 => 'Mei', 6 => 'Juni', 7 => 'Juli', 8 => 'Agustus',
                9 => 'September', 10 => 'Oktober', 11 => 'November', 12 => 'Desember'
            ];
            
            $result = [];
            foreach ($data as $item) {
                $result[] = [
                    'bulan' => $namaBulan[$item->bulan],
                    'bulan_angka' => $item->bulan,
                    'jumlah_pengajuan' => $item->jumlah_pengajuan,
                    'total_pinjaman' => (float) $item->total_pinjaman,
                    'disetujui' => $item->disetujui,
                    'dicairkan' => $item->dicairkan,
                    'ditolak' => $item->ditolak,
                ];
            }
            
            return response()->json([
                'status' => true,
                'data' => $result,
                'tahun' => $tahun
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Laporan Simpanan per Jemaat
     */
    public function laporanSimpanan()
    {
        try {
            $data = DB::table('tb_jemaat')
                ->select(
                    'id_jemaat',
                    'no_anggota',
                    'nama_lengkap',
                    'saldo_simpanan_pokok',
                    'saldo_simpanan_wajib',
                    'saldo_simpanan_sukarela',
                    DB::raw('(saldo_simpanan_pokok + saldo_simpanan_wajib + saldo_simpanan_sukarela) as total_simpanan'),
                    'tgl_bergabung'
                )
                ->where('is_active', 1)
                ->orderBy('total_simpanan', 'desc')
                ->get();
            
            // Total keseluruhan
            $total = DB::table('tb_jemaat')
                ->select(
                    DB::raw('SUM(saldo_simpanan_pokok) as total_pokok'),
                    DB::raw('SUM(saldo_simpanan_wajib) as total_wajib'),
                    DB::raw('SUM(saldo_simpanan_sukarela) as total_sukarela')
                )
                ->first();
            
            $totalIuranLunas = DB::table('tb_iuran')
                ->where('status', 'lunas')
                ->sum('nominal');

            return response()->json([
                'status' => true,
                'data' => $data,
                'total' => [
                    'pokok' => (float) $total->total_pokok,
                    'wajib' => (float) $total->total_wajib,
                    'sukarela' => (float) $total->total_sukarela,
                    'iuran' => (float) $totalIuranLunas,
                    'semua' => (float) ($total->total_pokok + $total->total_wajib + $total->total_sukarela + $totalIuranLunas),
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Laporan Angsuran (Pembayaran)
     */
    public function laporanAngsuran(Request $request)
    {
        try {
            $bulan = $request->get('bulan', date('m'));
            $tahun = $request->get('tahun', date('Y'));
            
            $data = DB::table('tb_angsuran as a')
                ->join('tb_pinjaman as p', 'a.id_pinjaman', '=', 'p.id_pinjaman')
                ->join('tb_jemaat as j', 'p.id_jemaat', '=', 'j.id_jemaat')
                ->select(
                    'a.id_angsuran',
                    'p.kode_pinjaman',
                    'j.nama_lengkap',
                    'j.no_anggota',
                    'a.angsuran_ke',
                    'a.jumlah_angsuran',
                    'a.denda',
                    'a.tgl_jatuh_tempo',
                    'a.tgl_bayar',
                    'a.status'
                )
                ->whereMonth('a.tgl_jatuh_tempo', $bulan)
                ->whereYear('a.tgl_jatuh_tempo', $tahun)
                ->orderBy('a.tgl_jatuh_tempo', 'asc')
                ->get();
            
            // Ringkasan
            $totalTagihan = DB::table('tb_angsuran')
                ->whereMonth('tgl_jatuh_tempo', $bulan)
                ->whereYear('tgl_jatuh_tempo', $tahun)
                ->sum('jumlah_angsuran');
            
            $totalTerbayar = DB::table('tb_angsuran')
                ->whereMonth('tgl_jatuh_tempo', $bulan)
                ->whereYear('tgl_jatuh_tempo', $tahun)
                ->where('status', 'lunas')
                ->sum('jumlah_angsuran');
            
            $totalDenda = DB::table('tb_angsuran')
                ->whereMonth('tgl_jatuh_tempo', $bulan)
                ->whereYear('tgl_jatuh_tempo', $tahun)
                ->sum('denda');
            
            $namaBulan = [
                1 => 'Januari', 2 => 'Februari', 3 => 'Maret', 4 => 'April',
                5 => 'Mei', 6 => 'Juni', 7 => 'Juli', 8 => 'Agustus',
                9 => 'September', 10 => 'Oktober', 11 => 'November', 12 => 'Desember'
            ];
            
            return response()->json([
                'status' => true,
                'data' => $data,
                'ringkasan' => [
                    'bulan' => $namaBulan[(int)$bulan],
                    'tahun' => $tahun,
                    'total_tagihan' => (float) $totalTagihan,
                    'total_terbayar' => (float) $totalTerbayar,
                    'total_belum_bayar' => (float) ($totalTagihan - $totalTerbayar),
                    'total_denda' => (float) $totalDenda,
                    'persentase' => $totalTagihan > 0 ? round(($totalTerbayar / $totalTagihan) * 100, 2) : 0,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Export Laporan Pinjaman ke CSV
     */
    public function exportPinjamanCsv(Request $request)
    {
        try {
            $tahun = $request->get('tahun', date('Y'));
            
            $data = DB::table('tb_pinjaman as p')
                ->join('tb_jemaat as j', 'p.id_jemaat', '=', 'j.id_jemaat')
                ->select(
                    'p.kode_pinjaman',
                    'j.nama_lengkap',
                    'j.no_anggota',
                    'p.jumlah_pinjaman',
                    'p.tenor',
                    'p.angsuran_per_bulan',
                    'p.status',
                    'p.tgl_pengajuan',
                    'p.tgl_disetujui',
                    'p.tgl_pencairan'
                )
                ->whereYear('p.tgl_pengajuan', $tahun)
                ->orderBy('p.tgl_pengajuan', 'desc')
                ->get();
            
            // Buat CSV
            $csv = "Kode Pinjaman,Nama Jemaat,No Anggota,Jumlah Pinjaman,Tenor (bulan),Angsuran/Bulan,Status,Tgl Pengajuan,Tgl Disetujui,Tgl Pencairan\n";
            
            foreach ($data as $row) {
                $csv .= "\"{$row->kode_pinjaman}\",";
                $csv .= "\"{$row->nama_lengkap}\",";
                $csv .= "\"{$row->no_anggota}\",";
                $csv .= "{$row->jumlah_pinjaman},";
                $csv .= "{$row->tenor},";
                $csv .= "{$row->angsuran_per_bulan},";
                $csv .= "\"{$row->status}\",";
                $csv .= "{$row->tgl_pengajuan},";
                $csv .= ($row->tgl_disetujui ?? '-') . ",";
                $csv .= ($row->tgl_pencairan ?? '-') . "\n";
            }
            
            return response($csv, 200)
                ->header('Content-Type', 'text/csv')
                ->header('Content-Disposition', "attachment; filename=laporan_pinjaman_{$tahun}.csv");
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}