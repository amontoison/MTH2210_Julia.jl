# Global scope
z = 10

for t=1:10
    z = z + 1
end

function test1()
    println(z)
    for t=1:10
        x = t + z
        println(x)
        #z = z + 1
    end
    println(z)
end

function test2()
    z = 5
    println(z)
    for t=1:10
        x = t + z
        println(x)
        #z = z + 1
    end
    println(z)
end

function test3()
    println(z)
    for t=1:10
        x = t + z
        println(x)
        #z = z + 1
    end
    println(z)
end

function test4()

    a = 10.
    println(a)
    for t=1:5
        a = a + t
        println(a)
    end
    println(a)
end

function test5()
    x = 2
    function test_in()
        x = 3
        return x + z
    end
    return test_in() + x
    #return x + test_in()
end
