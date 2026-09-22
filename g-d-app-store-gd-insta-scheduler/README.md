# GD Insta Scheduler (per Umbrel OS)

Programma e pubblica automaticamente post su Instagram dal tuo Umbrel. Backend **Node.js + Express**, scheduler **cron ogni minuto**, **SQLite** per post/log/token, frontend web responsive, pubblicazione via **Instagram Graph API** ufficiale.

Cartella store: `g-d-app-store-gd-insta-scheduler/` — ID app `g-d-app-store-gd-insta-scheduler`, porta `8757`.

## Avvio rapido (locale)

```bash
cd g-d-app-store-gd-insta-scheduler
npm install
cp .env.example .env   # imposta PUBLIC_URL
npm start              # http://localhost:8757
```

## Docker (multi-arch ARM64 + x86_64)

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/gigiomiccio425/insta-scheduler:1.0.0 --push .
```

Su Umbrel i dati stanno in `/data` (volume `${APP_DATA_DIR}/data`):
- `scheduler.db` — post (`bozza`/`programmato`/`pubblicato`/`errore`), settings, log
- `uploads/` — media caricati, serviti su `/uploads/*`

## Instagram Graph API

1. Account **Business/Creator** collegato a una Pagina Facebook.
2. App su [Meta for Developers](https://developers.facebook.com) con prodotto Instagram + permesso `instagram_content_publish`.
3. Genera token long-lived (~60 giorni), ricavane **IG User ID** (`GET /me/accounts?fields=instagram_business_account`).
4. Nella UI dell'app (tab Account): incolla IG User ID + token + `PUBLIC_URL`, poi **Testa connessione**.
5. `PUBLIC_URL` deve essere raggiungibile da Meta (dominio/Tailscale/LAN) perché i media vengono scaricati da lì.

Il rinnovo automatico del token è tentato una volta al giorno (ore 03:00) se `app_secret` è impostato; altrimenti rinnova manualmente.

## API

- `GET /api/health` · `GET/POST /api/settings` · `POST /api/connect/test`
- `GET /api/posts[?status=]` · `POST /api/posts` (multipart `files[]`) · `GET/PATCH/DELETE /api/posts/:id`
- `POST /api/posts/:id/publish-now` · `POST /api/posts/:id/retry` · `GET /api/logs?limit=`

## File Umbrel

- `umbrel-app.yml` — manifest (id, categoria Social, versione, porta, volumi via compose)
- `docker-compose.yml` — `app_proxy` + `insta-scheduler` su `ghcr.io/gigiomiccio425/insta-scheduler:1.0.0`
- `Dockerfile` — multi-stage ottimizzato ARM64/x86_64
- `exports/icon.svg` + `exports.sh` — compatibilità tooling classico
