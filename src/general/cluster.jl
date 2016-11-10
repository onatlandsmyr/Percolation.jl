# clustering and check each cluster size.
"""
cluster(Lattice::Lattice)

return percolation or not and each clustersize


"""
function cluster(Lattice::TwoDLattice)
    checkallcluster(Lattice)
    maxlabelnum = maximum(Lattice.visit)
    clustersize = zeros(Int, maxlabelnum)
    for i in 1:maxlabelnum
        clustersize[i] = sum(Lattice.visit .== i)
    end
    
    # check percolation or not
    if sum(Lattice.visit[1,:] ∩ Lattice.visit[ size(Lattice.lattice)[1], :] ) != 0
        perco = 1
    else
        perco = 0
    end
    
    return perco, clustersize
end

function cluster(Lattice::HighDimLattice)
    _N, dim = Lattice.N, Lattice.dim
    checkallcluster(Lattice)
    maxlabelnum = maximum(Lattice.visit)
    clustersize = zeros(Int, maxlabelnum)
    for i in 1:maxlabelnum
        clustersize[i] = sum(Lattice.visit .== i)
    end
    
    # check percolation or not
    if sum( Lattice.visit[1:_N^(dim-1)] ∩ Lattice.visit[_N^(dim-1)*(_N-1)+1:end] ) != 0
        perco = 1
    else
        perco = 0
    end
    
    return perco, clustersize
end

###################
# For 2D lattice
###################
    function checkallcluster(lattice::Matrix{Int}, visit::Matrix{Int}, Lattice::TwoDLattice)
        (row, column) = size(lattice)
        labelnum = 1
        for i in 1:row, j in 1:column
            if lattice[j,i] == 1 && visit[j,i] == 0
                searchlist = checkcluster(j,i, labelnum, Lattice)
                visit[j,i] = labelnum
                
                while searchlist != []
                    tmppos = pop!(searchlist)
                    searchlist =  [ searchlist; checkcluster(tmppos[1], tmppos[2], labelnum, Lattice) ]
                    visit[tmppos...] = labelnum
                end
                
                labelnum += 1
            end
        end
    end

    function checkallcluster(Lattice::squarenn)
        checkallcluster(Lattice.lattice, Lattice.visit, Lattice)
    end

    function checkallcluster(Lattice::squarennn)
        checkallcluster(Lattice.lattice, Lattice.visit, Lattice)
    end

    function checkallcluster(Lattice::trinn)
        checkallcluster(Lattice.lattice, Lattice.visit, Lattice)
    end

    function checkallcluster(Lattice::honeycomb)
        checkallcluster(Lattice.lattice, Lattice.visit, Lattice)
    end

    function checkallcluster(Lattice::kagome)
        checkallcluster(Lattice.lattice, Lattice.visit, Lattice)
    end

    #function checkallcluster(Lattice::squarenn)
    #    (row, column) = size(Lattice.lattice)
    #    labelnum = 1
    #    for i in 1:row, j in 1:column
    #        if Lattice.lattice[j,i] == 1 && Lattice.visit[j,i] == 0
    #            searchlist = checkcluster(j,i, labelnum, Lattice)
    #            Lattice.visit[j,i] = labelnum
                
    #            while searchlist != []
    #                tmppos = pop!(searchlist)
    #                searchlist =  [ searchlist; checkcluster(tmppos[1], tmppos[2], labelnum, Lattice) ]
    #                Lattice.visit[tmppos...] = labelnum
    #            end
                
    #            labelnum += 1
    #        end
    #    end
    #end



    # square lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarenn)
        (row, column) = size(Lattice.lattice)
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end
        end
        
        return searchlist
    end

    # square lattice next nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarennn)
        (row, column) = size(Lattice.lattice)
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end
            if 1 < i && 1 < j && Lattice.lattice[i-1, j-1] == 1; push!(searchlist, [i-1, j-1]); end
            if 1 < i && j < column && Lattice.lattice[i-1, j+1] == 1; push!(searchlist, [i-1, j+1]); end
            if i < row && 1 < j && Lattice.lattice[i+1, j-1] == 1; push!(searchlist, [i+1, j-1]); end
            if i < row && j < column && Lattice.lattice[i+1, j+1] == 1; push!(searchlist, [i+1, j+1]); end
        end
        
        return searchlist
    end

    # triangular lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::trinn)
        (row, column) = size(Lattice.lattice)
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
            if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
            if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
            if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end
            if 1 < i && j < column && Lattice.lattice[i-1, j+1] == 1; push!(searchlist, [i-1, j+1]); end
            if i < row && 1 < j && Lattice.lattice[i+1, j-1] == 1; push!(searchlist, [i+1, j-1]); end
        end
        
        return searchlist
    end


    # honeycomb lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::honeycomb)
        (row, column) = size(Lattice.lattice)
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            if iseven(i+j)
                if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
                if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
                if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end
            else
                if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
                if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
                if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
            end
        end
        
        return searchlist
    end

    # kagome lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::kagome)
        (row, column) = size(Lattice.lattice)
        searchlist = Array{Array{Int64, 1}, 1}()
        
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            if iseven(i+j) # if i and j are both zeros, always lattice[i,j] = 0
                if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
                if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
                if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
                if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end            
            elseif iseven(i) && isodd(j)
                if i < row && Lattice.lattice[i+1, j] == 1; push!(searchlist, [i+1, j]); end
                if 1 < i && Lattice.lattice[i-1, j] == 1; push!(searchlist, [i-1, j]); end  
                if 1 < i && j < column && Lattice.lattice[i-1, j+1] == 1; push!(searchlist, [i-1, j+1]); end
                if i < row && 1 < j && Lattice.lattice[i+1, j-1] == 1; push!(searchlist, [i+1, j-1]); end
            else
                if j < column && Lattice.lattice[i, j+1] == 1; push!(searchlist, [i, j+1]); end
                if 1 < j && Lattice.lattice[i, j-1] == 1; push!(searchlist, [i, j-1]); end
                if 1 < i && j < column && Lattice.lattice[i-1, j+1] == 1; push!(searchlist, [i-1, j+1]); end
                if i < row && 1 < j && Lattice.lattice[i+1, j-1] == 1; push!(searchlist, [i+1, j-1]); end
            end
        end
        
        return searchlist
    end


    ########################################################################################
    # recursive function
    ########################################################################################
    function checkallcluster(Lattice::TwoDLattice)
        (row, column) = size(Lattice.lattice)
        labelnum = 1
        for i in 1:row, j in 1:column
            if Lattice.lattice[j,i] == 1 && Lattice.visit[j,i] == 0
                checkcluster(j, i, labelnum, Lattice)
                labelnum += 1
            end
        end
    end

    # square lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarennrec)
        (row,  column) = size(Lattice.lattice)
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            Lattice.visit[i,j] = labelnum
            if j < column; checkcluster(i, j+1, labelnum, Lattice); end
            if 1 < j; checkcluster(i, j-1, labelnum, Lattice); end
            if i < row; checkcluster(i+1, j, labelnum, Lattice); end
            if 1 < i; checkcluster(i-1, j, labelnum, Lattice); end
        end
    end

    # square lattice next nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::squarennnrec)
        (row,  column) = size(Lattice.lattice)
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            Lattice.visit[i,j] = labelnum
            if j < column; checkcluster(i, j+1, labelnum, Lattice); end
            if 1 < j; checkcluster(i, j-1, labelnum, Lattice); end
            if i < row; checkcluster(i+1, j, labelnum, Lattice); end
            if 1 < i; checkcluster(i-1, j, labelnum, Lattice); end
            if 1 < i && 1 < j; checkcluster(i-1, j-1, labelnum, Lattice); end
            if 1 < i && j < column; checkcluster(i-1, j+1, labelnum, Lattice); end
            if i < row && 1 < j; checkcluster(i+1, j-1, labelnum, Lattice); end
            if i < row && j < column; checkcluster(i+1, j+1, labelnum, Lattice); end
        end
    end

    # triangular lattice nearest neighbor
    function checkcluster(i::Int, j::Int, labelnum::Int, Lattice::trinnrec)
        (row,  column) = size(Lattice.lattice)
        if Lattice.lattice[i,j] == 1 && Lattice.visit[i,j] == 0
            Lattice.visit[i,j] = labelnum
            if j < column; checkcluster(i, j+1, labelnum, Lattice); end
            if 1 < j; checkcluster(i, j-1, labelnum, Lattice); end
            if i < row; checkcluster(i+1, j, labelnum, Lattice); end
            if 1 < i; checkcluster(i-1, j, labelnum, Lattice); end
            if 1 < i && j < column; checkcluster(i-1, j+1, labelnum, Lattice); end
            if i < row && 1 < j; checkcluster(i+1, j-1, labelnum, Lattice); end
        end
    end


########################
# For over 3 dimension
########################
    function checkcluster(ind::Int, labelnum::Int,Lattice::simplenn)
        present_place = ind2sub(Lattice.lattice, ind)
        searchlist = Vector{Int}()
        
        if Lattice.lattice[present_place...] == 1 && Lattice.visit[present_place...] == 0
            for i in 1:length(Lattice.NearestNeighborList)
                tempposition = ([present_place...] + Lattice.NearestNeighborList[i])
                if 0 ∉ tempposition && Lattice.N + 1 ∉ tempposition
                    tmpind = sub2ind(Lattice.lattice, tempposition...)
                    push!(searchlist, tmpind)
                end
            end
        end
        
        return searchlist
    end

    function checkallcluster(Lattice::simplenn)
        _N, dim = Lattice.N, Lattice.dim
        labelnum = 1
        
        for ind in 1:_N^(dim-1)
            if Lattice.lattice[ind] == 1 && Lattice.visit[ind] == 0
                searchlist = checkcluster(ind, labelnum, Lattice)
                Lattice.visit[ind] = labelnum
                
                while searchlist != []
                    tmpind = pop!(searchlist)
                    searchlist =  [ searchlist; checkcluster(tmpind, labelnum, Lattice) ]
                    Lattice.visit[tmpind] = labelnum
                end
                
                labelnum += 1
            end
        end

    end




####################################################################################################
# cluster figure
####################################################################################################
" clusterplot(Lattice::Lattice; figsave=false, filename=\"cluster.png\") "
function clusterplot(Lattice::Lattice; figsave=false, filename="cluster.png")
    MaxClusterLabelNum = maximum(Lattice.visit)
    for i in 1:MaxClusterLabelNum
        y, x = ind2sub(Lattice.visit, findin(Lattice.visit, i))
        PyPlot.plot(x,y, ".")
        PyPlot.axis("equal")
        PyPlot.axis("off")
    end
    
    if sum(Lattice.visit[1,:] ∩ Lattice.visit[ size(Lattice.lattice)[1], :] ) != 0
        PyPlot.title("Percolation !")
    else
        PyPlot.title("Not percolation ")
    end   
    
    if figsave; PyPlot.savefig(filename); end
    
end