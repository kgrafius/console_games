module Banners
  def method_missing(method, *args, &block)
    file_name = "banners/#{method}.txt"
    return nil unless File::exists?(file_name)
    File.read(file_name)
  end
end
