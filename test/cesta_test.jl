# ver: 2026-11-05
using Test
using Martin

@testset "cesta Windows" begin
    ces = Martin.cesta("C:\\Users/markr/AppData/LocalLow/Kalypso Media Group GmbH/Commandos 2 HD Remaster", "Windows")
    @test occursin(ces, "C:\\Users\\markr\\AppData\\LocalLow\\Kalypso Media Group GmbH\\Commandos 2 HD Remaster")
end

@testset "cesta Linux" begin
    ces = Martin.cesta("/home/markr/AppData/LocalLow/Kalypso Media Group GmbH/Commandos 2 HD Remaster", "Linux")
    @test occursin(ces, "/home/markr/AppData/LocalLow/Kalypso Media Group GmbH/Commandos 2 HD Remaster")
end

nothing
