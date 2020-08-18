# typed: false

pbis = Dao::ProductBacklogItem.all
criteria = Dao::AcceptanceCriterion.all
releases = Dao::Release.all

data = {
  pbis: pbis.map(&:attributes),
  criteria: criteria.map(&:attributes),
  releases: releases.map(&:attributes),
}

puts JSON.pretty_generate(data)
