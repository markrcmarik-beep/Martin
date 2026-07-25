## Balíček Julia v1.12
###############################################################
## Popis balíčku
#
# ver: 2026-07-25
## Cesta uvnitř balíčku:
# Martin/src/Martin.jl
#
## Použité balíčky:
#
###############################################################
## Použité proměnné vnitřní:
#
module Martin

include("zaloha.jl")
include("zalohatext.jl")
include("zalohaokno.jl")
include("_zaloha_impl.jl")

export zaloha, zalohatext, zalohaokno

end # module Martin
