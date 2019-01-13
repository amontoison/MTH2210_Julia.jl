function test_scope()

    a = 10.
    println(a)
    for t=1:5
        a = 10
        a = t
        println(a)
    end
    println(a)
end
