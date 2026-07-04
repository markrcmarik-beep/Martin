# ver: 2026-07-01
using Test
using Martin

module DummySpravaSouboru
    export menutext, sprdsheet2velkst, sprsheetRef, sprsheet2tabl, zalohovat

    menutext(args...; kwargs...) = (0, "")
    sprdsheet2velkst(args...) = "A1:C1"
    sprsheetRef(args...) = (1,)
    sprsheet2tabl(args...) = (Any[""], Any[""], Any[""])
    zalohovat(args...) = nothing
end

using .DummySpravaSouboru

include(joinpath(@__DIR__, "..", "src", "zaloha.jl"))

@testset "zaloha helper functions" begin
    @test _auto_choice(nothing, 1) === nothing
    @test _auto_choice([1, 2, 3], 1) == 1
    @test _auto_choice([1, 2, 3], 2) == 2
    @test _auto_choice([1, 2, 3], 5) === nothing

    @test _flatten_cells([1, 2, 3]) == [1, 2, 3]
    @test _flatten_cells("abc") == ["abc"]
    @test _flatten_cells((1, 2, 3)) == [1, 2, 3]

    @test _cell_to_string(missing) == ""
    @test _cell_to_string(nothing) == ""
    @test _cell_to_string("  text  ") == "text"
    @test _cell_to_string(42) == "42"

    @test _cache_filename("zaloha.ods", "games") == "zaloha_games_sprsheet2tabl.jld2"
    @test _cache_filename("backup.ods", "dokumentyWin") == "backup_dokumentyWin_sprsheet2tabl.jld2"
end

nothing
