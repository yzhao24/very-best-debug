# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  venue_id   :integer
#

class Comment < ApplicationRecord
  validates(:commenter, { :presence => true })

  def commenter
    my_id = self.author_id
    
    matching_users = User.where({ :id => my_id })

    the_user = matching_users.at(0)
    
    return the_user
  end
end
