# Memento allows one to remember history and restore an object's 
# state to any prior state.  
module MementoExample

# It can be easily achieved using immutable structs in Julia.
using Dates

# A single post
struct Post
    title::String
    content::String
end
Base.show(io::IO, p::Post) = 
    print(io, "Post: ", p.title, " => ", p.content)

# Keep track of blog post versions in memory for undo purpose.
struct Blog
    author::String
    posts::Vector{Post}
    date_created::DateTime
end

# Constructor to create a new blog
function Blog(author::String, post::Post)
    return Blog(author, [post], now())
end

Base.show(io::IO, blog::Blog) = 
    print(io, "Blog by ", blog.author, 
        " created on ", blog.date_created)

# Update an existing blog post
function update!(blog::Blog; 
                 title = nothing, 
                 content = nothing)
    post = current_post(blog)
    new_post = Post(
        something(title, post.title),
        something(content, post.content)
    )
    push!(blog.posts, new_post)
    return new_post
end

# How many versions are availabe in this blog post?
version_count(blog::Blog) = length(blog.posts)

# Return the last version of the post
function undo!(blog::Blog)
    if version_count(blog) > 1
        pop!(blog.posts)
        return current_post(blog)
    else
        error("Cannot undo... no more previous history.")
    end
end

# latest version
current_post(blog::Blog) = blog.posts[end]

function test()
    blog = Blog("Tom", Post("Why is Julia so great?", "Blah blah."))
    update!(blog, content = "The reasons are...")

    println("Number of versions: ", version_count(blog))
    println("Current post")
    println(current_post(blog))
    
    println("Undo #1")
    undo!(blog)
    println(current_post(blog))

    println("Undo #2")  # expect failure
    undo!(blog)
    println(current_post(blog))
end

end #module

using .MementoExample
MementoExample.test()
