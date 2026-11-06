## Balíček Julia v1.13
###############################################################
## Popis balíčku
#
# ver: 2026-11-04
## Cesta uvnitř balíčku:
# Martin/src/Martin.jl
#
## Použité balíčky:
#
###############################################################
## Použité proměnné vnitřní:
#
"""
$(read(joinpath(@__DIR__, "..", "docs", "src", "Martin.md"), String))
"""
module Martin

include("cesta.jl")
include("zaloha.jl")
include("zalohatext.jl")
include("zalohaokno.jl")
include("_zaloha_impl.jl")

export zaloha, zalohatext, zalohaokno

end # module Martin
