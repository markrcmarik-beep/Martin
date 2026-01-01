## Funkce Julia
###############################################################
## Popis funkce:
# Zobrazí nabídku zálohování pro hry, software a dokumenty.
# Data čerpá z tabulky `zaloha.ods` umístěné ve stejné složce 
# jako tato funkce. 
# ver: 2025-11-19
## Funkce: []=zaloha()
#
## Vzor:
## []=zaloha()
## Vstupní proměnné:
#
## Výstupní proměnné:
#
## Použité balíčky
#
## Použité funkce:
#
## Příklad:
# >> zaloha()

## Použité proměnné vnitřní:
#
using XLSX, FilePathsBase, SpravaSouboru  # pokud je to balíček projektu – přizpůsobte
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
    cesta = joinpath(@__DIR__, "zaloha", soubor)

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
        if Sys.iswindows()
            sheet = "dokumentyWin"
        else
            sheet = "dokumentyLinux"
        end
        msg01 = "Vyber dokumenty"
    else
        return
    end

    # --- Druhá úroveň: výběr položky z tabulky ---
    choice001, source, destination = funkce01(cesta, sheet, soubor, msg01)

    # --- Třetí úroveň: akce ---
    akceVSE(choice001, source, destination)
end


"""
    funkce01(cesta, sheet, soubor, msg01)

Načte položky ze sešitu, zobrazí menu a vrátí:
- choice001 : index akce
- source : zdrojová složka
- destination : cílová složka
"""
function funkce01(cesta::String, sheet::String, soubor::String, msg01::String)

    rozsah = sprdsheet2velkst(cesta, sheet)
    Aref = souredniceRefSprdsheet(last(split(rozsah, ":")))

    # Načtení textů menu
    opt01 = XLSX.readtable(cesta, sheet; range="A3:A$(Aref[1])")[:][1]
    opt01 = [String(o) for o in opt01]

    choice01, _ = menugui(msg01, opt01)
    println("Vybráno: ", opt01[choice01])

    # Zdroj
    source01 = XLSX.readtable(cesta, sheet; range="B3:B$(Aref[1])")[:][1]
    source = String(source01[choice01])

    # Cíl
    destination01 = XLSX.readtable(cesta, sheet; range="C3:C$(Aref[1])")[:][1]
    destination = String(destination01[choice01])

    # Výběr akce
    msg001 = "Vyber"
    opt001 = ["zálohovat", "zálohovat a vytvořit .zip", "obnovit"]
    choice001, _ = menugui(msg001, opt001)
    println("Vybráno: ", opt001[choice001])

    return choice001, source, destination
end


"""
    akceVSE(choice001, source, destination)

Provede odpovídající operaci podle výběru uživatele.
"""
function akceVSE(choice001::Int, source::String, destination::String)

    if choice001 == 1
        zalohovat(source, destination, "zalohovat")

    elseif choice001 == 2
        zalohovat(source, destination, "zalohovat")
        pwd_before = pwd()
        cd(destination)
        zalohovat(source, destination, "zipnout")
        cd(pwd_before)

    elseif choice001 == 3
        zalohovat(source, destination, "obnovit")
    end
end