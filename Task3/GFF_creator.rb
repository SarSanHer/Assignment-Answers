## SARA SANCHEZ HEREDERO MARTINEZ
## ASSIGNMENT 3: GFF feature files and visualization
## 20 Nov 2019


#----------------------- LOAD REQUIREMENTS ----------------------------
require 'bio'
require 'net/http'   # this is how you access the Web
require './exons'
require './seq_finder'

#----------------------- CREATE CLASS ----------------------------
class GFF_creator 
  
  #object variables:
  attr_accessor :input
  attr_accessor :entry
  
  # class variables:
  @@all_objects = Array.new  # array with all the objects from this class  
  
  def initialize (params = {})
    @input = params.fetch(:input, String.new)
    @entry = params.fetch(:entry, String.new)
    
  end
  
  def write_file_4a(name)
    report = File.open("#{name}.gff", "a+")
    if not report.readlines.grep(/gff/).size > 0
      report.puts "##gff-version 3"
    end
    
    @input.features.each do |feature|
      featuretype = feature.feature
      next unless featuretype == "myrepeat"
      chr=@entry.accession.split(':')[2]
      start=feature.position[0]
      ending=feature.position[1]
      report.puts "chr#{chr}\t·\texon_region\t#{start}\t#{ending}\t·\t#{feature.assoc['strand']}\t·\tID=#{feature.assoc['gene_ID']};Species=#{@entry.species.delete(' ')};Repeat=#{feature.assoc['repeat_motif']}"  
    end
  end
  
  def write_file_5(name)
    report = File.open("#{name}.gff", "a+")
    if not report.readlines.grep(/gff/).size > 0
      report.puts "##gff-version 3"
    end
    
    @input.features.each do |feature|
      featuretype = feature.feature
      next unless featuretype == "myrepeat"
      chr=@entry.accession.split(':')[2]
      
      gene_start=@entry.accession.to_s.split(':')[3].to_i # getting the position where the gene starts according to the ENSEMBL whole-chromosome start/end coordinates
      start=feature.position[0] + gene_start
      ending=feature.position[1] + gene_start
      
      report.puts "chr#{chr}\t·\texon_region\t#{start}\t#{ending}\t·\t#{feature.assoc['strand']}\t·\tID=#{feature.assoc['gene_ID']};Species=#{@entry.species.delete(' ')};Repeat=#{feature.assoc['repeat_motif']}"  
    end
  end
  
end
    
                     