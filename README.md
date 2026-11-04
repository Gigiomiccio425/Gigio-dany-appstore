<div align="center">

# Gigio &amp; Dany — Community App Store

Nove app per [umbrelOS](https://umbrel.com), installabili in due clic.

</div>

## Aggiungere lo store

**App Store → ⋯ → Community App Stores → Add**, e incolla:

```
https://github.com/Gigiomiccio425/Gigio-dany-appstore
```

Compare «Gigio &amp; Dany» accanto allo store ufficiale. Le app si installano, aggiornano e
disinstallano come tutte le altre.

---

## Le app

| App | Cosa fa | Porta | Versione |
|---|---|---|---|
| **[ANGEL](g-d-app-store-gd-angel/)** | Bot Discord di sicurezza e moderazione, con pannello web. Dentro c'è anche un bot di chat Twitch | 780, 781 | `1.32.0` |
| **[FraBot](g-d-app-store-gd-frabot/)** | Bot Discord con ticket, mini giochi e annunci Twitch, configurato da un pannello web | 8417 | `1.0.2` |
| **[Bot Nuke](g-d-app-store-gd-bot-nuke/)** | Bot Discord per eventi: rinomina e riordina i canali in loop, crea canali all. infinito e ripete messaggi, con dashboard guidata | 4321 | `1.1.0` |
| **[Beszel](g-d-app-store-gd-beszel/)** | Monitoraggio leggero dei tuoi server: carico, memoria, dischi, container | 8090 | `0.19.0` |
| **[Beszel Agent](g-d-app-store-gd-beszel-agent/)** | Fa misurare *questo* Umbrel da un Beszel che gira altrove | 8091 | `0.19.0` |
| **[GD AMP](g-d-app-store-gd-amp/)** | Pannello CubeCoders AMP per server di gioco (immagine Docker non ufficiale) | 8080 | `2.7.2-1` |
| **[GD Magazzino](g-d-app-store-gd-magazzino/)** | Gestione semplice di un magazzino | 8000 | `1.1.1` |
| **[GD Insta Scheduler](g-d-app-store-gd-insta-scheduler/)** | Programma e pubblica post su Instagram via Graph API | 8757 | `1.0.1` |
| **[Spotify Stats](g-d-app-store-gd-spotify-stats/)** | Il tuo storico Spotify, archiviato per sempre | 8787 | `0.2.0` |

Beszel e Beszel Agent sono due app distinte perché fanno due mestieri opposti: la prima raccoglie
e mostra, la seconda si limita a farsi misurare. Su una macchina sola servono entrambe; su più
macchine, un Beszel e tanti agent.

---

## ANGEL: la prima configurazione

ANGEL chiede un bot Discord e un file di segreti prima di funzionare. Il suo token non può stare
nel `docker-compose.yml`.

### Perché non nel compose

Il compose di un'app umbrelOS **appartiene a questo repository**: viene riscritto da qui a ogni
aggiornamento. Un token messo lì dentro sparirebbe al primo aggiornamento — e nel frattempo
starebbe in chiaro in un file leggibile da chiunque abbia accesso alla macchina.

C'è anche un secondo motivo, indipendente: GitHub riconosce il formato dei token Discord e
**rifiuta il push** con `GH013`. E Discord analizza le repository pubbliche e revoca i token che
trova.

### Dove stanno invece

In una cartella dentro i dati dell'app, che gli aggiornamenti non toccano:

```bash
ssh umbrel@umbrel.local
nano ~/umbrel/app-data/g-d-app-store-gd-angel/data/segreti/segreti.env
```

Cinque righe, una per valore, senza virgolette:

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

Il segreto di sessione, la chiave di cifratura e la password del database **non vanno scritti**:
sono numeri casuali, ANGEL se li genera al primo avvio e se li salva lì dentro.

### Finché manca qualcosa

Parte **solo il pannello**, e il bot aspetta: ricontrolla ogni quindici secondi e parte da solo
appena i valori ci sono, senza riavviare l'app. Nei log compaiono i nomi letti, mai i valori.

### L'indirizzo deve combaciare in tre punti

`PUBLIC_URL` segreto non è, ma va scritto lì lo stesso: nel compose tornerebbe a `umbrel.local` a
ogni aggiornamento, e l'accesso al pannello fallirebbe con «stato non valido», che non spiega
niente.

Lo stesso indirizzo, seguito da `/api/auth/callback`, deve stare su Discord in
**OAuth2 → Redirects**. Browser, `segreti.env` e Discord: tutti e tre uguali.

### Il resto

Travaso dei valori da una versione precedente, password del database da riallineare, backup,
comandi, pannello:

**[Documentazione di ANGEL](https://github.com/Gigiomiccio425/aegis-discord-bot/tree/main/docs)**

---

## FraBot: la prima configurazione

FraBot si configura interamente dal pannello: non serve modificare file né impostare variabili
d'ambiente. Dopo l'installazione:

1. Apri FraBot dallo store. Il pannello passa dal login di Umbrel.
2. Segui il wizard in 7 passaggi: crea l'app Discord, incolla Application ID e Bot Token, invita il
   bot, scegli il server e i moduli, collega Twitch se ti serve e invia il messaggio di prova.
3. Alla fine si apre la Dashboard. Ticket, mini giochi e annunci Twitch si gestiscono da lì.

Il token Discord e il Client Secret Twitch stanno nel database del volume `/data`, non nel
compose. Non vengono mai restituiti dalle API e vengono rimossi dai log. Il pannello è protetto
dal login di Umbrel; se lo esponi fuori da Umbrel, mettilo dietro un reverse proxy con
autenticazione.

Gli aggiornamenti dell'app conservano `/data`, quindi configurazione, ticket, transcript e saldi
restano. Il codice e il workflow dell'immagine sono in
[**danyx67800/frabot**](https://github.com/danyx67800/frabot).

---

## Bot Nuke: la prima configurazione

Bot Nuke non fa niente finché non glielo dici tu, e si configura tutto dal browser: nessun file da
modificare e nessun token nel compose.

1. Apri Bot Nuke dallo store. La dashboard ha una password sua, diversa da quella di Umbrel: la
   scegli al primo accesso.
2. Crea l'app su Discord e incolla il token al passo 1. Lì accanto c'è il pulsante che invita il bot
   con i permessi già calcolati: Gestire i canali, Vedere i canali, Inviare messaggi.
3. Scegli server e canali, scrivi i nomi a rotazione (uno per riga), i testi dei messaggi e i tempi.
4. Al passo 6 lascia acceso il **dry run**: il bot calcola tutto e scrive nel log cosa farebbe, senza
   toccare Discord. Quando ti convince, spegnilo e avvia il loop.

Il **Panic** ferma il loop e rimette nomi e ordine di prima. Lo snapshot viene preso al primo avvio
del loop, quindi conviene avviarlo una volta prima dell'evento: se lo snapshot non c'è, il pulsante
resta disattivato.

I limiti non si aggirano: Discord concede 2 rinomine per canale ogni 10 minuti e 2 riordini per
server ogni 10 minuti. Con un intervallo corto il bot rimanda le azioni in eccesso — e in dashboard
vedi il countdown di ogni canale — invece di prendere errori.

Il token resta in `/data`, dentro il volume dell'app. Codice e workflow dell'immagine sono in
[**danyx67800/Bot_nuke**](https://github.com/danyx67800/Bot_nuke).

---

## Per chi vuole guardarci dentro

```
Gigio-dany-appstore/
  umbrel-app-store.yml          id e nome dello store
  g-d-app-store-gd-angel/
    umbrel-app.yml              la scheda che umbrelOS mostra
    docker-compose.yml          i servizi
  …una cartella per app
```

L'`id` di ogni app **deve** cominciare con quello dello store (`g-d-app-store`), e la cartella
deve chiamarsi esattamente come l'app: è anche il prefisso con cui compose battezza i container,
quindi la stringa che finisce in `APP_HOST`. Rinominarla senza aggiornare `APP_HOST` produce
un'app che si installa, parte, e mostra una pagina bianca.

Per aggiornare un'app servono **due** numeri, cambiati insieme: `version:` in `umbrel-app.yml`,
che è quello che umbrelOS mostra e confronta, e il tag dell'immagine in `docker-compose.yml`, che
è quello che scarica davvero. Cambiarne uno solo produce un aggiornamento che dice di aver
funzionato senza fare niente — o un'immagine nuova che si dichiara vecchia.

---

<sub>Basato sul [template ufficiale](https://github.com/getumbrel/umbrel-community-app-store) di
Umbrel. Le app di terze parti restano dei rispettivi autori; qui c'è solo il confezionamento per
umbrelOS.</sub>
