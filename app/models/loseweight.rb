#encoding: UTF-8
class Loseweight < ActiveRecord::Base
  validates_format_of :weight, :with => /^\d+(\.\d+)?$/,  :message => "体重必须是数字!"
end
