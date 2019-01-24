using Profile
include("euler.jl")
function fct(t,z)
    f = zeros(typeof(z[1]),length(z))
    f[1] = z[2]
    f[2] = -z[1]
    return f
end
tspan   =   [0.;1.]
Y0      =   [1.;0.]
nbpas   =   1000000


function profile_custom()


    # Run once, to force compilation.
    println("======================= First run:")
    @time euler(fct,tspan,Y0,nbpas)

    # Run a second time, with profiling.
    println("\n\n======================= Second run:")
    #Profile.init(n=10000000)
    Profile.clear()
    Profile.clear_malloc_data()
    @profile (t,y) = euler(fct,tspan,Y0,nbpas)
    (data,lidict) = Profile.retrieve()

    io  =   open("profile_myfct.txt","w")
    Profile.print(io,data,lidict;format=:flat,maxdepth=100)
    Profile.print()
    close(io)

    io  =   open("type_myfct.txt","w")
    code_warntype(io, euler, (typeof(fct),typeof(tspan),typeof(Y0),typeof(nbpas)))
    close(io)



end
