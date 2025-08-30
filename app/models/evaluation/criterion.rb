class Evaluation::Criterion
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization
  include Questionize

  questionize :label

  ANSWERS = {
    "yes" => "Oui",
    "no" => "Non",
    "na" => "Non applicable"
  }

  attribute :label, :string
  attribute :answer, :string, default: nil

  def answered?
    answer.present?
  end

  def done?
    [ "yes", "na" ].include?(answer)
  end

  def negative?
    answered? && !done?
  end

  def inspect
   "<Evaluation::Criterion label: #{label}, answer: #{answer}>"
  end
end
