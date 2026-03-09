Martin

Balíček v jazyce Julia pro jednoduchou správu záloh pomocí menu.
Knihovna staví na balíčku `SpravaSouboru` a poskytuje vyšší úroveň ovládání pro zálohování, obnovu a archivaci dat.

Projekt je určen především pro:

rychlé spuštění zálohy přes menu

obnovu dat ze záložní složky

vytváření zip archivů záloh

automatizaci zálohovacích kroků bez ručního psaní příkazů

Instalace

Balíček lze instalovat pomocí správce balíčků Julia.

using Pkg
Pkg.add(url="https://github.com/markrcmarik-beep/Martin")

Poté je možné balíček načíst:

using Martin

Hlavní funkce

Balíček aktuálně exportuje hlavní funkci:

zaloha() - zobrazí menu pro výběr oblasti zálohy a navazující akce

Funkce využívá interně nástroje z `SpravaSouboru`, zejména:

menugui() - výběr možností v grafickém menu

zalohovat() - provedení zálohy, obnovy nebo zip archivace

sprdsheet2velkst(), sprsheetRef(), sprsheet2tabl() - načítání konfiguračních dat z tabulky

Příklad použití

Spuštění hlavního menu zálohy:

zaloha()

Typický průběh:

výběr kategorie (hry / software / dokumenty)

výběr konkrétní položky

výběr akce (zálohovat, zálohovat + zip, obnovit)

Práce se zálohami

Balíček je navržen jako orchestrace zálohovacích operací.
Samotné kopírování, synchronizace a zip archivace je delegováno na balíček `SpravaSouboru`.

Struktura projektu
Martin
│
├─ src
│   ├─ Martin.jl
│   └─ zaloha.jl
│
├─ test.jl
├─ build.jl
├─ clean.jl
├─ update.jl
└─ Project.toml

Stav projektu

Projekt je ve vývoji.
Nové funkce a úpravy jsou průběžně přidávány.

Spolupráce na vývoji

Pokud chcete přispět k vývoji:

vytvořte vlastní branch

proveďte změny

odešlete Pull Request

Diskuse o vývoji probíhá pomocí nástrojů platformy GitHub.

Licence

Licence projektu bude doplněna.
