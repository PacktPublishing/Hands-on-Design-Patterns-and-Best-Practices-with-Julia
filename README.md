## $5 Tech Unlocked 2021!
[Buy and download this Book for only $5 on PacktPub.com](https://www.packtpub.com/product/hands-on-design-patterns-and-best-practices-with-julia/9781838648817)
-----
*If you have read this book, please leave a review on [Amazon.com](https://www.amazon.com/gp/product/183864881X).     Potential readers can then use your unbiased opinion to help them make purchase decisions. Thank you. The $5 campaign         runs from __December 15th 2020__ to __January 13th 2021.__*

# Hands-On Design Patterns and Best Practices with Julia 

<a href="https://www.packtpub.com/application-development/hands-design-patterns-julia-10?utm_source=github&utm_medium=repository&utm_campaign=9781838648817"><img src="https://www.packtpub.com/media/catalog/product/cache/bf3310292d6e1b4ca15aeea773aca35e/9/7/9781838648817-original.jpeg" alt="Hands-On Design Patterns and Best Practices with Julia " height="256px" align="right"></a>

This is the code repository for [Hands-On Design Patterns and Best Practices with Julia ](https://www.packtpub.com/application-development/hands-design-patterns-julia-10?utm_source=github&utm_medium=repository&utm_campaign=9781838648817), published by Packt.

**Proven solutions to common problems in software design for Julia 1.x**

## What is this book about?
Design patterns are fundamental techniques for developing reusable and maintainable code. They provide a set of proven solutions that allow developers to solve problems in software development quickly. This book will demonstrate how to leverage design patterns with real-world applications.


This book covers the following exciting features:
* Master the Julia language features that are key to developing large-scale software applications 
* Discover design patterns to improve overall application architecture and design 
* Develop reusable programs that are modular, extendable, performant, and easy to maintain 
* Weigh up the pros and cons of using different design patterns for use cases 
* Explore methods for transitioning from object-oriented programming to using equivalent or more advanced Julia techniques

If you feel this book is for you, get your [copy](https://www.amazon.com/dp/183864881X) today!

<a href="https://www.packtpub.com/?utm_source=github&utm_medium=banner&utm_campaign=GitHubBanner"><img src="https://raw.githubusercontent.com/PacktPublishing/GitHub/master/GitHub.png" 
alt="https://www.packtpub.com/" border="5" /></a>

## Instructions and Navigations
All of the code is organized into folders. For example, Chapter02.

The code will look like the following:
```
abstract type Formatter end
struct IntegerFormatter <: Formatter end
struct FloatFormatter <: Formatter end
```

**Following is what you need for this book:**
This book is for beginner to intermediate-level Julia programmers who want to enhance their skills in designing and developing large-scale applications.

With the following software and hardware list you can run all code files present in the book (Chapter 1-12).
### Software and Hardware List
| Chapter | Software required | OS required |
| -------- | ------------------------------------ | ----------------------------------- |
| 1-12 | Julia Version 1.3.0 or above | Windows, Mac OS X, and Linux (Any) |

## Code in Action

Click on the following link to see the Code in Action:

[YouTube](https://www.youtube.com/playlist?list=PLeLcvrwLe184DZW3gaIBXoAu0xHBt46SP)

## Errata

* Page 39 and 49:
Before running the using Calculator command, he/she can first go to the Pkg mode (by pressing the ] key) and then run the dev Calculator command.  For example:
 ```
        (@v1.4) pkg> dev Calculator

        Path `/Users/tomkwong/.julia/dev/Calculator` exists and looks like the correct package. Using existing path.

          Resolving package versions...

           Updating `~/.julia/environments/v1.4/Project.toml`

          [17fd2872] + Calculator v0.1.0 [`~/.julia/dev/Calculator`]

           Updating `~/.julia/environments/v1.4/Manifest.toml`

          [17fd2872] + Calculator v0.1.0 [`~/.julia/dev/Calculator`]
```

* Page 54:
The `subtypetree` function does not work when there is cycle in the type hierarchy. It is generally not a problem with the exception that the `Any` type is a subtype of itself. So, running `subtypetree(Any)` would get into an infinite loop. Please see [Chapter02/subtypetree2.jl](Chapter02/subtypetree2.jl) for a more robust version.

* Page 219:
The `vendor_id` of the `TripPayment` has the wrong type. It should be `Int` rather than `String`.

* Page 249:
The second image on page number 249 is incorrect. The correct image is as follows:
<img src="https://user-images.githubusercontent.com/1159782/93007143-19430980-f51a-11ea-9982-5fb58fc5ed01.png">

* Page 318, 352, 494:
These pages contain typos where "accessor" was misspelled as "assessor".

### Related products
* Julia 1.0 High Performance  [[Packt]](https://www.packtpub.com/application-development/julia-10-high-performance?utm_source=github&utm_medium=repository&utm_campaign=9781788298117) [[Amazon]](https://www.amazon.com/dp/1785880918)

* Julia Programming Projects  [[Packt]](https://www.packtpub.com/big-data-and-business-intelligence/julia-programming-projects?utm_source=github&utm_medium=repository&utm_campaign=9781788292740) [[Amazon]](https://www.amazon.com/dp/178829274X)

## Get to Know the Author
**Tom Kwong**
, CFA, is an experienced software engineer with over 25 years of industry programming experience. He has spent the majority of his career in the financial services industry. His expertise includes software architecture, design, and the development of trading/risk systems. Since 2017, he has uncovered the Julia language and has worked on several open source packages, including SASLib.jl. He currently works at Western Asset Management Company, a prestige asset management company that specializes in fixed income investment services. He holds an MS degree in computer science from the University of California, Santa Barbara (from 1993), and he holds the Chartered Financial Analyst® designation since 2009.

## Other books by the authors
### Suggestions and Feedback
[Click here](https://docs.google.com/forms/d/e/1FAIpQLSdy7dATC6QmEL81FIUuymZ0Wy9vH1jHkvpY57OiMeKGqib_Ow/viewform) if you have any feedback or suggestions.
