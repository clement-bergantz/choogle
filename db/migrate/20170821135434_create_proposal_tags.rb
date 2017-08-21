class CreateProposalTags < ActiveRecord::Migration[5.0]
  def change
    create_table :proposal_tags do |t|
      t.references :tag, foreign_key: true
      t.references :proposal, foreign_key: true

      t.timestamps
    end
  end
end
