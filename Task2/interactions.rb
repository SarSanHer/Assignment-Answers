#------------------- FIND NETWORK INTERACTIONS  --------------------

def get_network(my_genes)
## first level interactions
  int_L1=Array.new
  annotate_int_L1=Array.new

  my_genes.each do |gene|
     interactions=get_interactions(gene,my_genes) #get interactions from web accessing function
     if interactions != [] # if there are interacions
       annotate_int_L1.push([gene,interactions]) # add that interaction as [my_gene, [array of interactions]] 
       int_L1.push([gene,interactions].flatten) # add that interaction as [my_gene,interaction1,interaction2, ...] 
     end
   end
  
  ## second level interactions
  int_L2=Array.new
  annotate_int_L1.each do |gene|  # takes something like [my_gene, [interaction1, interaction2, ...]]
    gene[1].each do |interaction| #takes eash item of [interaction1, interaction2, ...]
      int_list=[]
      annotate_int_L1.each do |item| # per set of [my_gene, [interaction1, interaction2, ...]]
        if item[1].include? interaction # if my interaction is also in that set
          int_list.push([item[0]]) #add the my_gene to the list
        end
      end
      if int_list.flatten.length > 1 #there is interaction with 2 genes and therefore forms a network
        int_L2.push([interaction,int_list.flatten].flatten)
      end
    end
  end
  
  ## merge and make that array a local variable so it can be called later on
  all=[int_L1,int_L2].flatten!(1)
   
   
  ## create network's arrays
  
  networks=Array.new
  all.each do |item| # get one array of interactions, for example [gene1 , gene2, gene3]
    net=Array.new
    
    item.each do |elem| # get one of those genes, for example gene1
      (0..$all.length-1).each do |i| #iterate over the arrays again (like all[0] = [gene1 , gene2, gene3])
        if $all[i].any? elem #if the array contains that gene (for example gene1 is in all[0])
          net.push($all[i].flatten) # include that array of interactions to my new array 
        end
      end
    end
    net.flatten!.uniq!.sort! #make the array: unnested, no duplicates and sorted 
    if net.length > 2 
      networks.push(net)
    end
  end
  
  networks.uniq! #remove duplicated networks
  
  return networks

end
      