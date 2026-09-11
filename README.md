# LiftIt

Besplatna, lokalna Android aplikacija za praćenje treninga, ishrane i fizičkog napretka. Nema naloga, nema servera, nema pretplate — svi podaci ostaju na uređaju. Napravljena u Flutteru za ličnu upotrebu.

Paket: `com.liftit.app`

---

## Sadržaj

- [Trening](#trening)
- [Statistika i istorija](#statistika-i-istorija)
- [Streak sistem](#streak-sistem)
- [Telesna težina i progres fotografije](#telesna-težina-i-progres-fotografije)
- [Ishrana](#ishrana)
- [BMI i kalkulator kalorija](#bmi-i-kalkulator-kalorija)
- [Profil](#profil)
- [Podešavanja](#podešavanja)
- [AI funkcionalnosti](#ai-funkcionalnosti)
- [Privatnost i podaci](#privatnost-i-podaci)
- [Lokalizacija](#lokalizacija)
- [Tehnologije](#tehnologije)

---

## Trening

- **Splitovi** — kreiranje sopstvenih trening splitova (npr. Push/Pull/Legs), svaki dan u splitu ima svoje planirane vežbe sa ciljnim brojem serija i opsegom ponavljanja.
- **Aktivni trening** — pokretanje treninga iz splita ili slobodno (bez plana), logovanje serija (težina, ponavljanja, RPE, beleška, opcija "zagrevanje"), tajmer odmora između serija.
- **Predlog sledeće serije** — kada loguješ seriju neke vežbe, aplikacija predlaže sledeći cilj na osnovu prošlog treninga te vežbe (standardna dupla progresija: ako si prošli put dostigao gornju granicu ponavljanja, predlaže se veća težina uz manje ponavljanja; ako nisi, predlaže se isto opterećenje uz jedno ponavljanje više). Predlog se popunjava jednim dodirom, ostaje slobodan za izmenu. Ovo je lokalni proračun, ne ide preko interneta.
- **Ekran završetka treninga** — trajanje, ukupan volumen, broj vežbi/serija, oznaka ličnih rekorda (PR) oborenih tog treninga.
- **AI beleške trenera** — nakon završetka treninga, u pozadini se generiše kratak rezime (poredi trenutni trening sa prethodnim uporedivim — brzina, volumen, napredak, čestitke za PR). Vidljivo odmah na ekranu završetka (dugme "Pogledaj šta kaže trener") i kasnije u istoriji tog treninga.
- **Biblioteka vežbi** — pregled i pretraga vežbi po mišićnoj grupi i opremi, svaka vežba ima svoju stranicu sa istorijom performansi i ličnim rekordom (testiran 1RM ili Epley procena).

## Statistika i istorija

- **Istorija treninga** — lista svih završenih treninga, detalji po vežbi (serije, težine, ponavljanja), brisanje uz potvrdu.
- **Stats ekran** — ukupan broj treninga, trenutni streak, prosek treninga nedeljno, prosečno trajanje, grafikon nedeljnog volumena, lista ličnih rekorda, raspodela volumena po mišićnim grupama (kružni grafikon).

## Streak sistem

- 5 nivoa streak-a (Iskra → Žar → Plamen → Buktinja → Inferno) na osnovu doslednosti treniranja, uzima u obzir podešene dane odmora.

## Telesna težina i progres fotografije

- **Praćenje telesne težine** — logovanje kroz vreme, izbor jedinice (kg/lb), grafikon trenda, istorija sa brisanjem.
- **Progres fotografije** — galerija fotografija tela kroz vreme, slikanje kamerom ili izbor iz galerije, čuvaju se u punoj rezoluciji bez kompresije. Pregled preko celog ekrana sa zumiranjem.
- **AI poređenje fotografija** — svaka nova fotografija se u pozadini upoređuje sa prethodnom, Gemini piše kratku ohrabrujuću belešku o vidljivom napretku vezanom za trening (držanje, definicija, opšti izgled) — namerno bez ikakvog komentara na telesnu težinu, veličinu ili izgled.

## Ishrana

- **Dnevnik ishrane** — pregled bilo kog dana (prošlost do danas), ukupne kalorije/proteini/ugljeni hidrati/masti sa progres barovima naspram dnevnih ciljeva (crveno kad se pređe cilj).
- **Ručni unos** — unos apsolutnih vrednosti, ili prebacivanje na "na 100g" režim (unosiš nutritivne vrednosti na 100g te hrane + koliko grama si pojeo, aplikacija sama izračuna).
- **Pretraga** — Open Food Facts (pakovani proizvodi) i USDA FoodData Central (generička/sirova hrana) spojeno u jednu listu rezultata, sa automatskim preračunom po unetoj količini.
- **Skeniranje bar koda** — kamera skenira bar kod, pretražuje Open Food Facts bazu; ako proizvod nije pronađen, nudi se ručni unos.
- **Prepoznavanje sa slike** — slikaš obrok, Gemini prepoznaje stavke i procenjuje kalorije/makronutrijente.
- **Opiši hranu** — opišeš šta si jeo, koliko i kako je spremljeno, Gemini proceni kalorije i makroe (dostupno direktno iz menija za dodavanje hrane, ili kao opcija kad pretraga ne nađe ništa).
- **Sačuvana hrana ("Moja hrana")** — čuvanje bilo koje unete hrane (na 100g ili fiksna količina) za brzo ponovno korišćenje bez ponovnog kucanja.
- **Praćenje vode** — brzi dodaci (100/250/500ml), opozivanje poslednjeg unosa, progres bar naspram dnevnog cilja.
- **Suplementi** — dodavanje suplemenata sa dnevnom dozom (npr. "Kreatin" / "5g"), čekiranje po danu da li je popijen, istorija po danima.
- **Trendovi ishrane** — nedeljni prosek kalorija (grafikon sa linijom cilja) i nedeljni prosek makronutrijenata (slojeviti grafikon proteini/ugljeni hidrati/masti) za poslednjih 8 nedelja.
- Svaki unos (hrana, voda) ide na dan koji trenutno gledaš u dnevniku, ne uvek na "danas" — može se naknadno uneti/ispraviti unos za prošli dan.

## BMI i kalkulator kalorija

- **BMI kalkulator** — unos težine/visine/godina/pola/nivoa aktivnosti, prikaz BMI vrednosti i kategorije uz vizuelnu skalu u boji (pothranjenost/normalno/prekomerno/gojaznost) sa strelicom koja pokazuje tvoju vrednost.
- **Kalkulator dnevnih ciljeva** — na osnovu istih podataka izračunava 5 setova dnevnih ciljeva kalorija i makronutrijenata (Agresivan cut, Cut, Održavanje, Bulk, Agresivan bulk) po proverenim formulama (Mifflin-St Jeor BMR + faktor aktivnosti). Dugme "Postavi kao cilj" odmah primenjuje izabrani set kao tvoje nutritivne ciljeve. Proračun je lokalan, ne ide preko interneta.

## Profil

- **Osnovni podaci** — ime, datum rođenja, pol, visina, nivo iskustva, primarni cilj, preferirana jedinica težine, nedeljni cilj treninga.
- **Ciljevi ishrane** — posebna sekcija za kalorije/proteine/ugljene hidrate/masti/vodu, odvojena od osnovnih podataka, sa sopstvenim dugmetom za izmenu.

## Podešavanja

- **Izgled** — svetla/tamna/sistemska tema.
- **Jezik** — srpski/engleski/sistemski, promena u letu.
- **API ključevi** — mesto za unos sopstvenih besplatnih Gemini i USDA API ključeva.
- **Rezervna kopija** — izvoz kompletne baze podataka u jedan fajl (deljenje preko sistema), vraćanje iz rezervne kopije uz potvrdu.
- **O aplikaciji** — verzija i osnovne informacije.

## AI funkcionalnosti

Sve AI funkcije koriste Gemini API preko tvog sopstvenog besplatnog ključa i potpuno su opcione — aplikacija radi normalno i bez njih:

- Prepoznavanje hrane sa fotografije
- Procena kalorija/makroa iz teksta opisa
- Beleške trenera nakon treninga (poređenje sa prethodnim)
- Poređenje progres fotografija

Namerno **nisu** AI-bazirani (koriste proverene formule umesto poziva ka Gemini-ju, radi brzine, pouzdanosti i rada bez interneta/ključa):

- BMI i kalkulator dnevnih kalorijskih ciljeva
- Predlog sledeće serije (progresivno opterećenje)

## Privatnost i podaci

- Nema naloga, nema prijave, nema servera — sve što je uneto ostaje na uređaju.
- Svi podaci se čuvaju u lokalnoj SQLite bazi (uključujući progres fotografije, kao BLOB).
- Rezervna kopija je jedan fajl koji korisnik sam čuva i deli po želji.
- API ključevi se čuvaju odvojeno (lokalno, u SharedPreferences) i **namerno nisu uključeni** u rezervnu kopiju — nikad se ne kompajliraju u aplikaciju niti šalju na bilo koji server osim direktno ka odgovarajućem API-ju (Gemini/USDA) kada korisnik aktivno koristi tu funkciju.
- Open Food Facts ne zahteva nikakav ključ.

## Lokalizacija

Kompletna aplikacija je prevedena na srpski i engleski, sa mogućnošću promene jezika u hodu iz Podešavanja.

## Tehnologije

- **Flutter** (Dart) — Android
- **Riverpod** — upravljanje stanjem
- **Drift (SQLite)** — lokalna baza podataka
- **go_router** — navigacija
- **fl_chart** — grafikoni
- **Open Food Facts**, **USDA FoodData Central**, **Google Gemini API** — spoljni izvori podataka (svi opcioni)
