# Martin

`Martin` balíček v jazyce Julia pro jednoduchou správu záloh pomocí menu.
Knihovna staví na balíčku `SpravaSouboru` a poskytuje vyšší úroveň ovládání 
pro zálohování, obnovu a archivaci dat.

Projekt je určen především pro:
- rychlé spuštění zálohy přes menu
- obnovu dat ze záložní složky
- vytváření zip archivů záloh
- automatizaci zálohovacích kroků bez ručního psaní příkazů

## Instalace

Balíček lze instalovat pomocí správce balíčků Julia.
```julia
using Pkg
Pkg.add(url="https://github.com/markrcmarik-beep/Martin")
```
Poté je možné balíček načíst:
```julia
using Martin
```

## Hlavní funkce

Balíček aktuálně exportuje hlavní funkci:
- `Martin._zaloha_impl()` - 
- `zaloha()` - zobrazí menu pro výběr oblasti zálohy a navazující akce
- `zalohaokno` - 
- `zalohhatext` - 

## Struktura projektu
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
