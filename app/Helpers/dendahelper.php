<?php

namespace App\Helpers;

class DendaHelper
{
    /**
     * Hitung nominal denda keterlambatan angsuran berdasarkan bunga.
     *
     * Aturan Denda:
     * - Lewat 1 minggu (> 7 hari): 2.5% dari bunga yang akan dibayar
     * - Lewat 2 minggu (> 14 hari): 5.0% dari bunga yang akan dibayar
     * - Lewat 3 minggu (> 21 hari): 7.5% dari bunga yang akan dibayar
     * - Lewat 4 minggu (> 28 hari): 10.0% dari bunga yang akan dibayar
     *
     * @param float $jumlahBunga Nominal bunga angsuran yang akan dibayar
     * @param string $tglJatuhTempo Tanggal jatuh tempo (format Y-m-d)
     * @param string|null $tglAcuan Tanggal acuan perhitungan keterlambatan
     * @return float Nominal denda (0 jika belum lewat 1 minggu)
     */
    public static function hitung(float $jumlahBunga, string $tglJatuhTempo, ?string $tglAcuan = null): float
    {
        try {
            $jatuhTempo = new \DateTime($tglJatuhTempo);
            $acuan = $tglAcuan ? new \DateTime($tglAcuan) : new \DateTime(date('Y-m-d'));

            // Jika belum melewati tanggal jatuh tempo, denda = 0
            if ($acuan <= $jatuhTempo) {
                return 0.0;
            }

            $selisihHari = (int) $jatuhTempo->diff($acuan)->days;

            $persenDenda = 0.0;
            if ($selisihHari > 28) {
                $persenDenda = 0.10; // 10%
            } elseif ($selisihHari > 21) {
                $persenDenda = 0.075; // 7.5%
            } elseif ($selisihHari > 14) {
                $persenDenda = 0.05; // 5%
            } elseif ($selisihHari > 7) {
                $persenDenda = 0.025; // 2.5%
            } else {
                return 0.0;
            }

            $denda = $jumlahBunga * $persenDenda;

            return round($denda, 2);
        } catch (\Exception $e) {
            return 0.0;
        }
    }

    /**
     * Cek apakah sebuah angsuran sudah lewat jatuh tempo.
     *
     * @param string $tglJatuhTempo
     * @return bool
     */
    public static function isTerlambat(string $tglJatuhTempo): bool
    {
        try {
            $jatuhTempo = new \DateTime($tglJatuhTempo);
            $hariIni = new \DateTime(date('Y-m-d'));
            return $hariIni > $jatuhTempo;
        } catch (\Exception $e) {
            return false;
        }
    }
}