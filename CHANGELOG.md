# Changelog

Přehled změn balíčku `Martin` podle verzí zaznamenaných v historii `Project.toml`.

## [0.1.6] - 2026-11-06

### Přidáno
- Soubor nápovědy balíčku `SpravaSouboru.md`
- funkce `cesta()`
### Upraveno
- Opravy výchozí konfigurace záloh pro Windows a Linux.
- Kontrola podporovaného operačního systému při výběru dat.
- Příprava a úpravy konfiguračního souboru `zaloha.toml`.
- Odstraněno verzování používaných balíčků.

## [0.1.5] - 2026-07-26

### Přidáno
- Textová funkce `zalohatext()` a grafická funkce `zalohaokno()`.
- Společná implementace výběru a provádění zálohovacích akcí.
- Konfigurace kategorií a položek v souboru `zaloha.toml`.
- Možnost zadat vlastní konfiguraci, automatické volby a vypnout provádění akcí, například pro testování.
- Skript pro prekompilaci balíčku a testy nové funkcionality.
### Upraveno
- Funkce `zaloha()` deleguje ovládání na textové menu.

## [0.1.4] - 2026-06-05

### Přidáno
- Funkční verze nabídky pro výběr zálohovacích operací.

## [0.1.3] - 2026-03-31

### Upraveno
- Doplněn popis projektu a průběžně upravena struktura balíčku.

## [0.1.2] - 2026-01-01

### Přidáno
- První zaznamenaná verze balíčku pro spouštění zálohování pomocí nabídky.

## Historie před první verzí

Počáteční vývoj zahrnoval nastavení projektu, úklid a opravy. Verze `0.1.2` je uvedena v prvním souboru `Project.toml`; samostatný commit, který by ji přímo označoval, v historii chybí.
