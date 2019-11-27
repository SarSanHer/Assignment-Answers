## SARA SANCHEZ HEREDERO MARTINEZ
## ASSIGNMENT 3: GFF feature files and visualization
## 20 Nov 2019


#----------------------- LOAD REQUIREMENTS ----------------------------
require 'bio'
require 'net/http'   # this is how you access the Web
require './exons'
require './seq_finder'
require './GFF_creator'


#----------------------- CREATE CLASS ----------------------------
class File_explorer 
  
  #object variables:
  attr_accessor :file #embl file name
  attr_accessor :gene #gene to which the embl refers
  attr_accessor :my_repeat

  
  def initialize (params = {})
    @file = params.fetch(:file, String.new)
    @gene = params.fetch(:gene, String.new)
    @my_repeat = params.fetch(:my_repeat, String.new)
    
  end
  
  
  def explore
    datafile = Bio::FlatFile.auto(@file) # create Flat File object
    
    #puts 'datafile created'
  
    datafile.each_entry do |entry| # iterate over each record of the file
      next unless entry.features.length != 0 #do not iterate over empty files
  
      my_bioseq = entry.to_biosequence
      ft0 = my_bioseq.features.length.to_i
      #puts "This entry has: #{my_bioseq.features.length} features at the beginning"
      #puts ''
      
      my_coords=Array.new
      entry.features.each do |feature| # iterate over features of the record
        next unless feature.assoc['note']  # go to next feature unless note is a key... 
        next unless feature.assoc['note'].include?('exon')   # that contains the word 'exon'
        
        my_exon=Exons.new(:gene_ID => @gene, :feature_input => feature.position.to_s, :gene_seq => entry.seq.to_s) # create an exon object
        next unless my_exon.position != nil # if there is a valid exon in that position (some exon FT reference other genes with exon positions out of range)
    
        
        exon_repeats=Array.new
        if my_exon.strand == '+'
           o = my_exon.position[0].to_i + 1  # it's necesary to sum 1 position because there is a displacement of the coords
          exon_repeats=@my_repeat.get_coords(@my_repeat.regex,my_exon.seq, o)
        else
          exon_repeats=@my_repeat.get_coords(@my_repeat.complement_regex,my_exon.seq,my_exon.position[0])
        end
        
        
          
        next unless exon_repeats != [] # go to next feature if there are no matches found
        
        exon_repeats.each do |rep| # create features
          next if my_coords.include?(rep) # don't create a feature if it has already been created
          my_coords.push(rep) # if it was not included, add to array. This is a control in case my repetition is in the same position in the gene sequence but in different exones, and therefore appears multiple times
          f = Bio::Feature.new('myrepeat',rep)
          f.append(Bio::Feature::Qualifier.new('repeat_motif', 'CTTCTT'))
          f.append(Bio::Feature::Qualifier.new('gene_ID', my_exon.gene_ID))
          f.append(Bio::Feature::Qualifier.new('strand', my_exon.strand))
          my_bioseq.features << f
        end
        
        
      end #close the feature
  
      #puts "This entry has: #{my_bioseq.features.length} features after calling Features_creator"
      next unless (my_bioseq.features.length.to_i-ft0) != 0 # if the number of features has been increased == a repetition feature has been added, then continue
      $good_genes.push(@gene)
      
      # write GFF file
      gff=GFF_creator.new(:input => my_bioseq, :entry => entry)
      
      gff.write_file_4a('ex_4a')
      gff.write_file_5('ex_5') 
    
    end #close the entry
  end
end