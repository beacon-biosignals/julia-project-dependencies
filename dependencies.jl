#!/usr/bin/env -S julia

using Pkg

# When generating a GitHub action heredoc we'll use a string that should never be the name
# of a Julia package. Additionally, `@` is not allowed in a GitHub repository names.
const PKG_NAME_DELIMITER = "@EOF"

function github_output((k, v)::Pair; delimiter::Union{AbstractString,Nothing}=nothing)
    k = string(k)
    v = string(v)

    open(ENV["GITHUB_OUTPUT"], "a") do io
        if isnothing(delimiter)
            println(io, "$k=$v")
        else
            # https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/workflow-commands-for-github-actions#multiline-strings
            println(io, "$k<<$delimiter")
            !isempty(v) && println(io, v)
            println(io, delimiter)
        end
    end
end

project = Pkg.project()

deps = Pkg.dependencies()
direct_deps = filter(((id, pkg),) -> pkg.is_direct_dep, deps)
unpublished_deps = filter(((id, pkg),) -> !pkg.is_tracking_registry, direct_deps)

direct_dep_names = sort!([pkg.name for (id, pkg) in direct_deps])
print("Direct package dependencies: ")
if !isempty(direct_dep_names)
    println()
    for name in direct_dep_names
        println("- $name")
    end
    println()
else
    println("N/A")
end

unpublished_dep_names = sort!([pkg.name for (id, pkg) in unpublished_deps])
print("Unpublished package dependencies: ")
if !isempty(unpublished_dep_names)
    println()
    for name in unpublished_dep_names
        println("- $name")
    end
    println()
else
    println("N/A")
end

if haskey(ENV, "GITHUB_OUTPUT")

    github_output("direct-dependencies" => join(direct_dep_names, '\n');
                  delimiter=PKG_NAME_DELIMITER)
    github_output("num-direct-dependencies" => length(direct_dep_names))
    github_output("unpublished-dependencies" => join(unpublished_dep_names, '\n');
                  delimiter=PKG_NAME_DELIMITER)
    github_output("num-unpublished-dependencies" => length(unpublished_dep_names))
end
