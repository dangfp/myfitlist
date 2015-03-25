class RenamePlanningIdToPlanIdInItems < ActiveRecord::Migration
  def change
    rename_column :items, :planning_id, :plan_id
  end
end
