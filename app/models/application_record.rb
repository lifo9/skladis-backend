class ApplicationRecord < ActiveRecord::Base
  has_paper_trail ignore: [:updated_at]

  self.abstract_class = true
end
