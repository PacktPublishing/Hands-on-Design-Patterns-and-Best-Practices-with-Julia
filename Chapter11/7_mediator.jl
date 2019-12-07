abstract type Widget end

mutable struct TextField <: Widget
    id::Symbol
    value::String
end

Base.@kwdef struct App
    amount_field::TextField
    interest_rate_field::TextField
    interest_amount_field::TextField
end

# extract numeric value from a text field
get_number(t::TextField) = parse(Float64, t.value)

# set text field from a numeric value
function set_number(t::TextField, x::Real)
    t.value = string(x)
    return nothing
end

# create an app - the "mediator"
const app = App(
    amount_field = TextField(:amount, "100.00"), 
    interest_rate_field = TextField(:interest_rate, "5"),
    interest_amount_field = TextField(:interest_amount, "5.00"))

# this function is called for any field
function on_change_event(widget::Widget)
    update(app, widget)
end

# app is the mediator since it has references to all children
function update(app::App, widget::Widget)
    if widget in (app.amount_field, app.interest_rate_field)
        new_interest = get_number(app.amount_field) * get_number(app.interest_rate_field)/100
        set_number(app.interest_amount_field, new_interest)
        println("Updated interest amount to ", new_interest)
    end
end

# initial interest amount
println("current interest = ", get_number(app.interest_amount_field))

# double principal amount from 100 to 200
set_number(app.amount_field, 200)
on_change_event(app.amount_field)

# change interest rate to 3%
set_number(app.interest_rate_field, 3)
on_change_event(app.amount_field)

