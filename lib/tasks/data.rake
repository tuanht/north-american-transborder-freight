namespace :data do
  desc 'Import transborder freight data'
  task :import => :environment do
    require 'roo'

    Dir.glob("#{File.dirname(__FILE__)}/dataset/csv/dot1_*").each do |path|
      import_table_1(path)
    end

    Dir.glob("#{File.dirname(__FILE__)}/dataset/csv/dot2_*").each do |path|
      import_table_2(path)
    end

    Dir.glob("#{File.dirname(__FILE__)}/dataset/csv/dot3_*").each do |path|
      import_table_3(path)
    end
  end

  def import_table_1(path, table_type=:with_state_and_port)
    csv = Roo::CSV.new(path)
    last_row = csv.last_row
    for row in 2...last_row
      trade_type = csv.cell(row, 'A').to_i
      usa_state_id = UsaState.find_by(code: csv.cell(row, 'B')).id
      port_id = Port.find_by(code: csv.cell(row, 'C')).id
      mode_id = Mode.find_by(code: csv.cell(row, 'D')).id
      country_id = Country.find_by(code: csv.cell(row, 'G')).id

      mexstate = csv.cell row, 'E'
      canprov = csv.cell row, 'F'
      state_code = (mexstate.nil? or mexstate.empty?) ? canprov : mexstate
      next if state_code.nil? # Some row missing both code on CANPROV & MEXSTATE
      state_id = State.find_by(country_id: country_id, code: state_code).id

      value = csv.cell(row, 'H').to_d
      shipwt = csv.cell(row, 'I').to_d
      freight_charges = csv.cell(row, 'J').to_d
      df = csv.cell(row, 'K').to_i

      containerized = csv.cell row, 'L'
      containerized = containerized == '1' ? true : false

      month = csv.cell(row, 'M').to_i
      year = csv.cell(row, 'N').to_i

      t = Trade.new trade_type: trade_type, usa_state_id: usa_state_id,
                    port_id: port_id, mode_id: mode_id, country_id: country_id, state_id: state_id,
                    value: value, shipwt: shipwt, freight_charges: freight_charges,
                    df: df, containerized: containerized,
                    date: Date.new(year, month, 1), table_type: table_type
      t.save if t.valid?

      puts "#{path}: Imported #{row - 1}/#{last_row}"
    end
  end

  def import_table_2(path, table_type=:with_state_and_commodity)
    csv = Roo::CSV.new(path)
    last_row = csv.last_row
    for row in 2...last_row
      trade_type = csv.cell(row, 'A').to_i
      usa_state_id = UsaState.find_by(code: csv.cell(row, 'B')).id
      commodity_id = Commodity.find_by(code: csv.cell(row, 'C').to_i.to_s).id
      mode_id = Mode.find_by(code: csv.cell(row, 'D')).id
      country_id = Country.find_by(code: csv.cell(row, 'G')).id

      mexstate = csv.cell row, 'E'
      canprov = csv.cell row, 'F'
      state_code = (mexstate.nil? or mexstate.empty?) ? canprov : mexstate
      next if state_code.nil? # Some row missing both code on CANPROV & MEXSTATE
      state_id = State.find_by(country_id: country_id, code: state_code).id

      value = csv.cell(row, 'H').to_d
      shipwt = csv.cell(row, 'I').to_d
      freight_charges = csv.cell(row, 'J').to_d
      df = csv.cell(row, 'K').to_i

      containerized = csv.cell row, 'L'
      containerized = containerized == '1' ? true : false

      month = csv.cell(row, 'M').to_i
      year = csv.cell(row, 'N').to_i

      t = Trade.new trade_type: trade_type, usa_state_id: usa_state_id,
                    commodity_id: commodity_id, mode_id: mode_id, country_id: country_id, state_id: state_id,
                    value: value, shipwt: shipwt, freight_charges: freight_charges,
                    df: df, containerized: containerized,
                    date: Date.new(year, month, 1), table_type: table_type
      t.save if t.valid?

      puts "#{path}: Imported #{row - 1}/#{last_row}"
    end
  end

  def import_table_3(path, table_type=:with_port_and_commodity)
    csv = Roo::CSV.new(path)
    last_row = csv.last_row
    for row in 2...last_row
      trade_type = csv.cell(row, 'A').to_i
      port_id = Port.find_by(code: csv.cell(row, 'B')).id
      commodity_id = Commodity.find_by(code: csv.cell(row, 'C').to_i.to_s).id
      mode_id = Mode.find_by(code: csv.cell(row, 'D')).id
      country_id = Country.find_by(code: csv.cell(row, 'E')).id

      value = csv.cell(row, 'F').to_d
      shipwt = csv.cell(row, 'G').to_d
      freight_charges = csv.cell(row, 'H').to_d
      df = csv.cell(row, 'I').to_i

      containerized = csv.cell row, 'J'
      containerized = containerized == '1' ? true : false

      month = csv.cell(row, 'K').to_i
      year = csv.cell(row, 'L').to_i

      t = Trade.new trade_type: trade_type, commodity_id: commodity_id,
                    port_id: port_id, mode_id: mode_id, country_id: country_id,
                    value: value, shipwt: shipwt, freight_charges: freight_charges,
                    df: df, containerized: containerized,
                    date: Date.new(year, month, 1), table_type: table_type
      t.save if t.valid?

      puts "#{path}: Imported #{row - 1}/#{last_row}"
    end
  end
end
