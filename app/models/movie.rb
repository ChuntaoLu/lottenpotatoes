class Movie < ActiveRecord::Base
  def self.ratings
    out = []
    self.all.each do |movie| 
      out << movie[:rating]
    end
    out.uniq
  end
end
