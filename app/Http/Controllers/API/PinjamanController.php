<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Helpers\LogActivity;
use App\Helpers\DendaHelper;

class PinjamanController extends Controller
{
    public function index()
    {
        $pinjaman = DB::table('tb_pinjaman as p')
            ->leftJoin('tb_jemaat as j', 'p.id_jemaat', '=', 'j.id_jemaat')
            ->select(
                'p.id_pinjaman',
                'p.kode_pinjaman',
                'j.nama_lengkap as nama_jemaat',
                'j.no_anggota',
                'p.jumlah_pinjaman',
                'p.tenor',
                'p.bunga_persen',
                'p.biaya_admin',
                'p.angsuran_per_bulan',
                'p.status',
                'p.tgl_pengajuan',
                'p.jaminan',
                'p.deskripsi_jaminan',
                'p.catatan_internal'
            )
            ->orderBy('p.id_pinjaman', 'desc')
            ->get();

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
    }

    public function show($id)
    {
        $pinjaman = DB::table('tb_pinjaman as p')
            ->leftJoin('tb_jemaat as j', 'p.id_jemaat', '=', 'j.id_jemaat')
            ->leftJoin('tb_produk_pinjaman as pr', 'p.id_produk_pinjaman', '=', 'pr.id_produk_pinjaman')
            ->select(
                'p.*', 
                'j.nama_lengkap', 
                'j.no_anggota', 
                'pr.nama_produk', 
                'p.jaminan', 
                'p.deskripsi_jaminan'
            )
            ->where('p.id_pinjaman', $id)
            ->first();

        if (!$pinjaman) {
            return response()->json([
                'status' => false,
                'message' => 'Pinjaman tidak ditemukan'
            ], 404);
        }

        $jumlah = (float) $pinjaman->jumlah_pinjaman;
        $pinjaman->dana_resiko = round($jumlah * 0.01, 2);
        $pinjaman->dana_diterima = round($jumlah - $pinjaman->dana_resiko, 2);
        $pinjaman->keterangan_resiko = 'Dipotong 1% sebagai dana risiko pinjaman. Peminjam menerima 99% dari total pinjaman.';

        $angsuran = DB::table('tb_angsuran')
            ->where('id_pinjaman', $id)
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
            'data' => [
                'pinjaman' => $pinjaman,
                'angsuran' => $angsuran
            ]
        ]);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:diajukan,disetujui,dicairkan,ditolak,lunas,macet'
        ]);

        // Ambil data pinjaman sebelum update
        $pinjamanLama = DB::table('tb_pinjaman')
            ->where('id_pinjaman', $id)
            ->first();

        if (!$pinjamanLama) {
            return response()->json([
                'status' => false,
                'message' => 'Pinjaman tidak ditemukan'
            ], 404);
        }

        $updateData = ['status' => $request->status];

        if ($request->status == 'disetujui') {
            $updateData['tgl_disetujui'] = date('Y-m-d');
            
            // GENERATE ANGSURAN OTOMATIS DENGAN BUNGA MENURUN KETIKA DISETUJUI
            $this->generateAngsuran($pinjamanLama);
        }

        if ($request->status == 'dicairkan') {
            $updateData['tgl_pencairan'] = date('Y-m-d');
        }

        if ($request->has('alasan_tolak')) {
            $updateData['alasan_ditolak'] = $request->alasan_tolak;
        }

        $updateData['updated_at'] = now();

        DB::table('tb_pinjaman')
            ->where('id_pinjaman', $id)
            ->update($updateData);

        // Log Activity
        $statusText = '';
        switch ($request->status) {
            case 'disetujui':
                $statusText = 'disetujui';
                break;
            case 'dicairkan':
                $statusText = 'dicairkan';
                break;
            case 'ditolak':
                $statusText = 'ditolak' . ($request->has('alasan_tolak') ? ' dengan alasan: ' . $request->alasan_tolak : '');
                break;
            case 'lunas':
                $statusText = 'dinyatakan lunas';
                break;
            default:
                $statusText = $request->status;
        }

        LogActivity::log(
            1,
            'Update Status Pinjaman',
            'Pinjaman ID ' . $id . ' (' . ($pinjamanLama->kode_pinjaman ?? 'Kode: -') . ') diubah status menjadi ' . $statusText
        );

        return response()->json([
            'status' => true,
            'message' => 'Status pinjaman berhasil diupdate'
        ]);
    }

    /**
     * FUNGSI UNTUK GENERATE ANGSURAN OTOMATIS (BUNGA MENURUN DARI SISA POKOK)
     * Bunga awal 1.5% dari sisa pokok, turun ke 1.25% dari sisa pokok setelah 50% tenor terlewati.
     */
    private function generateAngsuran($pinjaman)
    {
        // Cek apakah sudah ada angsuran untuk pinjaman ini
        $existingAngsuran = DB::table('tb_angsuran')
            ->where('id_pinjaman', $pinjaman->id_pinjaman)
            ->count();
        
        if ($existingAngsuran > 0) {
            return;
        }
        
        // Ambil produk pinjaman untuk mendapatkan biaya admin
        $produk = DB::table('tb_produk_pinjaman')
            ->where('id_produk_pinjaman', $pinjaman->id_produk_pinjaman)
            ->first();
        
        $totalPinjaman = (float) $pinjaman->jumlah_pinjaman;
        $tenor = (int) $pinjaman->tenor;
        $pokokPerBulan = $totalPinjaman / $tenor;
        $biayaAdmin = $produk->biaya_admin ?? 0;
        
        // Titik tengah tenor untuk diskon suku bunga
        $halfTenor = ceil($tenor / 2);
        
        // Tanggal pengajuan sebagai dasar perhitungan jatuh tempo
        $tglPengajuan = $pinjaman->tgl_pengajuan;
        
        // Sisa pokok pinjaman berjalan
        $sisaPokok = $totalPinjaman;
        
        for ($i = 1; $i <= $tenor; $i++) {
            $tglJatuhTempo = date('Y-m-d', strtotime("+$i months", strtotime($tglPengajuan)));
            
            // Suku bunga: 1.5% pada paruh pertama, 1.25% setelah paruh pertama (dihitung dari sisa pokok)
            $rate = ($i > $halfTenor) ? 0.0125 : 0.015;
            $bungaNominal = round($sisaPokok * $rate, 2);
            $totalAngsuranBulanIni = round($pokokPerBulan + $bungaNominal + $biayaAdmin, 2);
            
            DB::table('tb_angsuran')->insert([
                'id_pinjaman' => $pinjaman->id_pinjaman,
                'angsuran_ke' => $i,
                'jumlah_angsuran' => $totalAngsuranBulanIni,
                'jumlah_pokok' => $pokokPerBulan,
                'jumlah_bunga' => $bungaNominal,
                'denda' => 0,
                'tgl_jatuh_tempo' => $tglJatuhTempo,
                'status' => 'belum_bayar',
                'created_at' => now(),
            ]);
            
            // Kurangi sisa pokok untuk perhitungan bunga bulan berikutnya
            $sisaPokok -= $pokokPerBulan;
            if ($sisaPokok < 0) {
                $sisaPokok = 0;
            }
        }
    }
}
