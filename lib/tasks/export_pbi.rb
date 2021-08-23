# typed: false

issues = Dao::Issue.all
criteria = Dao::AcceptanceCriterion.all
releases = Dao::Release.all

data = {
  issues: issues.map(&:attributes),
  criteria: criteria.map(&:attributes),
  releases: releases.map(&:attributes),
}

puts JSON.pretty_generate(data)
