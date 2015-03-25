Fabricator(:plan) do
  weight { Faker::Number.number(2) }
end

Fabricator(:invalid_plan, from: Plan) do
  weight nil
end