# PUPR Traffic Monitoring — Starter v0.1.0

Starter aplikasi WebGIS berdasarkan hasil preprocessing SHP Revisi SK Jalan 2025 (Windows preview package v0.1.1).

## Isi saat ini
- FastAPI: endpoint health, GeoJSON ruas jalan, statistik panjang.
- Next.js: dashboard PUPR putih/navy/kuning, peta Google Maps, pencarian ruas, panel detail.
- PostGIS: service database melalui Docker Compose dan schema awal.
- Data: hasil preprocessing GeoJSON, CSV perbandingan panjang, dan ringkasan.

## Menjalankan dengan Docker
1. Salin `.env.example` menjadi `.env`.
2. Isi `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` dengan key Google Maps JavaScript API. Batasi key berdasarkan referrer/API saat deployment publik.
3. Jalankan `docker compose up --build -d`.
4. Buka `http://localhost:3000`. Frontend meneruskan `/api/*` ke backend melalui jaringan Docker sehingga satu Quick Tunnel cukup untuk demo publik.
6. API lokal untuk pemeriksaan: `http://localhost:8000/api/health`, `http://localhost:8000/api/roads`, `http://localhost:8000/api/roads/stats`.

Database hanya di-bind ke 127.0.0.1. Jangan membuka port database ke internet.

## Catatan penting
- Dashboard saat ini menampilkan geometri SHP dan atributnya. Google TrafficLayer dan Routes API belum diaktifkan; tidak ada status kemacetan aktual yang direkayasa.
- Status traffic ditampilkan UNKNOWN sampai provider traffic dan proses map matching diterapkan serta diuji.
- Statistik panjang dibaca dari ringkasan preprocessing. Periksa `backend/data/processing_summary.json` sebelum penggunaan produksi.
- Segmentasi per 500 m/1 km/2 km belum diterapkan. Tentukan metode dan panjang segmen setelah memvalidasi kebutuhan jaringan.
- Autentikasi admin, upload SHP melalui UI, scheduler, histori traffic, dan laporan merupakan tahap implementasi berikutnya.

## Development tanpa Docker
Backend:
```bash
cd backend
python -m venv .venv
# Windows: .venv\\Scripts\\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```
Frontend:
```bash
cd frontend
npm install
# buat .env.local dan isi NEXT_PUBLIC_GOOGLE_MAPS_API_KEY; API memakai proxy same-origin
npm run dev
```

## Temporary public preview on Windows
1. Start Docker Desktop and wait until it says Engine running.
2. In PowerShell, open this project folder and run `docker compose up --build -d`.
3. Confirm `http://localhost:3000` works.
4. Install `cloudflared` for Windows, then run `cloudflared tunnel --url http://localhost:3000`.
5. Open the `https://....trycloudflare.com` URL printed in the terminal. Keep the terminal and computer running while sharing the preview.
6. Press Ctrl+C in the cloudflared terminal to stop public access. Run `docker compose down` to stop the app.

Quick Tunnel URLs are temporary and anyone who has the URL can access the site. This starter is a development preview: it does not yet include admin authentication or production security controls. Do not upload confidential data or share the preview publicly until access controls are implemented.


## Netlify static deployment (v0.2.0)
Lihat `NETLIFY_DEPLOY_ID.md`. Frontend menggunakan data GeoJSON statis di `frontend/public/data`, sehingga dapat dipublikasikan pada Netlify tanpa menjalankan FastAPI. Google Maps API key diatur sebagai environment variable Netlify saat build. Traffic aktual, upload SHP, PostGIS, autentikasi, dan scheduler belum termasuk dalam static deployment.
