## Funkce Julia
###############################################################
## Popis funkce:
#
# ver: 2026-07-25
## Funkce: Martin._zaloha_impl()
## Autor: Martin
#
## Cesta uvnitř baličku:
# Martin/src/_zaloha_impl.jl
#
## Vzor:
#
## Vstupní proměnné:
#
## Výstupní proměnné:
#
## Použité balíčky
# TOML, SpravaSouboru
## Použité funkce:
# zalohovat()
###############################################################
## Pomocné funkce: _default_zaloha_config(), _read_backup_entries(), 
# _run_backup_action(), _auto_choice()
using SpravaSouboru
using TOML

function _zaloha_impl(
    menu_func::Function;
    config::Union{Nothing,AbstractString}=nothing,
    auto_choices::Union{Nothing,AbstractVector{<:Integer}}=nothing,
    execute::Bool=true,
)
    config_path = isnothing(config) ? _default_zaloha_config() : String(config)
    config_data = TOML.parsefile(config_path)

    categories = [
        (label="hry", sheet="games", prompt="Vyber hru"),
        (label="software", sheet="software", prompt="Vyber software"),
        (
            label="dokumenty",
            sheet=Sys.iswindows() ? "dokumentyWin" : "dokumentyLinux",
            prompt="Vyber dokumenty",
        ),
    ]

    # 1. Výběr kategorie (hry, software, dokumenty)
    category_choice, _ = menu_func(
        "Vyber",
        [category.label for category in categories];
        auto_choice=_auto_choice(auto_choices, 1),
    )
    category_choice == 0 && return nothing
    category = categories[category_choice]

    # 2. Výběr položky v kategorii
    entries, prompt_from_config = _read_backup_entries(config_data, category.sheet)
    labels = [entry.label for entry in entries]
    item_choice, item_label = menu_func(
        prompt_from_config, # Použití promptu z TOML souboru
        labels;
        auto_choice=_auto_choice(auto_choices, 2),
    )
    item_choice == 0 && return nothing
    entry = entries[item_choice]

    # 3. Výběr akce (zálohovat, zip, obnovit)
    action_options = ["zálohovat", "zálohovat a vytvořit .zip", "obnovit"]
    action_choice, action_label = menu_func(
        "Vyber",
        action_options;
        auto_choice=_auto_choice(auto_choices, 3),
    )
    action_choice == 0 && return nothing

    plan = (
        category=category.label,
        sheet=category.sheet,
        item=item_label,
        action=action_label,
        source=entry.source,
        destination=entry.destination,
    )

    execute && _run_backup_action(action_choice, entry.source, entry.destination)
    return plan
end

const _DEFAULT_CONFIG_NAME = "zaloha.toml"

"""
Najde výchozí konfigurační soubor `zaloha.toml`.
Priorita je soubor v `src/` adresáři balíčku.
"""
function _default_zaloha_config()
    # Primárně hledá soubor ve stejném adresáři jako tento skript
    config_path = joinpath(@__DIR__, _DEFAULT_CONFIG_NAME)
    isfile(config_path) && return config_path
    
    error("Konfigurační soubor '$_DEFAULT_CONFIG_NAME' nebyl nalezen v adresáři 'src/'. " *
          "Zadejte cestu pomocí `config=\"cesta/k/zaloha.toml\"`.")
end

"""
Načte a zvaliduje položky zálohy z již načtených dat z TOML souboru.
"""
function _read_backup_entries(config_data::Dict, sheet::String)::Tuple{Vector, String}
    haskey(config_data, sheet) || error("Sekce '$sheet' v konfiguračním souboru chybí.")
    
    sheet_data = config_data[sheet]
    haskey(sheet_data, "entries") || error("V sekci '$sheet' chybí klíč 'entries'.")

    entries = NamedTuple{(:label, :source, :destination),Tuple{String,String,String}}[]
    for entry_dict in sheet_data["entries"]
        label = get(entry_dict, "label", "")
        source = get(entry_dict, "source", "")
        destination = get(entry_dict, "destination", "")
        
        !isempty(label) && !isempty(source) && !isempty(destination) &&
            push!(entries, (label=label, source=source, destination=destination))
    end

    isempty(entries) && error("Sekce '$sheet' neobsahuje žádné platné položky pro zálohu.")
    prompt = get(sheet_data, "prompt", "Vyber položku") # Výchozí hodnota, pokud by chyběl
    return entries, prompt
end

function _run_backup_action(action_choice::Int, source::String, destination::String)
    if action_choice == 1
        zalohovat(source, destination, "zalohovat")
    elseif action_choice == 2
        zalohovat(source, destination, "zalohovat")
        zalohovat(source, destination, "zipnout")
    elseif action_choice == 3
        zalohovat(source, destination, "obnovit")
    else
        throw(ArgumentError("Neznama akce: $action_choice"))
    end

    return nothing
end

function _auto_choice(auto_choices::Union{Nothing,AbstractVector{<:Integer}}, index::Int)
    isnothing(auto_choices) && return nothing
    index <= length(auto_choices) || return nothing
    return Int(auto_choices[index])
end
