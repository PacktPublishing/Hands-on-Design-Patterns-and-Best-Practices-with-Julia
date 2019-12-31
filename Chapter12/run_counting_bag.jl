# Run CountingBag program with with Bag1 or Bag2 as super-class.

function usage(msg = nothing) 
    println("Usage: julia run_counting_bag.jl [Bag1|Bag2]")
    msg !== nothing && println(msg)
    exit(1)
end

# Check # of arguments
length(ARGS) != 1 && usage()

# Check argument 1 - must be Bag1 or Bag2
superclass = ARGS[1]
supported = ["Bag1", "Bag2"]
superclass in supported || usage("Please specify either Bag1 or Bag2")

# Compile
run(`cp $(superclass).java Bag.java`)
run(`javac Bag.java CountingBag.java`)
run(`java CountingBag`)
