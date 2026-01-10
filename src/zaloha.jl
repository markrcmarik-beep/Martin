## Funkce Julia
###############################################################
## Popis funkce:
# Zobrazí nabídku zálohování pro hry, software a dokumenty.
# Data čerpá z tabulky `zaloha.ods` umístěné ve stejné složce 
# jako tato funkce. 
# ver: 2025-11-20
## Funkce: []=zaloha()
#
## Vzor:
## []=zaloha()
## Vstupní proměnné:
#
## Výstupní proměnné:
#
## Použité balíčky
# FilePathsBase, SpravaSouboru
## Použité funkce:
#
## Příklad:
# >> zaloha()

## Použité proměnné vnitřní:
#
using FilePathsBase, SpravaSouboru  # pokud je to balíček projektu – přizpůsobte
# using menugui, zalohovat  – přidejte podle své struktury

"""
    zaloha()

Zobrazí nabídku zálohování pro hry, software a dokumenty.
Data čerpá z tabulky `zaloha.ods` umístěné ve stejné složce jako 
tato funkce.
"""
function zaloha()

    # Absolutní cesta k souboru zaloha.ods
    soubor = "zaloha.ods"
    cesta = joinpath(pkgdir(Martin, "data"), soubor)

    # --- První úroveň menu ---
    msg1 = "Vyber"
    opt1 = ["hry", "software", "dokumenty"]
    choice1, _ = menugui(msg1, opt1)

    if choice1 == 1
        sheet = "games"
        msg01 = "Vyber hru"

    elseif choice1 == 2
        sheet = "software"
        msg01 = "Vyber software"

    elseif choice1 == 3
        sheet = Sys.iswindows() ? "dokumentyWin" : "dokumentyLinux"
        msg01 = "Vyber dokumenty"

    else
        return
    end

    # Druhá úroveň
    choice001, source, destination =
        funkce01(cesta, sheet, soubor, msg01)

    # Třetí úroveň
    akceVSE(choice001, source, destination)
end

function funkce01(cesta::String, sheet::String, soubor::String, msg01::String)

    # Získání rozsahu dat, např. "A3:C17"
    rozsah = sprdsheet2velkst(cesta, sheet)

    # Pravá horní buňka—například "C17"
    ref_end = last(split(rozsah, ":"))

    # Převod pomocí nové funkce sprsheetRef()
    Aref = sprsheetRef(ref_end)   # vrací [row, col]
    lastrow = Aref[1]
    # --------- A texty (sloupec A) ----------
    opt01 = sprsheet2tabl(cesta, sheet, "A3", "A$(lastrow)")
    opt01 = [String(o) for o in opt01]

    choice01, _ = menugui(msg01, opt01)
    println("Vybráno: ", opt01[choice01])

    # --------- B zdroje ----------
    source01 = sprsheet2tabl(cesta, sheet, "B3", "B$(lastrow)")
    source = String(source01[choice01])

    # --------- C destinace ----------
    destination01 = sprsheet2tabl(cesta, sheet, "C3", "C$(lastrow)")
    destination = String(destination01[choice01])

    # --------- Akce ----------
    msg001 = "Vyber"
    opt001 = ["zálohovat", "zálohovat a vytvořit .zip", "obnovit"]

    choice001, _ = menugui(msg001, opt001)
    println("Vybráno: ", opt001[choice001])

    return choice001, source, destination
end

function akceVSE(choice001::Int, source::String, destination::String)

    if choice001 == 1
        zalohovat(source, destination, "zalohovat") # Pouze zálohovat

    elseif choice001 == 2
        zalohovat(source, destination, "zalohovat") # Nejprve zálohovat

        cd(destination) do # Přepnout do cílové složky
            zalohovat(source, destination, "zipnout") # Vytvořit .zip
        end

    elseif choice001 == 3
        zalohovat(source, destination, "obnovit") # Obnovit
    end
end
