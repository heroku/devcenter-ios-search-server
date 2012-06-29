DB = Sequel.connect(ENV['DATABASE_URL'])

class Plant < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer, naked: true, except: [:id, :tsv]

  def before_save
    super
    self.common_name = self.common_name.split(/\s+/).collect(&:capitalize).join(" ") rescue nil
    self.latin_name = self.latin_name.downcase rescue nil
  end

  def validate
    super
    validates_presence [:latin_name, :common_name]
    validates_unique :latin_name
  end
end
