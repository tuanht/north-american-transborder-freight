class Importer
  attr_reader :count

  def initialize(reader, header)
    @header = header
    @reader = reader
  end

  def read(klass)
    array = @reader.parse header_search: @header
    array.shift # remove first element is column name
    klass.create array.map {|a| yield(a)}
    @count = array.count
  end

  def read_with_each(klass)
    array = @reader.parse header_search: @header
    array.shift # remove first element is column name
    current = 0
    array.each do |a|
      k = klass.new yield(a, current, array.count)
      k.save if k.valid?
      current += 1
    end
    @count = array.count
  end

  def self.get_excel_reader(path, sheet_name)
    xls = Roo::Excel.new path
    xls.sheet(sheet_name)
  end

  def self.get_csv_reader(path)
    Roo::CSV.new(path)
  end
end
