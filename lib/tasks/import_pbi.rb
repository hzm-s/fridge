# typed: false
data = JSON.parse(File.read(ARGV[0])).deep_symbolize_keys

data[:issues].each do |i|
  p Dao::Issue.create!(i)
end

data[:criteria].each do |c|
  p Dao::AcceptanceCriterion.create!(c)
end

data[:plans].each do |p|
  p Dao::Plan.create!(p)
end

data[:releases].each do |r|
  Dao::Release.create!(r)
end
