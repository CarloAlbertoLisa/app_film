# app_film
________________________________________
Descrizione del progetto
Applicazione Flutter Web che mostra una lista di film con relativi dettagli, utilizzando le API pubbliche di The Movie Database (TMDB).
L’obiettivo è stato sviluppare un’app funzionante con struttura chiara, separazione delle responsabilità e gestione corretta degli stati (loading, errore, dati).
________________________________________
API utilizzata
•	The Movie Database (TMDB) 
•	https://www.themoviedb.org/ 
•	https://developer.themoviedb.org/docs 
Le chiamate HTTP vengono effettuate tramite API REST utilizzando una API key fornita via --dart-define.
________________________________________
Funzionalità implementate
Lista film
•	Visualizzazione film popolari 
•	Titolo, locandina, voto medio 
•	Gestione stati: 
o	loading 
o	errore 
o	dati caricati 
•	Retry in caso di errore 
Dettaglio film
•	Titolo 
•	Descrizione 
•	Voto 
•	Data di uscita 
•	Immagine di copertina 
Funzionalità aggiuntive
•	Ricerca film per titolo 
•	Sistema di preferiti 
•	Persistenza preferiti con SharedPreferences 
•	Tema chiaro/scuro 
•	Splash screen iniziale 
________________________________________
Architettura e struttura del progetto
lib/
├── controllers/
├── models/
├── services/
├── pages/
├── widgets/
├── routes/
└── theme/
Separazione chiara tra:
•	UI 
•	logica applicativa 
•	servizi API 
•	gestione stato 
•	modelli dati 
________________________________________
State Management
Utilizzato Provider (ChangeNotifier).
Scelta motivata da:
•	complessità del progetto contenuta 
•	semplicità di implementazione 
•	buona separazione UI/logica 
•	sufficiente per gestire stati globali senza overhead 
________________________________________
Gestione errori
Gestiti i principali casi:
•	errori di rete 
•	API key mancante/non valida 
•	errori server TMDB 
•	risultati vuoti 
•	failure caricamento dati 
In ogni caso viene mostrato un messaggio con possibilità di retry.
________________________________________
Come avviare il progetto
Requisiti
•	Flutter stable 
•	Chrome 
Installazione
flutter pub get
Avvio
flutter run -d chrome --dart-define=TMDB_API_KEY=YOUR_API_KEY
Build web
flutter build web --dart-define=TMDB_API_KEY=YOUR_API_KEY
________________________________________
Librerie utilizzate
Libreria	Utilizzo
provider	state management
http	API REST
shared_preferences	storage locale
cached_network_image	caching immagini
________________________________________
Difficoltà incontrate
•	gestione HTTP su Flutter Web 
•	organizzazione architettura iniziale 
•	gestione persistenza preferiti 
•	gestione stati (loading/error/success) 
•	configurazione API key con dart-define 
Soluzione: scomposizione del progetto in moduli e sviluppo incrementale.
________________________________________
Miglioramenti con più tempo
•	paginazione/infinite scroll 
•	miglioramento lato grafico
•	caching locale dei dati API 
•	supporto offline 
•	animazioni UI 
•	ricerca lato API TMDB 
•	gestione casi limite più completa 
________________________________________
Utilizzo di Intelligenza Artificiale
Durante lo sviluppo è stato utilizzato un supporto di AI generativa.
Uso principale:
•	generazione codice base 
•	suggerimenti architetturali 
•	supporto nella gestione stato e API 
•	velocizzazione boilerplate 
Contributo personale:
•	definizione requisiti e struttura 
•	organizzazione architettura 
•	integrazione e test del codice 
•	modifiche UI e comportamento 
•	debug e correzioni 
________________________________________
Tempo impiegato
Circa 3 ore.

