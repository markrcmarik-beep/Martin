## Funkce Julia
###############################################################
## Popis funkce:
# Zobrazi textove menu pro zalohovani her, softwaru a dokumentu.
# Data cte z tabulky zaloha.ods podle vzoru MATLAB funkce zaloha.m.
# ver: 2026-06-05
## Funkce: zaloha()
## Autor: Martin
#
## Cesta uvnitr balicku:
# Martin/src/zaloha.jl
#
## Vzor:
# zaloha()
# zaloha(; auto_choices=[1, 2, 1])
#
## Pouzite balicky
# SpravaSouboru
## Pouzite funkce:
# menutext(), sprdsheet2velkst(), sprsheetRef(), sprsheet2tabl(), zalohovat()
###############################################################

using SpravaSouboru

"""
    zaloha(; spreadsheet=nothing, auto_choices=nothing, execute=true)

Zobrazi menu pro vyber zalohy podle tabulky `zaloha.ods`.

Volby odpovidaji MATLAB funkci `zaloha.m`:
- `hry` -> list `games`
- `software` -> list `software`
- `dokumenty` -> list `dokumentyWin` nebo `dokumentyLinux` podle OS

Keyword `auto_choices` je urceny hlavne pro testy, napr. `[1, 1, 3]`.
Pokud `execute=false`, funkce pouze vrati vybranou akci bez spusteni zalohy.
"""
function zaloha(;
    spreadsheet::Union{Nothing,AbstractString}=nothing,
    auto_choices::Union{Nothing,AbstractVector{<:Integer}}=nothing,
    execute::Bool=true,
)
    spreadsheet_path = isnothing(spreadsheet) ? _default_zaloha_spreadsheet() : String(spreadsheet)

    categories = [
        (label="hry", sheet="games", prompt="Vyber hru"),
        (label="software", sheet="software", prompt="Vyber software"),
        (
            label="dokumenty",
            sheet=Sys.iswindows() ? "dokumentyWin" : "dokumentyLinux",
            prompt="Vyber dokumenty",
        ),
    ]

    category_choice, _ = menutext(
        "Vyber",
        [category.label for category in categories];
        auto_choice=_auto_choice(auto_choices, 1),
    )
    category_choice == 0 && return nothing

    category = categories[category_choice]
    entries = _read_backup_entries(spreadsheet_path, category.sheet)
    labels = [entry.label for entry in entries]

    item_choice, item_label = menutext(
        category.prompt,
        labels;
        auto_choice=_auto_choice(auto_choices, 2),
    )
    item_choice == 0 && return nothing

    entry = entries[item_choice]
    action_options = ["zálohovat", "zálohovat a vytvořit .zip", "obnovit"]
    action_choice, action_label = menutext(
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

function _default_zaloha_spreadsheet()
    package_root = normpath(joinpath(@__DIR__, ".."))
    candidates = [
        joinpath(@__DIR__, "zaloha.ods"),
        joinpath(package_root, "data", "zaloha.ods"),
        joinpath(package_root, "zaloha.ods"),
        normpath(joinpath(package_root, "..", "FunkceMATLAB", "SpravaSouboru", "zaloha.ods")),
    ]

    for path in candidates
        isfile(path) && return path
    end

    error(
        "Soubor zaloha.ods nebyl nalezen. Zadej cestu pomoci keywordu " *
        "`spreadsheet=\"cesta/k/zaloha.ods\"`.",
    )
end

function _read_backup_entries(spreadsheet_path::String, sheet::String)
    isfile(spreadsheet_path) || error("Soubor nebyl nalezen: $spreadsheet_path")

    full_range = sprdsheet2velkst(spreadsheet_path, sheet)
    isempty(full_range) && error("List '$sheet' v souboru '$spreadsheet_path' je prazdny.")

    last_ref = last(split(full_range, ":"))
    last_row = sprsheetRef(last_ref)[1]
    last_row >= 3 || error("List '$sheet' neobsahuje zadne polozky od radku 3.")

    folder = dirname(spreadsheet_path)
    spreadsheet_file = basename(spreadsheet_path)
    cache_file = _cache_filename(spreadsheet_file, sheet)

    labels_raw, sources_raw, destinations_raw = sprsheet2tabl(
        folder,
        [spreadsheet_file, cache_file],
        sheet,
        ["A3:A$(last_row)", "B3:B$(last_row)", "C3:C$(last_row)"],
    )

    labels = _flatten_cells(labels_raw)
    sources = _flatten_cells(sources_raw)
    destinations = _flatten_cells(destinations_raw)
    row_count = minimum(length.((labels, sources, destinations)))

    entries = NamedTuple{(:label, :source, :destination),Tuple{String,String,String}}[]
    for i in 1:row_count
        label = _cell_to_string(labels[i])
        source = _cell_to_string(sources[i])
        destination = _cell_to_string(destinations[i])

        if !isempty(label) && !isempty(source) && !isempty(destination)
            push!(entries, (label=label, source=source, destination=destination))
        end
    end

    isempty(entries) && error("List '$sheet' neobsahuje zadne platne radky ve sloupcich A:C.")
    return entries
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

function _cache_filename(spreadsheet_file::String, sheet::String)
    base = splitext(spreadsheet_file)[1]
    safe_sheet = replace(sheet, r"[^A-Za-z0-9_-]" => "_")
    return "$(base)_$(safe_sheet)_sprsheet2tabl.jld2"
end

function _flatten_cells(value)
    value isa AbstractArray && return collect(vec(value))
    return Any[value]
end

function _cell_to_string(value)
    (ismissing(value) || value === nothing) && return ""
    return strip(string(value))
end
