# Deploy PUPR Traffic Monitoring ke Netlify

## Isi paket
- Frontend Next.js dalam mode static export.
- Data hasil preprocessing SHP (216 ruas) disertakan sebagai `frontend/public/data/roads_web.geojson`.
- Statistik GIS disertakan sebagai `frontend/public/data/roads_stats.json`.
- Backend FastAPI dan skema PostGIS tetap disertakan sebagai fondasi pengembangan berikutnya, tetapi **tidak dijalankan oleh Netlify static hosting**.

## Cara deploy yang disarankan: Git repository
1. Ekstrak ZIP ini.
2. Buat repository GitHub baru dan upload seluruh isi folder proyek.
3. Di Netlify pilih **Add new site → Import an existing project** lalu hubungkan repository.
4. Netlify akan membaca `netlify.toml`: base directory `frontend`, build command `npm run build`, publish directory `out`.
5. Sebelum deploy, buka **Site configuration → Environment variables** dan tambahkan:
   - `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` = API key Google Maps JavaScript API.
   - `NEXT_PUBLIC_GOOGLE_MAP_ID` = optional Google Map ID (boleh dikosongkan untuk tampilan peta dasar).
6. Trigger deploy. Buka URL `*.netlify.app` yang diberikan Netlify.

## Alternatif deploy dari komputer
1. Install Node.js 22 LTS.
2. Buka terminal di `frontend`.
3. Jalankan `npm install`.
4. Set environment variable sebelum build (PowerShell):
   `$env:NEXT_PUBLIC_GOOGLE_MAPS_API_KEY="API_KEY_ANDA"`
   `$env:NEXT_PUBLIC_GOOGLE_MAP_ID=""`
5. Jalankan `npm run build`.
6. Upload isi folder `frontend/out` melalui Netlify manual deploy (drag and drop di Netlify Deploys).

## Catatan Google Maps
- Aktifkan billing dan Google Maps JavaScript API pada Google Cloud project.
- Batasi browser key dengan HTTP referrer untuk domain Netlify Anda, misalnya `https://nama-site.netlify.app/*`, dan hanya izinkan API yang diperlukan.
- API key `NEXT_PUBLIC_*` terlihat oleh browser. Jangan gunakan server key atau secret di sini.
- Setelah mengubah environment variable di Netlify, lakukan deploy ulang karena nilainya disisipkan saat build.

## Batasan versi Netlify ini
- Ini adalah **static GIS preview**: peta dan 216 ruas berasal dari file GeoJSON yang disertakan dalam situs.
- Statistik panjang berasal dari hasil preprocessing SHP: atribut 1.298,078 km dan geometri 1.338,335 km.
- Kondisi lalu lintas aktual belum tersedia; status semua ruas tetap UNKNOWN. Tombol Traffic overlay hanya menampilkan lapisan visual Google jika Google Maps API key dan cakupan layanan mendukungnya.
- Upload SHP, database PostGIS, FastAPI, scheduler, histori traffic, autentikasi admin, dan pemanggilan Google Routes API tidak berjalan pada Netlify static hosting. Untuk fitur tersebut diperlukan backend terpisah (misalnya VPS/server lokal dengan API publik) dan konfigurasi CORS/HTTPS.

## Jalankan lokal
```powershell
cd frontend
npm install
$env:NEXT_PUBLIC_GOOGLE_MAPS_API_KEY="API_KEY_ANDA"
npm run dev
```
Buka `http://localhost:3000`.
