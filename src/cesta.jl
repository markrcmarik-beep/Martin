## Funkce Julia v1.13
###############################################################
## Popis funkce:
#
# ver: 2026-11-06
## Funkce: cesta()
## Autor: Martin
#
## Cesta uvnitř balíčku:
# balicek/src/cesta.jl
#
## Vzor:
## vystupni_promenne = cesta(vstupni_promenne)
## Vstupní proměnné:
# ces - cesta k souboru nebo složce, může používat značky
#   značky:
#      *uzivatel* - cesta k uživatelské složce
#      *dokumenty* - cesta k dokumentům
#      *onedrive* - cesta k OneDrive složce
#      *pcloud* - cesta k PC Cloud složce
## Výstupní proměnné:
# ces - cesta k souboru nebo složce, převedená na správný formát pro daný operační systém
## Použité balíčky:
#
## Použité uživatelské funkce:
#
## Příklad:
#
###############################################################
## Použité proměnné vnitřní:
#

function cesta(ces, operacni=nothing)

    if isnothing(operacni)
        if Sys.iswindows()
            operacni = "Windows"
        elseif Sys.islinux()
            operacni = "Linux"
        else
            error("Nepodporovaný operační systém: $(Sys.KERNEL)")
        end
    end

    if operacni == "Windows"
        ces = replace(ces, '/' => '\\')
    elseif operacni == "Linux"
        ces = replace(ces, '\\' => '/')
    else
        error("Nepodporovaný operační systém: $operacni")
    end
    resolved = replace(ces, "*uzivatel*" => homedir())
    if operacni == "Windows"
        resolved = replace(resolved, "*dokumenty*" => joinpath(homedir(), "Documents"))
    elseif operacni == "Linux"
        resolved = replace(resolved, "*dokumenty*" => joinpath(homedir(), "Documents"))
    end
    if operacni == "Windows"
        resolved = replace(resolved, "*onedrive*" => get(ENV, "OneDrive", joinpath(homedir(), "OneDrive"))) #
        resolved = replace(resolved, "*pcloud*" => get(ENV, "PCLOUD", "P:\\"))
    elseif operacni == "Linux"
        resolved = replace(resolved, "*onedrive*" => get(ENV, "OneDrive", joinpath(homedir(), "OneDrive")))
        resolved = replace(resolved, "*pcloud*" => get(ENV, "PCLOUD", joinpath(homedir(), "PCLOUD")))
    end
    ces = joinpath(resolved)
    return ces
end
