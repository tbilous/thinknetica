ThinkingSphinx::Index.define :user, with: :active_record do
  indexes email
  indexes name, sortable: true

  has created_at, updated_at
end
