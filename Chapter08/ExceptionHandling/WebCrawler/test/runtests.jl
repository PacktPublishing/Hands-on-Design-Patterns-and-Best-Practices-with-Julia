using Test
using WebCrawler

@testset "Crawling tests" begin
    add_site!(Target(url = "http://www.google.com"))
    add_site!(Target(url = "http://www.apple.com"))
    @test current_sites() |> length == 2
end

println("All done")
exit(0)