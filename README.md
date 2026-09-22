<div align="center">

# Gigio &amp; Dany — Community App Store

Sette app per [umbrelOS](https://umbrel.com), installabili in due clic.

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
| **[ANGEL](g-d-app-store-gd-angel/)** | Bot Discord di sicurezza e moderazione, con pannello web. Dentro c'è anche un bot di chat Twitch | 780, 781 | `1.31.1` |
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

È l'unica app dello store che chiede qualcosa prima di funzionare. Serve un bot Discord tuo, e il
suo token non può stare nel `docker-compose.yml`.

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
