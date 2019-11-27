## SARA SANCHEZ HEREDERO MARTINEZ
## ASSIGNMENT 3: GFF feature files and visualization
## 20 Nov 2019


#----------------------- LOAD REQUIREMENTS ----------------------------
require 'bio'
require 'net/http'   # this is how you access the Web
#----------------------- CREATE CLASS ----------------------------
class Exons 
  
  #object variables:
  attr_accessor :feature_input
  attr_accessor :gene_seq
  attr_accessor :seq
  attr_accessor :position
  attr_accessor :strand
  attr_accessor :gene_ID
  
  # class variables:
  @@all_objects = Array.new  # array with all the objects from this class
  @@genes_with_rep = Array.new # array to store all object that had the repetititon
  
  
  def initialize (params = {})
    @feature_input = params.fetch(:feature_input, String.new)
    @gene_ID = params.fetch(:gene_ID, String.new)
    @gene_seq = params.fetch(:gene_seq, String.new)
    @strand = strand_type
    @position = get_exon_position(@feature_input)
    @seq = params.fetch(:seq, String.new)
    if @position != nil
      get_exon_seq(@feature_input,@position,@gene_seq)
    end
    
    @@all_objects << self
  end
  
  
  def strand_type
    if @feature_input.include?('complement')
      @strand = '-'
    else
      @strand = '+'
    end
  end
  
  
  def get_exon_position(query)
    unless @feature_input.include?(':') # if the query references another gene
      @position=@feature_input.scan(/\d*\.\.\d*/)[0].split('..')
    end
  end
  

  
  def get_exon_seq(query,position,seq)
    exon=seq[position[0].to_i..position[1].to_i]
    @seq = exon
  end
  
  
end