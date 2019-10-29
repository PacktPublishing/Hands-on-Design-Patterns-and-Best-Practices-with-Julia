module CreditApprovalStub

export check_background, create_account, notify_downstream, open_account

# Background check.  
# In practice, we would call a remote service for this.
# For this example, we just return true.
function check_background(first_name, last_name, email)
    println("Doing background check for $first_name $last_name")
    return true
end

# Create an account.
# In practice, we would actually create a record in database.
# For this example, we return an account number of 1.
function create_account(first_name, last_name, email)
    println("Creating an account for $first_name $last_name")
    return 1
end

# Notify downstream system by sending a message.
# For this example, we just print to console and returns nothing.
function notify_downstream(account_number)
    println("Notifying downstream system about new account $account_number")
    return nothing
end

# Open a new account.  
# Returns `:success` if account is created successfully.
# Returns `:failure` if background check fails.
function open_account(first_name, last_name, email; checker = check_background)
    checker(first_name, last_name) || return :failure
    account_number = create_account(first_name, last_name, email)
    notify_downstream(account_number)
    return :success
end

end # module
