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
    import_table(path, table_type) do |t, country_id|
      {
          usa_state_id: get_usa_state_id(t),
          port_id: get_port_id(t),
          state_id: get_state_id(t, country_id)
      }
    end
  end

  def import_table_2(path, table_type=:with_state_and_commodity)
    import_table(path, table_type) do |t, country_id|
      {
          usa_state_id: get_usa_state_id(t),
          commodity_id: get_commodity_id(t),
          state_id: get_state_id(t, country_id)
      }
    end
  end

  def import_table_3(path, table_type=:with_port_and_commodity)
    import_table(path, table_type) do |t|
      {
          port_id: get_port_id(t),
          commodity_id: get_commodity_id(t)
      }
    end
  end

  private
  def import_table(path, table_type)
    unless block_given?
      return
    end

    importer = get_csv_importer path, [] # Parse all
    importer.read_with_each(Trade) do |t, current, total|
      puts "#{path}: Importing #{current + 1}/#{total}"

      common_fields = get_common_fields t, table_type

      yield(t, common_fields[:country_id]).merge common_fields
    end
  end

  def get_csv_importer(path, header)
    Importer.new Importer.get_csv_reader(path), header
  end

  def get_common_fields(t, table_type)
    containerized = t['CONTCODE']

    month = t['MONTH'].to_i
    year = t['YEAR'].to_i

    {
        trade_type: t['TRDTYPE'].to_i,
        mode_id: Mode.find_by(code: t['DISAGMOT']).id,
        country_id: Country.find_by(code: t['COUNTRY']).id,

        value: t['VALUE'].to_d,
        shipwt: t['SHIPWT'].to_d,
        freight_charges: t['FREIGHT_CHARGES'].to_d,
        df: t['DF'].to_i,

        containerized: containerized == '1' ? true : false,

        date: Date.new(year, month, 1),

        table_type: table_type
    }
  end

  def get_usa_state_id(t)
    UsaState.find_by(code: t['USASTATE']).id
  end

  def get_port_id(t)
    Port.find_by(code: t['DEPE']).id
  end

  def get_commodity_id(t)
    Commodity.find_by(code: t['COMMODITY2']).id
  end

  def get_state_id(t, country_id)
    mexstate = t['MEXSTATE']
    canprov = t['CANPROV']

    return nil if mexstate.nil? and canprov.nil? # Some row missing both code on CANPROV & MEXSTATE

    state_code = (mexstate.nil? or mexstate.empty?) ? canprov : mexstate
    State.find_by(country_id: country_id, code: state_code).id
  end
end
