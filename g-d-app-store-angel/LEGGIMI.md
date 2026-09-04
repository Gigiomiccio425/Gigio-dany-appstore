# ANGEL su umbrelOS

Stessa immagine che gira sulla VPS (`ghcr.io/gigiomiccio425/aegis-discord-bot`):
bot, worker e pannello dentro un contenitore solo, con Postgres e Redis accanto.

I segreti non stanno nella repository — è pubblica. Vivono in un file sul tuo
Umbrel, che Docker Compose legge da solo.

---

## Installazione

**1.** Nell'interfaccia di umbrelOS: *Impostazioni → App store → Aggiungi*, e
incolla `https://github.com/Gigiomiccio425/Gigio-dany-appstore`

**2.** Installa **ANGEL**. Parte, ma senza token non si collega a Discord: è
atteso.

**3.** Da SSH sull'Umbrel, crea il file dei segreti partendo dal modello
`env.esempio` di questa cartella:

```sh
sudo nano ~/umbrel/app-data/g-d-app-store-angel/.env
```

**4.** Riavvia l'app:

```sh
sudo ~/umbrel/scripts/app restart g-d-app-store-angel
```

Pannello su `http://umbrel.local:7801` — o l'indirizzo che hai messo in
`PUBLIC_URL`, che deve combaciare esattamente, porta compresa.

---

## Prima dell'installazione serve

Un'applicazione su <https://discord.com/developers/applications>:

- **Bot → Reset Token** per `DISCORD_TOKEN`, e nella stessa pagina accendi
  **tutti e tre** i Privileged Gateway Intents — *Presence*, *Server Members*,
  *Message Content*. Se ne manca uno solo Discord rifiuta la connessione con
  «Used disallowed intents» e il bot riparte in ciclo senza mai collegarsi.
- **General Information** per `DISCORD_CLIENT_ID`.
- **OAuth2** per `DISCORD_CLIENT_SECRET`, e come redirect aggiungi il tuo
  `PUBLIC_URL` con `/api/auth/callback` in fondo.

Poi invita il bot e **sposta il suo ruolo in cima alla lista dei ruoli**:
Discord non consente di agire su chi sta più in alto, ed è il motivo più
frequente per cui una difesa non riesce a sanzionare.

---

## `ENCRYPTION_KEY`, l'unico valore che non si inventa due volte

`SESSION_SECRET` firma i cookie: cambiarlo scollega tutti e basta.

`ENCRYPTION_KEY` cifra i token dentro il database. Se questa installazione
affianca o sostituisce un'altra — la VPS, o il nodo di emergenza in
`emergenza-mia/` — la chiave va **copiata identica** da lì. Con una chiave
diversa i dati esportati dall'altro nodo non sono rileggibili, e il rientro
dal nodo di emergenza fallisce senza modo di recuperarli.

---

## Dove finiscono i dati

| Cosa | Percorso sull'Umbrel |
|---|---|
| Database | `app-data/g-d-app-store-angel/data/postgres` |
| Redis | `app-data/g-d-app-store-angel/data/redis` |
| Allegati archiviati | `app-data/g-d-app-store-angel/data/storage` |
| Copie e trasloco | `app-data/g-d-app-store-angel/backup` |

Le copie stanno fuori da `data/` di proposito: una copia che sparisce insieme
a ciò che protegge non protegge nulla.

---

## Aggiornare

Cambia il tag dell'immagine in `docker-compose.yml` e la `version` in
`umbrel-app.yml`, entrambi in questa cartella, poi da umbrelOS aggiorna l'app.

Il bot parte con **tutti i moduli spenti**: si accendono dal pannello, e
conviene tenere la modalità prova accesa per qualche giorno prima di far
sanzionare davvero.
