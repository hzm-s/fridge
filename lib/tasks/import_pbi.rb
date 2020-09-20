# typed: false
data = JSON.parse(File.read(ARGV[0])).deep_symbolize_keys

data[:pbis].each do |i|
  p Dao::ProductBacklogItem.new(i).save!
end

data[:criteria].each do |c|
  p Dao::AcceptanceCriterion.new(c).save!
end

data[:releases].each do |r|
  Dao::Release.create!(r)
end
