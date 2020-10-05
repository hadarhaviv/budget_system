class FileUtilities
  def self.load(name)
    data = nil
    file_name = "./#{name}.json"
    if File.exist?(file_name) && !File.zero?(file_name)
      data = JSON.parse(File.read(file_name), symbolize_names: true)
    end
    data
  end

  def self.save(name, data)
    name = "#{name}.json"
    File.write name, data.to_json
  end
end
