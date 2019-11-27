## SARA SANCHEZ HEREDERO MARTINEZ
## ASSIGNMENT 3: GFF feature files and visualization
## 20 Nov 2019

puts '>>> PROGRAM RUNNING...'
#----------------------- LOAD REQUIREMENTS ----------------------------
require 'bio'
require 'net/http'   # this is how you access the Web
require './exons'
require './seq_finder'
require './GFF_creator'
require './explore_emblFiles'

#------------------- LOAD INFO FROM GENE FILE --------------------

#Now I open the gene file and create some arrays that will help create the Class objects
gene_file = File.new("./ArabidopsisSubNetwork_GeneList.txt","r")
genes_list=Array.new 
gene_file.each do |agi| # iterate over the elements of gene_file
  genes_list.push(agi.strip.upcase!) #add AGI codes to a list
end

$good_genes=Array.new


#------------------- ITERATE OVER GENES --------------------
genes_list.each do |xxx|
  #xxx = genes_list[61]
  
  ## CREATE FILE 
  address = URI("http://www.ebi.ac.uk/Tools/dbfetch/dbfetch?db=ensemblgenomesgene&format=embl&id=#{xxx}")  # create a "URI" with the genes from the list
  response = Net::HTTP.get_response(address)  # use the Net::HTTP object "get_response" method                                            
  record= response.body
  # create a local file with this data so that latter I can create a flatFile object
  File.open("temp.embl", 'w') do |myfile|  # w makes it writable
    myfile.puts record
  end
  
  
  ## CREATE REPEAT OBJECT 
  my_repeat=Seq_finder.new(:my_repeat => 'CTTCTT') # create repetition object

  ## EXPLORE FILE: create exon features and write GFF file with those new features
  new=File_explorer.new(:file => "temp.embl", :gene => xxx, :my_repeat => my_repeat)
  new.explore
  
  
  
end

#------------------- PRINT REPORT--------------------
report_file = File.open('./report1.txt', "a+")
report_file.puts "\n\nSARA SANCHEZ-HEREDERO MARTÍNEZ \n\n\nASSIGNMENT 3: output report"
report_file.puts "\n\nThe genes that do not have the repetition are #{genes_list - $good_genes} \n\n\t\t\t\t      *** *** ***\n\n\n\n"


