## SARA SANCHEZ HEREDERO MARTINEZ
## ASSIGNMENT 3: GFF feature files and visualization
## 20 Nov 2019


#----------------------- LOAD REQUIREMENTS ----------------------------
require 'bio'
require 'net/http'   # this is how you access the Web

#----------------------- CREATE CLASS ----------------------------
class Seq_finder 
  attr_accessor :my_repeat  # sequence I want to find
  attr_accessor :regex  # regular expresion of my repetititon
  attr_accessor :complement_regex  # complementary of the regular expresion of my repetititon
  attr_accessor :coords
  @@all_objects = Array.new
  
  
  def initialize (params = {})
    @my_repeat = params.fetch(:my_repeat, String.new)
    @regex = create_regex
    @complement_regex = create_complement_regex
    @@all_objects << self
  end
    
  
 ## create regular expression for target seq
  def create_regex
    search = Bio::Sequence::NA.new(my_repeat)   # create a seq object
    re = Regexp.new(search.to_re) # create regular expression
    return re.source  
  end
  
  
 ## create regular expression for complemenatry of target seq
  def create_complement_regex
    search = Bio::Sequence::NA.new(my_repeat)    # create a seq object
    search = search.complement! # transfrom it to its complement sequence
    re = Regexp.new(search.to_re)   # create regular expression
    return re.source   
  end
  
  ## function give the position in which a seq is found  
  def get_coords(target,seq,count_origin)
    count_origin=count_origin.to_i
    seq = seq.to_s # transform sequence to string so that it doesnt give an error when working with flatfile_objetc.seq
    coords=Array.new
    pos = seq.enum_for(:scan, target).map { Regexp.last_match.begin(0) } # get the position where the match starts
    pos.each do |p| # for each time the secuence was found
      begining = count_origin + p # begining is where the seq was found plus the origen of the exon
      ending = begining - 1 + @my_repeat.length # ends at begining + as many positions as our target seq has
      #puts "strand has the seq at #{[begining,ending]}"
      coords.push([begining,ending]) # add the coordenates to the array
    end
    @coods=coords
    return coords
  end

end