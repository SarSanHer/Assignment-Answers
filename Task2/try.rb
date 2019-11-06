
puts ">>> PROGRAM RUNNING"
puts " "
#----------------------- LOAD REQUIREMENTS ----------------------------
require 'rest-client'
require 'json' 
require './web_access'
require './network_generator_L3'
require './annotation_class'
require './network_members'



#------------------- LOAD INFO FROM GENE FILE --------------------

#Now I open the gene file and create some arrays that will help create the Class objects
gene_file = File.new("/Users/sara/BioCompu/Programming_challenges/Task2/ArabidopsisSubNetwork_GeneList.txt","r")

genes_list=Array.new 
gene_file.each do |agi| # iterate over the elements of gene_file
  genes_list.push(agi.strip.upcase!) #add AGI codes to a list
end

#------------------- CREATE NETWORK with class Network --------------------
object_networks = Network_generator.new(:input_genes => genes_list)
my_networks = object_networks.get_network

puts my_networks.length
puts ""
puts ""

my_networks.each do |net|
      puts "net length is #{net.length}"
end
