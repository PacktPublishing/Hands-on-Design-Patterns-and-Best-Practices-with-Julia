using CreditApprovalStub
using Test

@testset "CreditApprovalStub.jl" begin

# stubs
check_background_success(first_name, last_name) = true
check_background_failure(first_name, last_name) = false

# testing
let first_name = "John", last_name = "Doe", email = "jdoe@julia-is-awesome.com"
    @test open_account(first_name, last_name, email, checker = check_background_success) == :success
    @test open_account(first_name, last_name, email, checker = check_background_failure) == :failure
end

end
