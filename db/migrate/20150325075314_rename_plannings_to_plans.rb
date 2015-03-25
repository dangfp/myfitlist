class RenamePlanningsToPlans < ActiveRecord::Migration
  def change
    rename_table :plannings, :plans
  end
end
