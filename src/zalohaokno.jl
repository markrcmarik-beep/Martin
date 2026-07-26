## Funkce Julia
###############################################################
## Popis funkce:
# Zobrazí grafické menu pro zálohování her, softwaru a dokumentů.
# Data čte z konfiguračního souboru zaloha.toml.
# ver: 2026-07-25 (aktualizováno pro TOML)
## Funkce: zalohaokno()
## Autor: Martin
#
## Cesta uvnitř balíčku:
# Martin/src/zalohaokno.jl
#
## Vzor:
# zalohaokno()
# zalohaokno(; auto_choices=[1, 2, 1], execute=false)
#
## Vstupní proměnné:
#
## Výstupní proměnné:
#
## Použité balíčky
#
## Použite funkce:
# menuokno()
###############################################################

"""
    zalohaokno(; config=nothing, auto_choices=nothing, execute=true)

Zobrazí menu pro výběr zálohy podle konfiguračního souboru `zaloha.toml`.

Volby odpovidaji MATLAB funkci `zaloha.m`:
- `hry` -> list `games`
- `software` -> list `software`
- `dokumenty` -> list `dokumentyWin` nebo `dokumentyLinux` podle OS

Keyword `auto_choices` je určený hlavně pro testy, např. `[1, 1, 3]`.
Pokud `execute=false`, funkce pouze vrátí vybranou akci bez spuštění zálohy.
"""
function zalohaokno(;
    config::Union{Nothing,AbstractString}=nothing,
    auto_choices::Union{Nothing,AbstractVector{<:Integer}}=nothing,
    execute::Bool=true,
)
    return Martin._zaloha_impl(menuokno; config, auto_choices, execute)
end
