Matricola: 342924 

Nome: Matteo Pulcinelli
---
# CardioGuard – Misurazioni di pressione arteriosa e battito  con analisi tramite modello di regressione logistica su servizio remoto

### Panoramica del Progetto
CardioGuard è un'applicazione sviluppata in Dart con Flutter che consente agli utenti di monitorare la propria salute cardiaca. L'utente ha a disposizione due funzionalità principali:
*   **Misurazioni**: registrare i propri parametri  (pressione e battito) nel tempo.
*   **Analisi AI**: utilizzare un sistema di classificazione basato su regressione logistica per valutare il   rischio di malattie cardiache.

L'applicazione è multipiattaforma e supporta Android e Windows.


Le schermate sono quattro:
*   **Home**: pagina principale. Fornisce accesso alle funzionalità principali. Inoltre, è presente un widget dedicato alla qualità dell'aria basato sulla posizione GPS attuale dell'utente.
*   **Misurazioni**: sezione dedicata dove gli utenti possono aggiungere, visualizzare ed eliminare le proprie misurazioni sanitarie giornaliere (es. pressione sanguigna, frequenza cardiaca). I dati vengono salvati localmente e persistono tra le sessioni.
*   **Analisi AI**: sezione dove gli utenti inseriscono i propri dati clinici (età, colesterolo, tipo di dolore toracico, ecc.). Questi dati vengono inviati a un server remoto che li elabora e restituisce una valutazione del rischio (basso/alto rischio e percentuale di confidenza).
*   **Impostazioni**: schermata di configurazione che permette di impostare il profilo utente e selezionare il tipo di tema (chiaro o scuro) dell'applicazione.


<table align="center">
  <tr>
    <td align="center">
      <img src="screenshots/1.png" width="200" alt="Dashboard Principale" />
      <br />
      <sub><b>Dashboard Principale</b><br>Monitoraggio AQI e bottoni di navigazione</sub>
    </td>
    <td align="center">
      <img src="screenshots/2.png" width="180" alt="Registro Misurazioni" />
      <br />
      <sub><b>Registro Misurazioni</b><br>Form inserimento e storico pressione e battito</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="screenshots/3.png" width="200" alt="Analisi AI" />
      <br />
      <sub><b>Analisi AI</b><br>Valutazione rischio cardiaco</sub>
    </td>
    <td align="center">
      <img src="screenshots/4.png" width="200" alt="Risposta AI" />
      <br />
      <sub><b>Risposta AI</b><br>Esito della diagnosi</sub>
    </td>
  </tr>
  <tr>
    <td colspan="2" align="center">
      <img src="screenshots/5.png" width="200" alt="Impostazioni" />
      <br />
      <sub><b>Impostazioni</b><br>Gestione utente e tema</sub>
    </td>
  </tr>
</table>


### Librerie Utilizzate

Per la realizzazione del progetto sono state utilizzate diverse librerie di seguito riportate:
*   **flutter_riverpod**: usato per lo state management; consente di centralizzare lo stato e gestire in modo asincrono i dati (loading/error/data).
*   **sqflite**: implementa un database SQLite locale per archiviare le misurazioni dell'utente da poter poi consultare in qualsiasi momento.
*   **http**: gestisce le richieste di rete verso il servizio AI in Python e le API esterne per la qualità dell'aria.
*   **shared_preferences**: utilizzato per salvare le impostazioni utente semplici e  preferenze sul tema (chiaro/scuro).
*   **geolocator**: recupera le coordinate del dispositivo per ottenere dati sulla qualità dell'aria nel luogo in cui si trova l'utente.
*   **window_manager**: consente di impostare le dimensioni minime della finestra su desktop.

## **Scelte implementative**

* **Repository Pattern**: la logica di accesso ai dati è incapsulata in MeasurementRepository, separando persistenza e UI.
* **Riverpod AsyncNotifier**: usato per gestire la lista delle misurazioni e le operazioni CRUD sul database (insert/delete), mantenendo sincronizzato lo stato della UI (loading/error/data).
* **Iniezione di SharedPreferences**: l’istanza viene inizializzata nel main() e fornita tramite ProviderScope(overrides: ...), così le impostazioni sono disponibili in modo sincrono ovunque.
* **Design adattivo**: un wrapper basato su FittedBox nel builder di MaterialApp scala l’interfaccia su schermi grandi (tablet/desktop), mantenendo layout e leggibilità coerenti.
* **Backend Remoto (FastAPI)**: la logica di Machine Learning è ospitata su un server remoto in Python per permettere l'esecuzione del modello di regressione logistica senza appesantire il client mobile.

## **Problemi riscontrati e soluzioni**

* **Preferenze sincrone per il rendering (tema, impostazioni)**

  * **Problema**: _SharedPreferences.getInstance()_ è asincrono, ma alcune parti della UI (es. tema) hanno bisogno di valori immediati. Usare un _FutureProvider_ avrebbe imposto di gestire _AsyncValue_ e stati di caricamento anche per letture banali.
  * **Soluzione**: inizializzazione di SharedPreferences prima di _runApp()_ e override nel _ProviderScope_. In questo modo il provider può essere sincrono e le impostazioni sono disponibili senza await o FutureBuilder.

* **Ripetizione dei campi di input nella schermata di diagnosi**
  * **Problema**: la gestione di numerosi _TextFormField_ simili comportava codice duplicato e difficile da manutenere; ogni modifica allo stile richiedeva aggiornamenti manuali su più widget.
  * **Soluzione**:  creazione di _CustomTextField_, un widget riutilizzabile che centralizza logica e design, riducendo le ripetizioni e facilitando modifiche globali.

* **Adattabilità dell'interfaccia su schermi grandi (Desktop/Tablet)**
  * **Problema**: su schermi ampi, il layout da mobile risultava troppo dispersivo, con elementi piccoli e molto spazio bianco inutilizzato.
  * **Soluzione**: implementazione di un sistema di "scaling automatico" nel builder di MaterialApp. Se la larghezza supera un breakpoint definito, l'intera interfaccia viene racchiusa in un _FittedBox_ che ne aumenta proporzionalmente le dimensioni, simulando un effetto zoom mantenendo la nitidezza (aumentando il devicePixelRatio).
