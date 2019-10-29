using CreditApprovalMockingStub
using Test

using Mocking
Mocking.activate()

# using ExpectationStubs

@testset "Stubs" begin

# 1. setup patches

check_background_success_patch = 
    @patch function check_background(first_name, last_name)
        println("check_background stub ==> simulating success")
        return true
    end

check_background_failure_patch =
    @patch function check_background(first_name, last_name)
        println("check_background stub ==> simulating failure")
        return false
    end

create_account_patch = 
    @patch function create_account(first_name, last_name, email)
        println("create_account stub is called")
        return 314
    end

# 2. test

# test background check failure case
apply(check_background_failure_patch) do 
    @test open_account("john", "doe", "jdoe@julia-is-awesome.com") == :failure
end

# test background check successful case
apply(check_background_success_patch) do 
    @test open_account("peter", "doe", "pdoe@julia-is-awesome.com") == :success
end

# apply two stubs
apply([check_background_success_patch, create_account_patch]) do
    @test open_account("peter", "doe", "pdoe@julia-is-awesome.com") == :success
end

end # testset

# --------------------------------------------------------------------------------

@testset "Mocking" begin

let check_background_call_count = 0,
    create_account_call_count = 0,
    notify_downstream_call_count = 0,
    notify_downstream_received_proper_account_number = false

    # 1. create mock function
    check_background_success_patch = 
        @patch function check_background(first_name, last_name)
            check_background_call_count += 1
            println("check_background mock is called, simulating success")
            return true
        end

    create_account_patch = 
        @patch function create_account(first_name, last_name, email)
            create_account_call_count += 1
            println("create account_number mock is called")
            return 314
        end

    notify_downstream_patch = 
        @patch function notify_downstream(account_number)
            notify_downstream_call_count += 1
            if account_number > 0
                notify_downstream_received_proper_account_number = true
            end
            println("notify downstream mock is called")
            return nothing
        end
    
    # 2. establish expectation
    function verify()
        @test check_background_call_count  == 1
        @test create_account_call_count    == 1
        @test notify_downstream_call_count == 1
        @test notify_downstream_received_proper_account_number
    end

    # 3. exercise and test return value
    apply([check_background_success_patch, create_account_patch, notify_downstream_patch]) do
        @test open_account("peter", "doe", "pdoe@julia-is-awesome.com") == :success
    end

    # 4. verify our previous expectation
    verify()
end

# # --------------------------------------------------------------------------------
# @testset "Mocking and ExpectationStubs" begin

# # 1. setup
# notify_downstream_patch = 
#     @patch function notify_downstream(account_number)
#         println("notify downstream mock is called")
#         return nothing
#     end

# # 2. Establish expectations

# # set it up as a stub
# @stub notify_downstream_patch

# # we expect account number 1 to be passed from the original create_account function
# @expect notify_downstream_patch(1) = nothing

# # 3. exercise
# apply(notify_downstream_patch) do
#     @test open_account("peter", "doe", "pdoe@julia-is-awesome.com") == :success
# end

# # 4. verify
# @test all_expectations_used(notify_downstream_patch)
# @test @usecount(notify_downstream_patch(::Int)) == 1

# end

end