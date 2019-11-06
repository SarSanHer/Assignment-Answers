require 'rest-client'
require './web_access'

#----------------------- CREATE GENE CLASS ----------------------------
class Network_generator
  attr_accessor :input_genes # AGI gene ID code
  @@all_objects = Array.new
  
  
  def initialize (params = {}) 
    @input_genes = params.fetch(:input_genes, Array.new)
    @@all_objects << self
  end
  
  
 ## first level interactions
  def get_network
    int_L1=Array.new    
    @input_genes.each do |gene|
      interactions = get_interactions(gene,@input_genes)
       if interactions != [] # if there are interacions
         int_L1.push([gene,interactions].flatten) # add that interaction as [my_gene,interaction1,interaction2, ...] 
       end
     end
    
    
    
    ## second level interactions
    int_L2=Array.new
    int_L1.each do |gene|  # takes something like [my_gene, interaction1, interaction2, ...]
    
      gene[1..-1].each do |interaction| #takes each item of [interaction1, interaction2, ...]
        int_list=[]
        
        int_L1.each do |item| # per set of [my_gene, [interaction1, interaction2, ...]]
          if item[1..-1].include? interaction # if [interaction1, interaction2, ...] includes my_gene
            int_list.push([item[0]]) #add my_gene to the list
          end
        end
        
        int_list.flatten!.uniq! # un-nest arrays and remove duplicates
        if int_list.length > 1 #there is interaction with 2 genes and therefore is part of a network
          int_L2.push([interaction,int_list].flatten)
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
        (0..all.length-1).each do |i| #iterate over the arrays again (like all[0] = [gene1 , gene2, gene3])
          if all[i].any? elem #if the array contains that gene (for example gene1 is in all[0])
            net.push(all[i].flatten) # include that array of interactions to my new array 
          end
        end
      end
      
      net.flatten! # unnest array
      net.uniq! # delete repetitions
      net.sort! # sort array
      
      if net.length > 2 
        networks.push(net)
        #puts " my network is \n #{net} \t"
      end
    end
     
    networks.uniq! #remove duplicated networks
    return networks
  end 
  
end

