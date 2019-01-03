class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  enum search_regexp:{完全一致検索:1,あいまい検索:2}
end
