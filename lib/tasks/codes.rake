namespace :codes do
  desc 'Import transborder freight codes'
  task :import => :environment do
    require 'roo'

    path = "#{File.dirname(__FILE__)}/dataset/codes_all.xls"

    import_country path, 'Country'
    import_commodity path, 'Commodity Classification'

    canada = Country.find_by code: '1220'
    import_state canada.id, canada.country, path, 'Canadian Province', ['Code', 'Province name']

    mexico = Country.find_by code: '2010'
    import_state mexico.id, mexico.country, path, 'Mexican State', ['Code', 'State name']

    import_usa_state path, 'US State'

    import_mode path, 'Mode of Transportation'
    import_port path, 'Port'

    # region Import missing code
    mexstate = State.new country_id: mexico.id, code: 'XX', name: 'Unknown XX' # codes_all.xls missing XX state for Mexico, it included in `dot1_0115.csv`
    mexstate.save if mexstate.valid?
    missing_port = Port.new code: '2383', name: 'VALLEY INTL AIRPORT, HARLINGEN, TX', port_type: :port
    missing_port.save if missing_port.valid? # insert missing code
    missing_port = Port.new code: '59XX', name: 'MISSING US DISTRICT', port_type: :district
    missing_port.save if missing_port.valid? # insert missing code
    # endregion
  end

  def import_country(path, sheet_name)
    header = ['Code', 'Country']
    importer = get_excel_importer path, sheet_name, header
    importer.read(Country) {|c| {code: c[header[0]].to_i.to_s, country: c[header[1]].strip}}
    puts "Imported #{importer.count} countries"
  end

  def import_commodity(path, sheet_name)
    header = ["2-Digit\nCommodity Code", 'Commodity Description']
    importer = get_excel_importer path, sheet_name, header
    importer.read(Commodity) {|c| {code: "%.2d" % c[header[0]], description: c[header[1]].strip}}
    puts "Imported #{importer.count} commodities"
  end

  def import_usa_state(path, sheet_name)
    header = ['Code', 'State name']
    importer = get_excel_importer path, sheet_name, header
    importer.read(UsaState) {|s| {code: s[header[0]].strip, name: s[header[1]].strip}}
    puts "Imported #{importer.count} states for USA"
  end

  def import_state(country_id, country_name, path, sheet_name, header)
    importer = get_excel_importer path, sheet_name, header
    importer.read(State) {|s| {country_id: country_id, code: s[header[0]].strip, name: s[header[1]].strip}}
    puts "Imported #{importer.count} states for country #{country_name}"
  end

  def import_mode(path, sheet_name)
    header = ['Code', 'Description']
    importer = get_excel_importer path, sheet_name, header
    importer.read(Mode) {|m| {code: m[header[0]].to_i.to_s, description: m[header[1]].strip}}
    puts "Imported #{importer.count} modes"
  end

  def import_port(path, sheet_name)
    header = ['District code', 'Port code', 'Port name']
    importer = get_excel_importer path, sheet_name, header
    importer.read(Port) do |p|
      district = p[header[0]].to_s.strip

      port = p[header[1]].to_s.strip
      port = port.to_i.to_s if port.include? '.' # xls auto convert `1100` to `1100.0`, so find `.` to remove it

      {
          code: district.empty? ? port : district,
          name: p[header[2]].strip,
          port_type: district.empty? ? :port : :district
      }
    end
    puts "Imported #{importer.count} ports"
  end

  private
  def get_excel_importer(path, sheet_name, header)
    Importer.new Importer.get_excel_reader(path, sheet_name), header
  end
end
