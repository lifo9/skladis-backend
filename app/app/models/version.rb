class Version < PaperTrail::Version
  include Searchable
  include Orderable
  include Filterable

  belongs_to :user, foreign_key: :whodunnit

  def user_id
    self.user&.id
  end
end
