# typed: false

issues = Dao::Issue.all
criteria = Dao::AcceptanceCriterion.all
plans = Dao::Plan.all
releases = Dao::Release.all

data = {
  issues: issues.map(&:attributes),
  criteria: criteria.map(&:attributes),
  plans: plans.map(&:attributes),
  releases: releases.map(&:attributes),
}

puts JSON.pretty_generate(data)
