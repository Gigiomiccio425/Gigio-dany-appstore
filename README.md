# Gigio & Dany — Community App Store per umbrelOS

Per aggiungerlo: **App Store → ⋯ → Community App Stores → Add**, e incolla

```
https://github.com/Gigiomiccio425/Gigio-dany-appstore
```

## ANGEL

Bot Discord di moderazione e sicurezza, con pannello web. Il pannello risponde
sulla porta 780, quello per gli streamer Twitch sulla 781.

### Prima cosa dopo l'installazione: il file dei segreti

Nel `docker-compose.yml` **non c'è nessun dato sensibile, e non va messo**:
umbrelOS riscrive quel file dal repository a ogni aggiornamento, quindi quello
che ci si scrive sparisce — e finché ci sta, sta in chiaro in un file leggibile
da chiunque abbia accesso alla macchina.

I valori vanno in una cartella che gli aggiornamenti non toccano:

```bash
ssh umbrel@umbrel.local
mkdir -p ~/umbrel/app-data/g-d-app-store-gd-angel/data/segreti
sudo chown -R 1000:1000 ~/umbrel/app-data/g-d-app-store-gd-angel/data/segreti
nano ~/umbrel/app-data/g-d-app-store-gd-angel/data/segreti/segreti.env
```

Il `chown` serve davvero: le cartelle di bind-mount le crea Docker, e le crea
di `root`, mentre ANGEL gira con un utente normale (uid 1000). Se la cartella
resta di `root` non ci scrive, e senza `postgres_password` **Postgres non parte
proprio**. Se te ne dimentichi non si rompe niente in silenzio: nei log ANGEL
scrive esattamente quel comando.

⚠️ Solo `data/segreti`, non `data`. Dentro `data` c'è anche `data/postgres`,
che appartiene all'utente del container di Postgres (uid 999): cambiargli
proprietario gli fa rifiutare l'avvio con «data directory has wrong
ownership».

Una riga per valore, senza virgolette:

```
DISCORD_TOKEN=il.tuo.token
DISCORD_CLIENT_ID=il-tuo-client-id
DISCORD_CLIENT_SECRET=il-tuo-client-secret
PUBLIC_URL=http://il-tuo-umbrel:780
OWNER_IDS=il-tuo-id-discord
```

Poi chiudilo agli altri:

```bash
chmod 600 ~/umbrel/app-data/g-d-app-store-gd-angel/data/segreti/segreti.env
```

Il segreto di sessione, la chiave di cifratura e la password del database non
servono: sono numeri casuali, ANGEL se li genera al primo avvio e se li salva
lì dentro.

Finché manca qualcosa parte **solo il pannello**, e il bot aspetta: ricontrolla
ogni quindici secondi e parte da solo appena i valori ci sono, senza bisogno di
riavviare. Nei log compaiono i nomi letti, mai i valori.

`PUBLIC_URL` segreto non è, ma va scritto lì lo stesso: è l'indirizzo di quella
macchina, e nel compose tornerebbe a `umbrel.local` a ogni aggiornamento. Su
Discord, in **OAuth2 → Redirects**, deve esserci esattamente lo stesso
indirizzo seguito da `/api/auth/callback`.

Il resto — travaso dei valori da una versione precedente, password del database
da riallineare, backup — sta nel
[README dello sviluppo](https://github.com/Gigiomiccio425/aegis-discord-bot/blob/main/umbrel-appstore/README.md).

---

## Le altre app

`beszel` e `beszel-agent` (monitoraggio), `amp`, `magazzino`, `spotify-stats`.

---

Basato sul [template ufficiale](https://github.com/getumbrel/umbrel-community-app-store)
di Umbrel. L'`id` di ogni app deve cominciare con quello dello store
(`g-d-app-store`), e la cartella deve chiamarsi come l'app: è anche il prefisso
dei nomi dei container, quindi di `APP_HOST` dentro il compose.
