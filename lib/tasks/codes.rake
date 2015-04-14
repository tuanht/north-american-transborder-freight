namespace :codes do
  desc 'Import transborder freight codes'
  task :import => :environment do
    require 'roo'

    xls = Roo::Excel.new "#{File.dirname(__FILE__)}/dataset/codes_all.xls"

    import_country xls.sheet('Country')
    import_commodity xls.sheet('Commodity Classification')

    canada = Country.find_by code: '1220'
    import_state canada.id, canada.country, xls.sheet('Canadian Province')

    mexico = Country.find_by code: '2010'
    import_state mexico.id, mexico.country, xls.sheet('Mexican State')
    mexstate = State.new country_id: mexico.id, code: 'XX', name: 'Unknown XX' # codes_all.xls missing XX state for Mexico, it included in `dot1_0115.csv`
    mexstate.save if mexstate.valid?

    import_usa_state xls.sheet('US State')

    import_mode xls.sheet('Mode of Transportation')

    import_port xls.sheet('Port')
    missing_port = Port.new code: '2383', name: 'VALLEY INTL AIRPORT, HARLINGEN, TX', port_type: :port
    missing_port.save if missing_port.valid? # insert missing code
    missing_port = Port.new code: '59XX', name: 'MISSING US DISTRICT', port_type: :district
    missing_port.save if missing_port.valid? # insert missing code
  end

  def import_country(sheet)
    total_country = 0
    for row in 4...sheet.last_row + 1
      c = Country.new(code: sheet.cell(row, 'A').to_i.to_s, country: sheet.cell(row, 'B').strip)
      c.save if c.valid?
      total_country += 1
    end
    puts "Imported #{total_country} countries"
  end

  def import_commodity(sheet)
    total_commodity = 0
    for row in 4...sheet.last_row + 1
      c = Commodity.new code: sheet.cell(row, 'A').to_i.to_s, description: sheet.cell(row, 'B').strip
      c.save if c.valid?
      total_commodity += 1
    end
    puts "Imported #{total_commodity} commodities"
  end

  def import_usa_state(sheet)
    total_state = 0
    for row in 4...sheet.last_row + 1
      s = UsaState.new code: sheet.cell(row, 'A').strip, name: sheet.cell(row, 'B').strip
      s.save if s.valid?
      total_state += 1
    end
    puts "Imported #{total_state} states for USA"
  end

  def import_state(country_id, country_name, sheet)
    total_state = 0
    for row in 4...sheet.last_row + 1
      s = State.new country_id: country_id, code: sheet.cell(row, 'A').strip, name: sheet.cell(row, 'B').strip
      s.save if s.valid?
      total_state += 1
    end
    puts "Imported #{total_state} states for country #{country_name}"
  end

  def import_mode(sheet)
    total_mode = 0
    for row in 4...sheet.last_row + 1
      m = Mode.new code: sheet.cell(row, 'A').to_i.to_s, description: sheet.cell(row, 'B').strip
      m.save if m.valid?
      total_mode += 1
    end
    puts "Imported #{total_mode} modes"
  end

  def import_port(sheet)
    total_port = 0
    for row in 4...sheet.last_row + 1
      district = sheet.cell(row, 'A').to_s.strip

      port = sheet.cell(row, 'B').to_s.strip
      port = port.to_i.to_s if port.include? '.' # xls auto convert `1100` to `1100.0`, so find `.` to remove it

      break if district.empty? and port.empty?

      p = Port.new code: district.empty? ? port : district, name: sheet.cell(row, 'C').strip
      district.empty? ? p.port_type = :port : p.port_type = :district
      p.save if p.valid?

      total_port += 1
    end
    puts "Imported #{total_port} ports"
  end
end
