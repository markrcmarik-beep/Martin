# ver: 2026-07-25
using Test
using Martin

@testset "File structure" begin
    @test isfile(joinpath(@__DIR__, "..", "src", "zalohatext.jl"))
end

nothing
