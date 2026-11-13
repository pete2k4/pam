# Laboratorul 3 – GemStore

Interfața din laboratorul 2, conectată la un fișier JSON local prin Cubit.

```sh
cd lab3
flutter pub get
flutter run
```

Butonul de meniu deschide căutarea, filtrele de categorie și secțiune, sortarea
după preț și filtrul de favorite. „Show all” deschide produsele secțiunii.
Apasă pe un produs pentru detalii, culori, mărimi și produse similare.
Favoritele sunt comune între catalog și detalii și se păstrează pe durata sesiunii.
„Add To Cart” afișează confirmarea alegerii, la fel ca în laboratorul 2.

Aplicația gestionează Loading, Success, Empty și Error. Un nume inexistent sau
o categorie fără produse afișează Empty. Pentru o eroare la citirea sau parsarea
fișierului apare butonul Retry.

Datele și imaginile se încarcă din proiect. Modelele sunt în `lib/models`,
citirea asincronă în `lib/data`, Cubit în `lib/state`, ecranele în `lib/screens`,
iar componentele reutilizabile în `lib/widgets`.

Modificările față de JSON-ul primit sunt următoarele.

- Toate cele opt produse sunt în lista comună `products`. Obiectul singular
  `productPage.product` a fost înlocuit cu detaliile fiecărui produs.
- Listele `homePage.featureProducts`, `homePage.recommended` și
  `similarProductIds` conțin ID-uri de produse. Câmpul `group` identifică
  secțiunea folosită de filtrul de catalog.
- Am adăugat `categoryId`. Toate produsele existente sunt încadrate la
  `women`. Categoriile Men, Accessories și Beauty rămân disponibile și
  afișează starea Empty.
- Pentru cele șapte produse fără detalii am adăugat descrieri demonstrative,
  câte o culoare, mărimile S/M/L disponibile și mărimea inițială M.
  Evaluările și numărul de recenzii pentru acestea sunt zero.
- Sportwear Set păstrează descrierea, culorile, disponibilitatea mărimilor,
  evaluarea și cele două recenzii din fișierul primit.
- URL-urile imaginilor au fost înlocuite cu `image` și `avatar`, fiecare
  conținând `asset` și `crop`. Acestea indică fotografiile din imaginile locale
  folosite de laboratorul 2. Titlurile și textele bannerelor sunt randate din JSON.
- Fiecare produs are o singură imagine corectă în `galleryImages`.
  Imaginea de tricou din galeria Sportwear Set și numărul artificial de slide-uri
  al bannerului au fost eliminate.
- Categoriile folosesc chei `icon` pentru pictograme Flutter în loc de URL-uri SVG.
  Bannerele au `categoryId` pentru deschiderea catalogului corespunzător.
